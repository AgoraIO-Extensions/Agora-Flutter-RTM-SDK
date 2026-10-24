import 'dart:io';

import 'package:args/args.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:path/path.dart' as path;
import 'package:testcase_gen/core/paraphrase.dart';
import 'package:testcase_gen/templated_generator.dart';

import 'unit_test_gen_config.dart';

const file.FileSystem fileSystem = LocalFileSystem();

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption('output-dir', mandatory: true);

  final results = parser.parse(arguments);

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

  // RTM 2.3.1 moved callbacks and their payloads into separate files.
  for (final eventPath in [
    path.join(srcDir, 'agora_rtm_event_handler.dart'),
    path.join(srcDir, 'bindings', 'gen', 'agora_rtm_event_handler.dart'),
  ]) {
    if (File(eventPath).existsSync()) includedPaths.add(eventPath);
  }
  final unitTestOutputDir = path.join(outputDir, 'test', 'generated');
  final templatedTestCases = createUnitTestCases(unitTestOutputDir);

  Paraphrase paraphrase = Paraphrase(includedPaths: includedPaths);
  final parseResult = paraphrase.visit();

  final generator = TemplatedGenerator(templatedTestCases);

  final file = File('tmp');
  final fileSink = file.openWrite();
  generator.generate(fileSink, parseResult);

  file.delete(recursive: true);
}
