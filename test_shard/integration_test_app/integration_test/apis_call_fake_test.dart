// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// import 'package:iris_tester/iris_tester.dart';
// import 'package:iris_method_channel/iris_method_channel.dart';

// // import 'generated/rtmclient_fake_test.generated.dart' as rtmclient_fake_test;
// import 'generated/rtmlock_fake_test.generated.dart' as rtmlock_fake_test;
// import 'generated/rtmpresence_fake_test.generated.dart'
//     as rtmpresence_fake_test;
// import 'generated/rtmstorage_fake_test.generated.dart' as rtmstorage_fake_test;
// import 'generated/streamchannel_fake_test.generated.dart'
//     as streamchannel_fake_test;

// import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart'
//     as rtm_client_impl_override;

// class TestInitilizationArgProvider implements InitilizationArgProvider {
//   TestInitilizationArgProvider(this.testerArgs);
//   TestInitilizationArgProvider.fromValue(IrisHandle this.value)
//       : testerArgs = [];
//   final List<TesterArgsProvider> testerArgs;
//   IrisHandle? value;
//   @override
//   IrisHandle provide(IrisApiEngineHandle apiEngineHandle) {
//     return value ?? ObjectIrisHandle(testerArgs[0](apiEngineHandle()));
//   }
// }

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   IrisTester? irisTester;

//   setUp(() {
//     irisTester = createIrisTester();
//     irisTester!.initialize();
//     if (kIsWeb) {
//       rtm_client_impl_override.setMockSharedNativeHandleProvider(
//           TestInitilizationArgProvider(irisTester!.getTesterArgs()));
//     } else {
//       // On IO, the function return from the `irisTester.getTesterArgs()` capture
//       // the `Pointer` from `IrisTester`, which is invalid to pass to the `Isolate`,
//       // so directly pass the `ObjectIrisHandle` as value to the `setMockSharedNativeHandleProvider`
//       final value =
//           irisTester!.getTesterArgs()[0](const IrisApiEngineHandle(0));
//       rtm_client_impl_override.setMockSharedNativeHandleProvider(
//           TestInitilizationArgProvider.fromValue(ObjectIrisHandle(value)));
//     }
//   });

//   tearDown(() {
//     rtm_client_impl_override.setMockSharedNativeHandleProvider(null);
//     irisTester!.dispose();
//     irisTester = null;
//   });

//   rtmclient_fake_test.testCases();
//   rtmlock_fake_test.testCases();
//   rtmpresence_fake_test.testCases();
//   rtmstorage_fake_test.testCases();
//   streamchannel_fake_test.testCases();
// }
