import 'dart:async';

import 'package:flutter/services.dart';

class _AgoraRtmPlugin {
  static const MethodChannel _channel = const MethodChannel('io.agora.rtm');
  static bool _hasMethodCallHandler = false;

  static void _addMethodCallHandler() {
    if (_hasMethodCallHandler) {
      return;
    }
    _channel.setMethodCallHandler((MethodCall call) {
      Map arguments = call.arguments;
      String obj = arguments['obj'];
      switch (obj) {
        case 'AgoraRtmClient':
          AgoraRtmClient._receiveEvent(call.method, arguments);
          break;
        case 'AgoraRtmChannel':
          AgoraRtmChannel._receiveEvent(call.method, arguments);
          break;
        default:
      }
    });
    _hasMethodCallHandler = true;
  }
}

/// The entry point to the Agora RTM system
class AgoraRtmClient {
  /// Occurs when the connection state between the SDK and the Agora RTM system changes.
  void Function(int state, int reason) onConnectionStateChanged;

  /// Occurs when the local user receives a peer-to-peer message.
  void Function(AgoraRtmMessage message, String peerId) onMessageReceived;

  /// Occurs when your token expires.
  void Function() onTokenExpired;

  final int _clientIndex;
  AgoraRtmClient._(this._clientIndex);

  static var _clients = <int, AgoraRtmClient>{};
  Completer<void> _loginCompletion;
  Completer<void> _logoutCompletion;
  Completer<String> _renewTokenCompletion;
  Completer<Map<String, bool>> _queryPeersOnlineStatusCompletion;
  Completer<void> _sendMessageToPeerCompletion;
  Completer<void> _setLocalUserAttributesCompletion;
  Completer<void> _addOrUpdateLocalUserAttributesCompletion;
  Completer<void> _deleteLocalUserAttributesByKeysCompletion;
  Completer<void> _clearLocalUserAttributesCompletion;
  Completer<Map> _getUserAttributesCompletion;
  Completer<Map> _getUserAttributesByKeysCompletion;

  /// Initializes an [AgoraRtmClient] instance
  ///
  /// The Agora RTM SDK supports multiple [AgoraRtmClient] instances.
  static Future<AgoraRtmClient> createInstance(String appId) async {
    _AgoraRtmPlugin._addMethodCallHandler();
    int id = await _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmClient_createInstance', {'appId': appId});
    if (id >= 0) {
      AgoraRtmClient client = AgoraRtmClient._(id);
      _clients[id] = client;
      return client;
    } else {
      throw ('Create client failed.');
    }
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
  Future<void> login(String token, String userId) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_login',
        {'clientIndex': _clientIndex, 'token': token, 'userId': userId});
    _loginCompletion = new Completer<void>();
    return _loginCompletion.future;
  }

  /// Allows a user to log out of the Agora RTM system.
  Future<void> logout() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmClient_logout', {'clientIndex': _clientIndex});
    _logoutCompletion = new Completer<void>();
    return _logoutCompletion.future;
  }

  /// Renews the token.
  Future<String> renewToken(String token) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_renewToken',
        {'clientIndex': _clientIndex, 'token': token});
    _renewTokenCompletion = new Completer<String>();
    return _renewTokenCompletion.future;
  }

  /// Queries the online status of the specified user(s).
  Future<Map<String, bool>> queryPeersOnlineStatus(List<String> peerIds) async {
    _AgoraRtmPlugin._channel.invokeMethod(
        'AgoraRtmClient_queryPeersOnlineStatus',
        {'clientIndex': _clientIndex, 'peerIds': peerIds});
    _queryPeersOnlineStatusCompletion = new Completer<Map<String, bool>>();
    return _queryPeersOnlineStatusCompletion.future;
  }

  /// Allows a user to send a peer-to-peer message to a specific peer user.
  Future<void> sendMessageToPeer(String peerId, AgoraRtmMessage message) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_sendMessageToPeer', {
      'clientIndex': _clientIndex,
      'peerId': peerId,
      'message': message._jsonMap(),
    });
    _sendMessageToPeerCompletion = new Completer<void>();
    return _sendMessageToPeerCompletion.future;
  }

  /// Substitutes the local user’s attributes with new ones.
  Future<void> setLocalUserAttributes(List<Map<String,String>> attributes) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_setLocalUserAttributes', {
      'clientIndex': _clientIndex,
      'attributes': attributes,
    });
    _setLocalUserAttributesCompletion = new Completer<void>();
    return _setLocalUserAttributesCompletion.future;
  }

  /// Adds or updates the local user’s attribute(s).
  Future<void> addOrUpdateLocalUserAttributes(List<Map<String,String>> attributes) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_addOrUpdateLocalUserAttributes', {
      'clientIndex': _clientIndex,
      'attributes': attributes,
    });
    _addOrUpdateLocalUserAttributesCompletion = new Completer<void>();
    return _addOrUpdateLocalUserAttributesCompletion.future;
  }

  /// Deletes the local user’s attributes using attribute keys.
  Future<void> deleteLocalUserAttributesByKeys(List<String> keys) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_deleteLocalUserAttributesByKeys', {
      'clientIndex': _clientIndex,
      'keys': keys
    });
    _deleteLocalUserAttributesByKeysCompletion = new Completer<void>();
    return _deleteLocalUserAttributesByKeysCompletion.future;
  }

  /// Clears all attributes of the local user.
  Future<void> clearLocalUserAttributes() async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_clearLocalUserAttributes', {
      'clientIndex': _clientIndex,
    });
    _clearLocalUserAttributesCompletion = new Completer<void>();
    return _clearLocalUserAttributesCompletion.future;
  }

  /// Gets all attributes of a specified user.
  Future<Map> getUserAttributes(String userId) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_getUserAttributes', {
      'clientIndex': _clientIndex,
      'userId': userId
    });
    _getUserAttributesCompletion = new Completer<Map>();
    return _getUserAttributesCompletion.future;
  }

  /// Gets the attributes of a specified user using attribute keys.
  Future<Map> getUserAttributesByKeys(String userId, List<String> keys) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_getUserAttributesByKeys', {
      'clientIndex': _clientIndex,
      'userId': userId,
      'keys': keys
    });
    _getUserAttributesByKeysCompletion = new Completer<Map>();
    return _getUserAttributesByKeysCompletion.future;
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
    int channelIndex = await _AgoraRtmPlugin._channel.invokeMethod(
        'AgoraRtmClient_createChannel',
        {'clientIndex': _clientIndex, 'channelId': channelId});
    if (channelIndex >= 0) {
      AgoraRtmChannel channel =
          AgoraRtmChannel._(this._clientIndex, channelIndex, channelId);
      AgoraRtmChannel._channels[channelIndex] = channel;
      return channel;
    } else {
      throw ("Create channel failed.");
    }
  }

  static void _receiveEvent(String method, Map arguments) {
    int index = arguments['objIndex'];
    AgoraRtmClient client = _clients[index];
    if (client == null) {
      return;
    }

    switch (method) {
      case 'AgoraRtmClient_login':
        if (client._loginCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._loginCompletion.complete();
        } else {
          client._loginCompletion.completeError(code);
        }
        client._loginCompletion = null;
        break;
      case 'AgoraRtmClient_logout':
        if (client._logoutCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._logoutCompletion.complete();
        } else {
          client._logoutCompletion.completeError(code);
        }
        client._logoutCompletion = null;
        break;
      case 'AgoraRtmClient_renewToken':
        if (client._renewTokenCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          String token = arguments['token'];
          client._renewTokenCompletion.complete(token);
        } else {
          client._renewTokenCompletion.completeError(code);
        }
        client._renewTokenCompletion = null;
        break;
      case 'AgoraRtmClient_queryPeersOnlineStatus':
        if (client._queryPeersOnlineStatusCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          Map<String, bool> results =
              Map<String, bool>.from(arguments['results']);
          client._queryPeersOnlineStatusCompletion.complete(results);
        } else {
          client._queryPeersOnlineStatusCompletion.completeError(code);
        }
        client._queryPeersOnlineStatusCompletion = null;
        break;
      case 'AgoraRtmClient_sendMessageToPeer':
        if (client._sendMessageToPeerCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._sendMessageToPeerCompletion.complete();
        } else {
          client._sendMessageToPeerCompletion.completeError(code);
        }
        client._sendMessageToPeerCompletion = null;
        break;
      case 'AgoraRtmClient_onConnectionStateChanged':
        if (client.onConnectionStateChanged == null) {
          return;
        }
        client.onConnectionStateChanged(
            arguments['state'], arguments['reason']);
        break;
      case 'AgoraRtmClient_onMessageReceived':
        if (client.onMessageReceived == null) {
          return;
        }
        Map messageValue = arguments['message'];
        AgoraRtmMessage message = AgoraRtmMessage(messageValue['text']);
        client.onMessageReceived(message, arguments['peerId']);
        break;
      case 'AgoraRtmClient_onTokenExpired':
        if (client.onTokenExpired == null) {
          return;
        }
        client.onTokenExpired();
        break;
      case 'AgoraRtmClient_setLocalUserAttributes':
        if (client._setLocalUserAttributesCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._setLocalUserAttributesCompletion.complete();
        } else {
          client._setLocalUserAttributesCompletion.completeError(code);
        }
        client._setLocalUserAttributesCompletion = null;
        break;
      case 'AgoraRtmClient_addOrUpdateLocalUserAttributes':        
        if (client._addOrUpdateLocalUserAttributesCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._addOrUpdateLocalUserAttributesCompletion.complete();
        } else {
          client._addOrUpdateLocalUserAttributesCompletion.completeError(code);
        }
        client._addOrUpdateLocalUserAttributesCompletion = null;
        break; 
      case 'AgoraRtmClient_deleteLocalUserAttributesByKeys':
        if (client._deleteLocalUserAttributesByKeysCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._deleteLocalUserAttributesByKeysCompletion.complete();
        } else {
          client._deleteLocalUserAttributesByKeysCompletion.completeError(code);
        }
        client._deleteLocalUserAttributesByKeysCompletion = null;
        break;
      case 'AgoraRtmClient_clearLocalUserAttributes':
        if (client._clearLocalUserAttributesCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          client._clearLocalUserAttributesCompletion.complete();
        } else {
          client._clearLocalUserAttributesCompletion.completeError(code);
        }
        client._clearLocalUserAttributesCompletion = null;
        break;
      case 'AgoraRtmClient_getUserAttributes':
        if (client._getUserAttributesCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        Map results = arguments['results'];
        if (code == 0) {
          client._getUserAttributesCompletion.complete(results);
        } else {
          client._getUserAttributesCompletion.completeError(code);
        }
        client._getUserAttributesCompletion = null;
        break;
      case 'AgoraRtmClient_getUserAttributesByKeys':
        if (client._getUserAttributesByKeysCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        Map results = arguments['results'];
        if (code == 0) {
          client._getUserAttributesByKeysCompletion.complete(results);
        } else {
          client._getUserAttributesByKeysCompletion.completeError(code);
        }
        client._getUserAttributesByKeysCompletion = null;
        break;
      default:
    }
  }
}

class AgoraRtmChannel {
  /// Occurs when the local user receives a channel message.
  void Function(AgoraRtmMessage message, AgoraRtmMember fromMember)
      onMessageReceived;

  /// Occurs when a remote user joins a channel.
  ///
  /// This callback is disabled when the number of the channel members exceeds 512.
  void Function(AgoraRtmMember member) onMemberJoined;

  /// Occurs when a remote user leaves a channel.
  ///
  /// This callback is disabled when the number of the channel members exceeds 512.
  void Function(AgoraRtmMember member) onMemberLeft;

  final int _clientIndex;
  final int _channelIndex;
  final String _channelId;

  AgoraRtmChannel._(this._clientIndex, this._channelIndex, this._channelId);

  static var _channels = <int, AgoraRtmChannel>{};
  Completer<void> _joinCompletion;
  Completer<void> _leaveCompletion;
  Completer<void> _sendMessageCompletion;
  Completer<List<AgoraRtmMember>> _getMembersCompletion;

  /// Allows a user to join a channel.
  Future<void> join() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmChannel_join', {'channelIndex': _channelIndex});
    _joinCompletion = new Completer<void>();
    return _joinCompletion.future;
  }

  /// Allows a user to leave a channel.
  Future<void> leave() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmChannel_leave', {'channelIndex': _channelIndex});
    _leaveCompletion = new Completer<void>();
    return _leaveCompletion.future;
  }

  /// Allows a user to send a message to all users in the channel.
  ///
  /// You can send channel messages at a maximum speed of 60 queries per second.
  Future<void> sendMessage(AgoraRtmMessage message) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmChannel_sendMessage', {
      'channelIndex': _channelIndex,
      'clientIndex': _clientIndex,
      'message': message._jsonMap()
    });
    _sendMessageCompletion = new Completer<void>();
    return _sendMessageCompletion.future;
  }

  /// Retrieves the member list of a channel.
  Future<List<AgoraRtmMember>> getMembers() async {
    _AgoraRtmPlugin._channel.invokeMethod(
        'AgoraRtmChannel_getMembers', {'channelIndex': _channelIndex});
    _getMembersCompletion = new Completer<List<AgoraRtmMember>>();
    return _getMembersCompletion.future;
  }

  /// Release an [AgoraRtmChannel] instance.
  ///
  /// Do not call this method in any of your callbacks.
  Future<void> release() async {
    await _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmChannel_release', {
      'channelIndex': _channelIndex,
      'clientIndex': _clientIndex,
      'channelId': _channelId
    });
  }

  static void _receiveEvent(String method, Map arguments) {
    int index = arguments['objIndex'];
    AgoraRtmChannel channel = _channels[index];
    if (channel == null) {
      return;
    }

    switch (method) {
      case 'AgoraRtmChannel_join':
        if (channel._joinCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          channel._joinCompletion.complete();
        } else {
          channel._joinCompletion.completeError(code);
        }
        channel._joinCompletion = null;
        break;
      case 'AgoraRtmChannel_leave':
        if (channel._leaveCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          channel._leaveCompletion.complete();
        } else {
          channel._leaveCompletion.completeError(code);
        }
        channel._leaveCompletion = null;
        break;
      case 'AgoraRtmChannel_sendMessage':
        if (channel._sendMessageCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          channel._sendMessageCompletion.complete();
        } else {
          channel._sendMessageCompletion.completeError(code);
        }
        channel._sendMessageCompletion = null;
        break;
      case 'AgoraRtmChannel_getMembers':
        if (channel._getMembersCompletion == null) {
          return;
        }
        int code = arguments['errorCode'];
        if (code == 0) {
          List memberList = List.from(arguments['members']);
          List<AgoraRtmMember> members = List<AgoraRtmMember>();
          for (var memberMap in memberList) {
            AgoraRtmMember member =
                AgoraRtmMember(memberMap['userId'], memberMap['channelId']);
            members.add(member);
          }
          channel._getMembersCompletion.complete(members);
        } else {
          channel._getMembersCompletion.completeError(code);
        }
        channel._getMembersCompletion = null;
        break;
      // events
      case 'AgoraRtmChannel_onMemberJoined':
        if (channel.onMemberJoined == null) {
          return;
        }
        Map<String, String> memberDic =
            Map<String, String>.from(arguments['member']);
        String userId = memberDic['userId'];
        String channelId = memberDic['channelId'];
        AgoraRtmMember member = AgoraRtmMember(userId, channelId);
        channel.onMemberJoined(member);
        break;
      case 'AgoraRtmChannel_onMemberLeft':
        if (channel.onMemberLeft == null) {
          return;
        }
        Map<String, String> memberDic =
            Map<String, String>.from(arguments['member']);
        String userId = memberDic['userId'];
        String channelId = memberDic['channelId'];
        AgoraRtmMember member = AgoraRtmMember(userId, channelId);
        channel.onMemberLeft(member);
        break;
      case 'AgoraRtmChannel_onMessageReceived':
        if (channel.onMessageReceived == null) {
          return;
        }
        Map<String, String> memberDic =
            Map<String, String>.from(arguments['member']);
        String userId = memberDic['userId'];
        String channelId = memberDic['channelId'];
        AgoraRtmMember member = AgoraRtmMember(userId, channelId);
        Map<String, String> messageDic =
            Map<String, String>.from(arguments['message']);
        String text = messageDic['text'];
        AgoraRtmMessage message = AgoraRtmMessage(text);
        channel.onMessageReceived(message, member);
        break;
      default:
    }
  }
}

class AgoraRtmMessage {
  String text;

  AgoraRtmMessage(String text) {
    this.text = text;
  }

  Map<String, dynamic> _jsonMap() {
    return {
      'text': text,
    };
  }
}

class AgoraRtmMember {
  String userId;
  String channelId;

  AgoraRtmMember(String userId, String channelId) {
    this.userId = userId;
    this.channelId = channelId;
  }

  @override
  String toString() {
    return "{uid: " + userId + ", cid: " + channelId + "}";
  }
}
