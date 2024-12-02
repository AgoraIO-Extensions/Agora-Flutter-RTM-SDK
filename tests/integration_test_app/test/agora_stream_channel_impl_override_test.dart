import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agora_rtm/src/bindings/agora_stream_channel_impl_override.dart'
    as agora_stream_channel_impl;

import 'fake_iris_method_channel.dart';

void main() {
  test('StreamChannelImpl.publishTopicMessage', () {
    FakeIrisMethodChannel irisMethodChannel = FakeIrisMethodChannel();
    agora_stream_channel_impl.StreamChannelImpl streamChannelImpl =
        agora_stream_channel_impl.StreamChannelImpl(irisMethodChannel, '123');
    const message = 'hello';
    final messageUint8List = Uint8List.fromList(utf8.encode(message));

    streamChannelImpl.publishTopicMessage(
        topic: '123',
        message: message,
        length: 5,
        option: const TopicMessageOptions());

    final methodCall = irisMethodChannel.methodCallQueue[0];
    final paramsMap = jsonDecode(methodCall.params);
    expect(paramsMap['length'], messageUint8List.length);
    expect(methodCall.buffers![0], messageUint8List);
  });

  test('StreamChannelImpl.publishBinaryMessage', () {
    FakeIrisMethodChannel irisMethodChannel = FakeIrisMethodChannel();
    agora_stream_channel_impl.StreamChannelImpl streamChannelImpl =
        agora_stream_channel_impl.StreamChannelImpl(irisMethodChannel, '123');
    const message = 'hello';
    final messageUint8List = Uint8List.fromList(utf8.encode(message));

    streamChannelImpl.publishBinaryMessage(
        topic: '123',
        message: messageUint8List,
        length: messageUint8List.length,
        option: const TopicMessageOptions());

    final methodCall = irisMethodChannel.methodCallQueue[0];
    final paramsMap = jsonDecode(methodCall.params);
    expect(paramsMap['length'], messageUint8List.length);
    expect(methodCall.buffers![0], messageUint8List);
  });
}
