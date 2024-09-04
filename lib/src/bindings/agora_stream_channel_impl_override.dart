import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:agora_rtm/src/agora_rtm_base.dart' show TopicMessageOptions;

import 'gen/agora_stream_channel_impl.dart' as sci_binding;
import 'package:iris_method_channel/iris_method_channel.dart';

class StreamChannelImpl extends sci_binding.StreamChannelImpl
    with ScopedDisposableObjectMixin {
  // ignore: use_super_parameters
  StreamChannelImpl(IrisMethodChannel irisMethodChannel, this._channelName)
      : super(irisMethodChannel);

  final String _channelName;

  bool _released = false;

  @override
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return {'channelName': _channelName, ...param};
  }

  @override
  Future<int> release() async {
    if (_released) {
      return 0;
    }

    _released = true;
    markDisposed();
    // return super.release();
    return 0;
  }

  @override
  Future<void> dispose() async {
    await release();
  }

  @override
  Future<int> publishTopicMessage(
      {required String topic,
      required String message,
      required int length,
      required TopicMessageOptions option}) async {
    return publishBinaryMessage(
        topic: topic,
        message: Uint8List.fromList(utf8.encode(message)),
        length: length,
        option: option);
  }

  @override
  Future<int> publishTextMessage(
      {required String topic,
      required String message,
      required int length,
      required TopicMessageOptions option}) {
    return publishBinaryMessage(
        topic: topic,
        message: Uint8List.fromList(utf8.encode(message)),
        length: length,
        option: option);
  }
}
