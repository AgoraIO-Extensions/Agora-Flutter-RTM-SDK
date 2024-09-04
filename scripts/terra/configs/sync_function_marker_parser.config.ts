import { CXXTYPE } from "@agoraio-extensions/cxx-parser";
import { SyncFunctionsMarkerParserConfig } from "../parsers/sync_function_marker_parser";

module.exports = {
  syncFunctionNodes: [
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "getStorage",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmClient",
    },
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "getLock",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmClient",
    },
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "getPresence",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmClient",
    },
  ],
} as SyncFunctionsMarkerParserConfig;
