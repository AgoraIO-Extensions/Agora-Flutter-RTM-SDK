import 'package:agora_rtm_example/src/rtm_api_demo.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'src/log_sink.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logSink.log(details.toString());
  };

  // TODO(littlegnal): The newer version of Flutter SDK doc shows use of the
  // `PlatformDispatcher.instance.onError` but not `runZonedGuarded` to
  // handle "Errors not caught by Flutter",
  // see: https://docs.flutter.dev/testing/errors#handling-all-types-of-errors,
  // follow the Flutter SDK doc after we can bump the mini supported Flutter SDK (currently 2.10.x)
  // to the newer version of Flutter SDK.
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    logSink.log(error.toString());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RTM example app'),
          actions: const [LogActionWidget()],
        ),
        body: const RtmApiDemo(),
      ),
    );
  }
}
