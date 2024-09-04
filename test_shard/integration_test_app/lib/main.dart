import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:iris_method_channel/iris_method_channel.dart';
import 'package:iris_tester/iris_tester.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // List<InitilizationArgProvider> irisMethodChannelInitilizationArgs = [];
    // IrisTester? irisTester;
    // irisTester = createIrisTester();
    // irisTester!.initialize();
    // if (kIsWeb) {
    //   rtm_client_impl_override.setMockSharedNativeHandleProvider(
    //       TestInitilizationArgProvider(irisTester!.getTesterArgs()));
    // } else {
    //   // On IO, the function return from the `irisTester.getTesterArgs()` capture
    //   // the `Pointer` from `IrisTester`, which is invalid to pass to the `Isolate`,
    //   // so directly pass the `ObjectIrisHandle` as value to the `setMockSharedNativeHandleProvider`
    //   final value =
    //       irisTester!.getTesterArgs()[0](const IrisApiEngineHandle(0));
    //   // rtm_client_impl_override.setMockSharedNativeHandleProvider(
    //   //     TestInitilizationArgProvider.fromValue(ObjectIrisHandle(value)));

    //   irisMethodChannelInitilizationArgs = [
    //     TestInitilizationArgProvider.fromValue(ObjectIrisHandle(value))
    //   ];
    // }

    // Future<RtmClientImplOverride> _createBindingRtmClient() async {
    //   String appId = const String.fromEnvironment('TEST_APP_ID',
    //       defaultValue: '<YOUR_APP_ID>');
    //   final rtmResultHandler = RtmResultHandlerImpl();
    //   return RtmClientImplOverride.create(
    //     IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    //     RtmConfig(appId: appId),
    //     rtmResultHandler.rtmEventHandler,
    //     args: irisMethodChannelInitilizationArgs,
    //   );
    // }

    // await _createBindingRtmClient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on:\n'),
        ),
      ),
    );
  }
}
