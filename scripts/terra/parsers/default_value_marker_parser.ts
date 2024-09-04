import { CXXFile, CXXTerraNode } from "@agoraio-extensions/cxx-parser";
import {
  ParseResult,
  TerraContext,
  resolvePath,
} from "@agoraio-extensions/terra-core";
import { checkObjInclude } from "@agoraio-extensions/terra_shared_configs";

export interface DefaultValuesConfig {
  node: CXXTerraNode;
  value: string;
}

export interface DefaultValuesConfigs {
  defaultValues?: DefaultValuesConfig[];
}

export interface DefaultValueMarkerParserArgs {
  configPath: string;
}

export default function DefaultValueMarkerParser(
  terraContext: TerraContext,
  args: DefaultValueMarkerParserArgs,
  preParseResult?: ParseResult
): ParseResult | undefined {
  let parseResult = preParseResult!;
  let configPath = resolvePath(args.configPath, terraContext.configDir);
  let config = require(configPath) as DefaultValuesConfigs;
  let defaultValues = config.defaultValues ?? [];

  (parseResult.nodes as CXXFile[])
    .flatMap((node) => node.nodes)
    .filter((e) => e.isClazz())
    .flatMap((clazz) => clazz.asClazz().methods)
    .flatMap((method) => method.parameters)
    .forEach((variable) => {
      for (let defaultValue of defaultValues) {
        if (checkObjInclude(variable, defaultValue.node)) {
          variable.default_value = defaultValue.value;
          break;
        }
      }
    });

  return parseResult;
}
