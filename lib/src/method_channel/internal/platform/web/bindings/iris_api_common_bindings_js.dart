@JS()
library iris_web;

import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtm/src/method_channel/internal/platform/iris_event_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_method_channel_interface.dart';
import 'package:js/js.dart';

// ignore_for_file: public_member_api_docs, non_constant_identifier_names

// NOTE:
// For compatibility to dart sdk >= 2.12, we only use the feature that are
// supported in `js: 0.6.3` at this time

@JS('IrisCore.EventParam')
@anonymous
class EventParam {
  // Must have an unnamed factory constructor with named arguments.
  external factory EventParam({
    String event,
    String data,
    int data_size,
    String result,
    List<Object> buffer,
    List<int> length,
    int buffer_count,
  });

  external String get event;
  external String get data;
  external int get data_size;
  external String get result;
  external List<Object> get buffer;
  external List<int> get length;
  external int get buffer_count;
}

IrisEventMessage toIrisEventMessage(EventParam param) {
  return IrisEventMessage(
      param.event, param.data, List<Uint8List>.from(param.buffer));
}

typedef ApiParam = EventParam;

@JS('IrisCore.CallIrisApiResult')
@anonymous
class CallIrisApiResult {
  external factory CallIrisApiResult({
    int code,
    String data,
  });

  external int get code;
  external String get data;
}

extension CallIrisApiResultExt on CallIrisApiResult {
  CallApiResult toCallApiResult() {
    return CallApiResult(
        irisReturnCode: code, data: jsonDecode(data), rawData: data);
  }
}

@JS('IrisCore.IrisEventHandler')
@anonymous
class IrisEventHandler {}

@JS('IrisCore.IrisApiEngine')
@anonymous
class IrisApiEngine {}

@JS('IrisCore.createIrisApiEngine')
external IrisApiEngine createIrisApiEngine();

@JS('IrisCore.disposeIrisApiEngine')
external int disposeIrisApiEngine(IrisApiEngine engine_ptr);

@JS('IrisCore.callIrisApi')
external int callIrisApi(IrisApiEngine engine_ptr, ApiParam apiParam);

typedef IrisEventHandlerFuncJS = void Function(EventParam param);
typedef IrisCEventHandler = IrisEventHandlerFuncJS;

@JS('IrisCore.createIrisEventHandler')
external IrisEventHandler createIrisEventHandler(
    IrisCEventHandler event_handler);
