import 'package:testcase_gen/default_generator.dart';
import 'package:testcase_gen/templated_generator.dart';

List<TemplatedTestCase> createFakeTestCases(String outputDir) {
  List<TemplatedTestCase> templatedTestCases = [
    MethoCallTemplatedTestCase(
      className: 'RtmClient',
      package: Uri.tryParse(
          'package:agora_rtm/src/bindings/gen/agora_rtm_client.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
testWidgets('{{TEST_CASE_NAME}}', (WidgetTester tester) async {
    RtmClient rtmClient = await _createBindingRtmClient();
    await rtmClient.setParameters('{"rtm.log_filter":2063}');

    try {
      {{TEST_CASE_BODY}}
    } catch (e) {
      if (e is! AgoraRtmException) {
        debugPrint('[{{TEST_CASE_NAME}}] error: \${e.toString()}');
        rethrow;
      }

      if (e.code != -4) {
        // Only not supported error supported.
        rethrow;
      }
    }

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'rtmClient',
      outputDir: outputDir,
      skipMemberFunctions: [
        'addListener',
        'removeListener',
        'getStorage',
        'getLock',
        'getPresence',
      ],
      outputFileSuffixName: 'binding_fake_test',
    ),
    MethoCallTemplatedTestCase(
      className: 'RtmLock',
      package: Uri.tryParse(
          'package:agora_rtm/src/bindings/gen/agora_rtm_lock.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(
    ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
testWidgets('{{TEST_CASE_NAME}}', (WidgetTester tester) async {
    final rtmClient = await _createBindingRtmClient();
    await rtmClient.setParameters('{"rtm.log_filter":2063}');
    final rtmLock = RtmLockImpl(rtmClient.getIrisMethodChannel());

    try {
      {{TEST_CASE_BODY}}
    } catch (e) {
      if (e is! AgoraRtmException) {
        debugPrint('[{{TEST_CASE_NAME}}] error: \${e.toString()}');
        rethrow;
      }

      if (e.code != -4) {
        // Only not supported error supported.
        rethrow;
      }
    }

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'rtmLock',
      outputDir: outputDir,
      skipMemberFunctions: [],
      outputFileSuffixName: 'binding_fake_test',
    ),
    MethoCallTemplatedTestCase(
      className: 'RtmPresence',
      package: Uri.tryParse(
          'package:agora_rtm/src/bindings/gen/agora_rtm_presence.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(
    ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
testWidgets('{{TEST_CASE_NAME}}', (WidgetTester tester) async {
    final rtmClient = await _createBindingRtmClient();
    await rtmClient.setParameters('{"rtm.log_filter":2063}');
    final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

    try {
      {{TEST_CASE_BODY}}
    } catch (e) {
      if (e is! AgoraRtmException) {
        debugPrint('[{{TEST_CASE_NAME}}] error: \${e.toString()}');
        rethrow;
      }

      if (e.code != -4) {
        // Only not supported error supported.
        rethrow;
      }
    }

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'rtmPresence',
      outputDir: outputDir,
      skipMemberFunctions: [],
      outputFileSuffixName: 'binding_fake_test',
    ),
    MethoCallTemplatedTestCase(
      className: 'RtmStorage',
      package: Uri.tryParse(
          'package:agora_rtm/src/bindings/gen/agora_rtm_storage.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(
    ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
testWidgets('{{TEST_CASE_NAME}}', (WidgetTester tester) async {
    final rtmClient = await _createBindingRtmClient();
    await rtmClient.setParameters('{"rtm.log_filter":2063}');
    final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

    try {
      {{TEST_CASE_BODY}}
    } catch (e) {
      if (e is! AgoraRtmException) {
        debugPrint('[{{TEST_CASE_NAME}}] error: \${e.toString()}');
        rethrow;
      }

      if (e.code != -4) {
        // Only not supported error supported.
        rethrow;
      }
    }

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'rtmStorage',
      outputDir: outputDir,
      skipMemberFunctions: [],
      outputFileSuffixName: 'binding_fake_test',
    ),
    MethoCallTemplatedTestCase(
      className: 'StreamChannel',
      package: Uri.tryParse(
          'package:agora_rtm/src/bindings/gen/agora_stream_channel.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(
    ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
testWidgets('{{TEST_CASE_NAME}}', (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final streamChannel = await rtmClient.createStreamChannel('stream_channel');

    try {
      {{TEST_CASE_BODY}}
    } catch (e) {
      if (e is! AgoraRtmException) {
        debugPrint('[{{TEST_CASE_NAME}}] error: \${e.toString()}');
        rethrow;
      }

      if (e.code != -4) {
        // Only not supported error supported.
        rethrow;
      }
    }

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'streamChannel',
      outputDir: outputDir,
      skipMemberFunctions: [],
      outputFileSuffixName: 'binding_fake_test',
    ),
  ];
  return templatedTestCases;
}
