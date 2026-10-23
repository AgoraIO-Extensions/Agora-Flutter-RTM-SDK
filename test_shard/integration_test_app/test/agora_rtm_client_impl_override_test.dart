import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart'
    as agora_rtm_client_impl;

import 'fake_iris_method_channel.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_history_impl.dart'
    as history_binding;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_lock_impl.dart'
    as lock_binding;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_presence_impl.dart'
    as presence_binding;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_storage_impl.dart'
    as storage_binding;

void main() {
  test('native child factories share transport without JSON pointer calls',
      () async {
    final transport = FakeIrisMethodChannel();
    final client =
        agora_rtm_client_impl.RtmClientImplOverride.create(transport);
    expect(
        (await client.getHistory() as history_binding.RtmHistoryImpl)
            .irisMethodChannel,
        same(transport));
    expect(
        (await client.getLock() as lock_binding.RtmLockImpl).irisMethodChannel,
        same(transport));
    expect(
        (await client.getPresence() as presence_binding.RtmPresenceImpl)
            .irisMethodChannel,
        same(transport));
    expect(
        (await client.getStorage() as storage_binding.RtmStorageImpl)
            .irisMethodChannel,
        same(transport));
    expect(transport.methodCallQueue, isEmpty);
  });

  test('RtmClientImplOverride.publish', () {
    FakeIrisMethodChannel irisMethodChannel = FakeIrisMethodChannel();
    agora_rtm_client_impl.RtmClientImplOverride rtmClientImplOverride =
        agora_rtm_client_impl.RtmClientImplOverride.create(irisMethodChannel);
    const message = 'hello';
    final messageUint8List = Uint8List.fromList(utf8.encode(message));

    rtmClientImplOverride.publish(
        channelName: '123',
        message: message,
        length: 5,
        option: const PublishOptions());

    final methodCall = irisMethodChannel.methodCallQueue[0];
    final paramsMap = jsonDecode(methodCall.params);
    expect(paramsMap['length'], messageUint8List.length);
    expect(methodCall.buffers![0], messageUint8List);
  });

  test('RtmClientImplOverride.publishBinaryMessage', () {
    FakeIrisMethodChannel irisMethodChannel = FakeIrisMethodChannel();
    agora_rtm_client_impl.RtmClientImplOverride rtmClientImplOverride =
        agora_rtm_client_impl.RtmClientImplOverride.create(irisMethodChannel);
    const message = 'hello';
    final messageUint8List = Uint8List.fromList(utf8.encode(message));

    rtmClientImplOverride.publishBinaryMessage(
        channelName: '123',
        message: messageUint8List,
        length: messageUint8List.length,
        option: const PublishOptions());

    final methodCall = irisMethodChannel.methodCallQueue[0];
    final paramsMap = jsonDecode(methodCall.params);
    expect(paramsMap['length'], messageUint8List.length);
    expect(methodCall.buffers![0], messageUint8List);
  });
}
