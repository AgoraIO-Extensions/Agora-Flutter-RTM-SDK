import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm_example/src/log_sink.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtm_example/src/internal/internal_config.dart' as config;

/// publishTextMessage & publishBinaryMessage Usage Example
class StreamChannelDemo extends StatefulWidget {
  final String? userId;
  final String? channelName;
  const StreamChannelDemo({Key? key, this.userId, this.channelName})
      : super(key: key);

  @override
  State<StreamChannelDemo> createState() => _StreamChannelDemoState();
}

class _StreamChannelDemoState extends State<StreamChannelDemo> {
  late RtmClient _rtmClient;
  StreamChannel? _streamChannel;

  // Controllers
  final _userIdController = TextEditingController(text: 'test_userId');
  final _channelNameController = TextEditingController(text: 'test_channel');
  final _topicController = TextEditingController(text: 'test_topic');
  final _messageController = TextEditingController(text: 'Hello RTM!');
  final _customTypeController = TextEditingController(text: 'chat');
  final _binaryDataController =
      TextEditingController(text: 'Binary message content');
  final _subscribeUserIdsController = TextEditingController();

  // State variables
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _isChannelJoined = false;
  bool _isTopicJoined = false;
  bool _isTopicSubscribed = false;
  bool _ispPolicyEnabled = false;

  bool _isSubscribeWithMetadata = false;
  bool _isSubscribeWithPresence = true;
  bool _isSubscribeWithLock = false;
  bool _isSubscribeBeQuiet = false;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      _userIdController.text = widget.userId!;
    }
    if (widget.channelName != null && widget.channelName!.isNotEmpty) {
      _channelNameController.text = widget.channelName!;
    }
  }

  @override
  void dispose() {
    _cleanup();
    _userIdController.dispose();
    _channelNameController.dispose();
    _topicController.dispose();
    _messageController.dispose();
    _customTypeController.dispose();
    _binaryDataController.dispose();
    _subscribeUserIdsController.dispose();
    super.dispose();
  }

  /// Initialize RTM Client
  Future<void> _initializeRtm() async {
    try {
      // Create RTM client with proper initialization

      final userId = _userIdController.text.trim();

      final (status, client) = _ispPolicyEnabled
          ? await RTM(config.appId, _userIdController.text,
              config: RtmConfig(
                ispPolicyEnabled: _ispPolicyEnabled,
              ))
          : await RTM(config.appId, userId);
      if (status.error) {
        _addLog(
            '[error] errorCode: ${status.errorCode}, operation: ${status.operation}, reason: ${status.reason}');
        return;
      }
      _rtmClient = client;

      _addLog('create RTM success.');
      _rtmClient.addListener(
        linkState: (event) {
          _addLog('[linkState] ${event.toJson()}');
        },
        message: (event) {
          _addLog('[message] event: ${event.toJson()}');
        },
        presence: (event) {
          _addLog('[presence] event: ${event.toJson()}');
        },
        topic: (event) {
          _addLog('[topic] event: ${event.toJson()}');
        },
        lock: (event) {
          _addLog('[lock] event: ${event.toJson()}');
        },
        storage: (event) {
          _addLog('[storage] event: ${event.toJson()}');
        },
        token: (event) {
          _addLog('[token] event: ${event.toJson()}');
        },
      );
      await _rtmClient.setParameters('{"rtm.log_filter":2063}');

      if (status.error) {
        _addLog('RTM initialization failed: ${status.reason}');
        return;
      }

      _rtmClient = client;
      _addLog('RTM initialization success. userId: $userId');
      setState(() {
        _isInitialized = true;
      });
      // Listen for message events
      // _rtmClient.addListener(
      //   message: (event) {
      //     // Handle text and binary messages
      //     if (event.message != null) {
      //       try {
      //         // Try to decode as text message
      //         final textMessage = utf8.decode(event.message!);
      //         _addLog('📥 Received text message: $textMessage');
      //         _addLog('   - From: ${event.publisher}');
      //         _addLog('   - Channel: ${event.channelName}');
      //         _addLog('   - Topic: ${event.channelTopic}');
      //         if (event.customType != null) {
      //           _addLog('   - Custom type: ${event.customType}');
      //         }
      //       } catch (e) {
      //         // If cannot decode as text, handle as binary message
      //         final binaryData = event.message!;
      //         _addLog('📥 Received binary message:');
      //         _addLog('   - From: ${event.publisher}');
      //         _addLog('   - Channel: ${event.channelName}');
      //         _addLog('   - Topic: ${event.channelTopic}');
      //         _addLog('   - Data length: ${binaryData.length} bytes');

      //         if (event.customType != null) {
      //           _addLog('   - Custom type: ${event.customType}');

      //           // Try to parse binary data based on custom type
      //           _parseBinaryMessage(binaryData, event.customType!);
      //         } else {
      //           // Show hex representation of binary data (first 32 bytes)
      //           final hexData = binaryData
      //               .take(32)
      //               .map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}')
      //               .join(' ');
      //           _addLog(
      //               '   - Data preview: $hexData${binaryData.length > 32 ? '...' : ''}');
      //         }
      //       }
      //     } else {
      //       _addLog('📥 Received empty message (from: ${event.publisher})');
      //     }
      //   },
      // );
    } catch (e) {
      _addLog('RTM initialization failed: $e');
    }
  }

  Future<void> _login() async {
    if (!_isInitialized) return;
    final (status, _) = await _rtmClient.login(config.token);
    if (status.error) {
      _addLog('RTM login failed: ${status.reason}');
      return;
    }
    setState(() {
      _isLoggedIn = true;
    });
    _addLog('RTM login success. userId: ${_userIdController.text.trim()}');
  }

  /// Create Stream Channel
  Future<void> _createStreamChannel() async {
    if (!_isInitialized || !_isLoggedIn) return;

    try {
      final channelName = _channelNameController.text.trim();
      if (channelName.isEmpty) {
        _addLog('Please enter channel name');
        return;
      }

      final (status, streamChannel) =
          await _rtmClient.createStreamChannel(channelName);

      if (status.error) {
        _addLog('Failed to create StreamChannel: ${status.reason}');
        return;
      }

      _streamChannel = streamChannel;
      _addLog('StreamChannel created successfully: $channelName');
    } catch (e) {
      _addLog('StreamChannel creation error: $e');
    }
  }

  /// Join Channel
  Future<void> _joinChannel() async {
    if (_streamChannel == null || !_isLoggedIn) return;

    try {
      // _addLog('Joining channel, using token: ${config.token.substring(0, 20)}...');
      final (status, result) = await _streamChannel!.join(
          token: config.token,
          withMetadata: _isSubscribeWithMetadata,
          withPresence: _isSubscribeWithPresence,
          withLock: _isSubscribeWithLock,
          beQuiet: _isSubscribeBeQuiet);

      if (status.error) {
        _addLog(
            'Failed to join channel: ${status.reason} (Error code: ${status.errorCode})');
        _addLog(
            'Please check: 1) Token expiration 2) App ID validity 3) Network connection');

        // If token issue, suggest token regeneration
        if (status.reason.contains('token') ||
            status.reason.contains('Token')) {
          _addLog('Suggestion: Please follow these steps to get new token:');
          _addLog('1. Visit https://console.agora.io/');
          _addLog('2. Go to Project -> RTM Service');
          _addLog('3. Click "Generate Temp Token"');
          _addLog('4. Replace new token in internal_config.dart file');
          _addLog(
              'Or use environment variable: flutter run --dart-define=TEST_RTM_TOKEN=your_new_token');
        }
        return;
      }

      setState(() {
        _isChannelJoined = true;
      });
      _addLog(
          'Successfully joined channel ${_channelNameController.text.trim()}');
    } catch (e) {
      _addLog('Join channel error: $e');
      _addLog('Error type: ${e.runtimeType}');
    }
  }

  /// Join Topic
  Future<void> _joinTopic() async {
    if (_streamChannel == null || !_isChannelJoined || !_isLoggedIn) return;

    try {
      final topic = _topicController.text.trim();
      if (topic.isEmpty) {
        _addLog('Please enter topic name');
        return;
      }

      final (status, result) = await _streamChannel!.joinTopic(topic);

      if (status.error) {
        _addLog('Failed to join topic: ${status.reason}');
        return;
      }

      setState(() {
        _isTopicJoined = true;
      });
      _addLog(
          'Successfully joined topic: $topic ${_channelNameController.text.trim()}');
    } catch (e) {
      _addLog('Join topic error: $e');
    }
  }

  /// Send Basic Text Message
  Future<void> _sendBasicTextMessage() async {
    if (_streamChannel == null || !_isTopicJoined || !_isLoggedIn) return;

    try {
      final topic = _topicController.text.trim();
      final message = _messageController.text.trim();

      if (topic.isEmpty || message.isEmpty) {
        _addLog('Please enter topic and message content');
        return;
      }

      final (status, result) = await _streamChannel!.publishTextMessage(
        topic,
        message,
      );

      if (status.error) {
        _addLog('Failed to send message: ${status.reason}');
        return;
      }

      _addLog('✅ Basic text message sent successfully');
      _addLog(
          '   - Channel: ${result?.channelName} ${_channelNameController.text.trim()} ${_topicController.text.trim()} ${_messageController.text.trim()} ${_customTypeController.text.trim()}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Message: $message');
    } catch (e) {
      _addLog('Send message error: $e');
    }
  }

  /// Send Basic Binary Message
  Future<void> _sendBasicBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined || !_isLoggedIn) return;

    try {
      final topic = _topicController.text.trim();
      final message = _binaryDataController.text.trim();

      if (topic.isEmpty || message.isEmpty) {
        _addLog('Please enter topic and binary message content');
        return;
      }

      // Convert string to Uint8List
      final binaryData = Uint8List.fromList(utf8.encode(message));

      final (status, result) = await _streamChannel!.publishBinaryMessage(
        topic,
        binaryData,
      );

      if (status.error) {
        _addLog('Failed to send binary message: ${status.reason}');
        return;
      }

      _addLog('✅ Basic binary message sent successfully');
      _addLog(
          '   - Channel: ${result?.channelName} ${_channelNameController.text.trim()} ${_topicController.text.trim()} ${_messageController.text.trim()} ${_binaryDataController.text.trim()} ${_customTypeController.text.trim()}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Original content: $message');
      _addLog('   - Binary length: ${binaryData.length} bytes');
    } catch (e) {
      _addLog('Send binary message error: $e');
    }
  }

  /// Subscribe Topic
  Future<void> _subscribeToTopic() async {
    if (_streamChannel == null || !_isTopicJoined || !_isLoggedIn) return;

    try {
      final topic = _topicController.text.trim();
      final userIdsText = _subscribeUserIdsController.text.trim();

      if (topic.isEmpty) {
        _addLog('Please enter topic name');
        return;
      }

      // Parse user IDs from comma-separated string
      List<String> userIds = [];
      if (userIdsText.isNotEmpty) {
        userIds = userIdsText
            .split(',')
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();
      }

      final (status, result) = await _streamChannel!.subscribeTopic(
        topic,
        users: userIds,
      );

      if (status.error) {
        _addLog('Failed to subscribe topic: ${status.reason}');
        return;
      }

      setState(() {
        _isTopicSubscribed = true;
      });

      _addLog('✅ Topic subscribed successfully');
      _addLog('   - Channel: ${result?.channelName}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Subscribe user count: ${userIds.length}');
      if (userIds.isNotEmpty) {
        _addLog('   - Subscribe user list: ${userIds.join(', ')}');
      } else {
        _addLog('   - Subscribe to all users messages');
      }
      if (result != null) {
        if (result.succeedUsers.isNotEmpty) {
          _addLog(
              '   - Successfully subscribed users: ${result.succeedUsers.join(', ')}');
        }
        if (result.failedUsers.isNotEmpty) {
          _addLog(
              '   - Failed to subscribe users: ${result.failedUsers.join(', ')}');
        }
      }
    } catch (e) {
      _addLog('Subscribe topic error: $e');
    }
  }

  /// Unsubscribe Topic
  Future<void> _unsubscribeFromTopic() async {
    if (_streamChannel == null || !_isTopicJoined || !_isLoggedIn) return;

    try {
      final topic = _topicController.text.trim();
      final userIdsText = _subscribeUserIdsController.text.trim();

      if (topic.isEmpty) {
        _addLog('Please enter topic name');
        return;
      }

      // Parse user IDs from comma-separated string
      List<String> userIds = [];
      if (userIdsText.isNotEmpty) {
        userIds = userIdsText
            .split(',')
            .map((id) => id.trim())
            .where((id) => id.isNotEmpty)
            .toList();
      }

      final (status, result) = await _streamChannel!.unsubscribeTopic(
        topic,
        users: userIds,
      );

      if (status.error) {
        _addLog('Failed to unsubscribe topic: ${status.reason}');
        return;
      }

      setState(() {
        _isTopicSubscribed = false;
      });

      _addLog('✅ Topic unsubscribed successfully');
      _addLog('   - Channel: ${result?.channelName}');
      _addLog('   - Topic: ${result?.topic}');
      if (userIds.isNotEmpty) {
        _addLog('   - Unsubscribed users: ${userIds.join(', ')}');
      } else {
        _addLog('   - Unsubscribed from all users messages');
      }
    } catch (e) {
      _addLog('Unsubscribe topic error: $e');
    }
  }

  /// Cleanup Resources
  Future<void> _cleanup() async {
    try {
      if (_streamChannel != null) {
        await _streamChannel!.release();
      }
      await _rtmClient.release();
    } catch (e) {
      _addLog('Cleanup error: $e');
    }
  }

  /// Add Log
  void _addLog(String log) {
    String logs = '';
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      logs += '[$timestamp] $log\n';
    });
    logSink.log(logs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Channel Example'),
        actions: const [LogActionWidget()],
      ),
      body: Column(
        children: [
          // Upper part: scrollable content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Configuration area
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Configuration Parameters',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _userIdController,
                            decoration: const InputDecoration(
                              labelText: 'user Id',
                              hintText: 'Please enter user id',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _channelNameController,
                            decoration: const InputDecoration(
                              labelText: 'Channel Name',
                              hintText: 'Please enter channel name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _topicController,
                            decoration: const InputDecoration(
                              labelText: 'Topic Name',
                              hintText: 'Please enter topic name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Operation buttons area
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Operation Steps',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _switch('ispPolicyEnabled', _ispPolicyEnabled, (v) {
                            setState(() {
                              _ispPolicyEnabled = v;
                            });
                          }),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isInitialized ? null : _initializeRtm,
                              child: const Text('1. create RTM'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isInitialized && !_isLoggedIn
                                  ? _login
                                  : null,
                              child: const Text('2. Login'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isInitialized && _isLoggedIn
                                  ? () async {
                                      final (status, _) =
                                          await _rtmClient.logout();
                                      _addLog(
                                          '[LogoutResult] errorCode: ${status.errorCode}');
                                      setState(() {
                                        _isLoggedIn = false;
                                      });
                                    }
                                  : null,
                              child: const Text('Logout'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isInitialized &&
                                      _isLoggedIn &&
                                      _streamChannel == null
                                  ? _createStreamChannel
                                  : null,
                              child: const Text('3. Create StreamChannel'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            children: [
                              _switch('withMetadata', _isSubscribeWithMetadata,
                                  (v) {
                                setState(() {
                                  _isSubscribeWithMetadata = v;
                                });
                              }),
                              _switch('withPresence', _isSubscribeWithPresence,
                                  (v) {
                                setState(() {
                                  _isSubscribeWithPresence = v;
                                });
                              }),
                              _switch('withLock', _isSubscribeWithLock, (v) {
                                setState(() {
                                  _isSubscribeWithLock = v;
                                });
                              }),
                              _switch('beQuiet', _isSubscribeBeQuiet, (v) {
                                setState(() {
                                  _isSubscribeBeQuiet = v;
                                });
                              }),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _streamChannel != null &&
                                      _isLoggedIn &&
                                      !_isChannelJoined
                                  ? _joinChannel
                                  : null,
                              child: const Text('4. Join Channel'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChannelJoined &&
                                      _isLoggedIn &&
                                      !_isTopicJoined
                                  ? _joinTopic
                                  : null,
                              child: const Text('5. Join Topic'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _subscribeUserIdsController,
                            decoration: const InputDecoration(
                              labelText: 'Subscribe User IDs',
                              hintText:
                                  'Enter user IDs separated by commas, e.g.: user1,user2,user3',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isTopicJoined &&
                                      _isLoggedIn &&
                                      !_isTopicSubscribed
                                  ? _subscribeToTopic
                                  : null,
                              child: const Text('6. Subscribe Topic'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isTopicJoined &&
                                      _isLoggedIn &&
                                      _isTopicSubscribed
                                  ? _unsubscribeFromTopic
                                  : null,
                              child: const Text('Unsubscribe Topic'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _customTypeController,
                            decoration: const InputDecoration(
                              labelText: 'Custom Type (Optional)',
                              hintText: 'e.g.: chat, notification, system',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              labelText: 'Message Content',
                              hintText: 'Please enter message to send',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _binaryDataController,
                            decoration: const InputDecoration(
                              labelText: 'Binary Message Content',
                              hintText: 'For binary message sending test',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isTopicJoined &&
                                    _isLoggedIn &&
                                    _streamChannel != null &&
                                    _isChannelJoined
                                ? _sendBasicTextMessage
                                : null,
                            child: const Text('7. Send Basic Message'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _isTopicJoined &&
                                    _isLoggedIn &&
                                    _streamChannel != null &&
                                    _isChannelJoined
                                ? _sendBasicBinaryMessage
                                : null,
                            child: const Text('8. Send Basic Binary Message'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Status indicators
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatusIndicator('RTM Initialized', _isInitialized),
              _buildStatusIndicator('Logged In', _isLoggedIn),
              _buildStatusIndicator(
                  'StreamChannel Created', _streamChannel != null),
              _buildStatusIndicator('Channel Joined', _isChannelJoined),
              _buildStatusIndicator('Topic Joined', _isTopicJoined),
              _buildStatusIndicator('Topic Subscribed', _isTopicSubscribed),
            ],
          ),

          // Lower part: fixed height log display area
          // Container(
          //   height: 200, // Fixed height
          //   child: Card(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Padding(
          //           padding: EdgeInsets.all(16.0),
          //           child: Text(
          //             'Runtime Logs',
          //             style:
          //                 TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //           ),
          //         ),
          //         Expanded(
          //           child: Container(
          //             padding: const EdgeInsets.all(16.0),
          //             child: SingleChildScrollView(
          //               child: Text(
          //                 _logs.isEmpty ? 'No logs yet...' : _logs,
          //                 style: const TextStyle(
          //                   fontFamily: 'monospace',
          //                   fontSize: 12,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Build Status Indicator
  Widget _buildStatusIndicator(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _switch(String title, bool value, ValueChanged<bool> callback) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$title: '),
          Switch(
            value: value,
            onChanged: callback,
          )
        ]);
  }

  Widget _button(String text, Future<void> Function() call) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          child: Text(text),
          onPressed: () {
            _logCall(text, call);
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void _logCall(String func, Future<void> Function() call) async {
    void log_(String log) {
      debugPrint(log);
      logSink.log(log);
    }

    log_(func);
    try {
      await call();
    } catch (e) {
      final log = '[$func] error:\n $e';
      log_(log);
    }
  }
}
