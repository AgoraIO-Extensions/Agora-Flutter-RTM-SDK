import 'dart:async';
import 'package:flutter/services.dart';
import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmChannel {
  /// Occurs when you receive error events.
  void Function(dynamic error) onError;

  /// Occurs when receiving a channel message.
  void Function(AgoraRtmMessage message,
    AgoraRtmMember fromMember) onMessageReceived;

  /// Occurs when a user joins the channel.
  void Function(AgoraRtmMember member) onMemberJoined;

  /// Occurs when a channel member leaves the channel.
  void Function(AgoraRtmMember member) onMemberLeft;

  final String channelId;
  final int _clientIndex;

  bool _closed;

  StreamSubscription<dynamic> _eventSubscription;

  EventChannel _addEventChannel() {
    return new EventChannel(
        'io.agora.rtm.channel$_clientIndex$channelId');
  }

  _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onMessageReceived':
        AgoraRtmMessage message = AgoraRtmMessage(map['text']);
        AgoraRtmMember member = AgoraRtmMember(map['userId'], map['channelId']);
        this?.onMessageReceived(message, member);
        break;
      case 'onMemberJoined':
        AgoraRtmMember member = AgoraRtmMember(map['userId'], map['channelId']);
        this?.onMemberJoined(member);
        break;
      case 'onMemberLeft': 
        AgoraRtmMember member = AgoraRtmMember(map['userId'], map['channelId']);
        this?.onMemberLeft(member);
      break;
    }
  }

  AgoraRtmChannel(this._clientIndex, this.channelId) {
    _closed = false;
    _eventSubscription = _addEventChannel()
      .receiveBroadcastStream()
      .listen(_eventListener, onError: onError);
  }

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForClient(methodName,
      {
        'clientIndex': _clientIndex,
        'channelId': channelId,
        'arguments': arguments
      }
    );
  }

  Future<dynamic> join() {
    return _callNative("join", null);
  }

  Future<dynamic> sendMessage(AgoraRtmMessage message) {
    return _callNative("sendMessage", {'message': message.text});
  }

  Future<dynamic> leave() {
    return _callNative("leave", null);
  }

  Future<dynamic> getMembers() {
    return _callNative("getMembers", null);
  }

  Future<void> close() async {
    if (_closed) return null;
    await _eventSubscription.cancel();
    _closed = true;
  }

  @Deprecated('Use `AgoraRtmClient.releaseChannel` instead.')
  void release() {}
}