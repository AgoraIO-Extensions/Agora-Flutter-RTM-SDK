import 'dart:typed_data';

import 'package:flutter/foundation.dart' show protected;

// ignore_for_file: public_member_api_docs

/// Iris event handler interface
abstract class EventLoopEventHandler {
  /// Callback when received events
  bool handleEvent(
      String eventName, String eventData, List<Uint8List> buffers) {
    return handleEventInternal(eventName, eventData, buffers);
  }

  @protected
  bool handleEventInternal(
      String eventName, String eventData, List<Uint8List> buffers);
}

/// Object to hold the iris event infos
class IrisEventMessage {
  /// Construct [IrisEventMessage]
  const IrisEventMessage(this.event, this.data, this.buffers);

  /// The event name
  final String event;

  /// The json data
  final String data;

  /// Byte buffers
  final List<Uint8List> buffers;
}

/// Parse message to [IrisEventMessage] object
// ignore: avoid_annotating_with_dynamic
IrisEventMessage parseMessage(dynamic message) {
  final dataList = List.from(message);
  final String event = dataList[0];
  String data = dataList[1] as String;
  if (data.isEmpty) {
    data = '{}';
  }

  String res = dataList[1] as String;
  if (res.isEmpty) {
    res = '{}';
  }
  final List<Uint8List> buffers =
      dataList.length == 3 ? List<Uint8List>.from(dataList[2]) : <Uint8List>[];

  return IrisEventMessage(event, data, buffers);
}

typedef IrisEventMessageListener = void Function(IrisEventMessage message);

abstract class IrisEvent {}
