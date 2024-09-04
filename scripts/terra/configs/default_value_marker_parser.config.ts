import { CXXTYPE, CXXTerraNode } from "@agoraio-extensions/cxx-parser";
import {
  DefaultValuesConfig,
  DefaultValuesConfigs,
} from "../parsers/default_value_marker_parser";

module.exports = {
  defaultValues: [
    // {
    //   node: {
    //     __TYPE: CXXTYPE.Variable,
    //     name: "lockName",
    //     namespaces: ["agora", "rtm"],
    //     parent_full_scope_name: "agora::rtm::IRtmStorage::setChannelMetadata",
    //   } as CXXTerraNode,
    //   value: '\'\'',
    // } as DefaultValuesConfig,
    // {
    //   node: {
    //     __TYPE: CXXTYPE.Variable,
    //     name: "lockName",
    //     namespaces: ["agora", "rtm"],
    //     parent_full_scope_name:
    //       "agora::rtm::IRtmStorage::updateChannelMetadata",
    //   } as CXXTerraNode,
    //   value: '\'\'',
    // } as DefaultValuesConfig,
  ],
} as DefaultValuesConfigs;
