import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_event_handler_event_impl.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_presence_impl.dart'
    as native;
import 'package:agora_rtm/src/impl/gen/agora_rtm_presence_impl.dart'
    as semantic;
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/impl/agora_stream_channel_impl_override.dart';
import 'package:agora_rtm/src/bindings/agora_stream_channel_impl_override.dart'
    as stream_native;
import 'package:flutter_test/flutter_test.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

import 'fake_iris_method_channel.dart';

// Keep the real native binding, callback decoder and semantic result handler.
// Only replace the transport across the native boundary.
class PresenceTransport extends FakeIrisMethodChannel {
  int immediateError = 0;
  final invoked = Completer<void>();

  @override
  Future<CallApiResult> invokeMethod(IrisMethodCall call) async {
    methodCallQueue.add(call);
    if (call.funcName == 'GetIrisRtmErrorReason') {
      return CallApiResult(irisReturnCode: 0, data: {'result': 'test error'});
    }
    if (!invoked.isCompleted) invoked.complete();
    if (immediateError != 0) throw AgoraRtmException(code: immediateError);
    return CallApiResult(
        irisReturnCode: 0, data: {'result': 0, 'requestId': 42});
  }
}

void main() {
  for (final binary in [false, true]) {
    test(
        'stream ${binary ? "binary" : "text"} immediate error follows RtmStatus contract',
        () async {
      final transport = PresenceTransport()..immediateError = -10003;
      final stream = StreamChannelImplOverride(
          stream_native.StreamChannelImpl(transport, 'room'),
          RtmResultHandlerImpl());
      final (status, result) = binary
          ? await stream.publishBinaryMessage(
              'topic', Uint8List.fromList([1, 2]))
          : await stream.publishTextMessage('topic', '你好');
      expect(status.error, isTrue);
      expect(status.errorCode, '-10003');
      expect(status.operation,
          binary ? 'publishBinaryMessage' : 'publishTextMessage');
      expect(result, isNull);
    });
  }
  for (final callbackFirst in [false, true]) {
    test('online status reaches semantic Future (callbackFirst=$callbackFirst)',
        () async {
      final transport = PresenceTransport();
      final handler = RtmResultHandlerImpl();
      final wrapper = RtmEventHandlerWrapper(handler.rtmEventHandler);
      RtmPresence presence =
          semantic.RtmPresenceImpl(native.RtmPresenceImpl(transport), handler);
      void respond() {
        expect(
            wrapper.handleEvent(
                'RtmEventHandler_onGetUserOnlineStatusResult_eb2c395',
                jsonEncode({
                  'requestId': 42,
                  'status': {'userId': 'alice', 'online': true},
                  'errorCode': 0
                }),
                []),
            isTrue);
      }

      if (callbackFirst) respond();
      final pending = presence.getUserOnlineStatus('alice');
      await transport.invoked.future;
      if (!callbackFirst) {
        await Future<void>.delayed(Duration.zero);
        respond();
      }
      final (status, result) =
          await pending.timeout(const Duration(seconds: 2));
      expect(status, const RtmStatus.success(operation: 'getUserOnlineStatus'));
      expect(result!.status.userId, 'alice');
      expect(result.status.online, isTrue);
      expect(jsonDecode(transport.methodCallQueue.first.params),
          {'userId': 'alice'});
    });
  }

  test('asynchronous error preserves semantic status and callback payload',
      () async {
    final transport = PresenceTransport();
    final handler = RtmResultHandlerImpl();
    final presence =
        semantic.RtmPresenceImpl(native.RtmPresenceImpl(transport), handler);
    final pending = presence.getUserOnlineStatus('alice');
    RtmEventHandlerWrapper(handler.rtmEventHandler).handleEvent(
        'RtmEventHandler_onGetUserOnlineStatusResult_eb2c395',
        jsonEncode({
          'requestId': 42,
          'status': {'userId': 'alice', 'online': false},
          'errorCode': RtmErrorCode.presenceUserNotExist.value()
        }),
        []);
    final (status, result) = await pending.timeout(const Duration(seconds: 2));
    expect(status.error, isTrue);
    expect(
        status.errorCode, RtmErrorCode.presenceUserNotExist.value().toString());
    expect(status.operation, 'getUserOnlineStatus');
    expect(status.reason, 'test error');
    expect(result!.status.online, isFalse);
  });

  test('immediate native error returns semantic error and null result',
      () async {
    final transport = PresenceTransport()..immediateError = -10003;
    final presence = semantic.RtmPresenceImpl(
        native.RtmPresenceImpl(transport), RtmResultHandlerImpl());
    final (status, result) = await presence.getUserOnlineStatus('alice');
    expect(status.error, isTrue);
    expect(status.errorCode, '-10003');
    expect(status.operation, 'getUserOnlineStatus');
    expect(result, isNull);
  });

  test('token payload decodes through the real handler and respects removal',
      () {
    final handler = RtmResultHandlerImpl();
    final wrapper = RtmEventHandlerWrapper(handler.rtmEventHandler);
    final events = <TokenEvent>[];
    handler.setListener('token', events.add);
    void emit() => wrapper.handleEvent(
        'RtmEventHandler_onTokenEvent_ec6a1f1',
        jsonEncode({
          'event': {
            'eventType': RtmTokenEventType.willExpire.value(),
            'reason': 'renew',
            'affectedResources': {
              'messageChannels': {
                'channels': ['room']
              }
            }
          }
        }),
        []);
    emit();
    expect(events.single.eventType, RtmTokenEventType.willExpire);
    expect(events.single.reason, 'renew');
    expect(
        events.single.affectedResources!.messageChannels!.channels, ['room']);
    handler.removeListener('token');
    emit();
    expect(events, hasLength(1));
  });
}
