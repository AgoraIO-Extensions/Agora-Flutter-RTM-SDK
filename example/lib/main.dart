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
  LocalInvitation? _localInvitation;
  RemoteInvitation? _remoteInvitation;

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
  void dispose() {
    _client?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('RTM 1.x'),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildLogin(),
                _buildQueryOnlineStatus(),
                _buildSubscribeOnlineStatus(),
                _buildSendPeerMessage(),
                _buildLocalInvitation(),
                _buildRemoteInvitation(),
                _buildJoinChannel(),
                _buildGetMembers(),
                _buildSendChannelMessage(),
                _buildInfoList(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _refreshLogs();
            },
            child: const Icon(Icons.refresh),
          )),
    );
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('aab8b8f5a8cd4469a63042fcfafe7063');
    _log(await AgoraRtmClient.getSdkVersion());
    await _client?.setParameters('{"rtm.log_filter": 15}');
    await _client?.setLogFile('');
    await _client?.setLogFilter(RtmLogFilter.info);
    await _client?.setLogFileSize(10240);
    _client?.onError = (error) {
      _log("Client error: $error");
    };
    _client?.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      _log('Connection state changed: $state, reason: $reason');
      if (state == RtmConnectionState.aborted) {
        _client?.logout();
        _log('Logout');
        setState(() {
          _isLogin = false;
        });
      }
    };
    _client?.onMessageReceived = (RtmMessage message, String peerId) {
      _log("Peer msg: $peerId, msg: ${message.messageType} ${message.text}");
    };
    _client?.onTokenExpired = () {
      _log("Token expired");
    };
    _client?.onTokenPrivilegeWillExpire = () {
      _log("Token privilege will expire");
    };
    _client?.onPeersOnlineStatusChanged =
        (Map<String, RtmPeerOnlineState> peersStatus) {
      _log("Peers online status changed ${peersStatus.toString()}");
    };

    var callManager = _client?.getRtmCallManager();
    callManager?.onError = (error) {
      _log('Call manager error: $error');
    };
    callManager?.onLocalInvitationReceivedByPeer =
        (LocalInvitation localInvitation) {
      _log(
          'Local invitation received by peer: ${localInvitation.calleeId}, content: ${localInvitation.content}');
    };
    callManager?.onLocalInvitationAccepted =
        (LocalInvitation localInvitation, String response) {
      _log(
          'Local invitation accepted by peer: ${localInvitation.calleeId}, response: $response');
      setState(() {
        _localInvitation = null;
      });
    };
    callManager?.onLocalInvitationRefused =
        (LocalInvitation localInvitation, String response) {
      _log(
          'Local invitation refused by peer: ${localInvitation.calleeId}, response: $response');
      setState(() {
        _localInvitation = null;
      });
    };
    callManager?.onLocalInvitationCanceled = (LocalInvitation localInvitation) {
      _log(
          'Local invitation canceled: ${localInvitation.calleeId}, content: ${localInvitation.content}');
      setState(() {
        _localInvitation = null;
      });
    };
    callManager?.onLocalInvitationFailure =
        (LocalInvitation localInvitation, int errorCode) {
      _log(
          'Local invitation failure: ${localInvitation.calleeId}, errorCode: $errorCode');
      setState(() {
        _localInvitation = null;
      });
    };
    callManager?.onRemoteInvitationReceived =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation received by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {
        _remoteInvitation = remoteInvitation;
      });
    };
    callManager?.onRemoteInvitationAccepted =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation accepted by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {
        _remoteInvitation = null;
      });
    };
    callManager?.onRemoteInvitationRefused =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation refused by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {
        _remoteInvitation = null;
      });
    };
    callManager?.onRemoteInvitationCanceled =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation canceled: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      setState(() {
        _remoteInvitation = null;
      });
    };
    callManager?.onRemoteInvitationFailure =
        (RemoteInvitation remoteInvitation, int errorCode) {
      _log(
          'Remote invitation failure: ${remoteInvitation.callerId}, errorCode: $errorCode');
      setState(() {
        _remoteInvitation = null;
      });
    };
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onError = (error) {
        _log("Channel error: $error");
      };
      channel.onMemberCountUpdated = (int memberCount) {
        _log("Member count updated: $memberCount");
      };
      channel.onAttributesUpdated = (List<RtmChannelAttribute> attributes) {
        _log("Channel attributes updated: ${attributes.toString()}");
      };
      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        _log("Channel msg: ${member.userId}: ${message.text}");
      };
      channel.onMemberJoined = (RtmChannelMember member) {
        _log('Member joined: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMemberLeft = (RtmChannelMember member) {
        _log('Member left: ${member.userId}, channel: ${member.channelId}');
      };
    }
    return channel;
  }

  static TextStyle textStyle =
      const TextStyle(fontSize: 15, color: Colors.blue);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      _isLogin
          ? Expanded(
              child: Text('Uid: ${_userNameController.text}', style: textStyle))
          : Flexible(
              child: TextField(
                  controller: _userNameController,
                  decoration: const InputDecoration(hintText: 'uid'))),
      IconButton(
        icon: Icon(_isLogin ? Icons.logout_outlined : Icons.login_sharp),
        onPressed: _toggleLogin,
      )
    ]);
  }

  Widget _buildQueryOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      Flexible(
          child: TextField(
              controller: _peerUserIdController,
              decoration:
                  const InputDecoration(hintText: 'Input peer user id'))),
      IconButton(
        onPressed: _toggleQueryPeersOnlineStatus,
        icon: const Icon(Icons.search_outlined),
      )
    ]);
  }

  Widget _buildSubscribeOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        OutlinedButton(
          onPressed: _subscribePeersOnlineStatus,
          child: const Text('Subscribe Online'),
        ),
        OutlinedButton(
          onPressed: _unsubscribePeersOnlineStatus,
          child: const Text('Unsubscribe Online'),
        ),
      ],
    );
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
      IconButton(
        onPressed: _sendPeerMessage,
        icon: const Icon(Icons.send),
      )
    ]);
  }

  Widget _buildLocalInvitation() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      Expanded(
          child: TextField(
              controller: _invitationController,
              decoration:
                  const InputDecoration(hintText: 'Input invitation content'))),
      IconButton(
        onPressed: () {
          _toggleLocalInvitation();
          Text(
              '${_localInvitation == null ? 'Send' : 'Cancel'} local invitation',
              style: textStyle);
        },
        icon: const Icon(Icons.mail_outline),
      )
    ]);
  }

  Widget _buildRemoteInvitation() {
    if (!_isLogin || _remoteInvitation == null) {
      return Container();
    }
    return Row(children: <Widget>[
      OutlinedButton(
        onPressed: _acceptRemoteInvitation,
        child: Text('accept remote invitation', style: textStyle),
      ),
      OutlinedButton(
        onPressed: _refuseRemoteInvitation,
        child: Text('refuse remote invitation', style: textStyle),
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
      IconButton(
        onPressed: _toggleJoinChannel,
        icon: Icon(
            _isInChannel ? Icons.group_off_outlined : Icons.group_add_outlined),
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
      IconButton(
        onPressed: _sendChannelMessage,
        icon: const Icon(Icons.send),
      )
    ]);
  }

  Widget _buildGetMembers() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: ElevatedButton(
              onPressed: _getMembers,
              child: const Text('Get Members'),
            ),
          ),
          Flexible(
              child: ElevatedButton(
            onPressed: _getMemberCount,
            child: const Text('Get Member Count'),
          ))
        ]);
  }

  Widget _buildInfoList() {
    return Flexible(
        child: ListView.builder(
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(5.0),
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
        _log('Logout success');

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
        _log('Please input your user id to login');
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

  void _toggleQueryPeersOnlineStatus() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      try {
        List<String>? result = await _client?.queryPeersBySubscriptionOption(
            RtmPeerSubscriptionOption.onlineStatus);
        _log('Query result: $result');
      } catch (errorCode) {
        _log('Query error: $errorCode');
      }
    } else {
      try {
        Map<dynamic, dynamic>? result =
            await _client?.queryPeersOnlineStatus([peerUid]);
        _log('Query result: $result');
      } catch (errorCode) {
        _log('Query error: $errorCode');
      }
    }
  }

  void _subscribePeersOnlineStatus() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to subscribe');
      return;
    }

    try {
      await _client?.subscribePeersOnlineStatus([peerUid]);
      _log('Subscribe success');
    } catch (errorCode) {
      _log('Subscribe error: $errorCode');
    }
  }

  void _unsubscribePeersOnlineStatus() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to unsubscribe');
      return;
    }

    try {
      await _client?.unsubscribePeersOnlineStatus([peerUid]);
      _log('Unsubscribe success');
    } catch (errorCode) {
      _log('Unsubscribe error: $errorCode');
    }
  }

  void _sendPeerMessage() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send message');
      return;
    }

    String text = _peerMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send');
      return;
    }

    try {
      RtmMessage? message = _client?.createTextMessage(text);
      if (message != null) {
        _log(message.text);
        await _client?.sendMessageToPeer2(peerUid, message);
        _log('Send peer message success');
      }
    } catch (errorCode) {
      _log('Send peer message error: $errorCode');
    }
  }

  void _toggleLocalInvitation() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send invitation');
      return;
    }

    String text = _invitationController.text;
    if (text.isEmpty) {
      _log('Please input content to send');
      return;
    }

    if (_localInvitation == null) {
      try {
        LocalInvitation? invitation =
            await _client?.getRtmCallManager().createLocalInvitation(peerUid);
        if (invitation != null) {
          invitation.content = text;
          _log(invitation.content ?? '');
          await _client?.getRtmCallManager().sendLocalInvitation(invitation);
          setState(() {
            _localInvitation = invitation;
          });
          _log('Send local invitation success');
        }
      } catch (errorCode) {
        _log('Send local invitation error: $errorCode');
      }
    } else {
      try {
        await _client
            ?.getRtmCallManager()
            .cancelLocalInvitation(_localInvitation!);
        _log('Cancel local invitation success');
      } catch (errorCode) {
        _log('Cancel local invitation error: $errorCode');
      }
    }
  }

  void _acceptRemoteInvitation() async {
    if (_remoteInvitation == null) {
      _log('No remote invitation');
      return;
    }

    try {
      await _client
          ?.getRtmCallManager()
          .acceptRemoteInvitation(_remoteInvitation!);
      _log('Accept remote invitation success');
    } catch (errorCode) {
      _log('Accept remote invitation error: $errorCode');
    }
  }

  void _refuseRemoteInvitation() async {
    if (_remoteInvitation == null) {
      _log('No remote invitation');
      return;
    }

    try {
      await _client
          ?.getRtmCallManager()
          .refuseRemoteInvitation(_remoteInvitation!);
      _log('Refuse remote invitation success');
    } catch (errorCode) {
      _log('Refuse remote invitation error: $errorCode');
    }
  }

  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel?.leave();
        _log('Leave channel success');
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
        _log('Please input channel id to join');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel?.join();
        _log('Join channel success');

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        _log('Join channel error: $errorCode');
      }
    }
  }

  void _getMembers() async {
    try {
      List<RtmChannelMember>? members = await _channel?.getMembers();
      if (members != null) {
        List<String> userIds = members.map((member) => member.userId).toList();
        _log('User IDs: $userIds');
      }
    } catch (errorCode) {
      _log('GetMembers failed: $errorCode');
    }
  }

  void _getMemberCount() async {
    String channelId = _channelNameController.text;
    if (channelId.isEmpty) {
      _log('Please input channel id to get');
      return;
    }

    try {
      List<RtmChannelMember>? members = await _channel?.getMembers();

      if (members != null) {
        _log('Total members in the channel: ${members.length}');
      }
    } catch (errorCode) {
      _log('GetMembers failed: $errorCode');
    }
  }

  void _sendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send');
      return;
    }

    try {
      RtmMessage? message = _client?.createTextMessage(text);
      if (message != null) {
        _log(message.text);
        await _channel?.sendMessage2(message);
        _log('Send channel message success: $text');
      }
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

  void _refreshLogs() {
    setState(() {
      _infoStrings.clear();
    });
  }
}
