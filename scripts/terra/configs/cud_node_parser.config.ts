import { CXXTYPE, SimpleTypeKind } from "@agoraio-extensions/cxx-parser";

const deleteNodes = [
  // agora::rtm::IRtmClient::createStreamChannel
  {
    __TYPE: CXXTYPE.Variable,
    name: "errorCode",
    namespaces: ["agora", "rtm"],
    parent_full_scope_name: "agora::rtm::IRtmClient::createStreamChannel",
  },
];

const updateNodes = [
  {
    node: {
      __TYPE: CXXTYPE.Variable,
      name: "items",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmPresence::setState",
    },
    updated: {
      __TYPE: CXXTYPE.Variable,
      name: "items",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmPresence::setState",
      type: {
        __TYPE: CXXTYPE.SimpleType,
        is_builtin_type: false,
        is_const: true,
        kind: SimpleTypeKind.array_t,
      },
    },
  },

  // agora::rtm::IRtmEventHandler::MessageEvent::message
  {
    node: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "message",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler::MessageEvent",
    },
    updated: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "message",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler::MessageEvent",
      type: {
        __TYPE: CXXTYPE.SimpleType,
        is_builtin_type: false,
        is_const: true,
        kind: SimpleTypeKind.pointer_t,
        name: "uint8_t",
        source: "const uint8_t*",
      },
    },
  },
  // agora::rtm::RtmConfig::areaCode
  {
    node: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "areaCode",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
    },
    updated: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "areaCode",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
      type: {
        __TYPE: CXXTYPE.SimpleType,
        is_builtin_type: false,
        is_const: false,
        kind: SimpleTypeKind.array_t,
      },
    },
  },
  // agora::rtm::RtmPrivateConfig::serviceType
  {
    node: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "serviceType",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmPrivateConfig",
    },
    updated: {
      __TYPE: CXXTYPE.MemberVariable,
      name: "serviceType",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmPrivateConfig",
      type: {
        __TYPE: CXXTYPE.SimpleType,
        is_builtin_type: false,
        is_const: false,
        kind: SimpleTypeKind.array_t,
      },
    },
  },
  {
    node: {
      __TYPE: CXXTYPE.Variable,
      name: "channels",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler::onWhereNowResult",
    },
    updated: {
      __TYPE: CXXTYPE.Variable,
      name: "channels",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler::onWhereNowResult",
      type: {
        __TYPE: CXXTYPE.SimpleType,
        is_builtin_type: false,
        is_const: true,
        kind: SimpleTypeKind.array_t,
      },
    },
  },
];

module.exports = {
  deleteNodes: deleteNodes,
  updateNodes: updateNodes,
};
