import 'binding_forward_export.dart';
part 'agora_stream_channel.g.dart';

@JsonEnum(alwaysCreate: true)
enum RtmMessageQos {
  @JsonValue(0)
  unordered,

  @JsonValue(1)
  ordered,
}

extension RtmMessageQosExt on RtmMessageQos {
  /// @nodoc
  static RtmMessageQos fromValue(int value) {
    return $enumDecode(_$RtmMessageQosEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmMessageQosEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmMessagePriority {
  @JsonValue(0)
  highest,

  @JsonValue(1)
  high,

  @JsonValue(4)
  normal,

  @JsonValue(8)
  low,
}

extension RtmMessagePriorityExt on RtmMessagePriority {
  /// @nodoc
  static RtmMessagePriority fromValue(int value) {
    return $enumDecode(_$RtmMessagePriorityEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmMessagePriorityEnumMap[this]!;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class JoinChannelOptions {
  const JoinChannelOptions(
      {this.token,
      this.withMetadata = false,
      this.withPresence = true,
      this.withLock = false,
      this.beQuiet = false});

  @JsonKey(name: 'token')
  final String? token;

  @JsonKey(name: 'withMetadata')
  final bool? withMetadata;

  @JsonKey(name: 'withPresence')
  final bool? withPresence;

  @JsonKey(name: 'withLock')
  final bool? withLock;

  @JsonKey(name: 'beQuiet')
  final bool? beQuiet;

  factory JoinChannelOptions.fromJson(Map<String, dynamic> json) =>
      _$JoinChannelOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$JoinChannelOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class JoinTopicOptions {
  const JoinTopicOptions(
      {this.qos = RtmMessageQos.unordered,
      this.priority = RtmMessagePriority.normal,
      this.meta = '',
      this.syncWithMedia = false});

  @JsonKey(name: 'qos')
  final RtmMessageQos? qos;

  @JsonKey(name: 'priority')
  final RtmMessagePriority? priority;

  @JsonKey(name: 'meta')
  final String? meta;

  @JsonKey(name: 'syncWithMedia')
  final bool? syncWithMedia;

  factory JoinTopicOptions.fromJson(Map<String, dynamic> json) =>
      _$JoinTopicOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$JoinTopicOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicOptions {
  const TopicOptions({this.users, this.userCount = 0});

  @JsonKey(name: 'users')
  final List<String>? users;

  @JsonKey(name: 'userCount')
  final int? userCount;

  factory TopicOptions.fromJson(Map<String, dynamic> json) =>
      _$TopicOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$TopicOptionsToJson(this);
}

class JoinResult {
  JoinResult({required this.channelName, required this.userId});

  final String channelName;

  final String userId;
}

class LeaveResult {
  LeaveResult({required this.channelName, required this.userId});

  final String channelName;

  final String userId;
}

class JoinTopicResult {
  JoinTopicResult(
      {required this.channelName,
      required this.userId,
      required this.topic,
      required this.meta});

  final String channelName;

  final String userId;

  final String topic;

  final String meta;
}

class PublishTopicMessageResult {
  PublishTopicMessageResult({required this.channelName, required this.topic});

  final String channelName;

  final String topic;
}

class LeaveTopicResult {
  LeaveTopicResult(
      {required this.channelName,
      required this.userId,
      required this.topic,
      required this.meta});

  final String channelName;

  final String userId;

  final String topic;

  final String meta;
}

class SubscribeTopicResult {
  SubscribeTopicResult(
      {required this.channelName,
      required this.userId,
      required this.topic,
      required this.succeedUsers,
      required this.failedUsers});

  final String channelName;

  final String userId;

  final String topic;

  final List<String> succeedUsers;

  final List<String> failedUsers;
}

class UnsubscribeTopicResult {
  UnsubscribeTopicResult({required this.channelName, required this.topic});

  final String channelName;

  final String topic;
}

class GetSubscribedUserListResult {
  GetSubscribedUserListResult(
      {required this.channelName, required this.topic, required this.users});

  final String channelName;

  final String topic;

  final UserList users;
}

abstract class StreamChannel {
  Future<(RtmStatus, JoinResult?)> join(
      {String? token,
      bool withMetadata = false,
      bool withPresence = true,
      bool withLock = false,
      bool beQuiet = false});

  Future<(RtmStatus, RenewTokenResult?)> renewToken(String token);

  Future<(RtmStatus, LeaveResult?)> leave();

  Future<(RtmStatus, String?)> getChannelName();

  Future<(RtmStatus, JoinTopicResult?)> joinTopic(String topic,
      {RtmMessageQos qos = RtmMessageQos.unordered,
      RtmMessagePriority priority = RtmMessagePriority.normal,
      String meta = '',
      bool syncWithMedia = false});

  Future<(RtmStatus, LeaveTopicResult?)> leaveTopic(String topic);

  Future<(RtmStatus, SubscribeTopicResult?)> subscribeTopic(String topic,
      {List<String> users = const []});

  Future<(RtmStatus, UnsubscribeTopicResult?)> unsubscribeTopic(String topic,
      {List<String> users = const []});

  Future<(RtmStatus, GetSubscribedUserListResult?)> getSubscribedUserList(
      String topic);

  Future<RtmStatus> release();

  Future<(RtmStatus, PublishTopicMessageResult?)> publishTextMessage(
      String topic, String message,
      {int sendTs = 0, String? customType});

  Future<(RtmStatus, PublishTopicMessageResult?)> publishBinaryMessage(
      String topic, Uint8List message,
      {int sendTs = 0, String? customType});
}
