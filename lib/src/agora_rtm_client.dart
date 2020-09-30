import 'dart:async';

import 'package:flutter/services.dart';

import 'agora_rtm_channel.dart';
import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmClientException implements Exception {
  final reason;
  final code;

  AgoraRtmClientException(this.reason, this.code) : super();

  Map<String, dynamic> toJson() => {"reason": reason, "code": code};

  @override
  String toString() {
    return this.reason;
  }
}

class AgoraRtmClient {
  static var _clients = <int, AgoraRtmClient>{};

  /// Initializes an [AgoraRtmClient] instance
  ///
  /// The Agora RTM SDK supports multiple [AgoraRtmClient] instances.
  static Future<AgoraRtmClient> createInstance(String appId) async {
    final res = await AgoraRtmPlugin.callMethodForStatic(
        "createInstance", {'appId': appId});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "Create client failed errorCode:${res['errorCode']}",
          res['errorCode']);
    final index = res['index'];
    AgoraRtmClient client = AgoraRtmClient._(index);
    _clients[index] = client;
    return _clients[index];
  }

  /// get the agora native sdk version
  static Future<String> getSdkVersion() async {
    final res = await AgoraRtmPlugin.callMethodForStatic("getSdkVersion", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "getSdkVersion failed errorCode:${res['errorCode']}",
          res['errorCode']);
    return res["version"];
  }

  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  void Function(int state, int reason) onConnectionStateChanged;

  /// Occurs when the local user receives a peer-to-peer message.
  void Function(AgoraRtmMessage message, String peerId) onMessageReceived;

  /// Occurs when your token expires.
  void Function() onTokenExpired;

  /// Occurs when you receive error events.
  void Function() onError;

  /// Callback to the caller: occurs when the caller receives the call invitation.
  void Function(AgoraRtmLocalInvitation invite) onLocalInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the caller accepts the call invitation.
  void Function(AgoraRtmLocalInvitation invite) onLocalInvitationAccepted;

  /// Callback to the caller: occurs when the caller declines the call invitation.
  void Function(AgoraRtmLocalInvitation invite) onLocalInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  void Function(AgoraRtmLocalInvitation invite) onLocalInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  void Function(AgoraRtmLocalInvitation invite, int errorCode)
      onLocalInvitationFailure;

  /// Callback to the caller: occurs when the callee receives the call invitation.
  void Function(AgoraRtmRemoteInvitation invite)
      onRemoteInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the callee accepts the call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationAccepted;

  /// Callback to the caller: occurs when the callee declines the call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  void Function(AgoraRtmRemoteInvitation invite, int errorCode)
      onRemoteInvitationFailure;

  var _channels = <String, AgoraRtmChannel>{};

  bool _closed;

  final int _clientIndex;
  StreamSubscription<dynamic> _clientSubscription;

  EventChannel _addEventChannel(name) {
    return new EventChannel(name);
  }

  _eventListener(dynamic event) {
    final Map<dynamic, dynamic> map = event;
    switch (map['event']) {
      case 'onConnectionStateChanged':
        int state = map['state'];
        int reason = map['reason'];
        this?.onConnectionStateChanged?.call(state, reason);
        break;
      case 'onMessageReceived':
        AgoraRtmMessage message = AgoraRtmMessage.fromJson(map["message"]);
        String peerId = map["peerId"];
        this?.onMessageReceived?.call(message, peerId);
        break;
      case 'onTokenExpired':
        this?.onTokenExpired?.call();
        break;
      case 'onLocalInvitationReceivedByPeer':
        this
            ?.onLocalInvitationReceivedByPeer
            ?.call(AgoraRtmLocalInvitation.fromJson(map['localInvitation']));
        break;
      case 'onLocalInvitationAccepted':
        this
            ?.onLocalInvitationAccepted
            ?.call(AgoraRtmLocalInvitation.fromJson(map['localInvitation']));
        break;
      case 'onLocalInvitationRefused':
        this
            ?.onLocalInvitationRefused
            ?.call(AgoraRtmLocalInvitation.fromJson(map['localInvitation']));
        break;
      case 'onLocalInvitationCanceled':
        this
            ?.onLocalInvitationCanceled
            ?.call(AgoraRtmLocalInvitation.fromJson(map['localInvitation']));
        break;
      case 'onLocalInvitationFailure':
        this?.onLocalInvitationFailure?.call(
            AgoraRtmLocalInvitation.fromJson(map['localInvitation']),
            map['errorCode']);
        break;
      case 'onRemoteInvitationReceivedByPeer':
        this
            ?.onRemoteInvitationReceivedByPeer
            ?.call(AgoraRtmRemoteInvitation.fromJson(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationAccepted':
        this
            ?.onRemoteInvitationAccepted
            ?.call(AgoraRtmRemoteInvitation.fromJson(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationRefused':
        this
            ?.onRemoteInvitationRefused
            ?.call(AgoraRtmRemoteInvitation.fromJson(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationCanceled':
        this
            ?.onRemoteInvitationCanceled
            ?.call(AgoraRtmRemoteInvitation.fromJson(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationFailure':
        this?.onRemoteInvitationFailure?.call(
            AgoraRtmRemoteInvitation.fromJson(map['remoteInvitation']),
            map['errorCode']);
        break;
    }
  }

  AgoraRtmClient._(this._clientIndex) {
    _closed = false;
    _clientSubscription = _addEventChannel('io.agora.rtm.client$_clientIndex')
        .receiveBroadcastStream()
        .listen(_eventListener, onError: onError);
  }

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForClient(
        methodName, {'clientIndex': _clientIndex, 'args': arguments});
  }

  /// Destroy and stop event to the client with related channels.
  Future<void> destroy() async {
    if (_closed) return null;
    await _clientSubscription.cancel();
    _closed = true;
    for (String channelId in _channels.keys) {
      await releaseChannel(channelId);
    }
    final res = await _callNative("destroy", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "destroy failed ${res['errorCode']}", res["errorCode"]);
    _clients.removeWhere((int clientIndex, AgoraRtmClient client) =>
        [_clientIndex].contains(clientIndex));
  }

  /// Allows a user set log
  Future setLog(int level, int size, String path) async {
    final res = await _callNative(
        "setLog", {'level': level, 'size': size, 'path': path});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "login failed errorCode:${res['errorCode']}", res['errorCode']);
    return res["result"];
  }

  /// Allows a user to log in the Agora RTM system.
  ///
  /// The string length of userId must be less than 64 bytes with the following character scope:
  /// - The 26 lowercase English letters: a to z
  /// - The 26 uppercase English letters: A to Z
  /// - The 10 numbers: 0 to 9
  /// - Space
  /// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "]", "[", "^", "_", " {", "}", "|", "~", ","
  /// Do not set userId as null and do not start with a space.
  /// If you log in with the same user ID from a different instance, you will be kicked out of your previous login and removed from previously joined channels.
  Future login(String token, String userId) async {
    final res = await _callNative("login", {'token': token, 'userId': userId});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "login failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  /// Allows a user to log out of the Agora RTM system.
  Future logout() async {
    final res = await _callNative("logout", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "logout failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  /// Renews the token.
  Future renewToken(String token) async {
    final res = await _callNative("renewToken", {"token": token});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "renewToken failed errorCode:${res['errorCode']}", res['errorCode']);
  }

  /// Queries the online status of the specified user(s).
  Future<Map<String, dynamic>> queryPeersOnlineStatus(
      List<String> peerIds) async {
    final res =
        await _callNative("queryPeersOnlineStatus", {'peerIds': peerIds});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "queryPeersOnlineStatus failed errorCode:${res['errorCode']}",
          res['errorCode']);
    return Map<String, dynamic>.from(res["results"]);
  }

  /// Allows a user to send a peer-to-peer message to a specific peer user.
  Future<void> sendMessageToPeer(String peerId, AgoraRtmMessage message,
      [bool offline, bool historical]) async {
    final res = await _callNative("sendMessageToPeer", {
      "peerId": peerId,
      "message": message.text,
      "offline": offline,
      "historical": historical
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "sendMessageToPeer failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Substitutes the local user’s attributes with new ones.
  Future<void> setLocalUserAttributes(
      List<Map<String, String>> attributes) async {
    final res = await _callNative("setLocalUserAttributes", {
      "attributes": attributes,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "setLocalUserAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Adds or updates the local user’s attribute(s).
  Future<void> addOrUpdateLocalUserAttributes(
      List<Map<String, String>> attributes) async {
    final res = await _callNative("addOrUpdateLocalUserAttributes", {
      "attributes": attributes,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "addOrUpdateLocalUserAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Deletes the local user’s attributes using attribute keys.
  Future<void> deleteLocalUserAttributesByKeys(List<String> keys) async {
    final res = await _callNative("deleteLocalUserAttributesByKeys", {
      "keys": keys,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "deleteLocalUserAttributesByKeys failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Clears all attributes of the local user.
  Future<void> clearLocalUserAttributes() async {
    final res = await _callNative("clearLocalUserAttributes", null);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "clearLocalUserAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Gets all attributes of a specified user.
  Future<Map<String, dynamic>> getUserAttributes(String userId) async {
    final res = await _callNative("getUserAttributes", {'userId': userId});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "getUserAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
    return Map<String, dynamic>.from(res["attributes"]);
  }

  /// Gets the attributes of a specified user using attribute keys.
  Future<Map<String, dynamic>> getUserAttributesByKeys(
      String userId, List<String> keys) async {
    final res = await _callNative(
        "getUserAttributesByKeys", {'userId': userId, 'keys': keys});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "getUserAttributesByKeys failed errorCode:${res['errorCode']}",
          res['errorCode']);
    return Map<String, dynamic>.from(res["attributes"]);
  }

  /// Substitutes the channel attributes with new ones.
  Future<void> setChannelAttributes(
      String channelId,
      List<AgoraRtmChannelAttribute> attributes,
      bool enableNotificationToChannelMembers) async {
    List<Map<String, dynamic>> attributeList = [];
    for (final attr in attributes) {
      attributeList.add(attr.toJson());
    }
    final res = await _callNative("setChannelAttributes", {
      'channelId': channelId,
      "attributes": attributeList,
      "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "setChannelAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Adds or updates the channel's attribute(s).
  Future<void> addOrUpdateChannelAttributes(
      String channelId,
      List<AgoraRtmChannelAttribute> attributes,
      bool enableNotificationToChannelMembers) async {
    List<Map<String, dynamic>> attributeList = [];
    for (final attr in attributes) {
      attributeList.add(attr.toJson());
    }
    final res = await _callNative("addOrUpdateChannelAttributes", {
      'channelId': channelId,
      "attributes": attributeList,
      "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "addOrUpdateChannelAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Deletes the channel's attributes using attribute keys.
  Future<void> deleteChannelAttributesByKeys(String channelId,
      List<String> keys, bool enableNotificationToChannelMembers) async {
    final res = await _callNative("deleteChannelAttributesByKeys", {
      "channelId": channelId,
      "keys": keys,
      "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "deleteChannelAttributesByKeys failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Clears all attributes of the channel.
  Future<void> clearChannelAttributes(
      String channelId, bool enableNotificationToChannelMembers) async {
    final res = await _callNative("clearChannelAttributes", {
      "channelId": channelId,
      "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
    });
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "clearChannelAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Gets all attributes of a specified channel.
  Future<List<AgoraRtmChannelAttribute>> getChannelAttributes(
      String channelId) async {
    final res =
        await _callNative("getChannelAttributes", {'channelId': channelId});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "getChannelAttributes failed errorCode:${res['errorCode']}",
          res['errorCode']);

    return (List<Map<dynamic, dynamic>>.from(res["attributes"]))
        .map((attr) => AgoraRtmChannelAttribute.fromJson(attr))
        .toList();
  }

  /// Gets the attributes of a specified channel using attribute keys.
  Future<List<AgoraRtmChannelAttribute>> getChannelAttributesByKeys(
      String channelId, List<String> keys) async {
    final res = await _callNative(
        "getChannelAttributesByKeys", {'channelId': channelId, 'keys': keys});
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "getChannelAttributesByKeys failed errorCode:${res['errorCode']}",
          res['errorCode']);
    return List<Map<dynamic, dynamic>>.from(res["attributes"])
        .map((attr) => AgoraRtmChannelAttribute.fromJson(attr))
        .toList();
  }

  /// Allows the caller to send a call invitation to the callee.
  Future<void> sendLocalInvitation(Map<dynamic, dynamic> arguments) async {
    final res = await _callNative("sendLocalInvitation", arguments);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "sendLocalInvitation failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Allows the caller to cancel a call invitation.
  Future<void> cancelLocalInvitation(Map<dynamic, dynamic> arguments) async {
    final res = await _callNative("cancelLocalInvitation", arguments);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "cancelLocalInvitation failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Allows the callee to accept a call invitation.
  Future<void> acceptRemoteInvitation(Map<dynamic, dynamic> arguments) async {
    final res = await _callNative("acceptRemoteInvitation", arguments);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "acceptRemoteInvitation failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Allows the callee to decline a call invitation.
  Future<void> refuseRemoteInvitation(Map<dynamic, dynamic> arguments) async {
    final res = await _callNative("refuseRemoteInvitation", arguments);
    if (res["errorCode"] != 0)
      throw AgoraRtmClientException(
          "refuseRemoteInvitation failed errorCode:${res['errorCode']}",
          res['errorCode']);
  }

  /// Creates an [AgoraRtmChannel].
  ///
  /// channelId is the unique channel name of the Agora RTM session. The string length must not exceed 64 bytes with the following character scope:
  /// - The 26 lowercase English letters: a to z
  /// - The 26 uppercase English letters: A to Z
  /// - The 10 numbers: 0 to 9
  /// - Space
  /// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "]", "[", "^", "_", " {", "}", "|", "~", ","
  /// channelId cannot be empty or set as nil.
  Future<AgoraRtmChannel> createChannel(String channelId) async {
    final res = await _callNative("createChannel", {'channelId': channelId});
    if (res['errorCode'] != 0)
      throw AgoraRtmClientException(
          "createChannel failed errorCode:${res['errorCode']}",
          res['errorCode']);
    AgoraRtmChannel channel = AgoraRtmChannel(_clientIndex, channelId);
    _channels[channelId] = channel;
    return _channels[channelId];
  }

  /// Releases an [AgoraRtmChannel].
  Future<void> releaseChannel(String channelId) async {
    final res = await _callNative("releaseChannel", {'channelId': channelId});
    if (res['errorCode'] != 0)
      throw AgoraRtmClientException(
          "releaseChannel failed errorCode:${res['errorCode']}",
          res['errorCode']);
    _channels[channelId]?.close();
    _channels.removeWhere((String channelId, AgoraRtmChannel channel) =>
        [channelId].contains(channel));
  }
}
