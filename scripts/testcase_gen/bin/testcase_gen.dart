import 'dart:io';

import 'package:args/args.dart';
import 'package:paraphrase/paraphrase.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:testcase_gen/templated_generator.dart';

import 'event_handler_gen_config.dart';
import 'method_call_gen_config.dart';
import 'unit_test_gen_config.dart';

const file.FileSystem fileSystem = LocalFileSystem();

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addFlag('gen-integration-test');
  parser.addFlag('gen-fake-test');
  parser.addOption('output-dir', mandatory: true);

  final results = parser.parse(arguments);

  final genIntegrationTest = results['gen-integration-test'] ?? false;
  final genFakeTest = results['gen-fake-test'] ?? false;
  final outputDir = results['output-dir']!;

  final srcDir = path.join(
    fileSystem.currentDirectory.absolute.path,
    'lib',
    'src',
  );
  final List<String> includedPaths = <String>[
    path.join(srcDir, 'agora_rtm_base.dart'),
    path.join(srcDir, 'agora_rtm_client.dart'),
    path.join(srcDir, 'agora_rtm_lock.dart'),
    path.join(srcDir, 'agora_rtm_presence.dart'),
    path.join(srcDir, 'agora_rtm_storage.dart'),
    path.join(srcDir, 'agora_stream_channel.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_rtm_client.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_rtm_lock.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_rtm_presence.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_rtm_storage.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_stream_channel.dart'),
  ];

  final bindingIntegrationTestOutputDir =
      path.join(outputDir, 'integration_test', 'generated', 'bindings');
  final unitTestOutputDir = path.join(outputDir, 'test', 'generated');
  List<TemplatedTestCase> templatedTestCases = [];
  if (genIntegrationTest) {
    templatedTestCases = [
      ...createUnitTestCases(unitTestOutputDir),
      ...createFakeTestCases(bindingIntegrationTestOutputDir),
      ...createEventHandlerTestCases(bindingIntegrationTestOutputDir),
    ];
  } else if (genFakeTest) {}

  Paraphrase paraphrase = Paraphrase(includedPaths: includedPaths);
  final parseResult = paraphrase.visit();

  final generator = TemplatedGenerator(templatedTestCases);

  final file = File('tmp');
  final fileSink = file.openWrite();
  generator.generate(fileSink, parseResult);

  file.delete(recursive: true);
}
