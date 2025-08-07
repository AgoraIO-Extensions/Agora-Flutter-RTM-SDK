import {
  ParseResult,
  RenderResult,
  TerraContext,
} from "@agoraio-extensions/terra-core";
import {
  ApiInterfaceRendererArgs,
  defaultParameterListBlockRenderer,
  defaultReturnTypeRenderer,
  functionSignature,
  renderClass,
} from "./api_interface_renderer";
import {
  CXXFile,
  CXXTYPE,
  CXXTerraNode,
  Clazz,
  Enumz,
  MemberFunction,
  MemberVariable,
  SimpleType,
  Struct,
  Variable,
} from "@agoraio-extensions/cxx-parser";
import {
  _trim,
  getBaseClasses,
  isCallbackClass,
  isNullableValue,
  isNullableVariable,
  renderEnumJsonSerializable,
  renderJsonSerializable,
  renderTopLevelVariable,
  getPointerArrayLengthNameMappings,
  filterPointerArrayLengthNames,
  isNullableType,
  toParameterDeclaration,
} from "./utils";
import {
  dartFileName,
  dartName,
  enumConstantNaming,
  toDartMemberName,
  toDartStyleNaming,
} from "../parsers/dart_syntax_parser";

import path from "path";
import _ from "lodash";
import { getDartTypeRemapping } from "../parsers/dart_type_remapping_parser";
import {
  getIrisApiIdValue,
  getOverrideNodeParserUserData,
  getPointerArrayNameMapping,
  isPointerName,
} from "@agoraio-extensions/terra_shared_configs";
import {
  getDartProjectMarkerParserUserData,
  isHiddenNodesAfterFlatten,
  isNotANamedParametersAfterFlattenOfMethod,
} from "../parsers/dart_project_marker_parser";

export type ExportRtmApiInterfaceRendererArgs = ApiInterfaceRendererArgs & {
  configPath?: string;
};

export default function ExportRtmApiInterfaceRenderer(
  terraContext: TerraContext,
  args: ExportRtmApiInterfaceRendererArgs,
  parseResult: ParseResult
): RenderResult[] {
  let renderResults = (parseResult!.nodes as CXXFile[]).map((cxxFile) => {
    let subContents = cxxFile.nodes
      .filter((it) => !isNativeBindingsNode(it))
      .filter((it) => it.name.length > 0)
      .map((node) => {
        switch (node.__TYPE) {
          case CXXTYPE.Clazz: {
            let clazz = node as Clazz;
            if (isCallbackClass(clazz.name)) {
              // return renderResultClasses(clazz);
              return "";
            } else {
              return renderExportRtmClass(parseResult, clazz);
            }
          }
          case CXXTYPE.Struct: {
            return renderJsonSerializable(
              parseResult,
              dartName(node.asStruct()),
              memeberVariablesWithoutCallbackClass(
                node.asStruct()!.member_variables
              ),
              !_isFlattenParameter(node)
                ? {
                    parentNode: node,
                  }
                : undefined
            );
          }
          case CXXTYPE.Enumz: {
            return renderEnumJsonSerializable(node.asEnumz());
          }
          case CXXTYPE.Variable: {
            return renderTopLevelVariable(node.asVariable());
          }
          default: {
            return "";
          }
        }
      })
      .join("\n\n");

    let isNeedImportGDartFile =
      cxxFile.nodes.find((node) => {
        return node.isStruct() || node.isEnumz();
      }) != undefined;

    let content = _trim(`
          import 'binding_forward_export.dart';
          ${
            isNeedImportGDartFile
              ? `part '${dartFileName(cxxFile)}.g.dart';`
              : ""
          }
          
          ${subContents}
          `);

    return {
      file_name: path.join(
        args.outputDir ?? "",
        `${dartFileName(cxxFile)}.dart`
      ),
      file_content: content,
    };
  });

  return [
    ...renderResults,
    ...implRendererResults(parseResult, args.outputDir ?? ""),
    renderRtmResultHandler(parseResult, args.outputDir ?? ""),
  ];
}

function memeberVariablesWithoutCallbackClass(
  memberVariables: MemberVariable[]
): MemberVariable[] {
  return memberVariables.filter((it) => {
    return !isCallbackClass(it.type.name);
  });
}

function functionsToResultClassMapping(
  parseResult: ParseResult
): Map<string, string> {
  let result = new Map<string, string>();

  let callbackClassMethods = (parseResult!.nodes as CXXFile[])
    .flatMap((it) => it.nodes)
    .filter((e) => isCallbackClass(e.name))
    .flatMap((it) => it.asClazz().methods);

  (parseResult!.nodes as CXXFile[])
    .flatMap((it) => it.nodes)
    .filter((e) => e.isClazz() && !isCallbackClass(e.name))
    .flatMap((it) => it.asClazz().methods)
    .forEach((method) => {
      if (!hasRequestIdParam(method)) {
        return "";
      }

      let matchedResultCallback = callbackClassMethods.find(
        (callbackMethod) => {
          let toMatchName = method.name[0].toUpperCase() + method.name.slice(1);
          return callbackMethod.name.includes(`${toMatchName}Result`);
        }
      );

      if (!matchedResultCallback) {
        matchedResultCallback = callbackClassMethods.find((callbackMethod) => {
          let toMatchName = method.name[0].toUpperCase() + method.name.slice(1);
          return callbackMethod.name.includes(toMatchName);
        });
      }

      if (matchedResultCallback) {
        let resultClassName = toDartStyleNaming(`${method.name}Result`, true);

        result.set(matchedResultCallback!.fullName, resultClassName);
        result.set(method!.fullName, resultClassName);
      }
    });

  return result;
}

let createdResultClass = new Set<string>();
function renderResultClasses(parseResult: ParseResult, clazz: Clazz): string {
  let callbackClassMethods = (parseResult!.nodes as CXXFile[])
    .flatMap((it) => it.nodes)
    .filter((e) => isCallbackClass(e.name))
    .flatMap((it) => it.asClazz().methods);

  return clazz.methods
    .map((method) => {
      if (!hasRequestIdParam(method)) {
        return "";
      }

      let matchedResultCallback = callbackClassMethods.find(
        (callbackMethod) => {
          let toMatchName = method.name[0].toUpperCase() + method.name.slice(1);
          return callbackMethod.name.includes(`${toMatchName}Result`);
        }
      );

      if (!matchedResultCallback) {
        matchedResultCallback = callbackClassMethods.find((callbackMethod) => {
          let toMatchName = method.name[0].toUpperCase() + method.name.slice(1);
          return callbackMethod.name.includes(toMatchName);
        });
      }

      if (!matchedResultCallback) {
        return "";
      }

      let resultClassName = toDartStyleNaming(`${method.name}Result`, true);

      if (createdResultClass.has(resultClassName)) {
        return "";
      }
      createdResultClass.add(resultClassName);

      let constructorNamedParametersBlock = matchedResultCallback.parameters
        .filter((it) => !isRequestIdParamName(it.name))
        .filter((it) => !isErrorCodeParamName(it.name))
        // .filter(
        //   (it) =>
        //     !getPointerArrayNameByLengthName(it.name, matchedResultCallback!)
        // )
        .map((parameter) => {
          // TODO(littlegnal): Remove `requestId`
          let type = dartName(parameter.type);
          let name = parameter.name;

          return `required this.${name}`;
        })
        .join(",");

      let memberVariablesBlock = matchedResultCallback.parameters
        .filter((it) => !isRequestIdParamName(it.name))
        .filter((it) => !isErrorCodeParamName(it.name))
        // .filter(
        //   (it) =>
        //     !getPointerArrayNameByLengthName(it.name, matchedResultCallback!)
        // )
        .map((parameter) => {
          // TODO(littlegnal): Remove `requestId`
          let type =
            getDartProjectMarkerParserUserData(parameter)?.displayNameConfig
              ?.displayType ?? dartName(parameter.type);
          let name = parameter.name;

          return `final ${type} ${name};`;
        })
        .join("\n\n");

      if (constructorNamedParametersBlock.length > 0) {
        constructorNamedParametersBlock = `{${constructorNamedParametersBlock}}`;
      }

      return `
        class ${resultClassName} {
            ${resultClassName}(${constructorNamedParametersBlock});
            
            ${memberVariablesBlock}
        }
        `;
    })
    .join("\n\n");
}

function isNativeBindingsNode(node: CXXTerraNode): boolean {
  let optionsNodeRegx = new RegExp("(.*)Options$");
  //   return optionsNodeRegx.test(node.name);
  return false;
}

function hasRequestIdParam(memberFunction: MemberFunction): boolean {
  return (
    memberFunction.parameters.find((it) => isRequestIdParamName(it.name)) !=
    undefined
  );
}

function hasErrorCodeParam(memberFunction: MemberFunction): boolean {
  return (
    memberFunction.parameters.find((it) => isErrorCodeParamName(it.name)) !=
    undefined
  );
}

function isErrorCodeParamName(name: string): boolean {
  return name === "errorCode";
}

function isRequestIdParamName(name: string): boolean {
  return name === "requestId";
}

function isUserIdParamName(name: string): boolean {
  return name === "userId";
}

function _returnTypeRendererFunc(
  clazz: Clazz
): (_: MemberFunction, __: boolean) => string {
  return function (
    memberFunction: MemberFunction,
    isSynchronizedFunc: boolean
  ): string {
    return _returnTypeRenderer(clazz, memberFunction, isSynchronizedFunc);
  };
}

function intToRtmStatusReturnTypeRenderer(
  memberFunction: MemberFunction,
  isSynchronizedFunc: boolean
): string {
  let returnType = dartName(memberFunction.return_type);
  if (returnType == "int") {
    returnType = "RtmStatus";
  }
  returnType = `${returnType}${
    isNullableType(memberFunction.return_type) ? "?" : ""
  }`;
  if (!isSynchronizedFunc) {
    if (returnType != "RtmStatus") {
      returnType = `(RtmStatus, ${returnType}?)`;
    }

    returnType = `Future<${returnType}>`;
  }
  return returnType;
}

function _getResultClassName(clazz: Clazz, memberFunction: MemberFunction) {
  let resultClassName = `${memberFunction.name}Result`;
  let overrideNodeParserUserData =
    getOverrideNodeParserUserData(memberFunction);
  if (
    overrideNodeParserUserData &&
    overrideNodeParserUserData.redirectIrisApiId
  ) {
    let existedFunction = clazz.methods.find((it) => {
      return (
        getIrisApiIdValue(it) == overrideNodeParserUserData!.redirectIrisApiId
      );
    });
    // Keep using the redirected function's name
    if (existedFunction) {
      resultClassName = `${existedFunction.name}Result`;
    }
  }

  return toDartStyleNaming(resultClassName, true);
}

function _returnTypeRenderer(
  clazz: Clazz,
  memberFunction: MemberFunction,
  isSynchronizedFunc: boolean
): string {
  let hasRequestIdParam =
    memberFunction.parameters.find((it) => it.name === "requestId") !=
    undefined;
  if (!hasRequestIdParam) {
    return intToRtmStatusReturnTypeRenderer(memberFunction, isSynchronizedFunc);
  }

  let resultClassName = _getResultClassName(clazz, memberFunction);

  let dartRecordType = `(RtmStatus, ${resultClassName}?)`;

  let returnType = `Future<${dartRecordType}>`;
  return returnType;
}

function _isFlattenParameter(param: CXXTerraNode): boolean {
  return (
    getDartProjectMarkerParserUserData(param)?.flattenParamNodeConfig !=
    undefined
  );
}

function _parameterListBlockRenderer(
  parseResult: ParseResult,
  mf: MemberFunction
): string {
  let memberFunction = _.cloneDeep(mf);
  memberFunction.parameters = memberFunction.parameters
    .filter((it) => filterPointerArrayLengthNames(memberFunction, it))
    .filter((e) => e.name != "requestId");

  let defaultValue = "";

  let mustParameters: (Variable | MemberVariable)[] = [];
  let namedParameters: (Variable | MemberVariable)[] = [];
  memberFunction.parameters.forEach((param) => {
    let flattenNodeConfig =
      getDartProjectMarkerParserUserData(param)?.flattenParamNodeConfig;
    let defaultValueBuilder =
      getDartProjectMarkerParserUserData(param)?.displayNameConfig?.converter
        ?.defaultValueBuilder;

    if (flattenNodeConfig) {
      let actualNode = parseResult.resolveNodeByType(param.type);
      let namedParametersInStruct = actualNode
        .asStruct()
        .member_variables.filter((it) =>
          filterPointerArrayLengthNames(actualNode.asStruct(), it)
        )
        .filter((it) => {
          return !isHiddenNodesAfterFlatten(param, it);
        })
        .forEach((it) => {
          if (isNotANamedParametersAfterFlattenOfMethod(memberFunction, it)) {
            mustParameters.push(it);
          } else {
            namedParameters.push(it);
          }
        });
      // .filter((it) => {
      //   return !isNotANamedParametersAfterFlatten(param, it);
      // });
      // namedParameters.push(...namedParametersInStruct);
    } else if (param.default_value.length != 0 || defaultValueBuilder) {
      namedParameters.push(param);
    } else {
      mustParameters.push(param);
    }
  });

  let namedParametersBlock = renderNamedParametersBlock(
    parseResult,
    namedParameters
  );

  let parameterList = mustParameters // memberFunction.parameters
    .map((param) => {
      let typeNode = parseResult.resolveNodeByType(param.type);
      let flattenNodeConfig =
        getDartProjectMarkerParserUserData(param)?.flattenParamNodeConfig;
      let defaultValueBuilder =
        getDartProjectMarkerParserUserData(param)?.displayNameConfig?.converter
          ?.defaultValueBuilder;
      // if (
      //   flattenNodeConfig ||
      //   param.default_value.length != 0 ||
      //   defaultValueBuilder
      // ) {
      //   return "";
      // }

      let typeName =
        getDartProjectMarkerParserUserData(param)?.displayNameConfig
          ?.displayType ?? dartName(param.type);
      let variableName =
        getDartProjectMarkerParserUserData(param)?.displayNameConfig
          ?.displayName ?? dartName(param);

      // Has default value
      if (param.isVariable() && param.asVariable().default_value) {
        // isNeedRequiredKeyword = false;

        if (typeNode.__TYPE == CXXTYPE.Enumz) {
          defaultValue = `${typeName}.${toDartMemberName(
            param.asVariable().default_value
          )}`;
        } else if (typeNode.__TYPE == CXXTYPE.Struct) {
          defaultValue = `const ${dartName(typeNode)}()`;
        } else {
          defaultValue = param.asVariable().default_value;
        }

        if (isNullableVariable(param.asVariable())) {
          typeName = `${typeName}?`;
          defaultValue = "";
        }
      }

      return `${typeName} ${variableName}`;
    })
    .filter((it) => it.length > 0);
  if (namedParametersBlock.length > 0) {
    parameterList.push(namedParametersBlock);
  }

  let parameterListBlock = parameterList.join(", ");

  return parameterListBlock;
}

const tokenEventClass = `
class TokenEvent {
  const TokenEvent(this.channelName);
  final String channelName;
}
`;

function renderExportRtmClass(parseResult: ParseResult, clazz: Clazz): string {
  let extraClassBody = "";
  let extracClasses = "";
  if (clazz.fullName == "agora::rtm::IRtmClient") {
    extraClassBody = renderAddListenerFunction(parseResult, false);
    extracClasses = tokenEventClass;
  }

  return `
  ${renderResultClasses(parseResult, clazz)}

  ${extracClasses}
  
  ${renderClass(parseResult, clazz, {
    extraClassBody: extraClassBody,
    returnTypeRenderer: _returnTypeRendererFunc(clazz),
    parameterListBlockRenderer: _parameterListBlockRenderer,
    methodFilter: (method) => {
      return getDartProjectMarkerParserUserData(method)?.isHiddenNode != true;
    },
  })}
  `;
}

function renderExportRtmClassImpl(
  parseResult: ParseResult,
  clazz: Clazz
): string {
  let clazzName = dartName(clazz);
  let methods = clazz.methods;
  let nativeBindingVariableName = `nativeBinding${clazzName}Impl`;
  let methodImpls = renderMethodImpls(
    parseResult,
    clazz,
    nativeBindingVariableName
  );
  let baseClassImplNames = getBaseClasses(parseResult, clazz).map(
    (baseClass) => `${dartName(baseClass)}Impl`
  );
  let shouldOverrideBaseClass = baseClassImplNames.length > 0;
  let classExtendsBlock = shouldOverrideBaseClass
    ? `extends ${baseClassImplNames.join(", ")} `
    : "";
  let constructorBlock = `${clazzName}Impl(this.${nativeBindingVariableName}, this.rtmResultHandler);`;

  let extraClassBody = "";
  if (clazz.fullName == "agora::rtm::IRtmClient") {
    extraClassBody = renderAddListenerFunction(parseResult, true);
  }

  return `
  class ${clazzName}Impl ${classExtendsBlock} implements ${clazzName} {
    ${constructorBlock}

    final RtmResultHandler rtmResultHandler;

    final native_binding.${clazzName}Impl ${nativeBindingVariableName};
    
    ${extraClassBody}
    ${methodImpls}
  }
  `.trim();
}

function getPointerArrayNameByLengthName(
  lengthName: string,
  method: MemberFunction | Struct
): string | undefined {
  let mappings = getPointerArrayLengthNameMappings(method);
  if (!mappings) {
    return undefined;
  }
  for (let [key, value] of mappings) {
    if (value == lengthName) {
      return key;
    }
  }
  return undefined;
}

function _getParamDisplayName(
  param: CXXTerraNode,
  paramTypeNode?: CXXTerraNode
) {
  let paramName = dartName(param);
  let displayParamName = paramName;
  let displayNameConfig =
    getDartProjectMarkerParserUserData(param)?.displayNameConfig;
  if (displayNameConfig) {
    if (displayNameConfig?.converter?.to && paramTypeNode) {
      displayParamName = `${paramName}${paramTypeNode.name}`;
    } else if (displayNameConfig.displayName) {
      displayParamName = displayNameConfig.displayName;
    }
  }
  return displayParamName;
}

function renderMethodImpls(
  parseResult: ParseResult,
  clazz: Clazz,
  nativeBindingVariableName: string
): string {
  let methodImpls = clazz.methods
    .filter((method) => {
      return getDartProjectMarkerParserUserData(method)?.isHiddenNode != true;
    })
    .map((method) => {
      let funcName = dartName(method);
      let funcSignature = functionSignature(parseResult, method, {
        forceAddOverridePrefix: true,
        returnTypeRenderer: _returnTypeRendererFunc(clazz),
        parameterListBlockRenderer: _parameterListBlockRenderer,
      });

      let returnTypeNode = parseResult.resolveNodeByType(method.return_type);
      if (returnTypeNode.isClazz()) {
        return _trim(`
${funcSignature} {
  // This function's implementation can't be generated automatically, please implement it manually.
  throw UnimplementedError();
}
`);
      }

      let isReturnInt = dartName(method.return_type) == "int";

      let apiCallParamList: string[] = [];
      let optionsParamInitList: string[] = [];
      let parameters = method.parameters.filter((it) => it.name != "requestId");
      let hasRequestId = hasRequestIdParam(method);
      // requestId
      let isNeedNamedApiCall = parameters.length > 1;
      parameters.forEach((param) => {
        let paramName = dartName(param);
        let paramTypeNode = parseResult.resolveNodeByType(param.type);

        let displayNameConfig =
          getDartProjectMarkerParserUserData(param)?.displayNameConfig;
        if (displayNameConfig) {
          let displayParamName = _getParamDisplayName(param, paramTypeNode);
          if (displayNameConfig?.converter?.to) {
            let converterTo = displayNameConfig.converter.to;
            let converterToBlock = converterTo(parseResult, displayNameConfig!);
            let mappingInitBlock = `final ${displayParamName} = ${converterToBlock};`;
            optionsParamInitList.push(mappingInitBlock);
          }

          apiCallParamList.push(`${paramName}: ${displayParamName}`);
        } else if (!isNeedNamedApiCall) {
          apiCallParamList.push(paramName);
        } else {
          let pointerArrayName = getPointerArrayNameByLengthName(
            param.name,
            method
          );
          let displayName = paramName;
          if (pointerArrayName) {
            displayName = pointerArrayName;

            let pointerArrayParam = parameters.find((it) => {
              return it.name == pointerArrayName;
            });
            if (pointerArrayParam) {
              let displayNameConfig =
                getDartProjectMarkerParserUserData(
                  pointerArrayParam
                )?.displayNameConfig;
              if (displayNameConfig) {
                let paramTypeNode = parseResult.resolveNodeByType(
                  pointerArrayParam.type
                );
                displayName = _getParamDisplayName(
                  pointerArrayParam,
                  paramTypeNode
                );
              }
            }
          }

          if (pointerArrayName) {
            apiCallParamList.push(`${paramName}: ${displayName}.length`);
          } else {
            apiCallParamList.push(`${paramName}: ${displayName}`);
          }
        }

        if (_isFlattenParameter(param)) {
          let paramTypeNodeStruct = paramTypeNode.asStruct();
          let optionsParamInit = _trim(`
          final ${paramName} = ${dartName(paramTypeNode)}(
            ${paramTypeNodeStruct.member_variables
              .filter((it) => {
                return !isHiddenNodesAfterFlatten(param, it);
              })
              .map((memberVariable) => {
                let pointerArrayName = getPointerArrayNameByLengthName(
                  memberVariable.name,
                  paramTypeNodeStruct
                );
                let displayName = _getParamDisplayName(memberVariable);
                if (pointerArrayName) {
                  displayName = pointerArrayName;

                  let pointerArrayParam =
                    paramTypeNodeStruct.member_variables.find((it) => {
                      return it.name == pointerArrayName;
                    });
                  if (pointerArrayParam) {
                    let displayNameConfig =
                      getDartProjectMarkerParserUserData(
                        pointerArrayParam
                      )?.displayNameConfig;
                    if (displayNameConfig) {
                      let paramTypeNode = parseResult.resolveNodeByType(
                        pointerArrayParam.type
                      );
                      displayName = _getParamDisplayName(pointerArrayParam);
                    }
                  }
                }

                if (pointerArrayName) {
                  return `${dartName(memberVariable)}: ${displayName}.length`;
                }

                return `${dartName(memberVariable)}: ${displayName}`;
              })}
          );
          `);
          optionsParamInitList.push(optionsParamInit);
        }
      });

      let optionsParamInitListBlock = optionsParamInitList.join("\n");
      let apiCallParamListBlock = apiCallParamList.join(", ");

      let resultClassName = _getResultClassName(clazz, method);

      let implWithResultClassReturnType = `
try {
  final requestId = await ${nativeBindingVariableName}.${funcName}(${apiCallParamListBlock});
  final (${resultClassName} result, RtmErrorCode errorCode) = await rtmResultHandler.request(requestId);
  final status = await ${nativeBindingVariableName}.irisMethodChannel.wrapRtmStatus(errorCode.value(), '${funcName}');
  return (status, result);
} on AgoraRtmException catch (e) {
  final status = await ${nativeBindingVariableName}.irisMethodChannel.wrapRtmStatus(e.code, '${funcName}');
  return (status, null);
}
      `;

      return _trim(`
      ${funcSignature} {
        ${optionsParamInitListBlock}
        ${(function () {
          if (hasRequestId) {
            return _trim(implWithResultClassReturnType);
          } else if (isReturnInt) {
            // int to RtmStatus
            return _trim(`
            try {
              await ${nativeBindingVariableName}.${funcName}(${apiCallParamListBlock});
              final status = await ${nativeBindingVariableName}.irisMethodChannel
                .wrapRtmStatus(0, '${funcName}');
              return status;
            } on AgoraRtmException catch (e) {
              final status = await ${nativeBindingVariableName}.irisMethodChannel
                  .wrapRtmStatus(e.code, '${funcName}');
              return status;
            }
            `);
          } else {
            return _trim(`
            try {
              final result = await ${nativeBindingVariableName}.${funcName}(${apiCallParamListBlock});
              final status = await ${nativeBindingVariableName}.irisMethodChannel
                  .wrapRtmStatus(0, '${funcName}');
              return (status, result);
            } on AgoraRtmException catch (e) {
              final status = await ${nativeBindingVariableName}.irisMethodChannel
                  .wrapRtmStatus(e.code, '${funcName}');
              return (status, null);
            }
            `);
          }
        })()}
        
      }
      `);
    })
    .join("\n\n");
  return methodImpls;
}

function dartPrimitiveTypeDefaultValue(type: SimpleType): string {
  let typeName = dartName(type);
  switch (typeName) {
    case "int":
      return "0";
    case "double":
      return "0.0";
    case "bool":
      return "false";
    case "String":
      return '""';
    default:
      return "";
  }
}

function renderNamedParametersBlock(
  parseResult: ParseResult,
  parameters: (Variable | MemberVariable)[]
): string {
  if (parameters.length == 0) {
    return "";
  }
  let namedList = [];
  for (let param of parameters) {
    let displayNameConfig =
      getDartProjectMarkerParserUserData(param)?.displayNameConfig;
    if (param.isMemberVariable()) {
      let memberVariableDefaultValues = new Map<string, string>();
      if (param.parent) {
        param.parent.asStruct().constructors.forEach((constructor) => {
          constructor.initializerList.forEach((initializer) => {
            if (initializer.kind == "Value") {
              memberVariableDefaultValues.set(
                initializer.name,
                initializer.values[0]
              );
            }
          });
        });
      }

      let markedDefaultValue = "";
      let defaultValueBuilder =
        getDartProjectMarkerParserUserData(param)?.displayNameConfig?.converter
          ?.defaultValueBuilder;
      if (defaultValueBuilder) {
        let config =
          getDartProjectMarkerParserUserData(param)!.displayNameConfig!;
        markedDefaultValue = defaultValueBuilder!(parseResult, config, "")!;
      } else if (dartName(param.asMemberVariable().type).includes("List")) {
        markedDefaultValue = "const []";
      }

      let holder = toParameterDeclaration(
        parseResult,
        param.asMemberVariable(),
        param.asMemberVariable().type,
        markedDefaultValue.length > 0 // Use the default value from the config first
          ? markedDefaultValue
          : memberVariableDefaultValues.get(param.asMemberVariable().name) ?? ""
      );

      let declaration = `${holder.type} ${holder.name}`;
      if (holder.defaultValue.length > 0) {
        declaration = `${declaration} = ${holder.defaultValue}`;
      }

      namedList.push(declaration);
    } else if (
      param.isVariable() &&
      (param.asVariable().default_value.length > 0 ||
        displayNameConfig?.converter?.defaultValueBuilder)
    ) {
      let type =
        getDartTypeRemapping(param)?.config?.dartType ?? dartName(param.type);
      let name = _getParamDisplayName(param);

      let defaultValue = param.asVariable().default_value;
      let defaultValueBuilder =
        displayNameConfig?.converter?.defaultValueBuilder;
      if (defaultValueBuilder) {
        defaultValue = defaultValueBuilder(
          parseResult,
          displayNameConfig!,
          defaultValue
        );
      }
      namedList.push(`${type} ${name} = ${defaultValue}`);
    }
    // else if (isUserIdParamName(param.name)) {
    //   let type = dartName(param.type);
    //   let name = dartName(param);
    //   namedList.push(`${type} ${name} = ""`);
    // }
  }

  return `{${namedList.join(",")}}`;
}

function implRendererResults(
  parseResult: ParseResult,
  outputDir: string
): RenderResult[] {
  let renderResults = (parseResult!.nodes as CXXFile[])
    .filter((it) => it.nodes.find((node) => node.isClazz()) != undefined)
    .map((cxxFile) => {
      let subContents = cxxFile.nodes
        .filter((it) => !isNativeBindingsNode(it))
        .filter((it) => it.name.length > 0)
        .map((node) => {
          switch (node.__TYPE) {
            case CXXTYPE.Clazz: {
              let clazz = node as Clazz;
              if (isCallbackClass(clazz.name)) {
                // return renderResultClasses(clazz);
                return "";
              } else {
                return renderExportRtmClassImpl(parseResult, clazz);
              }
            }

            default: {
              return "";
            }
          }
        })
        .join("\n\n");

      let isNeedImportGDartFile =
        cxxFile.nodes.find((node) => {
          return node.isStruct() || node.isEnumz();
        }) != undefined;

      let fileName = `${dartFileName(cxxFile)}_impl`;

      let content = _trim(`
          import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
          import 'package:agora_rtm/src/impl/extensions.dart';
          import 'package:agora_rtm/src/binding_forward_export.dart';
          import 'package:agora_rtm/src/bindings/gen/${fileName}.dart' as native_binding;
   
          ${subContents}
          `);

      return {
        file_name: path.join(outputDir, "impl", "gen", `${fileName}.dart`), //`lib/src/${dartFileName(cxxFile)}.dart`,
        file_content: content,
      };
    });

  return renderResults;
}

function renderRtmResultHandler(
  parseResult: ParseResult,
  outputDir: string
): RenderResult {
  let rtmEventHandlerNode = parseResult
    .resolveNodeByName("agora::rtm::IRtmEventHandler")
    ?.asClazz()!;

  let funcBlocks = [];
  let rtmEventHandlerFuncBlock = rtmEventHandlerNode.methods
    .map((method) => {
      let returnType = `${dartName(method.return_type)}`;
      let funcName = `${dartName(method)}`;
      let parameterListBlock = method.parameters
        .map((param) => `${dartName(param.type)} ${dartName(param)}`)
        .join(", ");

      let callbackImplBlock = "";

      let resultClassMapping = functionsToResultClassMapping(parseResult);
      let resultClassName = resultClassMapping.get(method.fullName);
      let resultClassInitParamsList: string[] = [];
      // final result = LoginResult(requestId: requestId, errorCode: errorCode);
      if (resultClassName) {
        let resultClassInitList = method.parameters
          .filter((it) => !isRequestIdParamName(it.name))
          .filter((it) => !isErrorCodeParamName(it.name))
          .map((param) => {
            let paramName = dartName(param);
            let displayNameConfig =
              getDartProjectMarkerParserUserData(param)?.displayNameConfig;
            if (displayNameConfig) {
              if (displayNameConfig?.converter?.from) {
                let converterFrom = displayNameConfig.converter.from;
                let converterFromBlock = converterFrom(
                  parseResult,
                  displayNameConfig!
                );
                let mappingInitParamName = `${dartName(param)}${dartName(
                  param.type
                )}`;
                paramName = mappingInitParamName;
                let mappingInitBlock = `final ${mappingInitParamName} = ${converterFromBlock};`;
                resultClassInitParamsList.push(mappingInitBlock);

                // apiCallParamList.push(`${paramName}: ${mappingInitParamName}`);
              }
            }

            return `${dartName(param)}: ${paramName}`;
          })
          .join(", ");
        callbackImplBlock = _trim(`
        final result = ${resultClassName}(${resultClassInitList});
        response(requestId, (result, errorCode));
        `);
        if (resultClassInitParamsList.length > 0) {
          callbackImplBlock = _trim(`
            ${resultClassInitParamsList.join("\n")}
            ${callbackImplBlock}
            `);
        }
      }

      return _trim(`
@visibleForTesting
@protected
${returnType} ${funcName}(${parameterListBlock}) {
  ${callbackImplBlock}
}`);
    })
    .join("\n\n");

  let rtmEventHandlerInitListBlock = rtmEventHandlerNode.methods
    .map((method) => {
      let funcName = `${dartName(method)}`;
      return `${funcName}: ${funcName}`;
    })
    .join(",");

  let constructorBlock = _trim(` `);

  let content = _trim(`
import 'dart:async';

import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_client.dart';

abstract class RtmResultHandler {
  RtmResultHandler() {
    rtmEventHandler = RtmEventHandler(
      ${rtmEventHandlerInitListBlock},
    );
  }
  late final RtmEventHandler rtmEventHandler;

  Future<T> request<T>(int requestId);

  void response(int requestId, (Object result, RtmErrorCode errorCode) data);

  ${rtmEventHandlerFuncBlock}
}
  `);

  return {
    file_name: path.join(outputDir, "impl", "gen", "rtm_result_handler.dart"),
    file_content: content,
  };
}

const tokenEventListener = `
void Function(TokenEvent event)? token
`;

function renderAddListenerFunction(
  parseResult: ParseResult,
  isImpl: boolean
): string {
  let eventHandlerFuncs = (parseResult!.nodes as CXXFile[])
    .flatMap((it) => it.nodes)
    .filter((e) => isCallbackClass(e.name))
    .flatMap((it) => it.asClazz().methods)
    .filter((it) => !hasRequestIdParam(it))
    .filter(
      (it) => getDartProjectMarkerParserUserData(it)?.isHiddenNode != true
    );
  let addListenerParmetersBlock = eventHandlerFuncs.map((method) => {
    let parameterList = method.parameters
      .map((param) => `${dartName(param.type)} ${dartName(param)}`)
      .join(", ");
    let functionParameterName = dartName(method);
    if (
      functionParameterName.includes("on") &&
      functionParameterName.includes("Event")
    ) {
      functionParameterName = functionParameterName
        .replace("on", "")
        .replace("Event", "");
    } else {
      // Take the first word of the name, e.g., tokenPrivilegeWillExpire -> token
      let words = functionParameterName.match(/[A-Z][a-z]+/g);
      if (words) {
        functionParameterName = words[0];
      }
    }

    return `void Function(${parameterList})? ${toDartStyleNaming(
      functionParameterName
    )}`;
  });
  addListenerParmetersBlock.push(tokenEventListener);

  let addListenerFunctionSignature = `void addListener({${addListenerParmetersBlock}})`;

  let removeListenerFunctionSignature = `void removeListener({${addListenerParmetersBlock}})`;

  if (!isImpl) {
    return _trim(`
    ${addListenerFunctionSignature};

    ${removeListenerFunctionSignature};
    `);
  }

  return _trim(`
  @override
  ${addListenerFunctionSignature} {
    throw UnimplementedError('Implement this function in sub-class.');
  }

  @override
  ${removeListenerFunctionSignature} {
    throw UnimplementedError('Implement this function in sub-class.');
  }
  `);
}
