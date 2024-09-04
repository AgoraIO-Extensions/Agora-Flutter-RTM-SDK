import {
  CXXFile,
  CXXTYPE,
  Clazz,
  MemberFunction,
  SimpleTypeKind,
  Variable,
} from "@agoraio-extensions/cxx-parser";
import {
  _trim,
  defaultDartHeader,
  defaultIgnoreForFile,
  getBaseClassMethods,
  getBaseClasses,
  isCallbackClass,
  isNullableType,
  isNullableVariable,
  isRegisterCallbackFunction,
  isUnregisterCallbackFunction,
  renderEnumJsonSerializable,
  renderJsonSerializable,
  renderTopLevelVariable,
} from "./utils";
import { isNodeMatched } from "../parsers/cud_node_parser";
import {
  ParseResult,
  RenderResult,
  TerraContext,
} from "@agoraio-extensions/terra-core";
import {
  dartFileName,
  dartName,
  toDartMemberName,
} from "../parsers/dart_syntax_parser";

import path from "path";
import { getSyncFunctionsMarkerParserUserData } from "../parsers/sync_function_marker_parser";

export interface ApiInterfaceRendererArgs {
  outputDir?: string;
}

export default function ApiInterfaceRenderer(
  terraContext: TerraContext,
  args: ApiInterfaceRendererArgs,
  parseResult: ParseResult
): RenderResult[] {
  let renderResults = (parseResult!.nodes as CXXFile[])
    .filter((cxxFile) => {
      return (
        cxxFile.nodes.find((node) => {
          return node.isClazz();
        }) != undefined
      );
    })
    .map((cxxFile) => {
      let subContents = cxxFile.nodes
        .filter((e) => e.isClazz())
        .map((node) => {
          switch (node.__TYPE) {
            case CXXTYPE.Clazz: {
              let clazz = node as Clazz;
              if (isCallbackClass(clazz.name)) {
                return renderCallbackClass(parseResult, clazz);
              } else {
                return renderClass(parseResult, clazz);
              }
            }
            // case CXXTYPE.Struct: {
            //   return renderJsonSerializable(
            //     parseResult,
            //     dartName(node.asStruct()),
            //     node.asStruct()!.member_variables
            //   );
            // }
            // case CXXTYPE.Enumz: {
            //   return renderEnumJsonSerializable(node.asEnumz());
            // }
            // case CXXTYPE.Variable: {
            //   return renderTopLevelVariable(node.asVariable());
            // }
            default: {
              return "";
            }
          }
        })
        .join("\n\n");

      // let isNeedImportGDartFile =
      //   cxxFile.nodes.find((node) => {
      //     return node.isStruct() || node.isEnumz();
      //   }) != undefined;

      let isNeedImportGDartFile = false;

      let content = _trim(`
        import 'binding_forward_export.dart';
        ${
          isNeedImportGDartFile ? `part '${dartFileName(cxxFile)}.g.dart';` : ""
        }
        
        ${subContents}
        `);

      return {
        file_name: path.join(
          args.outputDir ?? "",
          `${dartFileName(cxxFile)}.dart`
        ), //`lib/src/${dartFileName(cxxFile)}.dart`,
        file_content: content,
      };
    });

  return renderResults;
}

export function renderClass(
  parseResult: ParseResult,
  clazz: Clazz,
  options?: {
    extraClassBody?: string;
    returnTypeRenderer?: (
      memberFunction: MemberFunction,
      isSynchronizedFunc: boolean
    ) => string;
    parameterListBlockRenderer?: (
      parseResult: ParseResult,
      memberFunction: MemberFunction
    ) => string;
    methodFilter?: (method: MemberFunction) => boolean;
  }
) {
  let baseClassNames = getBaseClasses(parseResult, clazz).map((it) =>
    dartName(it)
  );
  let implementsBlock =
    baseClassNames.length > 0 ? `implements ${baseClassNames.join(", ")}` : "";

  let methodFilter = options?.methodFilter ?? ((method) => true);

  let funcs = clazz.methods
    .filter((method) => methodFilter(method))
    .map((method) => {
      return `${functionSignature(parseResult, method, {
        ignoreAsyncKeyword: true,
        returnTypeRenderer: options?.returnTypeRenderer,
        parameterListBlockRenderer: options?.parameterListBlockRenderer,
      })};`;
    })
    .join("\n\n");

  return `
abstract class ${dartName(clazz)} ${implementsBlock} {
    ${options?.extraClassBody ?? ""}

    ${funcs}
}
    `;
}

export function renderCallbackClass(parseResult: ParseResult, clazz: Clazz) {
  let clazzName = dartName(clazz);
  let baseClassMethods = getBaseClassMethods(parseResult, clazz);
  let baseClassNames = getBaseClasses(parseResult, clazz).map((it) =>
    dartName(it)
  );
  let extendsBlock =
    baseClassNames.length > 0 ? `extends ${baseClassNames.join(", ")}` : "";

  let constructorSuperBlock = "";
  if (baseClassMethods.length > 0) {
    constructorSuperBlock = `
super(
${baseClassMethods.map((it) => `${dartName(it)} : ${dartName(it)},`).join("")}
)
`;
  }

  let constructorParameters: string[] = [];
  if (baseClassMethods.length > 0) {
    baseClassMethods.forEach((it) => {
      let funcType = `${dartName(it.return_type)} Function(${it.parameters
        .map((param) => `${dartName(param.type)} ${dartName(param)}`)
        .join(", ")})?`;
      constructorParameters.push(`${funcType} ${dartName(it)},`);
    });
  }
  clazz.methods.forEach((method) => {
    constructorParameters.push(`this.${dartName(method)},`);
  });

  let constructorBlock = _trim(`
  /// Construct the [${clazzName}].
  const ${clazzName}({
    ${constructorParameters.join("")}
  })
  ${constructorSuperBlock.length > 0 ? `: ${constructorSuperBlock}` : ""};`);

  // NOTE: A new line between the constructor and the methods is required, otherwise the `iris_doc` CLI
  // may cause a bug.
  return _trim(`
  class ${clazzName} ${extendsBlock} {

  ${constructorBlock}

  ${clazz.methods
    .map((method) => {
      let funcType = `${dartName(
        method.return_type
      )} Function(${method.parameters
        .map((param) => `${dartName(param.type)} ${dartName(param)}`)
        .join(", ")})?`;
      return `final ${funcType} ${dartName(method)};`;
    })
    .join("\n\n")}
  }
    `);
}

// We treat the callback as a synchronized function, see the logic inside `isSynchronizedFunction`,
// but some functions with callback parameters are not synchronized, so we need to add them to the `asyncFunctions` list.
const asyncFunctions = [
  // agora::rtc::IMediaRecorder
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "setMediaRecorderObserver",
    parent_name: "IMediaRecorder",
    namespaces: ["agora", "rtc"],
  },
  // agora::rtc::IRtcEngine::startDirectCdnStreaming
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "startDirectCdnStreaming",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
];

const synchronizedFunctions = [
  // agora::rtc::IRtcEngine
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getVideoDeviceManager",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getAudioDeviceManager",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getMediaEngine",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getMediaRecorder",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getLocalSpatialAudioEngine",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getMusicContentCenter",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getH265Transcoder",
    parent_name: "IRtcEngine",
    namespaces: ["agora", "rtc"],
  },
  // agora::rtc::IMediaPlayer
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getMediaPlayerId",
    parent_name: "IMediaPlayer",
    namespaces: ["agora", "rtc"],
  },
  // agora::rtc::MusicCollection
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getCount",
    parent_name: "MusicCollection",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getTotal",
    parent_name: "MusicCollection",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getPage",
    parent_name: "MusicCollection",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getPageSize",
    parent_name: "MusicCollection",
    namespaces: ["agora", "rtc"],
  },
  {
    __TYPE: CXXTYPE.MemberFunction,
    name: "getMusic",
    parent_name: "MusicCollection",
    namespaces: ["agora", "rtc"],
  },
];
export function isSynchronizedFunction(
  parseResult: ParseResult,
  memberFunction: MemberFunction
): boolean {
  let isSyncFunc =
    synchronizedFunctions.find((it) => isNodeMatched(memberFunction, it)) !=
      undefined ||
    isRegisterCallbackFunction(memberFunction) ||
    isUnregisterCallbackFunction(memberFunction);
  if (
    !isSyncFunc &&
    asyncFunctions.find((it) => isNodeMatched(memberFunction, it)) == undefined
  ) {
    // If there a callback class in the parameter list, then it's a synchronized function
    isSyncFunc =
      memberFunction.parameters.find((param) => {
        let tmpNode = parseResult.resolveNodeByType(param.type);
        if (tmpNode.__TYPE == CXXTYPE.Clazz) {
          return isCallbackClass(tmpNode.asClazz().name);
        }
        return false;
      }) != undefined;
  }
  return isSyncFunc;
}

export function defaultReturnTypeRenderer(
  memberFunction: MemberFunction,
  isSynchronizedFunc: boolean
): string {
  let returnType = dartName(memberFunction.return_type);
  returnType = `${returnType}${
    isNullableType(memberFunction.return_type) ? "?" : ""
  }`;
  if (!isSynchronizedFunc) {
    returnType = `Future<${returnType}>`;
  }
  return returnType;
}

export function defaultParameterListBlockRenderer(
  parseResult: ParseResult,
  memberFunction: MemberFunction
): string {
  let parameterListBlock = memberFunction.parameters
    .map((param) => {
      let typeNode = parseResult.resolveNodeByType(param.type);
      let typeName = dartName(param.type);
      let variableName = dartName(param);
      let defaultValue = "";
      let isNeedRequiredKeyword = memberFunction.parameters.length > 1;

      // Has default value
      if (param.default_value.length > 0) {
        isNeedRequiredKeyword = false;

        if (typeNode.__TYPE == CXXTYPE.Enumz) {
          console.log(
            `method: ${memberFunction.name}, enum: ${typeNode.name}, default: ${param.default_value}`
          );
          defaultValue = `${typeName}.${toDartMemberName(param.default_value)}`;
        } else if (typeNode.__TYPE == CXXTYPE.Struct) {
          defaultValue = `const ${dartName(typeNode)}()`;
        } else {
          defaultValue = param.default_value;
        }

        if (isNullableVariable(param)) {
          typeName = `${typeName}?`;
          defaultValue = "";
        }
      }

      let requiredKeyword = isNeedRequiredKeyword ? "required" : "";
      let returnValue = `${requiredKeyword} ${typeName} ${variableName}`;
      if (defaultValue.length > 0) {
        returnValue = `${returnValue} = ${defaultValue}`;
      }

      // let value = `${
      //   isNeedRequiredKeyword ? "required" : ""
      // } ${typeName} ${variableName}${
      //   defaultValue.length > 0 ? ` = ${defaultValue}` : ""
      // }`;

      return returnValue;
    })
    .join(",");

  if (
    memberFunction.parameters.find((it) => it.default_value) ||
    memberFunction.parameters.length > 1
  ) {
    parameterListBlock = `{${parameterListBlock}}`;
  }
  return parameterListBlock;
}

export function functionSignature(
  parseResult: ParseResult,
  memberFunction: MemberFunction,
  options?: {
    forceAddOverridePrefix?: boolean;
    ignoreAsyncKeyword?: boolean;
    returnTypeRenderer?: (
      memberFunction: MemberFunction,
      isSynchronizedFunc: boolean
    ) => string;
    parameterListBlockRenderer?: (
      parseResult: ParseResult,
      memberFunction: MemberFunction
    ) => string;
  }
): string {
  let isSynchronizedFunc = isSynchronizedFunction(parseResult, memberFunction);
  isSynchronizedFunc =
    isSynchronizedFunc ||
    getSyncFunctionsMarkerParserUserData(memberFunction)
      ?.isMarkedAsSyncFunction == true;

  let parentClass = memberFunction.parent! as Clazz;
  let forceAddOverridePrefix: boolean =
    options?.forceAddOverridePrefix ?? false;
  let ignoreAsyncKeyword = options?.ignoreAsyncKeyword ?? false;
  let addOverrideSurffix =
    forceAddOverridePrefix ||
    getBaseClassMethods(parseResult, parentClass).find(
      (it) => it.name == memberFunction.name
    );
  let returnTypeRenderer =
    options?.returnTypeRenderer ?? defaultReturnTypeRenderer;
  let parameterListBlockRenderer =
    options?.parameterListBlockRenderer ?? defaultParameterListBlockRenderer;

  let overridePrefix = addOverrideSurffix ? "@override " : "";
  // let returnType = dartName(memberFunction.return_type);
  // returnType = `${returnType}${
  //   isNullableType(memberFunction.return_type) ? "?" : ""
  // }`;
  // if (!isSynchronizedFunc) {
  //   returnType = `Future<${returnType}>`;
  // }
  let returnType = returnTypeRenderer(memberFunction, isSynchronizedFunc);
  let functionName = dartName(memberFunction);
  // let defaultValue = "";
  // let isNeedRequiredKeyword = memberFunction.parameters.length > 1;
  let asyncKeywordSurffix =
    isSynchronizedFunc || ignoreAsyncKeyword ? "" : "async";

  // let parameterListBlock = memberFunction.parameters
  //   .map((param) => {
  //     let typeNode = parseResult.resolveNodeByType(param.type);
  //     let typeName = dartName(param.type);
  //     let variableName = dartName(param);

  //     // Has default value
  //     if (param.default_value) {
  //       isNeedRequiredKeyword = false;

  //       if (typeNode.__TYPE == CXXTYPE.Enumz) {
  //         console.log(
  //           `method: ${memberFunction.name}, enum: ${typeNode.name}, default: ${param.default_value}`
  //         );
  //         defaultValue = `${typeName}.${toDartMemberName(param.default_value)}`;
  //       } else if (typeNode.__TYPE == CXXTYPE.Struct) {
  //         defaultValue = `const ${dartName(typeNode)}()`;
  //       } else {
  //         defaultValue = param.default_value;
  //       }

  //       if (isNullableVariable(param)) {
  //         typeName = `${typeName}?`;
  //         defaultValue = "";
  //       }
  //     }

  //     return `${
  //       isNeedRequiredKeyword ? "required" : ""
  //     } ${typeName} ${variableName}${defaultValue ? ` = ${defaultValue}` : ""}`;
  //   })
  //   .join(",");

  // if (
  //   memberFunction.parameters.find((it) => it.default_value) ||
  //   memberFunction.parameters.length > 1
  // ) {
  //   parameterListBlock = `{${parameterListBlock}}`;
  // }

  let parameterListBlock = parameterListBlockRenderer(
    parseResult,
    memberFunction
  );

  return _trim(`
${overridePrefix}
${returnType} ${functionName}(${parameterListBlock}) ${asyncKeywordSurffix}
`);
}
