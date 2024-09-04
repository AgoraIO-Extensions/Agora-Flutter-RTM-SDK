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

export interface SyncFunctionsMarkerParserUserData {
  isMarkedAsSyncFunction?: boolean;
}

export interface SyncFunctionsMarkerParserConfig {
  syncFunctionNodes?: CXXTerraNode[];
}

export interface SyncFunctionsMarkerArgs {
  configPath: string;
}

export default function SyncFunctionsMarkerParser(
  terraContext: TerraContext,
  args: SyncFunctionsMarkerArgs,
  preParseResult?: ParseResult
): ParseResult | undefined {
  let parseResult = preParseResult!;
  let configPath = resolvePath(args.configPath, terraContext.configDir);
  let config = require(configPath) as SyncFunctionsMarkerParserConfig;
  let syncFunctionNodes = config.syncFunctionNodes ?? [];


  (parseResult.nodes as CXXFile[])
    .flatMap((node) => node.nodes)
    .filter((e) => e.isClazz() )
    .flatMap((clazz) => clazz.asClazz().methods)
    // .flatMap((method) => method.parameters)
    .forEach((node) => {
      for (let syncFunctionNode of syncFunctionNodes) {
        if (checkObjInclude(node, syncFunctionNode)) {
          // variable.dartType = remappingNode.dartType;
          applyUserData(node);
          break;
        }
      }
    });

  return parseResult;
}

function applyUserData(node: CXXTerraNode) {
  node.user_data ??= {};
  node.user_data["SyncFunctionsMarkerParser"] = {
    isMarkedAsSyncFunction: true,
  } as SyncFunctionsMarkerParserUserData;
}

export function getSyncFunctionsMarkerParserUserData(
  node: CXXTerraNode
): SyncFunctionsMarkerParserUserData | undefined {
  return node.user_data?.[
    "SyncFunctionsMarkerParser"
  ] as SyncFunctionsMarkerParserUserData;
}
