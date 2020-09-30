import 'dart:async';

import 'package:flutter/services.dart';

import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmChannelException implements Exception {
  final reason;
  final code;

  AgoraRtmChannelException(this.reason, this.code) : super();

  Map<String, dynamic> toJson() => {"reason": reason, "code": code};

  @override
  String toString() {
    return this.reason;
  }
}

class AgoraRtmChannel {
  /// Occurs when you receive error events.
  void Function(dynamic error) onError;

  /// Occurs when receiving a channel message.
  void Function(AgoraRtmMessage message, AgoraRtmMember fromMember)
      onMessageReceived;

  /// Occurs when a user joins the channel.
  void Function(AgoraRtmMember member) onMemberJoined;

  /// Occurs when a channel member leaves the channel.
  void Function(AgoraRtmMember member) onMemberLeft;

  /// Occurs when channel attribute updated.
  void Function(List<AgoraRtmChannelAttribute> attributes) onAttributesUpdated;

  /// Occurs when channel member count updated.
  void Function(int count) onMemberCountUpdated;

  final String channelId;
  final int _clientIndex;

  bool _closed;

  StreamSubscription<dynamic> _eventSubscription;

  EventChannel _addEventChannel() {
    return new EventChannel(
        'io.agora.rtm.client$_clientIndex.channel$channelId');
  }

  _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onMessageReceived':
        AgoraRtmMessage message = AgoraRtmMessage.fromJson(map['message']);
        AgoraRtmMember member = AgoraRtmMember.fromJson(map);
        this?.onMessageReceived?.call(message, member);
        break;
      case 'onMemberJoined':
        AgoraRtmMember member = AgoraRtmMember.fromJson(map);
        this?.onMemberJoined?.call(member);
        break;
      case 'onMemberLeft':
        AgoraRtmMember member = AgoraRtmMember.fromJson(map);
        this?.onMemberLeft?.call(member);
        break;
      case 'onAttributesUpdated':
        List<Map<dynamic, dynamic>> attributes =
            List<Map<dynamic, dynamic>>.from(map['attributes']);
        this?.onAttributesUpdated?.call(attributes
            .map((attr) => AgoraRtmChannelAttribute.fromJson(attr))
            .toList());
        break;
      case 'onMemberCountUpdated':
        int count = map['count'];
        this?.onMemberCountUpdated?.call(count);
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
    return AgoraRtmPlugin.callMethodForChannel(methodName, {
      'clientIndex': _clientIndex,
      'channelId': channelId,
      'args': arguments
    });
  }

  Future<void> join() async {
    final res = await _callNative("join", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmChannelException(
          "join failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  Future<void> sendMessage(AgoraRtmMessage message,
      [bool offline, bool historical]) async {
    final res = await _callNative("sendMessage", {
      'message': message.text,
      "offline": offline,
      "historical": historical
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmChannelException(
          "sendMessage failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  Future<void> leave() async {
    final res = await _callNative("leave", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmChannelException(
          "leave failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  Future<List<AgoraRtmMember>> getMembers() async {
    final res = await _callNative("getMembers", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmChannelException(
          "getMembers failed errorCode: ${res['errorCode']}", res['errorCode']);
    List<AgoraRtmMember> list = [];
    for (final member in res['members']) {
      list.add(AgoraRtmMember.fromJson(Map<String, dynamic>.from(member)));
    }
    return list;
  }

  Future<void> close() async {
    if (_closed) return null;
    await _eventSubscription.cancel();
    _closed = true;
  }

  @Deprecated('Use `AgoraRtmClient.releaseChannel` instead.')
  void release() {}
}
