import 'package:testcase_gen/default_generator.dart';
import 'package:testcase_gen/templated_generator.dart';

List<TemplatedTestCase> createEventHandlerTestCases(String outputDir) {
  List<TemplatedTestCase> templatedTestCases = [
    EventHandlerTemplatedTestCase(
      callerObjClassName: 'RtmClient',
      className: 'RtmEventHandler',
      testCaseFileTemplate: '''
$defaultHeader

import 'dart:async';
import 'dart:typed_data';

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';
import 'event_ids_mapping_gen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iris_tester/iris_tester.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(ValueGetter<IrisTester> irisTester,
    ValueGetter<List<InitilizationArgProvider>> irisMethodChannelInitilizationArgs) {

  Future<RtmClientImplOverride> _createBindingRtmClient(RtmEventHandler rtmEventHandler) async {
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
    {{TEST_CASE_BODY}}

    await rtmClient.release();
  },
  timeout: const Timeout(Duration(minutes: 2)),
);
''',
      callerObjName: 'rtmClient',
      outputDir: outputDir,
      eventPrefixOverride: '',
      registerFunctionName: '',
      unregisterFunctionName: '',
      registerFunctionBlockBuilder: (eventHandlerName) {
        return '''
final rtmClient = await _createBindingRtmClient($eventHandlerName);
''';
      },
      skipMemberFunctions: [],
    ),
  ];
  return templatedTestCases;
}
