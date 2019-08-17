import 'dart:async';
import 'package:flutter/services.dart';
import 'agora_rtm_plugin.dart';
import 'agora_rtm_channel.dart';
import 'utils.dart';

class AgoraRtmClient {
  static final _clients = <int, AgoraRtmClient>{};

  /// Initializes an [AgoraRtmClient] instance
  ///
  /// The Agora RTM SDK supports multiple [AgoraRtmClient] instances.
  static Future<AgoraRtmClient> createInstance(String appId) async {
    int id = await AgoraRtmPlugin.callMethodForStatic("createInstance", {'appId': appId});
    if (id < 0) throw ('Create client failed.');
    AgoraRtmClient client = AgoraRtmClient._(id);
    _clients[id] = client;
    return _clients[id];
  }

  /// get the agora native sdk version
  static Future<String> getSdkVersion() {
    return AgoraRtmPlugin.callMethodForStatic("getSdkVersion", null);
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
  void Function(AgoraRtmLocalInvitation invite, int errorCode) onLocalInvitationFailure;

  /// Callback to the caller: occurs when the callee receives the call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the callee accepts the call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationAccepted;

  /// Callback to the caller: occurs when the callee declines the call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  void Function(AgoraRtmRemoteInvitation invite) onRemoteInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  void Function(AgoraRtmRemoteInvitation invite, int errorCode) onRemoteInvitationFailure;

  final _channels = <String, AgoraRtmChannel>{};

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
        this?.onConnectionStateChanged(state, reason);
        break;
      case 'onMessageReceived':
        AgoraRtmMessage message = AgoraRtmMessage(map["message"]);
        String peerId = map["peerId"];
        this?.onMessageReceived(message, peerId);
        break;
      case 'onTokenExpired': 
        this?.onTokenExpired();
        break;
      case 'onLocalInvitationReceivedByPeer':
        this?.onLocalInvitationReceivedByPeer(AgoraRtmLocalInvitation(map['localInvitation']));
        break;
      case 'onLocalInvitationAccepted':
        this?.onLocalInvitationAccepted(AgoraRtmLocalInvitation(map['localInvitation']));
        break;
      case 'onLocalInvitationRefused':
        this?.onLocalInvitationRefused(AgoraRtmLocalInvitation(map['localInvitation']));
        break;
      case 'onLocalInvitationCanceled':
        this?.onLocalInvitationCanceled(AgoraRtmLocalInvitation(map['localInvitation']));
        break;
      case 'onLocalInvitationFailure':
        this?.onLocalInvitationFailure(AgoraRtmLocalInvitation(map['localInvitation']), map['errorCode']);
        break;
      case 'onRemoteInvitationReceivedByPeer':
        this?.onRemoteInvitationReceivedByPeer(AgoraRtmRemoteInvitation(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationAccepted':
        this?.onRemoteInvitationAccepted(AgoraRtmRemoteInvitation(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationRefused':
        this?.onRemoteInvitationRefused(AgoraRtmRemoteInvitation(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationCanceled':
        this?.onRemoteInvitationCanceled(AgoraRtmRemoteInvitation(map['remoteInvitation']));
        break;
      case 'onRemoteInvitationFailure':
        this?.onRemoteInvitationFailure(AgoraRtmRemoteInvitation(map['remoteInvitation']), map['errorCode']);
        break;
    }
  }

  AgoraRtmClient._(this._clientIndex) {
    _closed = false;
    _clientSubscription = _addEventChannel('io.agora.rtm.client$_clientIndex')
      .receiveBroadcastStream()
      .listen(_eventListener, onError: onError);
    // _callKitSubscription = _addEventChannel('io.agora.rtm.client.callKit$_clientIndex')
    //   .receiveBroadcastStream()
    //   .listen(_eventListener, onError: onError);
  }

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForClient(methodName, {'clientIndex': _clientIndex, 'args': arguments});
  }

  /// Destroy and stop event to the client with related channels.
  Future<void> destroy() async {
    if (_closed) return null;
    await _clientSubscription.cancel();
    _closed = true;
    for (String channelId in _channels.keys) {
      await releaseChannel(channelId);
      this._channels.remove(channelId);
    }
    await _callNative("destroy", null);
    _clients.remove(_clientIndex);
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
  Future login(String token, String userId) {
    return _callNative("login", {'token': token, 'userId': userId});
  }

  /// Allows a user to log out of the Agora RTM system.
  Future logout() {
    return _callNative("logout", null);
  }

  /// Renews the token.
  Future renewToken(String token) {
    return _callNative("renewToken", {"token": token});
  }

  /// Queries the online status of the specified user(s).
  Future queryPeersOnlineStatus(List<String> peerIds) {
    return _callNative("queryPeersOnlineStatus", {'peerIds': peerIds});
  }

  /// Allows a user to send a peer-to-peer message to a specific peer user.
  Future sendMessageToPeer(String peerId, AgoraRtmMessage message, bool offline) {
    return _callNative("sendMessageToPeer", {"peerId":peerId, "message": message.text, "offline": offline});
  }

  /// Substitutes the local user’s attributes with new ones.
  Future<void> setLocalUserAttributes(List<Map<String,String>> attributes) {
    return _callNative("setLocalUserAttributes", {
      "attributes": attributes,
    });
  }

  /// Adds or updates the local user’s attribute(s).
  Future<void> addOrUpdateLocalUserAttributes(List<Map<String,String>> attributes) {
    return _callNative("addOrUpdateLocalUserAttributes", {
      "attributes": attributes,
    });
  }

  /// Deletes the local user’s attributes using attribute keys.
  Future<void> deleteLocalUserAttributesByKeys(List<String> keys) {
    return _callNative("deleteLocalUserAttributesByKeys", {
      "keys": keys,
    });
  }

  /// Clears all attributes of the local user.
  Future<void> clearLocalUserAttributes() {
    return _callNative("clearLocalUserAttributes", null);
  }

  /// Gets all attributes of a specified user.
  Future<Map> getUserAttributes(String userId) {
    return _callNative("getUserAttributes", {'userId': userId});
  }

  /// Gets the attributes of a specified user using attribute keys.
  Future<Map> getUserAttributesByKeys(String userId, List<String> keys) {
    return _callNative("getUserAttributesByKeys", {'userId': userId, 'keys': keys});
  }

  /// Allows the caller to send a call invitation to the callee.
  Future<void> sendLocalInvitation(Map<String, String> arguments) {
    return _callNative("sendLocalInvitation", arguments);
  }

  /// Allows the caller to cancel a call invitation.
  Future<void> cancelLocalInvitation(Map<String, String> arguments) {
    return _callNative("cancelLocalInvitation", arguments);
  }

  /// Allows the callee to accept a call invitation.
  Future<void> acceptRemoteInvitation(Map<String, String> arguments) {
    return _callNative("acceptRemoteInvitation", arguments);
  }

  /// Allows the callee to decline a call invitation.
  Future<void> refuseRemoteInvitation(Map<String, String> arguments) {
    return _callNative("refuseRemoteInvitation", arguments);
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
    if (res < 0) throw ("Create channel failed.");
    AgoraRtmChannel channel =
        AgoraRtmChannel(_clientIndex, channelId);
    _channels[channelId] = channel;
    return _channels[channelId];
  }

  /// Releases an [AgoraRtmChannel].
  Future<void> releaseChannel(String channelId) async {
    final res = await _callNative("releaseChannel", {'channelId': channelId});
    if (res < 0) throw ("Release channel failed.");
    _channels[channelId]?.close();
  }
}