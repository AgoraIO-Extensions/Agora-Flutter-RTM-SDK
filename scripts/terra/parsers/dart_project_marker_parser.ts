import {
  CXXFile,
  CXXTerraNode,
  MemberFunction,
} from "@agoraio-extensions/cxx-parser";
import {
  ParseResult,
  TerraContext,
  resolvePath,
} from "@agoraio-extensions/terra-core";
import { checkObjInclude } from "@agoraio-extensions/terra_shared_configs";

export interface DartProjectMarkerParserUserData {
  jsonConverter?: JsonConverterConfig;
  displayNameConfig?: DisplayNameConfig;
  trimNamePrefixConfig?: TrimNamePrefixConfig;
  isHiddenNode?: boolean;
  flattenParamNodeConfig?: FlattenParamNodeConfig;
  isHiddenNodesAfterFlatten?: boolean;
}

export interface JsonConverterConfig {
  node: CXXTerraNode;
  jsonConverter: string;
}

export interface DisplayAndActualTypeConverter {
  from?: (parseResult: ParseResult, config: DisplayNameConfig) => string;
  to?: (parseResult: ParseResult, config: DisplayNameConfig) => string;
  defaultValueBuilder?: (
    parseResult: ParseResult,
    config: DisplayNameConfig,
    formattedDartName: string
  ) => string;
}

export interface DisplayNameConfig {
  node: CXXTerraNode;
  displayName?: string;
  displayType?: string;
  converter?: DisplayAndActualTypeConverter;
}

export interface TrimNamePrefixConfig {
  node: CXXTerraNode;
  trimPrefix: string;
}

export interface FlattenParamNodeConfig {
  flattenFunctionNode?: CXXTerraNode;
  // isFlattenFunctionNode?: (
  //   parseResult: ParseResult,
  //   config: FlattenNodeConfig,
  //   node: CXXTerraNode
  // ) => boolean;
  flattenParams?: CXXTerraNode[];
  isFlattenParam?: (
    parseResult: ParseResult,
    config: FlattenParamNodeConfig,
    node: CXXTerraNode
  ) => boolean;
  hiddenParamsAfterFlatten?: CXXTerraNode[];
  notANamedParametersAfterFlatten?: CXXTerraNode[];
}

export interface DartProjectMarkerParserConfig {
  jsonConverters?: JsonConverterConfig[];
  displayNameConfigs?: DisplayNameConfig[];
  trimNamePrefixConfigs?: TrimNamePrefixConfig[];
  hiddenNodes?: CXXTerraNode[]; // hide node in global scope
  flattenParamNodeConfigs?: FlattenParamNodeConfig[];
}

export interface DartProjectMarkerArgs {
  configPath: string;
}

export default function DartProjectMarkerParser(
  terraContext: TerraContext,
  args: DartProjectMarkerArgs,
  preParseResult?: ParseResult
): ParseResult | undefined {
  let parseResult = preParseResult!;
  let configPath = resolvePath(args.configPath, terraContext.configDir);
  let config = require(configPath) as DartProjectMarkerParserConfig;
  let jsonConverters = config.jsonConverters ?? [];
  let displayNameConfigs = config.displayNameConfigs ?? [];
  let trimNamePrefixConfigs = config.trimNamePrefixConfigs ?? [];
  let hiddenNodes = config.hiddenNodes ?? [];
  let flattenParamNodeConfigs = config.flattenParamNodeConfigs ?? [];

  (parseResult.nodes as CXXFile[])
    .flatMap((node) => node.nodes)
    .forEach((node) => {
      if (node.isClazz()) {
        node.asClazz().methods.forEach((method) => {
          for (let hiddenNode of hiddenNodes) {
            if (checkObjInclude(method, hiddenNode)) {
              applyHiddenNodeConfig(method, true);
            }
          }

          for (let flattenNodeConfig of flattenParamNodeConfigs) {
            if (flattenNodeConfig.flattenFunctionNode) {
              if (
                checkObjInclude(method, flattenNodeConfig.flattenFunctionNode)
              ) {
                applyFlattenParamNodeConfig(method, flattenNodeConfig);
              }
            }
          }

          method.parameters.forEach((variable) => {
            // let isFlattenParams = false;
            for (let flattenNodeConfig of flattenParamNodeConfigs) {
              if (flattenNodeConfig.flattenParams) {
                for (let flattenParam of flattenNodeConfig.flattenParams) {
                  if (checkObjInclude(variable, flattenParam)) {
                    applyFlattenParamNodeConfig(variable, flattenNodeConfig);
                  }
                }
              }

              if (flattenNodeConfig.isFlattenParam) {
                if (
                  flattenNodeConfig.isFlattenParam(
                    parseResult,
                    flattenNodeConfig,
                    variable
                  )
                ) {
                  applyFlattenParamNodeConfig(variable, flattenNodeConfig);
                }
              }
            }
          });

          method.parameters.forEach((variable) => {
            for (let displayNameConfig of displayNameConfigs) {
              if (checkObjInclude(variable, displayNameConfig.node)) {
                applyDisplayNameConfig(variable, displayNameConfig);
              }
            }
          });
        });
      }

      if (node.isStruct()) {
        let structt = node.asStruct();

        structt.member_variables.forEach((variable) => {
          for (let jsonConverter of jsonConverters) {
            if (checkObjInclude(variable, jsonConverter.node)) {
              applyJsonConverterConfig(variable, jsonConverter);
            }
          }

          for (let displayNameConfig of displayNameConfigs) {
            if (checkObjInclude(variable, displayNameConfig.node)) {
              applyDisplayNameConfig(variable, displayNameConfig);
            }
          }

          for (let hiddenNode of hiddenNodes) {
            if (checkObjInclude(variable, hiddenNode)) {
              applyHiddenNodeConfig(variable, true);
            }
          }
        });
      }

      if (node.isEnumz()) {
        let enumz = node.asEnumz();
        for (let trimNamePrefixConfig of trimNamePrefixConfigs) {
          if (checkObjInclude(enumz, trimNamePrefixConfig.node)) {
            applyTrimNamePrefixConfig(enumz, trimNamePrefixConfig);
          }
        }

        enumz.enum_constants.forEach((enumConstant) => {
          for (let jsonConverter of jsonConverters) {
            if (checkObjInclude(enumConstant, jsonConverter.node)) {
              applyJsonConverterConfig(enumConstant, jsonConverter);
            }
          }

          for (let displayNameConfig of displayNameConfigs) {
            if (checkObjInclude(enumConstant, displayNameConfig.node)) {
              applyDisplayNameConfig(enumConstant, displayNameConfig);
            }
          }
        });
      }
    });

  return parseResult;
}

function applyJsonConverterConfig(
  node: CXXTerraNode,
  jsonConverterConfig: JsonConverterConfig
) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].jsonConverter = jsonConverterConfig;
}

function applyDisplayNameConfig(
  node: CXXTerraNode,
  displayNameConfig: DisplayNameConfig
) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].displayNameConfig =
    displayNameConfig;
}

function applyTrimNamePrefixConfig(
  node: CXXTerraNode,
  trimNamePrefixConfig: TrimNamePrefixConfig
) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].trimNamePrefixConfig =
    trimNamePrefixConfig;
}

function applyHiddenNodeConfig(node: CXXTerraNode, isHiddenNode: boolean) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].isHiddenNode = isHiddenNode;
}

function applyIsHiddenNodesAfterFlatten(
  node: CXXTerraNode,
  isHiddenNodesAfterFlatten: boolean
) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].isHiddenNodesAfterFlatten =
    isHiddenNodesAfterFlatten;
}

export function isHiddenNodesAfterFlatten(
  node: CXXTerraNode,
  target: CXXTerraNode
): boolean {
  let hiddenParamsAfterFlatten =
    getDartProjectMarkerParserUserData(node)?.flattenParamNodeConfig
      ?.hiddenParamsAfterFlatten ?? [];
  for (let hiddenNode of hiddenParamsAfterFlatten) {
    if (checkObjInclude(target, hiddenNode)) {
      return true;
    }
  }

  return false;
}

export function isNotANamedParametersAfterFlattenOfMethod(
  node: MemberFunction,
  target: CXXTerraNode
): boolean {
  let notANamedParametersAfterFlatten =
    getDartProjectMarkerParserUserData(node)?.flattenParamNodeConfig
      ?.notANamedParametersAfterFlatten ?? [];
  for (let param of notANamedParametersAfterFlatten) {
    if (checkObjInclude(target, param)) {
      return true;
    }
  }

  return false;
}

function applyFlattenParamNodeConfig(
  node: CXXTerraNode,
  flattenParamNodeConfig: FlattenParamNodeConfig
) {
  node.user_data ??= {};
  if (!node.user_data["DartProjectMarkerParser"]) {
    node.user_data["DartProjectMarkerParser"] =
      {} as DartProjectMarkerParserUserData;
  }
  node.user_data["DartProjectMarkerParser"].flattenParamNodeConfig =
    flattenParamNodeConfig;
}

export function isFlattenParamNodeTypeStruct(
  parseResult: ParseResult,
  node: CXXTerraNode
): boolean {
  let allParams = (parseResult.nodes as CXXFile[])
    .flatMap((node) => node.nodes)
    .filter((e) => e.isClazz())
    .flatMap((clazz) => clazz.asClazz().methods)
    .flatMap((method) => method.parameters)
    .filter(
      (param) =>
        getDartProjectMarkerParserUserData(param)?.flattenParamNodeConfig
    );
  let allStructs = allParams.map((param) => {
    return parseResult.resolveNodeByType(param.type);
  });

  return allStructs.find((struct) => struct == node) !== undefined;
}

export function getDartProjectMarkerParserUserData(
  node: CXXTerraNode
): DartProjectMarkerParserUserData | undefined {
  return node.user_data?.[
    "DartProjectMarkerParser"
  ] as DartProjectMarkerParserUserData;
}
