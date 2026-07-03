import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Directory get repoRoot => Directory.current.parent.parent;

String readRepoFile(String relativePath) {
  return File('${repoRoot.path}/$relativePath').readAsStringSync();
}

bool repoFileExists(String relativePath) {
  return File('${repoRoot.path}/$relativePath').existsSync();
}

String pluginPlatformBlock(String pubspec, String platformName) {
  final start = pubspec.indexOf('      $platformName:\n');
  if (start == -1) {
    return '';
  }

  final rest = pubspec.substring(start);
  final nextPlatform =
      RegExp(r'\n      [a-z]+:\n').firstMatch(rest.substring(1));
  if (nextPlatform == null) {
    return rest;
  }

  return rest.substring(0, nextPlatform.start + 1);
}

void main() {
  group('desktop platform support config', () {
    test('root pubspec declares macos and windows plugin platforms', () {
      final pubspec = readRepoFile('pubspec.yaml');
      final macosBlock = pluginPlatformBlock(pubspec, 'macos');
      final windowsBlock = pluginPlatformBlock(pubspec, 'windows');

      expect(macosBlock, contains('pluginClass: AgoraRtmPlugin'));
      expect(windowsBlock, contains('pluginClass: AgoraRtmPluginCApi'));
    });

    test('macos and windows plugin files exist', () {
      const expectedFiles = <String>[
        'macos/agora_rtm.podspec',
        'macos/Classes/AgoraRtmPlugin.h',
        'macos/Classes/AgoraRtmPlugin.m',
        'windows/CMakeLists.txt',
        'windows/cmake/DownloadSDK.cmake',
        'windows/include/agora_rtm/agora_rtm_plugin_c_api.h',
        'windows/agora_rtm_plugin_c_api.cpp',
        'windows/agora_rtm_plugin.h',
        'windows/agora_rtm_plugin.cpp',
      ];

      for (final path in expectedFiles) {
        expect(repoFileExists(path), isTrue, reason: '$path should exist');
      }
    });

    test('desktop dependencies are wired into update scripts', () {
      final updateDeps = readRepoFile('ci/run_update_deps.sh');
      final artifactsVersion = readRepoFile('scripts/artifacts_version.sh');
      final integrationScript =
          readRepoFile('scripts/run_flutter_integration_test.sh');

      expect(updateDeps, contains('dep_file_macos=macos/agora_rtm.podspec'));
      expect(updateDeps,
          contains('dep_file_windows=windows/cmake/DownloadSDK.cmake'));
      expect(updateDeps, contains(r'"${platform}" == "macOS"'));
      expect(updateDeps, contains(r'"${platform}" == "Windows"'));
      expect(artifactsVersion, contains('IRIS_CDN_URL_MACOS'));
      expect(artifactsVersion, contains('IRIS_CDN_URL_WINDOWS'));
      expect(integrationScript, contains('PLATFORM} == "macos"'));
      expect(integrationScript, contains('PLATFORM} == "windows"'));
    });

    test('desktop platforms are covered by CI workflows', () {
      final runTestWorkflow = readRepoFile('.github/workflows/run_test.yml');
      final buildExampleWorkflow =
          readRepoFile('.github/workflows/run_build_example.yml');

      expect(runTestWorkflow, contains('integration_test_macos:'));
      expect(runTestWorkflow, contains('integration_test_windows:'));
      expect(runTestWorkflow, contains('build_macos:'));
      expect(runTestWorkflow, contains('build_windows:'));
      expect(runTestWorkflow,
          contains('scripts/run_flutter_integration_test.sh "macos"'));
      expect(runTestWorkflow,
          contains('scripts/run_flutter_integration_test.sh "windows"'));
      expect(buildExampleWorkflow,
          contains('os: [ubuntu-latest, macos-14, windows-latest]'));
      expect(buildExampleWorkflow, contains('os: macos-14'));
      expect(buildExampleWorkflow, isNot(contains('os: macos-latest')));
    });

    test('macos runners avoid duplicate aosl framework when RTC is present',
        () {
      final examplePodfile = readRepoFile('example/macos/Podfile');
      final integrationPodfile =
          readRepoFile('test_shard/integration_test_app/macos/Podfile');

      for (final podfile in [examplePodfile, integrationPodfile]) {
        expect(podfile, contains('AgoraRtm_OC_Special'));
        expect(podfile, contains('aosl.xcframework'));
        expect(podfile, contains('FileUtils.rm_rf'));
      }
    });
  });
}
