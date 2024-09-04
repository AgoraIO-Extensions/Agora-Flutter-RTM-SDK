import { CXXFile, CXXTYPE, Clazz } from "@agoraio-extensions/cxx-parser";
import {
  ParseResult,
  RenderResult,
  TerraContext,
} from "@agoraio-extensions/terra-core";
import { isCallbackClass } from "./utils";
import { dartFileName, dartName } from "../parsers/dart_syntax_parser";
import { ApiInterfaceRendererArgs } from "./api_interface_renderer";
import path from "path";

export type ForwardExportRendererArgs = ApiInterfaceRendererArgs & {
  extraBindingExportFiles?: string[];
};

/// Generate the files:
/// - lib/src/binding_forward_export.dart
/// - lib/src/binding/impl_forward_export.dart
export default function ForwardExportRenderer(
  terraContext: TerraContext,
  args: ForwardExportRendererArgs,
  parseResult: ParseResult
): RenderResult[] {
  let extraBindingExportFiles = (args?.extraBindingExportFiles ?? []).map(
    (e) => {
      return `export '${e}';`;
    }
  );
  let outputDir = args.outputDir ?? "";
  let cxxFiles = parseResult!.nodes as CXXFile[];
  let bindingExportFiles: string[] = [];
  let needHideClasses: string[] = [];
  let exportApiForwardExportFiles: string[] = [];
  let implExportFiles: string[] = [];
  cxxFiles.forEach((cxxFile: CXXFile) => {
    exportApiForwardExportFiles.push(`export '${dartFileName(cxxFile)}.dart';`);

    let hasImplClass = cxxFile.nodes.find((node) => {
      return (
        node.__TYPE == CXXTYPE.Clazz && !isCallbackClass((node as Clazz).name)
      );
    });
    let hasCallbackImplClass = cxxFile.nodes.find((node) => {
      return (
        node.__TYPE == CXXTYPE.Clazz && isCallbackClass((node as Clazz).name)
      );
    });
    if (hasImplClass || hasCallbackImplClass) {
      bindingExportFiles.push(`export '${dartFileName(cxxFile)}.dart';`);
    }

    if (hasImplClass) {
      implExportFiles.push(`export '${dartFileName(cxxFile)}_impl.dart';`);
    }
    if (hasCallbackImplClass) {
      implExportFiles.push(
        `export '${dartFileName(cxxFile)}_event_impl.dart';`
      );
    }

    cxxFile.nodes.forEach((node) => {
      if (node.__TYPE == CXXTYPE.Clazz) {
        let clazz = node as Clazz;
        if (!isCallbackClass(clazz.name)) {
          needHideClasses.push(dartName(clazz));
        }
      }
    });
  });

  let needHideClassesBlock = needHideClasses.join(", ");

  // lib/src/binding_forward_export.dart
  let bindingExport = `
export 'package:agora_rtm/src/binding_forward_export.dart' hide ${needHideClassesBlock};
${bindingExportFiles.join("\n")}
${implExportFiles.join("\n")}
export 'dart:convert';
export 'dart:typed_data';
export 'package:json_annotation/json_annotation.dart';
export 'package:flutter/foundation.dart';
${extraBindingExportFiles.join("\n")}
`;

  // lib/src/binding_forward_export.dart
  let exportApiForwardExport = `
${exportApiForwardExportFiles.join("\n")}
export 'dart:convert';
export 'dart:typed_data';
export 'package:json_annotation/json_annotation.dart';
export 'package:flutter/foundation.dart';
export 'package:agora_rtm/src/bindings/json_converters.dart';
export 'package:agora_rtm/src/agora_rtm_client_ext.dart';
`;

  // lib/src/binding/impl_forward_export.dart
  let implExport = `
${implExportFiles.join("\n")}
export 'event_handler_param_json.dart';
export 'call_api_impl_params_json.dart';
export 'call_api_event_handler_buffer_ext.dart';
`;

  return [
    {
      file_name: path.join(outputDir, `binding_forward_export.dart`),
      file_content: exportApiForwardExport,
    },
    {
      file_name: path.join(
        outputDir,
        "bindings",
        "gen",
        `binding_forward_export.dart`
      ),
      file_content: bindingExport,
    },

    // {
    //   file_name: "lib/src/binding/impl_forward_export.dart",
    //   file_content: implExport,
    // },
  ];
}
