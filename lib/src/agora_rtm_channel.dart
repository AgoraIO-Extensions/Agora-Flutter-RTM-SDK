import 'dart:async';

import 'package:agora_rtm/src/agora_rtm_client.dart';
import 'package:flutter/services.dart';

import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmChannelException implements Exception {
  final String reason;
  final int code;

  AgoraRtmChannelException(this.reason, this.code) : super();
}

class AgoraRtmChannel {
  /// Occurs when you receive error events.
  void Function(dynamic error)? onError;

  /// Occurs when channel member count updated.
  void Function(int memberCount)? onMemberCountUpdated;

  /// Occurs when channel attribute updated.
  void Function(List<RtmChannelAttribute> attributeList)? onAttributesUpdated;

  /// Occurs when receiving a channel message.
  void Function(RtmMessage message, RtmChannelMember fromMember)?
      onMessageReceived;

  /// Occurs when a user joins the channel.
  void Function(RtmChannelMember member)? onMemberJoined;

  /// Occurs when a channel member leaves the channel.
  void Function(RtmChannelMember member)? onMemberLeft;

  final int _clientIndex;
  final String _channelId;

  StreamSubscription<dynamic>? _eventSubscription;

  EventChannel _addEventChannel() {
    return EventChannel('io.agora.rtm.client$_clientIndex.channel$_channelId');
  }

  AgoraRtmChannel(this._clientIndex, this._channelId) {
    _eventSubscription =
        _addEventChannel().receiveBroadcastStream().listen((dynamic event) {
      final map = Map.from(event['data']);
      switch (event['event']) {
        case 'onMemberCountUpdated':
          int memberCount = map['memberCount'];
          onMemberCountUpdated?.call(memberCount);
          break;
        case 'onAttributesUpdated':
          List<RtmChannelAttribute> attributeList =
              List<Map>.from(map['attributeList'])
                  .map((e) => RtmChannelAttribute.fromJson(e))
                  .toList();
          onAttributesUpdated?.call(attributeList);
          break;
        case 'onMessageReceived':
          RtmMessage message = RtmMessage.fromJson(map['message']);
          RtmChannelMember fromMember =
              RtmChannelMember.fromJson(map['fromMember']);
          onMessageReceived?.call(message, fromMember);
          break;
        case 'onMemberJoined':
          RtmChannelMember member = RtmChannelMember.fromJson(map['member']);
          onMemberJoined?.call(member);
          break;
        case 'onMemberLeft':
          RtmChannelMember member = RtmChannelMember.fromJson(map['member']);
          onMemberLeft?.call(member);
          break;
      }
    }, onError: onError);
  }

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForChannel(methodName, {
      'clientIndex': _clientIndex,
      'channelId': _channelId,
      'args': arguments
    });
  }

  Future<void> join() {
    return _callNative("join", null);
  }

  Future<void> leave() {
    return _callNative("leave", null);
  }

  Future<void> sendMessage2(RtmMessage message, [SendMessageOptions? options]) {
    return _callNative("sendMessage", {
      'message': message.toJson(),
      "options": options?.toJson(),
    });
  }

  Future<List<RtmChannelMember>> getMembers() async {
    return List<Map>.from(await _callNative("getMembers", null))
        .map((e) => RtmChannelMember.fromJson(e))
        .toList();
  }

  String getId() {
    return _channelId;
  }

  Future<void> release() async {
    await _eventSubscription
        ?.cancel()
        .then((value) => _eventSubscription = null);
    await _callNative("release", {'channelId': _channelId});
    AgoraRtmClient.getChannels(_clientIndex)
        ?.removeWhere((String key, _) => key == _channelId);
  }

  String get channelId => _channelId;

  /// [sendMessage2]
  @Deprecated('Use sendMessage2 instead of.')
  Future<void> sendMessage(RtmMessage message,
      [bool? offline, bool? historical]) {
    return sendMessage2(
      message,
      SendMessageOptions(
        enableHistoricalMessaging: historical,
        enableOfflineMessaging: offline,
      ),
    );
  }
}
