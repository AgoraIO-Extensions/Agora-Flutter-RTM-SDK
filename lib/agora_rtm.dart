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

class AgoraRtmClient {
  void Function(int state, int reason) onConnectionStateChanged;
  void Function(AgoraRtmMessage message, String peerId) onMessageReceived;
  void Function() onTokenExpired;

  final int _clientIndex;
  AgoraRtmClient._(this._clientIndex);

  static var _clients = <int, AgoraRtmClient>{};
  Completer<void> _loginCompletion;
  Completer<void> _logoutCompletion;
  Completer<String> _renewTokenCompletion;
  Completer<Map<String, bool>> _queryPeersOnlineStatusCompletion;
  Completer<void> _sendMessageToPeerCompletion;

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

  Future<void> login(String token, String userId) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_login',
        {'clientIndex': _clientIndex, 'token': token, 'userId': userId});
    _loginCompletion = new Completer<void>();
    return _loginCompletion.future;
  }

  Future<void> logout() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmClient_logout', {'clientIndex': _clientIndex});
    _logoutCompletion = new Completer<void>();
    return _logoutCompletion.future;
  }

  Future<String> renewToken(String token) async {
    _AgoraRtmPlugin._channel.invokeMethod(
        'AgoraRtmClient_renewToken', {'clientIndex': _clientIndex, 'token': token});
    _renewTokenCompletion = new Completer<String>();
    return _renewTokenCompletion.future;
  }

  Future<Map<String, bool>> queryPeersOnlineStatus(List<String> peerIds) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_queryPeersOnlineStatus',
        {'clientIndex': _clientIndex, 'peerIds': peerIds});
    _queryPeersOnlineStatusCompletion = new Completer<Map<String, bool>>();
    return _queryPeersOnlineStatusCompletion.future;
  }

  Future<void> sendMessageToPeer(String peerId, AgoraRtmMessage message) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmClient_sendMessageToPeer', {
      'clientIndex': _clientIndex,
      'peerId': peerId,
      'message': message._jsonMap(),
    });
    _sendMessageToPeerCompletion = new Completer<void>();
    return _sendMessageToPeerCompletion.future;
  }

  Future<AgoraRtmChannel> createChannel(String channelId) async {
    int channelIndex = await _AgoraRtmPlugin._channel.invokeMethod(
        'AgoraRtmClient_createChannel', {'clientIndex': _clientIndex, 'channelId': channelId});
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
      default:
    }
  }
}

class AgoraRtmChannel {
  void Function(AgoraRtmMessage message, AgoraRtmMember fromMember)
      onMessageReceived;
  void Function(AgoraRtmMember member) onMemberJoined;
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

  Future<void> join() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmChannel_join', {'channelIndex': _channelIndex});
    _joinCompletion = new Completer<void>();
    return _joinCompletion.future;
  }

  Future<void> leave() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmChannel_leave', {'channelIndex': _channelIndex});
    _leaveCompletion = new Completer<void>();
    return _leaveCompletion.future;
  }

  Future<void> sendMessage(AgoraRtmMessage message) async {
    _AgoraRtmPlugin._channel.invokeMethod('AgoraRtmChannel_sendMessage',
        {'channelIndex': _channelIndex, 'clientIndex': _clientIndex, 'message': message._jsonMap()});
    _sendMessageCompletion = new Completer<void>();
    return _sendMessageCompletion.future;
  }

  Future<List<AgoraRtmMember>> getMembers() async {
    _AgoraRtmPlugin._channel
        .invokeMethod('AgoraRtmChannel_getMembers', {'channelIndex': _channelIndex});
    _getMembersCompletion = new Completer<List<AgoraRtmMember>>();
    return _getMembersCompletion.future;
  }

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
          List<AgoraRtmMember> members = arguments['members']
              .map((memberMap) =>
                  AgoraRtmMember(memberMap['userId'], memberMap['channelId']))
              .toList();
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
}
