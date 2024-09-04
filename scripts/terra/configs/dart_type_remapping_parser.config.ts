import { CXXTYPE } from "@agoraio-extensions/cxx-parser";
import {
  DartTypeRemappingParserConfig,
  DartTypeRemappingConfig,
} from "../parsers/dart_type_remapping_parser";
import { ParseResult } from "@agoraio-extensions/terra-core";
import { _trim } from "../renderers/utils";

function _toStateItem(
  parseResult: ParseResult,
  config: DartTypeRemappingConfig
): string {
  let name = config.node.name;
  return _trim(`
  state.entries.map((entry) => StateItem(key: entry.key, value: entry.value)).toList()
`);
}

function _fromUserList(
  parseResult: ParseResult,
  config: DartTypeRemappingConfig
): string {
  let name = config.node.name;
  return _trim(`${name}.users ?? []`);
}

module.exports = {
  remappingNodes: [
    // {
    //   node: {
    //     __TYPE: CXXTYPE.Variable,
    //     name: "items",
    //     namespaces: ["agora", "rtm"],
    //     parent_full_scope_name: "agora::rtm::IRtmPresence::setState",
    //   },
    //   dartType: "Map<String, String>",
    //   converter: { to: _toStateItem },
    // } as DartTypeRemappingConfig,
    // {
    //   node: {
    //     __TYPE: CXXTYPE.Variable,
    //     name: "succeedUsers",
    //     namespaces: ["agora", "rtm"],
    //     parent_full_scope_name:
    //       "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
    //   },
    //   dartType: "List<String>",
    //   converter: { from: _fromUserList },
    // } as DartTypeRemappingConfig,
    // {
    //   node: {
    //     __TYPE: CXXTYPE.Variable,
    //     name: "failedUsers",
    //     namespaces: ["agora", "rtm"],
    //     parent_full_scope_name:
    //       "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
    //   },
    //   dartType: "List<String>",
    //   converter: { from: _fromUserList },
    // } as DartTypeRemappingConfig,
  ],
} as DartTypeRemappingParserConfig;
