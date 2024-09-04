import 'binding_forward_export.dart';
part 'agora_rtm_client.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmConfig {
  const RtmConfig(
      {this.areaCode = const {RtmAreaCode.glob},
      this.protocolType = RtmProtocolType.tcpUdp,
      this.presenceTimeout = 300,
      this.heartbeatInterval = 5,
      this.useStringUserId = true,
      this.logConfig,
      this.proxyConfig,
      this.encryptionConfig,
      this.privateConfig});

  @RtmAreaCodeListConverter()
  @JsonKey(name: 'areaCode')
  final Set<RtmAreaCode>? areaCode;

  @JsonKey(name: 'protocolType')
  final RtmProtocolType? protocolType;

  @JsonKey(name: 'presenceTimeout')
  final int? presenceTimeout;

  @JsonKey(name: 'heartbeatInterval')
  final int? heartbeatInterval;

  @JsonKey(name: 'useStringUserId')
  final bool? useStringUserId;

  @JsonKey(name: 'logConfig')
  final RtmLogConfig? logConfig;

  @JsonKey(name: 'proxyConfig')
  final RtmProxyConfig? proxyConfig;

  @JsonKey(name: 'encryptionConfig')
  final RtmEncryptionConfig? encryptionConfig;

  @JsonKey(name: 'privateConfig')
  final RtmPrivateConfig? privateConfig;

  factory RtmConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RtmConfigToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LinkStateEvent {
  const LinkStateEvent(
      {this.currentState,
      this.previousState,
      this.serviceType,
      this.operation,
      this.reason,
      this.affectedChannels,
      this.unrestoredChannels,
      this.isResumed,
      this.timestamp});

  @JsonKey(name: 'currentState')
  final RtmLinkState? currentState;

  @JsonKey(name: 'previousState')
  final RtmLinkState? previousState;

  @JsonKey(name: 'serviceType')
  final RtmServiceType? serviceType;

  @JsonKey(name: 'operation')
  final RtmLinkOperation? operation;

  @JsonKey(name: 'reason')
  final String? reason;

  @JsonKey(name: 'affectedChannels')
  final List<String>? affectedChannels;

  @JsonKey(name: 'unrestoredChannels')
  final List<String>? unrestoredChannels;

  @JsonKey(name: 'isResumed')
  final bool? isResumed;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory LinkStateEvent.fromJson(Map<String, dynamic> json) =>
      _$LinkStateEventFromJson(json);

  Map<String, dynamic> toJson() => _$LinkStateEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MessageEvent {
  const MessageEvent(
      {this.channelType,
      this.messageType,
      this.channelName,
      this.channelTopic,
      this.message,
      this.messageLength,
      this.publisher,
      this.customType,
      this.timestamp});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'messageType')
  final RtmMessageType? messageType;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'channelTopic')
  final String? channelTopic;

  @JsonKey(name: 'message', ignore: true)
  final Uint8List? message;

  @JsonKey(name: 'messageLength')
  final int? messageLength;

  @JsonKey(name: 'publisher')
  final String? publisher;

  @JsonKey(name: 'customType')
  final String? customType;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory MessageEvent.fromJson(Map<String, dynamic> json) =>
      _$MessageEventFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PresenceEvent {
  const PresenceEvent(
      {this.type,
      this.channelType,
      this.channelName,
      this.publisher,
      this.stateItems,
      this.interval,
      this.snapshot,
      this.timestamp});

  @JsonKey(name: 'type')
  final RtmPresenceEventType? type;

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'publisher')
  final String? publisher;

  @JsonKey(name: 'stateItems')
  final List<StateItem>? stateItems;

  @JsonKey(name: 'interval')
  final IntervalInfo? interval;

  @JsonKey(name: 'snapshot')
  final SnapshotInfo? snapshot;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory PresenceEvent.fromJson(Map<String, dynamic> json) =>
      _$PresenceEventFromJson(json);

  Map<String, dynamic> toJson() => _$PresenceEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class IntervalInfo {
  const IntervalInfo(
      {this.joinUserList,
      this.leaveUserList,
      this.timeoutUserList,
      this.userStateList});

  @JsonKey(name: 'joinUserList')
  final UserList? joinUserList;

  @JsonKey(name: 'leaveUserList')
  final UserList? leaveUserList;

  @JsonKey(name: 'timeoutUserList')
  final UserList? timeoutUserList;

  @JsonKey(name: 'userStateList')
  final List<UserState>? userStateList;

  factory IntervalInfo.fromJson(Map<String, dynamic> json) =>
      _$IntervalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SnapshotInfo {
  const SnapshotInfo({this.userStateList});

  @JsonKey(name: 'userStateList')
  final List<UserState>? userStateList;

  factory SnapshotInfo.fromJson(Map<String, dynamic> json) =>
      _$SnapshotInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SnapshotInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicEvent {
  const TopicEvent(
      {this.type,
      this.channelName,
      this.publisher,
      this.topicInfos,
      this.timestamp});

  @JsonKey(name: 'type')
  final RtmTopicEventType? type;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'publisher')
  final String? publisher;

  @JsonKey(name: 'topicInfos')
  final List<TopicInfo>? topicInfos;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory TopicEvent.fromJson(Map<String, dynamic> json) =>
      _$TopicEventFromJson(json);

  Map<String, dynamic> toJson() => _$TopicEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LockEvent {
  const LockEvent(
      {this.channelType,
      this.eventType,
      this.channelName,
      this.lockDetailList,
      this.timestamp});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'eventType')
  final RtmLockEventType? eventType;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'lockDetailList')
  final List<LockDetail>? lockDetailList;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory LockEvent.fromJson(Map<String, dynamic> json) =>
      _$LockEventFromJson(json);

  Map<String, dynamic> toJson() => _$LockEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StorageEvent {
  const StorageEvent(
      {this.channelType,
      this.storageType,
      this.eventType,
      this.target,
      this.data,
      this.timestamp});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'storageType')
  final RtmStorageType? storageType;

  @JsonKey(name: 'eventType')
  final RtmStorageEventType? eventType;

  @JsonKey(name: 'target')
  final String? target;

  @JsonKey(name: 'data')
  final Metadata? data;

  @JsonKey(name: 'timestamp')
  final int? timestamp;

  factory StorageEvent.fromJson(Map<String, dynamic> json) =>
      _$StorageEventFromJson(json);

  Map<String, dynamic> toJson() => _$StorageEventToJson(this);
}

class LoginResult {
  LoginResult();
}

class LogoutResult {
  LogoutResult();
}

class RenewTokenResult {
  RenewTokenResult({required this.serverType, required this.channelName});

  final RtmServiceType serverType;

  final String channelName;
}

class PublishResult {
  PublishResult();
}

class SubscribeResult {
  SubscribeResult({required this.channelName});

  final String channelName;
}

class UnsubscribeResult {
  UnsubscribeResult({required this.channelName});

  final String channelName;
}

class TokenEvent {
  const TokenEvent(this.channelName);
  final String channelName;
}

abstract class RtmClient {
  void addListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token});

  void removeListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token});

  Future<RtmStatus> release();

  Future<(RtmStatus, LoginResult?)> login(String token);

  Future<(RtmStatus, LogoutResult?)> logout();

  RtmStorage getStorage();

  RtmLock getLock();

  RtmPresence getPresence();

  Future<(RtmStatus, RenewTokenResult?)> renewToken(String token);

  Future<(RtmStatus, PublishResult?)> publish(
      String channelName, String message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType});

  Future<(RtmStatus, SubscribeResult?)> subscribe(String channelName,
      {bool withMessage = true,
      bool withMetadata = false,
      bool withPresence = true,
      bool withLock = false,
      bool beQuiet = false});

  Future<(RtmStatus, UnsubscribeResult?)> unsubscribe(String channelName);

  Future<(RtmStatus, StreamChannel?)> createStreamChannel(String channelName);

  Future<RtmStatus> setParameters(String parameters);

  Future<(RtmStatus, PublishResult?)> publishBinaryMessage(
      String channelName, Uint8List message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType});
}
