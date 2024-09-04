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

export interface DartTypeRemappingInitializer {
  from?: (parseResult: ParseResult, config: DartTypeRemappingConfig) => string;
  to?: (parseResult: ParseResult, config: DartTypeRemappingConfig) => string;
  defaultValueBuilder?: (
    parseResult: ParseResult,
    config: DartTypeRemappingConfig,
    formattedDartName: string
  ) => string;
}

export interface DartTypeRemappingParserUserData {
  config?: DartTypeRemappingConfig;
}

export interface DartTypeRemappingConfig {
  node: CXXTerraNode;
  dartType: string;
  converter?: DartTypeRemappingInitializer;
}

export interface DartTypeRemappingParserConfig {
  remappingNodes?: DartTypeRemappingConfig[];
}

export interface DartTypeRemappingArgs {
  configPath: string;
}

export default function DartTypeRemappingParser(
  terraContext: TerraContext,
  args: DartTypeRemappingArgs,
  preParseResult?: ParseResult
): ParseResult | undefined {
  let parseResult = preParseResult!;
  let configPath = resolvePath(args.configPath, terraContext.configDir);
  let config = require(configPath) as DartTypeRemappingParserConfig;
  let remappingNodes = config.remappingNodes ?? [];

  function applyUserDataToMethods(methods: MemberFunction[]) {
    methods.forEach((method) => {
      method.parameters.forEach((variable) => {
        for (let remappingNode of remappingNodes) {
          if (checkObjInclude(variable, remappingNode.node)) {
            applyUserData(variable, remappingNode);
          }
        }
      });
    });
  }

  function appUserDataToMemberVariables(memberVariables: CXXTerraNode[]) {
    memberVariables.forEach((variable) => {
      for (let remappingNode of remappingNodes) {
        if (checkObjInclude(variable, remappingNode.node)) {
          applyUserData(variable, remappingNode);
          break;
        }
      }
    });
  }

  (parseResult.nodes as CXXFile[])
    .flatMap((node) => node.nodes)
    .filter((e) => e.isClazz() || e.isStruct())
    // .flatMap((clazz) => clazz.asClazz().methods)
    // .flatMap((method) => method.parameters)
    .forEach((node) => {
      if (node.isClazz()) {
        let clazz = node.asClazz();

        applyUserDataToMethods(clazz.methods);
        appUserDataToMemberVariables(clazz.member_variables);
      } else if (node.isStruct()) {
        let struct = node.asStruct();

        applyUserDataToMethods(struct.methods);
        appUserDataToMemberVariables(struct.member_variables);
      }
    });

  return parseResult;
}

function applyUserData(node: CXXTerraNode, config?: DartTypeRemappingConfig) {
  node.user_data ??= {};
  node.user_data["DartTypeRemappingParser"] = {
    config: config,
  } as DartTypeRemappingParserUserData;
}

export function getDartTypeRemapping(
  node: CXXTerraNode
): DartTypeRemappingParserUserData | undefined {
  return node.user_data?.[
    "DartTypeRemappingParser"
  ] as DartTypeRemappingParserUserData;
}
