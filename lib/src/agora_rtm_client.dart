import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtm/src/agora_rtm_call_manager.dart';
import 'package:flutter/services.dart';

import 'agora_rtm_channel.dart';
import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmClientException implements Exception {
  final String reason;
  final int code;

  AgoraRtmClientException(this.reason, this.code) : super();
}

class AgoraRtmClient {
  static final _clients = <int, AgoraRtmClient>{};

  static Map<String, AgoraRtmChannel>? getChannels(int clientIndex) {
    return _clients[clientIndex]?._channels;
  }

  /// Occurs when you receive error events.
  void Function(dynamic error)? onError;

  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  void Function(RtmConnectionState state, RtmConnectionChangeReason reason)?
      onConnectionStateChanged2;

  /// Occurs when the local user receives a peer-to-peer message.
  void Function(RtmMessage message, String peerId)? onMessageReceived;

  /// Occurs when your token expires.
  void Function()? onTokenExpired;

  void Function()? onTokenPrivilegeWillExpire;

  void Function(Map<String, RtmPeerOnlineState> peersStatus)?
      onPeersOnlineStatusChanged;

  final int _clientIndex;
  final _channels = <String, AgoraRtmChannel>{};
  final AgoraRtmCallManager _callManager;

  StreamSubscription<dynamic>? _eventSubscription;

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForClient(
        methodName, {'clientIndex': _clientIndex, 'args': arguments});
  }

  AgoraRtmClient._(this._clientIndex)
      : _callManager = AgoraRtmCallManager(_clientIndex) {
    _eventSubscription = EventChannel('io.agora.rtm.client$_clientIndex')
        .receiveBroadcastStream()
        .listen((dynamic event) {
      final map = Map.from(event['data']);
      switch (event['event']) {
        case 'onConnectionStateChanged':
          var state = RtmConnectionStateExtension.fromJson(map['state']);
          var reason =
              RtmConnectionChangeReasonExtension.fromJson(map['reason']);
          onConnectionStateChanged2?.call(state, reason);
          break;
        case 'onMessageReceived':
          var message = RtmMessage.fromJson(map["message"]);
          String peerId = map["peerId"];
          onMessageReceived?.call(message, peerId);
          break;
        case 'onTokenExpired':
          onTokenExpired?.call();
          break;
        case 'onTokenPrivilegeWillExpire':
          onTokenPrivilegeWillExpire?.call();
          break;
        case 'onPeersOnlineStatusChanged':
          var peersStatus = Map<String, int>.from(map["peersStatus"]).map(
              (key, value) =>
                  MapEntry(key, RtmPeerOnlineStateExtension.fromJson(value)));
          onPeersOnlineStatusChanged?.call(peersStatus);
          break;
      }
    }, onError: onError);
  }

  /// Initializes an [AgoraRtmClient] instance
  ///
  /// The Agora RTM SDK supports multiple [AgoraRtmClient] instances.
  static Future<AgoraRtmClient> createInstance(String appId) async {
    final index = await AgoraRtmPlugin.callMethodForStatic(
        "createInstance", {'appId': appId});
    AgoraRtmClient client = AgoraRtmClient._(index);
    _clients[index] = client;
    return client;
  }

  /// Destroy and stop event to the client with related channels.
  Future<void> release() async {
    await _eventSubscription
        ?.cancel()
        .then((value) => _eventSubscription = null);
    await Future.forEach<AgoraRtmChannel>(
        _channels.values, (element) => element.release());
    await _callNative("release", null);
    _clients.removeWhere((int key, _) => key == _clientIndex);
  }

  @Deprecated('Use `release` instead of.')
  Future<void> destroy() async {
    await release();
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
  Future<void> login(String? token, String userId) {
    return _callNative("login", {'token': token, 'userId': userId});
  }

  /// Allows a user to log out of the Agora RTM system.
  Future<void> logout() {
    return _callNative("logout", null);
  }

  RtmMessage createTextMessage(String text) {
    return RtmMessage.fromText(text);
  }

  RtmMessage createRawMessage(Uint8List raw, String? description) {
    return RtmMessage.fromRaw(raw, description ?? "");
  }

  /// Allows a user to send a peer-to-peer message to a specific peer user.
  Future<void> sendMessageToPeer2(String peerId, RtmMessage message,
      [SendMessageOptions? options]) {
    return _callNative("sendMessageToPeer", {
      "peerId": peerId,
      "message": message.toJson(),
      "options": options?.toJson(),
    });
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
  Future<AgoraRtmChannel?> createChannel(String channelId) async {
    await _callNative("createChannel", {'channelId': channelId});
    AgoraRtmChannel channel = AgoraRtmChannel(_clientIndex, channelId);
    _channels[channelId] = channel;
    return _channels[channelId];
  }

  AgoraRtmCallManager getRtmCallManager() {
    return _callManager;
  }

  /// Queries the online status of the specified user(s).
  Future<Map<String, RtmPeerOnlineState>> queryPeersOnlineStatus(
      List<String> peerIds) async {
    return Map<String, int>.from(
            await _callNative("queryPeersOnlineStatus", {'peerIds': peerIds}))
        .map((key, value) =>
            MapEntry(key, RtmPeerOnlineStateExtension.fromJson(value)));
  }

  Future<void> subscribePeersOnlineStatus(List<String> peerIds) {
    return _callNative("subscribePeersOnlineStatus", {'peerIds': peerIds});
  }

  Future<void> unsubscribePeersOnlineStatus(List<String> peerIds) {
    return _callNative("unsubscribePeersOnlineStatus", {'peerIds': peerIds});
  }

  Future<List<String>> queryPeersBySubscriptionOption(
      RtmPeerSubscriptionOption option) async {
    return List<String>.from(await _callNative(
        "queryPeersBySubscriptionOption", {'option': option.toJson()}));
  }

  /// Renews the token.
  Future<void> renewToken(String token) {
    return _callNative("renewToken", {"token": token});
  }

  /// Substitutes the local user’s attributes with new ones.
  Future<void> setLocalUserAttributes2(List<RtmAttribute> attributes) {
    return _callNative("setLocalUserAttributes", {
      "attributes": jsonDecode(jsonEncode(attributes)),
    });
  }

  /// Adds or updates the local user’s attribute(s).
  Future<void> addOrUpdateLocalUserAttributes2(List<RtmAttribute> attributes) {
    return _callNative("addOrUpdateLocalUserAttributes", {
      "attributes": jsonDecode(jsonEncode(attributes)),
    });
  }

  /// Deletes the local user’s attributes using attribute keys.
  Future<void> deleteLocalUserAttributesByKeys(List<String> attributeKeys) {
    return _callNative("deleteLocalUserAttributesByKeys", {
      "attributeKeys": attributeKeys,
    });
  }

  /// Clears all attributes of the local user.
  Future<void> clearLocalUserAttributes() {
    return _callNative("clearLocalUserAttributes", null);
  }

  /// Gets all attributes of a specified user.
  Future<List<RtmAttribute>> getUserAttributes2(String userId) async {
    return List<Map>.from(
            await _callNative("getUserAttributes", {'userId': userId}))
        .map((e) => RtmAttribute.fromJson(e))
        .toList();
  }

  /// Gets the attributes of a specified user using attribute keys.
  Future<List<RtmAttribute>> getUserAttributesByKeys2(
      String userId, List<String> attributeKeys) async {
    return List<Map>.from(await _callNative("getUserAttributesByKeys",
            {'userId': userId, 'attributeKeys': attributeKeys}))
        .map((e) => RtmAttribute.fromJson(e))
        .toList();
  }

  /// Substitutes the channel attributes with new ones.
  Future<void> setChannelAttributes2(
      String channelId, List<RtmChannelAttribute> attributes,
      [ChannelAttributeOptions? option]) {
    return _callNative("setChannelAttributes", {
      'channelId': channelId,
      "attributes": jsonDecode(jsonEncode(attributes)),
      "option": option?.toJson(),
    });
  }

  /// Adds or updates the channel's attribute(s).
  Future<void> addOrUpdateChannelAttributes2(
      String channelId, List<RtmChannelAttribute> attributes,
      [ChannelAttributeOptions? option]) {
    return _callNative("addOrUpdateChannelAttributes", {
      'channelId': channelId,
      "attributes": jsonDecode(jsonEncode(attributes)),
      "option": option?.toJson(),
    });
  }

  /// Deletes the channel's attributes using attribute keys.
  Future<void> deleteChannelAttributesByKeys2(
      String channelId, List<String> attributeKeys,
      [ChannelAttributeOptions? option]) {
    return _callNative("deleteChannelAttributesByKeys", {
      "channelId": channelId,
      "attributeKeys": attributeKeys,
      "option": option?.toJson(),
    });
  }

  /// Clears all attributes of the channel.
  Future<void> clearChannelAttributes2(String channelId,
      [ChannelAttributeOptions? option]) {
    return _callNative("clearChannelAttributes", {
      "channelId": channelId,
      "option": option?.toJson(),
    });
  }

  /// Gets all attributes of a specified channel.
  Future<List<RtmChannelAttribute>> getChannelAttributes(
      String channelId) async {
    return List<Map>.from(
            await _callNative("getChannelAttributes", {'channelId': channelId}))
        .map((attr) => RtmChannelAttribute.fromJson(attr))
        .toList();
  }

  /// Gets the attributes of a specified channel using attribute keys.
  Future<List<RtmChannelAttribute>> getChannelAttributesByKeys(
      String channelId, List<String> attributeKeys) async {
    return List<Map>.from(await _callNative("getChannelAttributesByKeys",
            {'channelId': channelId, 'attributeKeys': attributeKeys}))
        .map((attr) => RtmChannelAttribute.fromJson(attr))
        .toList();
  }

  Future<List<RtmChannelMemberCount>> getChannelMemberCount(
      List<String> channelIds) async {
    return List<Map>.from(await _callNative(
            "getChannelMemberCount", {'channelIds': channelIds}))
        .map((attr) => RtmChannelMemberCount.fromJson(attr))
        .toList();
  }

  Future<void> setParameters(String parameters) {
    return _callNative("setParameters", {'parameters': parameters});
  }

  Future<void> setLogFile(String filePath) {
    return _callNative("setLogFile", {'filePath': filePath});
  }

  Future<void> setLogFilter(RtmLogFilter filter) {
    return _callNative("setLogFilter", {'filter': filter.toJson()});
  }

  Future<void> setLogFileSize(int fileSizeInKBytes) {
    return _callNative(
        "setLogFileSize", {'fileSizeInKBytes': fileSizeInKBytes});
  }

  /// get the agora native sdk version
  static Future<String> getSdkVersion() async {
    return await AgoraRtmPlugin.callMethodForStatic("getSdkVersion", null);
  }

  static Future<void> setRtmServiceContext(RtmServiceContext context) async {
    return await AgoraRtmPlugin.callMethodForStatic(
        "setRtmServiceContext", {'context': context.toJson()});
  }

  /// [setLogFile]
  /// [setLogFilter]
  /// [setLogFileSize]
  @Deprecated('Use `setLogFile` `setLogFilter` `setLogFileSize` instead of.')
  Future<void> setLog(int level, int size, String path) async {
    await setLogFile(path);
    await setLogFilter(RtmLogFilterExtension.fromJson(level));
    await setLogFileSize(size);
  }

  /// [AgoraRtmChannel.release]
  @Deprecated('Use AgoraRtmChannel.release instead of.')
  Future<void> releaseChannel(String channelId) async {
    await _channels[channelId]?.release();
  }

  /// [onConnectionStateChanged2]
  @Deprecated('Use onConnectionStateChanged2 instead of.')
  set onConnectionStateChanged(
      Function(int state, int reason)? onConnectionStateChanged) {
    onConnectionStateChanged2 = onConnectionStateChanged == null
        ? null
        : (RtmConnectionState state, RtmConnectionChangeReason reason) {
            onConnectionStateChanged(state.toJson(), reason.toJson());
          };
  }

  /// [AgoraRtmCallManager.onLocalInvitationReceivedByPeer]
  @Deprecated(
      'Use AgoraRtmCallManager.onLocalInvitationReceivedByPeer instead of.')
  set onLocalInvitationReceivedByPeer(
      Function(LocalInvitation invite)? onLocalInvitationReceivedByPeer) {
    _callManager.onLocalInvitationReceivedByPeer =
        onLocalInvitationReceivedByPeer;
  }

  /// [AgoraRtmCallManager.onLocalInvitationAccepted]
  @Deprecated('Use AgoraRtmCallManager.onLocalInvitationAccepted instead of.')
  set onLocalInvitationAccepted(
      Function(LocalInvitation invite, String response)?
          onLocalInvitationAccepted) {
    _callManager.onLocalInvitationAccepted = onLocalInvitationAccepted;
  }

  /// [AgoraRtmCallManager.onLocalInvitationRefused]
  @Deprecated('Use AgoraRtmCallManager.onLocalInvitationRefused instead of.')
  set onLocalInvitationRefused(
      void Function(LocalInvitation invite, String response)?
          onLocalInvitationRefused) {
    _callManager.onLocalInvitationRefused = onLocalInvitationRefused;
  }

  /// [AgoraRtmCallManager.onLocalInvitationCanceled]
  @Deprecated('Use AgoraRtmCallManager.onLocalInvitationCanceled instead of.')
  set onLocalInvitationCanceled(
      void Function(LocalInvitation invite)? onLocalInvitationCanceled) {
    _callManager.onLocalInvitationCanceled = onLocalInvitationCanceled;
  }

  /// [AgoraRtmCallManager.onLocalInvitationFailure]
  @Deprecated('Use AgoraRtmCallManager.onLocalInvitationFailure instead of.')
  set onLocalInvitationFailure(
      void Function(LocalInvitation invite, int errorCode)?
          onLocalInvitationFailure) {
    _callManager.onLocalInvitationFailure = onLocalInvitationFailure;
  }

  /// [AgoraRtmCallManager.onRemoteInvitationReceived]
  @Deprecated(
      'Use AgoraRtmCallManager.onRemoteInvitationReceivedByPeer instead of.')
  set onRemoteInvitationReceivedByPeer(
      void Function(RemoteInvitation invite)?
          onRemoteInvitationReceivedByPeer) {
    _callManager.onRemoteInvitationReceived = onRemoteInvitationReceivedByPeer;
  }

  /// [AgoraRtmCallManager.onRemoteInvitationAccepted]
  @Deprecated('Use AgoraRtmCallManager.onRemoteInvitationAccepted instead of.')
  set onRemoteInvitationAccepted(
      void Function(RemoteInvitation invite)? onRemoteInvitationAccepted) {
    _callManager.onRemoteInvitationAccepted = onRemoteInvitationAccepted;
  }

  /// [AgoraRtmCallManager.onRemoteInvitationRefused]
  @Deprecated('Use AgoraRtmCallManager.onRemoteInvitationRefused instead of.')
  set onRemoteInvitationRefused(
      void Function(RemoteInvitation invite)? onRemoteInvitationRefused) {
    _callManager.onRemoteInvitationRefused = onRemoteInvitationRefused;
  }

  /// [AgoraRtmCallManager.onRemoteInvitationCanceled]
  @Deprecated('Use AgoraRtmCallManager.onRemoteInvitationCanceled instead of.')
  set onRemoteInvitationCanceled(
      void Function(RemoteInvitation invite)? onRemoteInvitationCanceled) {
    _callManager.onRemoteInvitationCanceled = onRemoteInvitationCanceled;
  }

  /// [AgoraRtmCallManager.onRemoteInvitationFailure]
  @Deprecated('Use AgoraRtmCallManager.onRemoteInvitationFailure instead of.')
  set onRemoteInvitationFailure(
      void Function(RemoteInvitation invite, int errorCode)?
          onRemoteInvitationFailure) {
    _callManager.onRemoteInvitationFailure = onRemoteInvitationFailure;
  }

  /// [AgoraRtmCallManager.sendLocalInvitation]
  @Deprecated('Use AgoraRtmCallManager.sendLocalInvitation instead of.')
  Future<void> sendLocalInvitation(Map<String, dynamic> arguments) {
    return _callManager
        .sendLocalInvitation(LocalInvitation.fromJson(arguments));
  }

  /// [AgoraRtmCallManager.acceptRemoteInvitation]
  @Deprecated('Use AgoraRtmCallManager.acceptRemoteInvitation instead of.')
  Future<void> acceptRemoteInvitation(Map<String, dynamic> arguments) {
    return _callManager
        .acceptRemoteInvitation(RemoteInvitation.fromJson(arguments));
  }

  /// [AgoraRtmCallManager.refuseRemoteInvitation]
  @Deprecated('Use AgoraRtmCallManager.refuseRemoteInvitation instead of.')
  Future<void> refuseRemoteInvitation(Map<String, dynamic> arguments) {
    return _callManager
        .refuseRemoteInvitation(RemoteInvitation.fromJson(arguments));
  }

  /// [AgoraRtmCallManager.cancelLocalInvitation]
  @Deprecated('Use AgoraRtmCallManager.cancelLocalInvitation instead of.')
  Future<void> cancelLocalInvitation(Map<String, dynamic> arguments) {
    return _callManager
        .cancelLocalInvitation(LocalInvitation.fromJson(arguments));
  }

  /// [sendMessageToPeer2]
  @Deprecated('Use sendMessageToPeer2 instead of.')
  Future<void> sendMessageToPeer(String peerId, RtmMessage message,
      [bool? offline, bool? historical]) {
    return sendMessageToPeer2(
        peerId,
        message,
        SendMessageOptions(
            enableHistoricalMessaging: historical,
            enableOfflineMessaging: offline));
  }

  /// [setLocalUserAttributes2]
  @Deprecated('Use setLocalUserAttributes2 instead of.')
  Future<void> setLocalUserAttributes(List<Map<String, String>> attributes) {
    return setLocalUserAttributes2(
        attributes.map((e) => RtmAttribute.fromJson(e)).toList());
  }

  /// [addOrUpdateLocalUserAttributes2]
  @Deprecated('Use addOrUpdateLocalUserAttributes2 instead of.')
  Future<void> addOrUpdateLocalUserAttributes(
      List<Map<String, String>> attributes) {
    return addOrUpdateLocalUserAttributes2(
        attributes.map((e) => RtmAttribute.fromJson(e)).toList());
  }

  /// [getUserAttributes2]
  @Deprecated('Use getUserAttributes2 instead of.')
  Future<Map<String, dynamic>> getUserAttributes(String userId) {
    return getUserAttributes2(userId).then(
        (value) => {for (var element in value) (element).key: element.value});
  }

  /// [getUserAttributesByKeys2]
  @Deprecated('Use getUserAttributesByKeys2 instead of.')
  Future<Map<String, dynamic>> getUserAttributesByKeys(
      String userId, List<String> keys) {
    return getUserAttributesByKeys2(userId, keys).then(
        (value) => {for (var element in value) (element).key: element.value});
  }

  /// [setChannelAttributes2]
  @Deprecated('Use setChannelAttributes2 instead of.')
  Future<void> setChannelAttributes(
      String channelId,
      List<RtmChannelAttribute> attributes,
      bool enableNotificationToChannelMembers) {
    return setChannelAttributes2(channelId, attributes,
        ChannelAttributeOptions(enableNotificationToChannelMembers));
  }

  /// [addOrUpdateChannelAttributes2]
  @Deprecated('Use addOrUpdateChannelAttributes2 instead of.')
  Future<void> addOrUpdateChannelAttributes(
      String channelId,
      List<RtmChannelAttribute> attributes,
      bool enableNotificationToChannelMembers) {
    return addOrUpdateChannelAttributes2(channelId, attributes,
        ChannelAttributeOptions(enableNotificationToChannelMembers));
  }

  /// [deleteChannelAttributesByKeys2]
  @Deprecated('Use deleteChannelAttributesByKeys2 instead of.')
  Future<void> deleteChannelAttributesByKeys(String channelId,
      List<String> keys, bool enableNotificationToChannelMembers) {
    return deleteChannelAttributesByKeys2(channelId, keys,
        ChannelAttributeOptions(enableNotificationToChannelMembers));
  }

  /// [clearChannelAttributes2]
  @Deprecated('Use clearChannelAttributes2 instead of.')
  Future<void> clearChannelAttributes(
      String channelId, bool enableNotificationToChannelMembers) {
    return clearChannelAttributes2(
        channelId, ChannelAttributeOptions(enableNotificationToChannelMembers));
  }
}
