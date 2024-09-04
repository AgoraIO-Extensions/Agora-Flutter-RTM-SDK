// import { CXXTYPE } from "@agoraio-extensions/cxx-parser";

// module.exports = {
//   remappingNodes: [
//     {
//       node: {
//         __TYPE: CXXTYPE.Variable,
//         name: "items",
//         namespaces: ["agora", "rtm"],
//         parent_full_scope_name: "agora::rtm::IRtmPresence::setState",
//       },
//       dartType: "Map<String, String>",
//     } as RemappingNodeDartTypeConfig,
//     {
//       node: {
//         __TYPE: CXXTYPE.Variable,
//         name: "succeedUsers",
//         namespaces: ["agora", "rtm"],
//         parent_full_scope_name:
//           "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
//       },
//       dartType: "List<String>",
//     } as RemappingNodeDartTypeConfig,
//     {
//       node: {
//         __TYPE: CXXTYPE.Variable,
//         name: "failedUsers",
//         namespaces: ["agora", "rtm"],
//         parent_full_scope_name:
//           "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
//       },
//       dartType: "List<String>",
//     } as RemappingNodeDartTypeConfig,
//     {
//       node: {
//         __TYPE: CXXTYPE.MemberVariable,
//         name: "states",
//         namespaces: ["agora", "rtm"],
//         parent_full_scope_name: "agora::rtm::UserState",
//       },
//       dartType: "Map<String, String>",
//     } as RemappingNodeDartTypeConfig,
//   ],
// } as ExportRtmApiInterfaceRendererConfig;
