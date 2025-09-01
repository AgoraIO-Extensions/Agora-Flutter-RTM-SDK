import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm_example/src/log_sink.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtm_example/src/internal/internal_config.dart' as config;

/// publishTextMessage & publishBinaryMessage Usage Example
class PublishTextMessageDemo extends StatefulWidget {
  const PublishTextMessageDemo({Key? key}) : super(key: key);

  @override
  State<PublishTextMessageDemo> createState() => _PublishTextMessageDemoState();
}

class _PublishTextMessageDemoState extends State<PublishTextMessageDemo> {
  late final RtmClient _rtmClient;
  StreamChannel? _streamChannel;

  // Controllers
  final _channelNameController = TextEditingController(text: 'test_channel');
  final _topicController = TextEditingController(text: 'test_topic');
  final _messageController = TextEditingController(text: 'Hello RTM!');
  final _customTypeController = TextEditingController(text: 'chat');
  final _binaryDataController =
      TextEditingController(text: 'Binary message content');

  // State variables
  bool _isInitialized = false;
  bool _isChannelJoined = false;
  bool _isTopicJoined = false;
  String _logs = '';

  @override
  void initState() {
    super.initState();
    _initializeRtm();
  }

  @override
  void dispose() {
    _cleanup();
    _channelNameController.dispose();
    _topicController.dispose();
    _messageController.dispose();
    _customTypeController.dispose();
    _binaryDataController.dispose();
    super.dispose();
  }

  /// Initialize RTM Client
  Future<void> _initializeRtm() async {
    try {
      final userId = 'test_user';

      // Create RTM client with proper initialization
      final (status, client) = await RTM(config.appId, userId);

      if (status.error) {
        _addLog('RTM initialization failed: ${status.reason}');
        return;
      }

      _rtmClient = client;

      // Listen for message events
      _rtmClient.addListener(
        message: (event) {
          // Handle text and binary messages
          if (event.message != null) {
            try {
              // Try to decode as text message
              final textMessage = utf8.decode(event.message!);
              _addLog('📥 Received text message: $textMessage');
              _addLog('   - From: ${event.publisher}');
              _addLog('   - Channel: ${event.channelName}');
              _addLog('   - Topic: ${event.channelTopic}');
              if (event.customType != null) {
                _addLog('   - Custom type: ${event.customType}');
              }
            } catch (e) {
              // If cannot decode as text, handle as binary message
              final binaryData = event.message!;
              _addLog('📥 Received binary message:');
              _addLog('   - From: ${event.publisher}');
              _addLog('   - Channel: ${event.channelName}');
              _addLog('   - Topic: ${event.channelTopic}');
              _addLog('   - Data length: ${binaryData.length} bytes');

              if (event.customType != null) {
                _addLog('   - Custom type: ${event.customType}');

                // Try to parse binary data based on custom type
                _parseBinaryMessage(binaryData, event.customType!);
              } else {
                // Show hex representation of binary data (first 32 bytes)
                final hexData = binaryData
                    .take(32)
                    .map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}')
                    .join(' ');
                _addLog(
                    '   - Data preview: $hexData${binaryData.length > 32 ? '...' : ''}');
              }
            }
          } else {
            _addLog('📥 Received empty message (from: ${event.publisher})');
          }
        },
      );

      // Login
      final (loginStatus, _) = await _rtmClient.login(config.token);
      if (loginStatus.error) {
        _addLog('RTM login failed: ${loginStatus.reason}');
        return;
      }

      setState(() {
        _isInitialized = true;
      });
      _addLog('RTM client initialized successfully (UserID: $userId)');
    } catch (e) {
      _addLog('RTM initialization failed: $e');
    }
  }

  /// Create Stream Channel
  Future<void> _createStreamChannel() async {
    if (!_isInitialized) return;

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
    if (_streamChannel == null) return;

    try {
      // _addLog('Joining channel, using token: ${config.token.substring(0, 20)}...');
      final (status, result) = await _streamChannel!.join();

      if (status.error) {
        _addLog('Failed to join channel: ${status.reason} (Error code: ${status.errorCode})');
        _addLog('Please check: 1) Token expiration 2) App ID validity 3) Network connection');

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
      _addLog('Successfully joined channel');
    } catch (e) {
      _addLog('Join channel error: $e');
      _addLog('Error type: ${e.runtimeType}');
    }
  }

  /// Join Topic
  Future<void> _joinTopic() async {
    if (_streamChannel == null || !_isChannelJoined) return;

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
      _addLog('Successfully joined topic: $topic');
    } catch (e) {
      _addLog('Join topic error: $e');
    }
  }
  /// Send Basic Text Message
  Future<void> _sendBasicTextMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

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
      _addLog('   - Channel: ${result?.channelName}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Message: $message');
    } catch (e) {
      _addLog('Send message error: $e');
    }
  }

  /// Send Timestamped Text Message
  Future<void> _sendTimestampedTextMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();
      final message = _messageController.text.trim();
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      final (status, result) = await _streamChannel!.publishTextMessage(
        topic,
        message,
        sendTs: currentTimestamp, // Set send timestamp
      );

      if (status.error) {
        _addLog('Failed to send timestamped message: ${status.reason}');
        return;
      }

      _addLog('✅ Timestamped message sent successfully');
      _addLog('   - Timestamp: $currentTimestamp');
      _addLog('   - Message: $message');
    } catch (e) {
      _addLog('Send timestamped message error: $e');
    }
  }

  /// Send Custom Type Text Message
  Future<void> _sendCustomTypeTextMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();
      final message = _messageController.text.trim();
      final customType = _customTypeController.text.trim();

      final (status, result) = await _streamChannel!.publishTextMessage(
        topic,
        message,
        customType: customType.isEmpty ? null : customType, // Set custom type
      );

      if (status.error) {
        _addLog('Failed to send custom type message: ${status.reason}');
        return;
      }

      _addLog('✅ Custom type message sent successfully');
      _addLog('   - Custom type: $customType');
      _addLog('   - Message: $message');
    } catch (e) {
      _addLog('Send custom type message error: $e');
    }
  }

  /// Send Full Parameter Text Message
  Future<void> _sendFullParameterTextMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();
      final message = _messageController.text.trim();
      final customType = _customTypeController.text.trim();
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      final (status, result) = await _streamChannel!.publishTextMessage(
        topic,
        message,
        sendTs: currentTimestamp, // Send timestamp
        customType: customType.isEmpty ? null : customType, // Custom type
      );

      if (status.error) {
        _addLog('Failed to send full parameter message: ${status.reason}');
        return;
      }

      _addLog('✅ Full parameter message sent successfully');
      _addLog('   - Channel: ${result?.channelName}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Message: $message');
      _addLog('   - Timestamp: $currentTimestamp');
      _addLog('   - Custom type: $customType');
    } catch (e) {
      _addLog('Send full parameter message error: $e');
    }
  }

  /// Send Batch Test Messages
  Future<void> _sendBatchMessages() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    final topic = _topicController.text.trim();
    _addLog('Starting batch test messages...');

    for (int i = 1; i <= 5; i++) {
      try {
        final message = 'Batch test message #$i';
        final (status, result) = await _streamChannel!.publishTextMessage(
          topic,
          message,
          sendTs: DateTime.now().millisecondsSinceEpoch,
          customType: 'batch_test',
        );

        if (status.error) {
          _addLog('❌ Message #$i failed: ${status.reason}');
        } else {
          _addLog('✅ Message #$i sent successfully');
        }

        // Wait 500ms
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        _addLog('❌ Message #$i error: $e');
      }
    }

    _addLog('Batch test messages completed');
  }

  /// Send JSON Format Message
  Future<void> _sendJsonMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();

      // Construct JSON message
      final jsonMessage = {
        'type': 'user_action',
        'action': 'join_room',
        'userId': 'test_user',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': {'roomId': 'room456', 'userName': 'Alice'}
      };

      final message = jsonEncode(jsonMessage);

      final (status, result) = await _streamChannel!.publishTextMessage(
        topic,
        message,
        customType: 'json_data',
      );

      if (status.error) {
        _addLog('Failed to send JSON message: ${status.reason}');
        return;
      }

      _addLog('✅ JSON message sent successfully');
      _addLog('   - JSON content: $message');
    } catch (e) {
      _addLog('Send JSON message error: $e');
    }
  }

  /// Send Basic Binary Message
  Future<void> _sendBasicBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

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
      _addLog('   - Channel: ${result?.channelName}');
      _addLog('   - Topic: ${result?.topic}');
      _addLog('   - Original content: $message');
      _addLog('   - Binary length: ${binaryData.length} bytes');
    } catch (e) {
      _addLog('Send binary message error: $e');
    }
  }

  /// Send Timestamped Binary Message
  Future<void> _sendTimestampedBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();
      final message = _binaryDataController.text.trim();
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      final binaryData = Uint8List.fromList(utf8.encode(message));

      final (status, result) = await _streamChannel!.publishBinaryMessage(
        topic,
        binaryData,
        sendTs: currentTimestamp, // Set send timestamp
      );

      if (status.error) {
        _addLog('Failed to send timestamped binary message: ${status.reason}');
        return;
      }

      _addLog('✅ Timestamped binary message sent successfully');
      _addLog('   - Timestamp: $currentTimestamp');
      _addLog('   - Binary length: ${binaryData.length} bytes');
    } catch (e) {
      _addLog('Send timestamped binary message error: $e');
    }
  }

  /// Send Custom Type Binary Message
  Future<void> _sendCustomTypeBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();
      final message = _binaryDataController.text.trim();
      final customType = _customTypeController.text.trim();

      final binaryData = Uint8List.fromList(utf8.encode(message));

      final (status, result) = await _streamChannel!.publishBinaryMessage(
        topic,
        binaryData,
        customType: customType.isEmpty ? null : customType, // Set custom type
      );

      if (status.error) {
        _addLog('Failed to send custom type binary message: ${status.reason}');
        return;
      }

      _addLog('✅ Custom type binary message sent successfully');
      _addLog('   - Custom type: $customType');
      _addLog('   - Binary length: ${binaryData.length} bytes');
    } catch (e) {
      _addLog('Send custom type binary message error: $e');
    }
  }

  /// Send JSON as Binary Message
  Future<void> _sendJsonBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();

      // Construct complex JSON data
      final jsonData = {
        'messageType': 'binary_json',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'payload': {
          'userId': 'binary_user_123',
          'action': 'file_upload',
          'metadata': {
            'fileName': 'example.pdf',
            'fileSize': 1024000,
            'mimeType': 'application/pdf',
            'checksum': 'abc123def456'
          },
          'chunks': [
            {'id': 1, 'size': 512000, 'offset': 0},
            {'id': 2, 'size': 512000, 'offset': 512000}
          ]
        }
      };

      final jsonString = jsonEncode(jsonData);
      final binaryData = Uint8List.fromList(utf8.encode(jsonString));

      final (status, result) = await _streamChannel!.publishBinaryMessage(
        topic,
        binaryData,
        customType: 'json_binary',
      );

      if (status.error) {
        _addLog('Failed to send JSON binary message: ${status.reason}');
        return;
      }

      _addLog('✅ JSON binary message sent successfully');
      _addLog('   - JSON length: ${jsonString.length} characters');
      _addLog('   - Binary length: ${binaryData.length} bytes');
      _addLog('   - Content preview: ${jsonString.substring(0, 100)}...');
    } catch (e) {
      _addLog('Send JSON binary message error: $e');
    }
  }

  /// Send Simulated Image Data Binary Message
  Future<void> _sendImageBinaryMessage() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    try {
      final topic = _topicController.text.trim();

      // Simulate image file header data (simplified PNG signature)
      final pngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

      // Simulate image metadata
      final imageMetadata = {
        'type': 'image',
        'format': 'png',
        'width': 800,
        'height': 600,
        'timestamp': DateTime.now().millisecondsSinceEpoch
      };

      final metadataBytes = utf8.encode(jsonEncode(imageMetadata));

      // Combine: PNG signature + metadata + simulated image data
      final imageData = Uint8List.fromList([
        ...pngSignature,
        ...metadataBytes,
        // Simulated image data (repeating byte pattern)
        ...List.generate(1000, (index) => index % 256)
      ]);

      final (status, result) = await _streamChannel!.publishBinaryMessage(
        topic,
        imageData,
        customType: 'image_data',
      );

      if (status.error) {
        _addLog('Failed to send simulated image binary message: ${status.reason}');
        return;
      }

      _addLog('✅ Simulated image binary message sent successfully');
      _addLog('   - Image format: PNG');
      _addLog('   - Data size: ${imageData.length} bytes');
      _addLog(
          '   - PNG signature: ${pngSignature.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');
      _addLog('   - Metadata: ${jsonEncode(imageMetadata)}');
    } catch (e) {
      _addLog('Send simulated image binary message error: $e');
    }
  }

  /// Send Batch Binary Test Messages
  Future<void> _sendBatchBinaryMessages() async {
    if (_streamChannel == null || !_isTopicJoined) return;

    final topic = _topicController.text.trim();
    _addLog('Starting batch binary test messages...');

    for (int i = 1; i <= 3; i++) {
      try {
        final message =
            'Binary batch test message #$i - ${DateTime.now().millisecondsSinceEpoch}';
        final binaryData = Uint8List.fromList(utf8.encode(message));

        final (status, result) = await _streamChannel!.publishBinaryMessage(
          topic,
          binaryData,
          sendTs: DateTime.now().millisecondsSinceEpoch,
          customType: 'binary_batch_test',
        );

        if (status.error) {
          _addLog('❌ Binary message #$i failed: ${status.reason}');
        } else {
          _addLog('✅ Binary message #$i sent successfully (${binaryData.length} bytes)');
        }

        // Wait 800ms
        await Future.delayed(const Duration(milliseconds: 800));
      } catch (e) {
        _addLog('❌ Binary message #$i error: $e');
      }
    }

    _addLog('Batch binary test messages completed');
  }

  /// Parse Binary Message
  void _parseBinaryMessage(Uint8List binaryData, String customType) {
    try {
      switch (customType) {
        case 'json_binary':
          // Try to parse JSON binary data
          final jsonString = utf8.decode(binaryData);
          final jsonData = jsonDecode(jsonString);
          _addLog('   - JSON parsing successful:');
          _addLog('     ${jsonEncode(jsonData)}');
          break;

        case 'image_data':
          // Parse simulated image data
          if (binaryData.length >= 8) {
            final pngSignature = binaryData.sublist(0, 8);
            final expectedSignature = [
              0x89,
              0x50,
              0x4E,
              0x47,
              0x0D,
              0x0A,
              0x1A,
              0x0A
            ];
            final isValidPNG = _listEquals(pngSignature, expectedSignature);

            _addLog('   - Image format check: ${isValidPNG ? 'PNG format valid' : 'Unknown format'}');
            _addLog(
                '   - File signature: ${pngSignature.map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ')}');

            if (isValidPNG && binaryData.length > 8) {
              // Try to parse metadata section
              try {
                final metadataStart = 8;
                final possibleJsonEnd = binaryData.indexOf(0, metadataStart);
                if (possibleJsonEnd > metadataStart) {
                  final metadataBytes =
                      binaryData.sublist(metadataStart, possibleJsonEnd);
                  final metadataString = utf8.decode(metadataBytes);
                  final metadata = jsonDecode(metadataString);
                  _addLog('   - Image metadata: ${jsonEncode(metadata)}');
                }
              } catch (e) {
                _addLog(
                    '   - Metadata parsing failed, possibly pure image data');
              }
            }
          }
          break;

        case 'binary_batch_test':
          // Parse batch test binary data
          try {
            final textContent = utf8.decode(binaryData);
            _addLog('   - Batch test content: $textContent');
          } catch (e) {
            _addLog('   - Batch test data cannot be decoded as text');
          }
          break;

        default:
          // Generic binary data display
          final hexData = binaryData
              .take(16)
              .map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}')
              .join(' ');
          _addLog(
              '   - Data preview: $hexData${binaryData.length > 16 ? '...' : ''}');

          // Try to decode as text (if possible)
          try {
            final textContent = utf8.decode(binaryData);
            if (textContent.length <= 100) {
              _addLog('   - Text content: $textContent');
            } else {
              _addLog('   - Text content: ${textContent.substring(0, 100)}...');
            }
          } catch (e) {
            _addLog('   - Cannot decode as text content');
          }
          break;
      }
    } catch (e) {
      _addLog('   - Binary data parsing failed: $e');
    }
  }

  /// Compare if two lists are equal
  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
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
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs += '[$timestamp] $log\n';
    });
    logSink.log(log);
  }

  /// Clear Logs
  void _clearLogs() {
    setState(() {
      _logs = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('publishTextMessage & publishBinaryMessage Examples'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: 'Clear Logs',
          ),
        ],
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
                            controller: _customTypeController,
                            decoration: const InputDecoration(
                              labelText: 'Custom Type (Optional)',
                              hintText: 'e.g.: chat, notification, system',
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

                          // Step 1: Create channel
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _isInitialized && _streamChannel == null
                                      ? _createStreamChannel
                                      : null,
                              child: const Text('1. Create StreamChannel'),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Step 2: Join channel
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _streamChannel != null && !_isChannelJoined
                                      ? _joinChannel
                                      : null,
                              child: const Text('2. Join Channel'),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Step 3: Join topic
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChannelJoined && !_isTopicJoined
                                  ? _joinTopic
                                  : null,
                              child: const Text('3. Join Topic'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Message sending test area
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'publishTextMessage Tests',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          // Basic message sending
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isTopicJoined
                                      ? _sendBasicTextMessage
                                      : null,
                                  child: const Text('Send Basic Message'),
                                ),
                              ),
                              // const SizedBox(width: 8),
                              // Expanded(
                              //   child: ElevatedButton(
                              //     onPressed: _isTopicJoined
                              //         ? _sendTimestampedTextMessage
                              //         : null,
                              //     child: const Text('Send Timestamped Message'),
                              //   ),
                              // ),
                            ],
                          ),

                          // const SizedBox(height: 8),

                          // // Custom type and full parameters
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendCustomTypeTextMessage
                          //             : null,
                          //         child: const Text('Send Custom Type Message'),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendFullParameterTextMessage
                          //             : null,
                          //         child:
                          //             const Text('Send Full Parameter Message'),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // const SizedBox(height: 8),

                          // // JSON and batch testing
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed:
                          //             _isTopicJoined ? _sendJsonMessage : null,
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.blue,
                          //         ),
                          //         child: const Text('Send JSON Message'),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendBatchMessages
                          //             : null,
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.orange,
                          //         ),
                          //         child: const Text('Batch Send Test'),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Binary message sending test area
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'publishBinaryMessage Tests',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          // Basic binary message sending
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isTopicJoined
                                      ? _sendBasicBinaryMessage
                                      : null,
                                  child:
                                      const Text('Send Basic Binary Message'),
                                ),
                              ),
                              // const SizedBox(width: 8),
                              // Expanded(
                              //   child: ElevatedButton(
                              //     onPressed: _isTopicJoined
                              //         ? _sendTimestampedBinaryMessage
                              //         : null,
                              //     child: const Text(
                              //         'Send Timestamped Binary Message'),
                              //   ),
                              // ),
                            ],
                          ),

                          // const SizedBox(height: 8),

                          // // Custom type binary messages
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendCustomTypeBinaryMessage
                          //             : null,
                          //         child: const Text(
                          //             'Send Custom Type Binary Message'),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendJsonBinaryMessage
                          //             : null,
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.blue,
                          //         ),
                          //         child: const Text('Send JSON Binary Message'),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // const SizedBox(height: 8),

                          // // Advanced binary message testing
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendImageBinaryMessage
                          //             : null,
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.purple,
                          //         ),
                          //         child: const Text(
                          //             'Send Simulated Image Binary Message'),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: ElevatedButton(
                          //         onPressed: _isTopicJoined
                          //             ? _sendBatchBinaryMessages
                          //             : null,
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.orange,
                          //         ),
                          //         child: const Text('Batch Send Binary Test'),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Status indicators
                  Row(
                    children: [
                      _buildStatusIndicator('RTM Initialized', _isInitialized),
                      const SizedBox(width: 8),
                      _buildStatusIndicator('Channel Joined', _isChannelJoined),
                      const SizedBox(width: 8),
                      _buildStatusIndicator('Topic Joined', _isTopicJoined),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Lower part: fixed height log display area
          Container(
            height: 200, // Fixed height
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Runtime Logs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Text(
                          _logs.isEmpty ? 'No logs yet...' : _logs,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
}
