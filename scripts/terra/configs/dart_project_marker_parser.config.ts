import { CXXTYPE, CXXTerraNode } from "@agoraio-extensions/cxx-parser";
import {
  DartProjectMarkerParserConfig,
  DisplayNameConfig,
  FlattenParamNodeConfig,
} from "../parsers/dart_project_marker_parser";
import { ParseResult } from "@agoraio-extensions/terra-core";
import { _trim } from "../renderers/utils";

function _dartSetTypeDefaultValueBuilder(
  parseResult: ParseResult,
  config: DisplayNameConfig,
  formattedDartName: string
): string {
  return `const {${formattedDartName}}`;
}

function _toStateItem(
  parseResult: ParseResult,
  config: DisplayNameConfig
): string {
  let name = config.displayName;
  return _trim(`
  ${name}.entries.map((entry) => StateItem(key: entry.key, value: entry.value)).toList()
`);
}

function _toMetadata(
  parseResult: ParseResult,
  config: DisplayNameConfig
): string {
  let name = config.displayName ?? config.node.name;
  return _trim(`
  Metadata(majorRevision: majorRevision, items: ${name});
  `);
}

function _fromUserList(
  parseResult: ParseResult,
  config: DisplayNameConfig
): string {
  let name = config.node.name;
  return _trim(`${name}.users ?? []`);
}

module.exports = {
  jsonConverters: [
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "areaCode",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::RtmConfig",
      },
      jsonConverter: "@RtmAreaCodeListConverter()",
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "serviceType",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::RtmPrivateConfig",
      },
      jsonConverter: "@RtmServiceTypeListConverter()",
    },
  ],
  displayNameConfigs: [
    {
      node: {
        __TYPE: CXXTYPE.EnumConstant,
        name: "RTM_AREA_CODE_IN",
        parent_full_scope_name: "agora::rtm::RTM_AREA_CODE",
      },
      displayName: "ind",
    },
    {
      node: {
        __TYPE: CXXTYPE.EnumConstant,
        name: "RTM_AREA_CODE_AS",
        parent_full_scope_name: "agora::rtm::RTM_AREA_CODE",
      },
      displayName: "asm",
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "areaCode",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::RtmConfig",
      },
      displayType: "Set<RtmAreaCode>",
      converter: { defaultValueBuilder: _dartSetTypeDefaultValueBuilder },
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "serviceType",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::RtmPrivateConfig",
      },
      displayType: "Set<RtmServiceType>",
      converter: { defaultValueBuilder: _dartSetTypeDefaultValueBuilder },
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "meta",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::JoinTopicOptions",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "''";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "syncWithMedia",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::JoinTopicOptions",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "false";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "page",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::PresenceOptions",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "''";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "items",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmPresence::setState",
      },
      displayName: "state",
      displayType: "Map<String, String>",
      converter: {
        to: _toStateItem,
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "keys",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmPresence::removeState",
      },
      displayName: "states",
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "const []";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "succeedUsers",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name:
          "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
      },
      displayType: "List<String>",
      converter: { from: _fromUserList },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "failedUsers",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name:
          "agora::rtm::IRtmEventHandler::onSubscribeTopicResult",
      },
      displayType: "List<String>",
      converter: { from: _fromUserList },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "lockName",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmStorage::setChannelMetadata",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "''";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "lockName",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name:
          "agora::rtm::IRtmStorage::updateChannelMetadata",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "''";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "lockName",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name:
          "agora::rtm::IRtmStorage::removeChannelMetadata",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "''";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "ttl",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmLock::setLock",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "10";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.Variable,
        name: "retry",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmLock::acquireLock",
      },
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "false";
        },
      },
    },
    {
      node: {
        __TYPE: CXXTYPE.MemberVariable,
        name: "items",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::Metadata",
      },
      displayName: "metadata",
      converter: {
        defaultValueBuilder: (
          parseResult: ParseResult,
          config: DisplayNameConfig,
          formattedDartName: string
        ) => {
          return "const []";
        },
        to: _toMetadata,
      },
    },
  ],
  trimNamePrefixConfigs: [
    {
      node: {
        __TYPE: CXXTYPE.Enumz,
        name: "RTM_CONNECTION_CHANGE_REASON",
        namespaces: ["agora", "rtm"],
      },
      trimPrefix: "RTM_CONNECTION_CHANGED_",
    },
    {
      node: {
        __TYPE: CXXTYPE.Enumz,
        name: "RTM_ERROR_CODE",
        namespaces: ["agora", "rtm"],
      },
      trimPrefix: "RTM_ERROR_",
    },
  ],
  hiddenNodes: [
    {
      __TYPE: CXXTYPE.MemberVariable,
      name: "appId",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
    },
    {
      __TYPE: CXXTYPE.MemberVariable,
      name: "userId",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
    },
    {
      __TYPE: CXXTYPE.MemberVariable,
      name: "context",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
    },
    {
      __TYPE: CXXTYPE.MemberVariable,
      name: "multipath",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::RtmConfig",
    },
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "onConnectionStateChanged",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler",
    },
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "onTokenPrivilegeWillExpire",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IRtmEventHandler",
    },
    {
      __TYPE: CXXTYPE.MemberFunction,
      name: "publishTopicMessage",
      namespaces: ["agora", "rtm"],
      parent_full_scope_name: "agora::rtm::IStreamChannel",
    },
  ],

  flattenParamNodeConfigs: [
    {
      isFlattenParam: (
        parseResult: ParseResult,
        config: FlattenParamNodeConfig,
        node: CXXTerraNode
      ) => {
        let regex = new RegExp("(.*)Options$");
        return node.isVariable() && regex.test(node.asVariable().type.name);
      },
      hiddenParamsAfterFlatten: [
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "messageType",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::PublishOptions",
        },
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "messageType",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::TopicMessageOptions",
        },
      ],
    },
    {
      isFlattenParam: (
        parseResult: ParseResult,
        config: FlattenParamNodeConfig,
        node: CXXTerraNode
      ) => {
        let regex = new RegExp("(.*)Metadata$");
        return node.isVariable() && regex.test(node.asVariable().type.name);
      },
    },
    {
      flattenFunctionNode: {
        __TYPE: CXXTYPE.MemberFunction,
        name: "setChannelMetadata",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmStorage",
      },
      notANamedParametersAfterFlatten: [
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "items",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::Metadata",
        },
      ],
    },
    {
      flattenFunctionNode: {
        __TYPE: CXXTYPE.MemberFunction,
        name: "updateChannelMetadata",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmStorage",
      },
      notANamedParametersAfterFlatten: [
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "items",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::Metadata",
        },
      ],
    },
    {
      flattenFunctionNode: {
        __TYPE: CXXTYPE.MemberFunction,
        name: "setUserMetadata",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmStorage",
      },
      notANamedParametersAfterFlatten: [
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "items",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::Metadata",
        },
      ],
    },
    {
      flattenFunctionNode: {
        __TYPE: CXXTYPE.MemberFunction,
        name: "updateUserMetadata",
        namespaces: ["agora", "rtm"],
        parent_full_scope_name: "agora::rtm::IRtmStorage",
      },
      notANamedParametersAfterFlatten: [
        {
          __TYPE: CXXTYPE.MemberVariable,
          name: "items",
          namespaces: ["agora", "rtm"],
          parent_full_scope_name: "agora::rtm::Metadata",
        },
      ],
    },
  ],
} as DartProjectMarkerParserConfig;
