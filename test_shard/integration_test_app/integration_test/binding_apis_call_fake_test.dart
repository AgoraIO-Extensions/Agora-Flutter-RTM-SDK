import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:iris_tester/iris_tester.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

import 'generated/bindings/rtmclient_binding_fake_test.generated.dart'
    as rtmclient_binding_fake_test;
import 'generated/bindings/rtmlock_binding_fake_test.generated.dart'
    as rtmlock_binding_fake_test;
import 'generated/bindings/rtmpresence_binding_fake_test.generated.dart'
    as rtmpresence_binding_fake_test;
import 'generated/bindings/rtmstorage_binding_fake_test.generated.dart'
    as rtmstorage_binding_fake_test;
import 'generated/bindings/streamchannel_binding_fake_test.generated.dart'
    as streamchannel_binding_fake_test;
// import 'generated/bindings/rtmclient_rtmeventhandler_testcases.generated.dart'
//     as rtmclient_rtmeventhandler_testcases;

import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart'
    as rtm_client_impl_override;

class TestInitilizationArgProvider implements InitilizationArgProvider {
  TestInitilizationArgProvider(this.testerArgs);
  TestInitilizationArgProvider.fromValue(IrisHandle this.value)
      : testerArgs = [];
  final List<TesterArgsProvider> testerArgs;
  IrisHandle? value;
  @override
  IrisHandle provide(IrisApiEngineHandle apiEngineHandle) {
    return value ?? ObjectIrisHandle(testerArgs[0](apiEngineHandle()));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  IrisTester? irisTester;

  List<InitilizationArgProvider> irisMethodChannelInitilizationArgs = [];

  setUp(() {
    irisTester = createIrisTester();
    irisTester!.initialize();
    if (kIsWeb) {
      rtm_client_impl_override.setMockSharedNativeHandleProvider(
          TestInitilizationArgProvider(irisTester!.getTesterArgs()));
    } else {
      // On IO, the function return from the `irisTester.getTesterArgs()` capture
      // the `Pointer` from `IrisTester`, which is invalid to pass to the `Isolate`,
      // so directly pass the `ObjectIrisHandle` as value to the `setMockSharedNativeHandleProvider`
      final value =
          irisTester!.getTesterArgs()[0](const IrisApiEngineHandle(0));
      // rtm_client_impl_override.setMockSharedNativeHandleProvider(
      //     TestInitilizationArgProvider.fromValue(ObjectIrisHandle(value)));

      irisMethodChannelInitilizationArgs = [
        TestInitilizationArgProvider.fromValue(ObjectIrisHandle(value))
      ];
    }
  });

  tearDown(() {
    rtm_client_impl_override.setMockSharedNativeHandleProvider(null);
    irisTester!.dispose();
    irisTester = null;
  });

  rtmclient_binding_fake_test
      .testCases(() => irisMethodChannelInitilizationArgs);
  rtmlock_binding_fake_test.testCases(() => irisMethodChannelInitilizationArgs);
  rtmpresence_binding_fake_test
      .testCases(() => irisMethodChannelInitilizationArgs);
  rtmstorage_binding_fake_test
      .testCases(() => irisMethodChannelInitilizationArgs);
  streamchannel_binding_fake_test
      .testCases(() => irisMethodChannelInitilizationArgs);
  // rtmclient_rtmeventhandler_testcases.testCases(
  //     () => irisTester!, () => irisMethodChannelInitilizationArgs);
}
