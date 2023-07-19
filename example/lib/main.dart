import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
    _client = await AgoraRtmClient.createInstance('YOUR_APP_ID');
    _log(await AgoraRtmClient.getSdkVersion());
    _client?.onMessageReceived = (RtmMessage message, String peerId) {
      _log("Peer msg: $peerId, msg: ${message.text}");
    };
    _client?.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      _log('Connection state changed: $state, reason: $reason');
      if (state == RtmConnectionState.aborted) {
        _client?.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    _client?.getRtmCallManager().onLocalInvitationReceivedByPeer =
        (LocalInvitation invite) {
      _log(
          'Local invitation received by peer: ${invite.calleeId}, content: ${invite.content}');
    };
    _client?.getRtmCallManager().onRemoteInvitationReceived =
        (RemoteInvitation invite) {
      _log(
          'Remote invitation received by peer: ${invite.callerId}, content: ${invite.content}');
    };
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onMemberJoined = (RtmChannelMember member) {
        _log('Member joined: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMemberLeft = (RtmChannelMember member) {
        _log('Member left: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        _log("Channel msg: ${member.userId}, msg: ${message.text}");
      };
    }
    return channel;
  }

  static TextStyle textStyle =
      const TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      _isLogin
          ? Expanded(
              child: Text('User Id: ${_userNameController.text}',
                  style: textStyle))
          : Expanded(
              child: TextField(
                  controller: _userNameController,
                  decoration:
                      const InputDecoration(hintText: 'Input your user id'))),
      OutlinedButton(
        onPressed: _toggleLogin,
        child: Text(_isLogin ? 'Logout' : 'Login', style: textStyle),
      )
    ]);
  }

  Widget _buildQueryOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
              controller: _peerUserIdController,
              decoration:
                  const InputDecoration(hintText: 'Input peer user id'))),
      OutlinedButton(
        onPressed: _toggleQuery,
        child: Text('Query Online', style: textStyle),
      )
    ]);
  }

  Widget _buildSendPeerMessage() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
              controller: _peerMessageController,
              decoration:
                  const InputDecoration(hintText: 'Input peer message'))),
      OutlinedButton(
        onPressed: _toggleSendPeerMessage,
        child: Text('Send to Peer', style: textStyle),
      )
    ]);
  }

  Widget _buildSendLocalInvitation() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
              controller: _invitationController,
              decoration:
                  const InputDecoration(hintText: 'Input invitation content'))),
      OutlinedButton(
        onPressed: _toggleSendLocalInvitation,
        child: Text('Send local invitation', style: textStyle),
      )
    ]);
  }

  Widget _buildJoinChannel() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      _isInChannel
          ? Expanded(
              child: Text('Channel: ${_channelNameController.text}',
                  style: textStyle))
          : Expanded(
              child: TextField(
                  controller: _channelNameController,
                  decoration:
                      const InputDecoration(hintText: 'Input channel id'))),
      OutlinedButton(
        onPressed: _toggleJoinChannel,
        child: Text(_isInChannel ? 'Leave Channel' : 'Join Channel',
            style: textStyle),
      )
    ]);
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
              controller: _channelMessageController,
              decoration:
                  const InputDecoration(hintText: 'Input channel message'))),
      OutlinedButton(
        onPressed: _toggleSendChannelMessage,
        child: Text('Send to Channel', style: textStyle),
      )
    ]);
  }

  Widget _buildGetMembers() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      OutlinedButton(
        onPressed: _toggleGetMembers,
        child: Text('Get Members in Channel', style: textStyle),
      )
    ]);
  }

  Widget _buildInfoList() {
    return Expanded(
        child: ListView.builder(
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    ));
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
        _log('Logout error: $errorCode');
      }
    } else {
      String userId = _userNameController.text;
      if (userId.isEmpty) {
        _log('Please input your user id to login.');
        return;
      }

      try {
        await _client?.login(null, userId);
        _log('Login success: $userId');
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: $errorCode');
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
      _log('Query result: $result');
    } catch (errorCode) {
      _log('Query error: $errorCode');
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
      RtmMessage message = RtmMessage.fromText(text);
      _log(message.text);
      await _client?.sendMessageToPeer2(peerUid, message);
      _log('Send peer message success.');
    } catch (errorCode) {
      _log('Send peer message error: $errorCode');
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
      LocalInvitation? invitation =
          await _client?.getRtmCallManager().createLocalInvitation(peerUid);
      if (invitation != null) {
        invitation.content = text;
        _log(invitation.content ?? '');
        await _client?.getRtmCallManager().sendLocalInvitation(invitation);
        _log('Send local invitation success.');
      }
    } catch (errorCode) {
      _log('Send local invitation error: $errorCode');
    }
  }

  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel?.leave();
        _log('Leave channel success.');
        await _channel?.release();
        _channelMessageController.clear();

        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Leave channel error: $errorCode');
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
        _log('Join channel error: $errorCode');
      }
    }
  }

  void _toggleGetMembers() async {
    try {
      List<RtmChannelMember>? members = await _channel?.getMembers();
      _log('Members: $members');
    } catch (errorCode) {
      _log('GetMembers failed: $errorCode');
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }
    try {
      await _channel?.sendMessage2(RtmMessage.fromText(text));
      _log('Send channel message success.');
    } catch (errorCode) {
      _log('Send channel message error: $errorCode');
    }
  }

  void _log(String info) {
    debugPrint(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
