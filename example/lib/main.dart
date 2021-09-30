import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogin = false;
  bool _isInChannel = false;

  final _userNameController = TextEditingController();
  final _peerUserIdController = TextEditingController();
  final _peerMessageController = TextEditingController();
  final _invitationController = TextEditingController();
  final _channelNameController = TextEditingController();
  final _channelMessageController = TextEditingController();

  final _infoStrings = <String>[];

  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Agora Real Time Message'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLogin(),
                _buildQueryOnlineStatus(),
                _buildSendPeerMessage(),
                _buildSendLocalInvitation(),
                _buildJoinChannel(),
                _buildGetMembers(),
                _buildSendChannelMessage(),
                _buildInfoList(),
              ],
            ),
          )),
    );
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance(YOUR_APP_ID);
    _client?.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + (message.text));
    };
    _client?.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client?.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    _client?.onLocalInvitationReceivedByPeer =
        (AgoraRtmLocalInvitation invite) {
      _log(
          'Local invitation received by peer: ${invite.calleeId}, content: ${invite.content}');
    };
    _client?.onRemoteInvitationReceivedByPeer =
        (AgoraRtmRemoteInvitation invite) {
      _log(
          'Remote invitation received by peer: ${invite.callerId}, content: ${invite.content}');
    };
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onMemberJoined = (AgoraRtmMember member) {
        _log("Member joined: " +
            member.userId +
            ', channel: ' +
            member.channelId);
      };
      channel.onMemberLeft = (AgoraRtmMember member) {
        _log(
            "Member left: " + member.userId + ', channel: ' + member.channelId);
      };
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        _log("Channel msg: " + member.userId + ", msg: " + message.text);
      };
    }
    return channel;
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      _isLogin
          ? new Expanded(
              child: new Text('User Id: ' + _userNameController.text,
                  style: textStyle))
          : new Expanded(
              child: new TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(hintText: 'Input your user id'))),
      new OutlineButton(
        child: Text(_isLogin ? 'Logout' : 'Login', style: textStyle),
        onPressed: _toggleLogin,
      )
    ]);
  }

  Widget _buildQueryOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerUserIdController,
              decoration: InputDecoration(hintText: 'Input peer user id'))),
      new OutlineButton(
        child: Text('Query Online', style: textStyle),
        onPressed: _toggleQuery,
      )
    ]);
  }

  Widget _buildSendPeerMessage() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerMessageController,
              decoration: InputDecoration(hintText: 'Input peer message'))),
      new OutlineButton(
        child: Text('Send to Peer', style: textStyle),
        onPressed: _toggleSendPeerMessage,
      )
    ]);
  }

  Widget _buildSendLocalInvitation() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _invitationController,
              decoration:
                  InputDecoration(hintText: 'Input invitation content'))),
      new OutlineButton(
        child: Text('Send local invitation', style: textStyle),
        onPressed: _toggleSendLocalInvitation,
      )
    ]);
  }

  Widget _buildJoinChannel() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      _isInChannel
          ? new Expanded(
              child: new Text('Channel: ' + _channelNameController.text,
                  style: textStyle))
          : new Expanded(
              child: new TextField(
                  controller: _channelNameController,
                  decoration: InputDecoration(hintText: 'Input channel id'))),
      new OutlineButton(
        child: Text(_isInChannel ? 'Leave Channel' : 'Join Channel',
            style: textStyle),
        onPressed: _toggleJoinChannel,
      )
    ]);
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _channelMessageController,
              decoration: InputDecoration(hintText: 'Input channel message'))),
      new OutlineButton(
        child: Text('Send to Channel', style: textStyle),
        onPressed: _toggleSendChannelMessage,
      )
    ]);
  }

  Widget _buildGetMembers() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      new OutlineButton(
        child: Text('Get Members in Channel', style: textStyle),
        onPressed: _toggleGetMembers,
      )
    ]);
  }

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
            child: ListView.builder(
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    )));
  }

  void _toggleLogin() async {
    if (_isLogin) {
      try {
        await _client?.logout();
        _log('Logout success.');

        setState(() {
          _isLogin = false;
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Logout error: ' + errorCode.toString());
      }
    } else {
      String userId = _userNameController.text;
      if (userId.isEmpty) {
        _log('Please input your user id to login.');
        return;
      }

      try {
        await _client?.login(null, userId);
        _log('Login success: ' + userId);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }

  void _toggleQuery() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to query.');
      return;
    }
    try {
      Map<dynamic, dynamic>? result =
          await _client?.queryPeersOnlineStatus([peerUid]);
      _log('Query result: ' + result.toString());
    } catch (errorCode) {
      _log('Query error: ' + errorCode.toString());
    }
  }

  void _toggleSendPeerMessage() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send message.');
      return;
    }

    String text = _peerMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      _log(message.text);
      await _client?.sendMessageToPeer(peerUid, message, false);
      _log('Send peer message success.');
    } catch (errorCode) {
      _log('Send peer message error: ' + errorCode.toString());
    }
  }

  void _toggleSendLocalInvitation() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send invitation.');
      return;
    }

    String text = _invitationController.text;
    if (text.isEmpty) {
      _log('Please input content to send.');
      return;
    }

    try {
      AgoraRtmLocalInvitation invitation =
          AgoraRtmLocalInvitation(peerUid, content: text);
      _log(invitation.content ?? '');
      await _client?.sendLocalInvitation(invitation.toJson());
      _log('Send local invitation success.');
    } catch (errorCode) {
      _log('Send local invitation error: ' + errorCode.toString());
    }
  }

  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel?.leave();
        _log('Leave channel success.');
        if (_channel != null) {
          _client?.releaseChannel(_channel!.channelId!);
        }
        _channelMessageController.clear();

        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Leave channel error: ' + errorCode.toString());
      }
    } else {
      String channelId = _channelNameController.text;
      if (channelId.isEmpty) {
        _log('Please input channel id to join.');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel?.join();
        _log('Join channel success.');

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        _log('Join channel error: ' + errorCode.toString());
      }
    }
  }

  void _toggleGetMembers() async {
    try {
      List<AgoraRtmMember>? members = await _channel?.getMembers();
      _log('Members: ' + members.toString());
    } catch (errorCode) {
      _log('GetMembers failed: ' + errorCode.toString());
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }
    try {
      await _channel?.sendMessage(AgoraRtmMessage.fromText(text));
      _log('Send channel message success.');
    } catch (errorCode) {
      _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
