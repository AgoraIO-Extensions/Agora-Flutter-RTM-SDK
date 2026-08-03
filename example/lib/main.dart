import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static const _token = String.fromEnvironment('TEST_TOKEN');

  bool _isClientReady = false;
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
  final _attributeKeyController = TextEditingController();
  final _attributeValueController = TextEditingController();

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
    final client = _client;
    _client = null;
    _channel = null;
    _userNameController.dispose();
    _peerUserIdController.dispose();
    _peerMessageController.dispose();
    _invitationController.dispose();
    _channelNameController.dispose();
    _channelMessageController.dispose();
    _attributeKeyController.dispose();
    _attributeValueController.dispose();
    client?.release();
    super.dispose();
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLogin(),
                        _buildQueryOnlineStatus(),
                        _buildSubscribeOnlineStatus(),
                        _buildSendPeerMessage(),
                        _buildUserAttributes(),
                        _buildLocalInvitation(),
                        _buildRemoteInvitation(),
                        _buildJoinChannel(),
                        _buildGetMembers(),
                        _buildSendChannelMessage(),
                        _buildChannelAttributes(),
                      ],
                    ),
                  ),
                ),
                _buildInfoList(),
              ],
            ),
          )),
    );
  }

  Future<void> _createClient() async {
    AgoraRtmClient? client;
    try {
      const appId = String.fromEnvironment(
        'TEST_APP_ID',
        defaultValue: 'dd8dfbf0f9484a8c960546ffe4ba4dce',
      );
      await AgoraRtmClient.setRtmServiceContext(RtmServiceContext());
      client = await AgoraRtmClient.createInstance(appId);
      if (!mounted) {
        await client.release();
        return;
      }
      _client = client;
      _log(await AgoraRtmClient.getSdkVersion());
      await client.setParameters('{"rtm.log_filter": 15}');
      // Native SDK rejects an empty path; use a writable temp file.
      final logPath = '${Directory.systemTemp.path}/agora_rtm.log';
      await client.setLogFile(logPath);
      await client.setLogFilter(RtmLogFilter.info);
      await client.setLogFileSize(10240);
    } catch (error) {
      _log('Create client error: $error');
      if (identical(_client, client)) {
        _client = null;
        try {
          await client?.release();
        } catch (releaseError) {
          _log('Release client error: $releaseError');
        }
      }
      return;
    }

    if (!mounted || !identical(_client, client)) {
      return;
    }

    client.onError = (error) {
      _log("Client error: $error");
    };
    client.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      _log('Connection state changed: $state, reason: $reason');
      if (state == RtmConnectionState.aborted) {
        _handleConnectionAborted();
      }
    };
    client.onMessageReceived = (RtmMessage message, String peerId) {
      _log("Peer msg: $peerId, msg: ${message.messageType} ${message.text}");
    };
    client.onTokenExpired = () {
      _log("Token expired");
    };
    client.onTokenPrivilegeWillExpire = () {
      _log("Token privilege will expire");
    };
    client.onPeersOnlineStatusChanged =
        (Map<String, RtmPeerOnlineState> peersStatus) {
      _log("Peers online status changed ${peersStatus.toString()}");
    };

    final callManager = client.getRtmCallManager();
    callManager.onError = (error) {
      _log('Call manager error: $error');
    };
    callManager.onLocalInvitationReceivedByPeer =
        (LocalInvitation localInvitation) {
      _log(
          'Local invitation received by peer: ${localInvitation.calleeId}, content: ${localInvitation.content}');
    };
    callManager.onLocalInvitationAccepted =
        (LocalInvitation localInvitation, String response) {
      _log(
          'Local invitation accepted by peer: ${localInvitation.calleeId}, response: $response');
      _updateState(() {
        _localInvitation = null;
      });
    };
    callManager.onLocalInvitationRefused =
        (LocalInvitation localInvitation, String response) {
      _log(
          'Local invitation refused by peer: ${localInvitation.calleeId}, response: $response');
      _updateState(() {
        _localInvitation = null;
      });
    };
    callManager.onLocalInvitationCanceled = (LocalInvitation localInvitation) {
      _log(
          'Local invitation canceled: ${localInvitation.calleeId}, content: ${localInvitation.content}');
      _updateState(() {
        _localInvitation = null;
      });
    };
    callManager.onLocalInvitationFailure =
        (LocalInvitation localInvitation, int errorCode) {
      _log(
          'Local invitation failure: ${localInvitation.calleeId}, errorCode: $errorCode');
      _updateState(() {
        _localInvitation = null;
      });
    };
    callManager.onRemoteInvitationReceived =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation received by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      _updateState(() {
        _remoteInvitation = remoteInvitation;
      });
    };
    callManager.onRemoteInvitationAccepted =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation accepted by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      _updateState(() {
        _remoteInvitation = null;
      });
    };
    callManager.onRemoteInvitationRefused =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation refused by peer: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      _updateState(() {
        _remoteInvitation = null;
      });
    };
    callManager.onRemoteInvitationCanceled =
        (RemoteInvitation remoteInvitation) {
      _log(
          'Remote invitation canceled: ${remoteInvitation.callerId}, content: ${remoteInvitation.content}');
      _updateState(() {
        _remoteInvitation = null;
      });
    };
    callManager.onRemoteInvitationFailure =
        (RemoteInvitation remoteInvitation, int errorCode) {
      _log(
          'Remote invitation failure: ${remoteInvitation.callerId}, errorCode: $errorCode');
      _updateState(() {
        _remoteInvitation = null;
      });
    };

    _updateState(() {
      _isClientReady = true;
    });
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
        _log(
            "Channel msg: ${member.userId}, msg: ${message.messageType} ${message.text}");
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
      const TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildTextFieldAction({
    required TextEditingController controller,
    required String hintText,
    required String actionText,
    required VoidCallback? onPressed,
  }) {
    final textField = TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
    final button = OutlinedButton(
      onPressed: onPressed,
      child: Text(actionText, style: textStyle),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textField,
              Align(alignment: Alignment.centerRight, child: button),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: textField),
            button,
          ],
        );
      },
    );
  }

  Widget _buildLogin() {
    return Column(
      children: [
        if (_isLogin)
          Row(children: <Widget>[
            Expanded(
                child: Text('User Id: ${_userNameController.text}',
                    style: textStyle)),
            OutlinedButton(
              onPressed: _toggleLogin,
              child: Text('Logout', style: textStyle),
            )
          ])
        else
          _buildTextFieldAction(
            controller: _userNameController,
            hintText: 'Input your user id',
            actionText: _isClientReady ? 'Login' : 'Initializing',
            onPressed: _isClientReady ? _toggleLogin : null,
          ),
        if (_isLogin && _token.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: _renewToken,
              child: Text('Renew Token', style: textStyle),
            ),
          ),
      ],
    );
  }

  Widget _buildQueryOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return _buildTextFieldAction(
      controller: _peerUserIdController,
      hintText: 'Input peer user id',
      actionText: 'Query Online',
      onPressed: _toggleQueryPeersOnlineStatus,
    );
  }

  Widget _buildSubscribeOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Wrap(spacing: 8, runSpacing: 4, children: <Widget>[
      OutlinedButton(
        onPressed: _subscribePeersOnlineStatus,
        child: Text('Subscribe Online', style: textStyle),
      ),
      OutlinedButton(
        onPressed: _unsubscribePeersOnlineStatus,
        child: Text('Unsubscribe Online', style: textStyle),
      )
    ]);
  }

  Widget _buildSendPeerMessage() {
    if (!_isLogin) {
      return Container();
    }
    return _buildTextFieldAction(
      controller: _peerMessageController,
      hintText: 'Input peer message',
      actionText: 'Send to Peer',
      onPressed: _sendPeerMessage,
    );
  }

  Widget _buildUserAttributes() {
    if (!_isLogin) {
      return Container();
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _attributeKeyController,
                decoration: const InputDecoration(hintText: 'Attribute key'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _attributeValueController,
                decoration: const InputDecoration(hintText: 'Attribute value'),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            OutlinedButton(
              onPressed: _setUserAttributes,
              child: Text('Set User Attr', style: textStyle),
            ),
            OutlinedButton(
              onPressed: _addOrUpdateUserAttributes,
              child: Text('Update User Attr', style: textStyle),
            ),
            OutlinedButton(
              onPressed: _deleteUserAttributes,
              child: Text('Delete User Attr', style: textStyle),
            ),
            OutlinedButton(
              onPressed: _clearUserAttributes,
              child: Text('Clear User Attr', style: textStyle),
            ),
            OutlinedButton(
              onPressed: _getUserAttributes,
              child: Text('Get User Attrs', style: textStyle),
            ),
            OutlinedButton(
              onPressed: _getUserAttributesByKeys,
              child: Text('Get User Attr', style: textStyle),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocalInvitation() {
    if (!_isLogin) {
      return Container();
    }
    return _buildTextFieldAction(
      controller: _invitationController,
      hintText: 'Input invitation content',
      actionText:
          '${_localInvitation == null ? 'Send' : 'Cancel'} local invitation',
      onPressed: _toggleLocalInvitation,
    );
  }

  Widget _buildRemoteInvitation() {
    if (!_isLogin || _remoteInvitation == null) {
      return Container();
    }
    return Wrap(spacing: 8, runSpacing: 4, children: <Widget>[
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
    if (_isInChannel) {
      return Row(children: <Widget>[
        Expanded(
            child: Text('Channel: ${_channelNameController.text}',
                style: textStyle)),
        OutlinedButton(
          onPressed: _toggleJoinChannel,
          child: Text('Leave Channel', style: textStyle),
        )
      ]);
    }
    return _buildTextFieldAction(
      controller: _channelNameController,
      hintText: 'Input channel id',
      actionText: 'Join Channel',
      onPressed: _toggleJoinChannel,
    );
  }

  Widget _buildChannelAttributes() {
    if (!_isLogin) {
      return Container();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        OutlinedButton(
          onPressed: _setChannelAttributes,
          child: Text('Set Channel Attr', style: textStyle),
        ),
        OutlinedButton(
          onPressed: _addOrUpdateChannelAttributes,
          child: Text('Update Channel Attr', style: textStyle),
        ),
        OutlinedButton(
          onPressed: _deleteChannelAttributes,
          child: Text('Delete Channel Attr', style: textStyle),
        ),
        OutlinedButton(
          onPressed: _clearChannelAttributes,
          child: Text('Clear Channel Attr', style: textStyle),
        ),
        OutlinedButton(
          onPressed: _getChannelAttributes,
          child: Text('Get Channel Attrs', style: textStyle),
        ),
        OutlinedButton(
          onPressed: _getChannelAttributesByKeys,
          child: Text('Get Channel Attr', style: textStyle),
        ),
      ],
    );
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return _buildTextFieldAction(
      controller: _channelMessageController,
      hintText: 'Input channel message',
      actionText: 'Send to Channel',
      onPressed: _sendChannelMessage,
    );
  }

  Widget _buildGetMembers() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Wrap(spacing: 8, runSpacing: 4, children: <Widget>[
      OutlinedButton(
        onPressed: _getMembers,
        child: Text('Get Members in Channel', style: textStyle),
      ),
      OutlinedButton(
        onPressed: _getMemberCount,
        child: Text('Get Member count in Channel', style: textStyle),
      )
    ]);
  }

  Widget _buildInfoList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(_infoStrings[i]),
          );
        },
        itemCount: _infoStrings.length,
      ),
    );
  }

  Future<void> _handleConnectionAborted() async {
    try {
      await _leaveAndReleaseChannel();
    } catch (errorCode) {
      _log('Leave channel error: $errorCode');
    }
    try {
      await _client?.logout();
    } catch (errorCode) {
      _log('Logout error: $errorCode');
    } finally {
      _updateState(() {
        _isLogin = false;
      });
    }
  }

  Future<void> _renewToken() async {
    final client = _client;
    if (client == null || !_isClientReady) {
      _log('Client is not ready');
      return;
    }
    if (_token.isEmpty) {
      _log('TEST_TOKEN is empty');
      return;
    }
    try {
      const token = _token;
      await client.renewToken(token);
      _log('Renew token success');
    } catch (errorCode) {
      _log('Renew token error: $errorCode');
    }
  }

  Future<void> _toggleLogin() async {
    final client = _client;
    if (client == null || !_isClientReady) {
      _log('Client is not ready');
      return;
    }

    if (_isLogin) {
      try {
        await _leaveAndReleaseChannel();
      } catch (errorCode) {
        _log('Leave channel error: $errorCode');
      }
      try {
        await client.logout();
        _log('Logout success');

        _updateState(() {
          _isLogin = false;
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
        final String? token = _token.isEmpty ? null : _token;
        await client.login(token, userId);
        _log('Login success: $userId');
        _updateState(() {
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
        await _client?.sendMessageToPeer2(
          peerUid,
          message,
          SendMessageOptions(),
        );
        _log('Send peer message success');
      }
    } catch (errorCode) {
      _log('Send peer message error: $errorCode');
    }
  }

  RtmAttribute? _userAttribute() {
    final key = _attributeKeyController.text.trim();
    final value = _attributeValueController.text;
    if (key.isEmpty) {
      _log('Please input an attribute key');
      return null;
    }
    if (value.isEmpty) {
      _log('Please input an attribute value');
      return null;
    }
    return RtmAttribute(key, value);
  }

  RtmChannelAttribute? _channelAttribute() {
    final attribute = _userAttribute();
    if (attribute == null) {
      return null;
    }
    return RtmChannelAttribute(attribute.key, attribute.value);
  }

  String? _attributeKey() {
    final key = _attributeKeyController.text.trim();
    if (key.isEmpty) {
      _log('Please input an attribute key');
      return null;
    }
    return key;
  }

  String? _attributeUserId() {
    final peerId = _peerUserIdController.text.trim();
    final userId = peerId.isEmpty ? _userNameController.text.trim() : peerId;
    if (userId.isEmpty) {
      _log('Please input a user id');
      return null;
    }
    return userId;
  }

  String? _attributeChannelId() {
    final channelId = _channelNameController.text.trim();
    if (channelId.isEmpty) {
      _log('Please input a channel id');
      return null;
    }
    return channelId;
  }

  Future<void> _runClientOperation(
    String name,
    Future<dynamic> Function(AgoraRtmClient client) operation,
  ) async {
    final client = _client;
    if (client == null || !_isClientReady) {
      _log('Client is not ready');
      return;
    }
    try {
      final result = await operation(client);
      _log(result == null ? '$name success' : '$name: $result');
    } catch (errorCode) {
      _log('$name error: $errorCode');
    }
  }

  void _setUserAttributes() {
    final attribute = _userAttribute();
    if (attribute == null) {
      return;
    }
    _runClientOperation(
      'Set user attributes',
      (client) => client.setLocalUserAttributes2([attribute]),
    );
  }

  void _addOrUpdateUserAttributes() {
    final attribute = _userAttribute();
    if (attribute == null) {
      return;
    }
    _runClientOperation(
      'Update user attributes',
      (client) => client.addOrUpdateLocalUserAttributes2([attribute]),
    );
  }

  void _deleteUserAttributes() {
    final key = _attributeKey();
    if (key == null) {
      return;
    }
    _runClientOperation(
      'Delete user attributes',
      (client) => client.deleteLocalUserAttributesByKeys([key]),
    );
  }

  void _clearUserAttributes() {
    _runClientOperation(
      'Clear user attributes',
      (client) => client.clearLocalUserAttributes(),
    );
  }

  void _getUserAttributes() {
    final userId = _attributeUserId();
    if (userId == null) {
      return;
    }
    _runClientOperation(
      'Get user attributes',
      (client) => client.getUserAttributes2(userId),
    );
  }

  void _getUserAttributesByKeys() {
    final userId = _attributeUserId();
    final key = _attributeKey();
    if (userId == null || key == null) {
      return;
    }
    _runClientOperation(
      'Get user attributes by key',
      (client) => client.getUserAttributesByKeys2(userId, [key]),
    );
  }

  ChannelAttributeOptions _channelAttributeOptions() {
    return ChannelAttributeOptions(true);
  }

  void _setChannelAttributes() {
    final channelId = _attributeChannelId();
    final attribute = _channelAttribute();
    if (channelId == null || attribute == null) {
      return;
    }
    _runClientOperation(
      'Set channel attributes',
      (client) => client.setChannelAttributes2(
        channelId,
        [attribute],
        _channelAttributeOptions(),
      ),
    );
  }

  void _addOrUpdateChannelAttributes() {
    final channelId = _attributeChannelId();
    final attribute = _channelAttribute();
    if (channelId == null || attribute == null) {
      return;
    }
    _runClientOperation(
      'Update channel attributes',
      (client) => client.addOrUpdateChannelAttributes2(
        channelId,
        [attribute],
        _channelAttributeOptions(),
      ),
    );
  }

  void _deleteChannelAttributes() {
    final channelId = _attributeChannelId();
    final key = _attributeKey();
    if (channelId == null || key == null) {
      return;
    }
    _runClientOperation(
      'Delete channel attributes',
      (client) => client.deleteChannelAttributesByKeys2(
        channelId,
        [key],
        _channelAttributeOptions(),
      ),
    );
  }

  void _clearChannelAttributes() {
    final channelId = _attributeChannelId();
    if (channelId == null) {
      return;
    }
    _runClientOperation(
      'Clear channel attributes',
      (client) => client.clearChannelAttributes2(
        channelId,
        _channelAttributeOptions(),
      ),
    );
  }

  void _getChannelAttributes() {
    final channelId = _attributeChannelId();
    if (channelId == null) {
      return;
    }
    _runClientOperation(
      'Get channel attributes',
      (client) => client.getChannelAttributes(channelId),
    );
  }

  void _getChannelAttributesByKeys() {
    final channelId = _attributeChannelId();
    final key = _attributeKey();
    if (channelId == null || key == null) {
      return;
    }
    _runClientOperation(
      'Get channel attributes by key',
      (client) => client.getChannelAttributesByKeys(channelId, [key]),
    );
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
          _updateState(() {
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

  Future<void> _leaveAndReleaseChannel() async {
    final channel = _channel;
    _channel = null;
    if (channel == null) {
      _updateState(() {
        _isInChannel = false;
      });
      return;
    }

    try {
      if (_isInChannel) {
        await channel.leave();
      }
    } finally {
      try {
        await channel.release();
      } finally {
        if (mounted) {
          _channelMessageController.clear();
        }
        _updateState(() {
          _isInChannel = false;
        });
      }
    }
  }

  Future<void> _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _leaveAndReleaseChannel();
        _log('Leave channel success');
      } catch (errorCode) {
        _log('Leave channel error: $errorCode');
      }
    } else {
      String channelId = _channelNameController.text;
      if (channelId.isEmpty) {
        _log('Please input channel id to join');
        return;
      }

      AgoraRtmChannel? channel;
      try {
        channel = await _createChannel(channelId);
        if (channel == null) {
          throw StateError('Client is not ready');
        }
        await channel.join();
        _channel = channel;
        _log(
          'Join channel success: ${channel.getId()}, channelId: ${channel.channelId}',
        );

        _updateState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        if (channel != null) {
          try {
            await channel.release();
          } catch (releaseError) {
            _log('Release channel error: $releaseError');
          }
        }
        _channel = null;
        _updateState(() {
          _isInChannel = false;
        });
        _log('Join channel error: $errorCode');
      }
    }
  }

  void _getMembers() async {
    try {
      List<RtmChannelMember>? members = await _channel?.getMembers();
      _log('Members: ${members?.map((m) => m.toJson()).toList()}');
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
      List<RtmChannelMemberCount>? members =
          await _client?.getChannelMemberCount([channelId]);
      _log('Member count: ${members?.map((m) => m.toJson()).toList()}');
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

    final client = _client;
    final channel = _channel;
    if (client == null || channel == null) {
      _log('Client or channel is not ready');
      return;
    }

    try {
      final message = client.createRawMessage(
        Uint8List.fromList(utf8.encode(text)),
        text,
      );
      _log(message.text);
      await channel.sendMessage2(message, SendMessageOptions());
      _log('Send channel message success');
    } catch (errorCode) {
      _log('Send channel message error: $errorCode');
    }
  }

  void _updateState(VoidCallback update) {
    if (!mounted) {
      return;
    }
    setState(update);
  }

  void _log(String info) {
    debugPrint(info);
    _updateState(() {
      _infoStrings.insert(0, info);
    });
  }
}
