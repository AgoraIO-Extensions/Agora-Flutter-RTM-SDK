import 'binding_forward_export.dart';
part 'agora_rtm_base.g.dart';

/// @nodoc
const defaultLogSizeInKb = 1024;

@JsonEnum(alwaysCreate: true)
enum RtmLinkState {
  @JsonValue(0)
  idle,

  @JsonValue(1)
  connecting,

  @JsonValue(2)
  connected,

  @JsonValue(3)
  disconnected,

  @JsonValue(4)
  suspended,

  @JsonValue(5)
  failed,
}

extension RtmLinkStateExt on RtmLinkState {
  /// @nodoc
  static RtmLinkState fromValue(int value) {
    return $enumDecode(_$RtmLinkStateEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmLinkStateEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmLinkOperation {
  @JsonValue(0)
  login,

  @JsonValue(1)
  logout,

  @JsonValue(2)
  join,

  @JsonValue(3)
  leave,

  @JsonValue(4)
  serverReject,

  @JsonValue(5)
  autoReconnect,

  @JsonValue(6)
  reconnected,

  @JsonValue(7)
  heartbeatLost,

  @JsonValue(8)
  serverTimeout,

  @JsonValue(9)
  networkChange,
}

extension RtmLinkOperationExt on RtmLinkOperation {
  /// @nodoc
  static RtmLinkOperation fromValue(int value) {
    return $enumDecode(_$RtmLinkOperationEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmLinkOperationEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmServiceType {
  @JsonValue(0x00000000)
  none,

  @JsonValue(0x00000001)
  message,

  @JsonValue(0x00000002)
  stream,
}

extension RtmServiceTypeExt on RtmServiceType {
  /// @nodoc
  static RtmServiceType fromValue(int value) {
    return $enumDecode(_$RtmServiceTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmServiceTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmProtocolType {
  @JsonValue(0)
  tcpUdp,

  @JsonValue(1)
  tcpOnly,
}

extension RtmProtocolTypeExt on RtmProtocolType {
  /// @nodoc
  static RtmProtocolType fromValue(int value) {
    return $enumDecode(_$RtmProtocolTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmProtocolTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmAreaCode {
  @JsonValue(0x00000001)
  cn,

  @JsonValue(0x00000002)
  na,

  @JsonValue(0x00000004)
  eu,

  @JsonValue(0x00000008)
  asm,

  @JsonValue(0x00000010)
  jp,

  @JsonValue(0x00000020)
  ind,

  @JsonValue((0xFFFFFFFF))
  glob,
}

extension RtmAreaCodeExt on RtmAreaCode {
  /// @nodoc
  static RtmAreaCode fromValue(int value) {
    return $enumDecode(_$RtmAreaCodeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmAreaCodeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmLogLevel {
  @JsonValue(0x0000)
  none,

  @JsonValue(0x0001)
  info,

  @JsonValue(0x0002)
  warn,

  @JsonValue(0x0004)
  error,

  @JsonValue(0x0008)
  fatal,
}

extension RtmLogLevelExt on RtmLogLevel {
  /// @nodoc
  static RtmLogLevel fromValue(int value) {
    return $enumDecode(_$RtmLogLevelEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmLogLevelEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmEncryptionMode {
  @JsonValue(0)
  none,

  @JsonValue(1)
  aes128Gcm,

  @JsonValue(2)
  aes256Gcm,
}

extension RtmEncryptionModeExt on RtmEncryptionMode {
  /// @nodoc
  static RtmEncryptionMode fromValue(int value) {
    return $enumDecode(_$RtmEncryptionModeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmEncryptionModeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmErrorCode {
  @JsonValue(0)
  ok,

  @JsonValue(-10001)
  notInitialized,

  @JsonValue(-10002)
  notLogin,

  @JsonValue(-10003)
  invalidAppId,

  @JsonValue(-10004)
  invalidEventHandler,

  @JsonValue(-10005)
  invalidToken,

  @JsonValue(-10006)
  invalidUserId,

  @JsonValue(-10007)
  initServiceFailed,

  @JsonValue(-10008)
  invalidChannelName,

  @JsonValue(-10009)
  tokenExpired,

  @JsonValue(-10010)
  loginNoServerResources,

  @JsonValue(-10011)
  loginTimeout,

  @JsonValue(-10012)
  loginRejected,

  @JsonValue(-10013)
  loginAborted,

  @JsonValue(-10014)
  invalidParameter,

  @JsonValue(-10015)
  loginNotAuthorized,

  @JsonValue(-10016)
  inconsistentAppid,

  @JsonValue(-10017)
  duplicateOperation,

  @JsonValue(-10018)
  instanceAlreadyReleased,

  @JsonValue(-10019)
  invalidChannelType,

  @JsonValue(-10020)
  invalidEncryptionParameter,

  @JsonValue(-10021)
  operationRateExceedLimitation,

  @JsonValue(-10022)
  serviceNotSupported,

  @JsonValue(-10023)
  loginCanceled,

  @JsonValue(-10024)
  invalidPrivateConfig,

  @JsonValue(-10025)
  notConnected,

  @JsonValue(-11001)
  channelNotJoined,

  @JsonValue(-11002)
  channelNotSubscribed,

  @JsonValue(-11003)
  channelExceedTopicUserLimitation,

  @JsonValue(-11004)
  channelInReuse,

  @JsonValue(-11005)
  channelInstanceExceedLimitation,

  @JsonValue(-11006)
  channelInErrorState,

  @JsonValue(-11007)
  channelJoinFailed,

  @JsonValue(-11008)
  channelInvalidTopicName,

  @JsonValue(-11009)
  channelInvalidMessage,

  @JsonValue(-11010)
  channelMessageLengthExceedLimitation,

  @JsonValue(-11011)
  channelInvalidUserList,

  @JsonValue(-11012)
  channelNotAvailable,

  @JsonValue(-11013)
  channelTopicNotSubscribed,

  @JsonValue(-11014)
  channelExceedTopicLimitation,

  @JsonValue(-11015)
  channelJoinTopicFailed,

  @JsonValue(-11016)
  channelTopicNotJoined,

  @JsonValue(-11017)
  channelTopicNotExist,

  @JsonValue(-11018)
  channelInvalidTopicMeta,

  @JsonValue(-11019)
  channelSubscribeTimeout,

  @JsonValue(-11020)
  channelSubscribeTooFrequent,

  @JsonValue(-11021)
  channelSubscribeFailed,

  @JsonValue(-11022)
  channelUnsubscribeFailed,

  @JsonValue(-11023)
  channelEncryptMessageFailed,

  @JsonValue(-11024)
  channelPublishMessageFailed,

  @JsonValue(-11025)
  channelPublishMessageTooFrequent,

  @JsonValue(-11026)
  channelPublishMessageTimeout,

  @JsonValue(-11027)
  channelNotConnected,

  @JsonValue(-11028)
  channelLeaveFailed,

  @JsonValue(-11029)
  channelCustomTypeLengthOverflow,

  @JsonValue(-11030)
  channelInvalidCustomType,

  @JsonValue(-11031)
  channelUnsupportedMessageType,

  @JsonValue(-11032)
  channelPresenceNotReady,

  @JsonValue(-11033)
  channelReceiverOffline,

  @JsonValue(-11034)
  channelJoinCanceled,

  @JsonValue(-12001)
  storageOperationFailed,

  @JsonValue(-12002)
  storageMetadataItemExceedLimitation,

  @JsonValue(-12003)
  storageInvalidMetadataItem,

  @JsonValue(-12004)
  storageInvalidArgument,

  @JsonValue(-12005)
  storageInvalidRevision,

  @JsonValue(-12006)
  storageMetadataLengthOverflow,

  @JsonValue(-12007)
  storageInvalidLockName,

  @JsonValue(-12008)
  storageLockNotAcquired,

  @JsonValue(-12009)
  storageInvalidKey,

  @JsonValue(-12010)
  storageInvalidValue,

  @JsonValue(-12011)
  storageKeyLengthOverflow,

  @JsonValue(-12012)
  storageValueLengthOverflow,

  @JsonValue(-12013)
  storageDuplicateKey,

  @JsonValue(-12014)
  storageOutdatedRevision,

  @JsonValue(-12015)
  storageNotSubscribe,

  @JsonValue(-12016)
  storageInvalidMetadataInstance,

  @JsonValue(-12017)
  storageSubscribeUserExceedLimitation,

  @JsonValue(-12018)
  storageOperationTimeout,

  @JsonValue(-12019)
  storageNotAvailable,

  @JsonValue(-13001)
  presenceNotConnected,

  @JsonValue(-13002)
  presenceNotWritable,

  @JsonValue(-13003)
  presenceInvalidArgument,

  @JsonValue(-13004)
  presenceCachedTooManyStates,

  @JsonValue(-13005)
  presenceStateCountOverflow,

  @JsonValue(-13006)
  presenceInvalidStateKey,

  @JsonValue(-13007)
  presenceInvalidStateValue,

  @JsonValue(-13008)
  presenceStateKeySizeOverflow,

  @JsonValue(-13009)
  presenceStateValueSizeOverflow,

  @JsonValue(-13010)
  presenceStateDuplicateKey,

  @JsonValue(-13011)
  presenceUserNotExist,

  @JsonValue(-13012)
  presenceOperationTimeout,

  @JsonValue(-13013)
  presenceOperationFailed,

  @JsonValue(-14001)
  lockOperationFailed,

  @JsonValue(-14002)
  lockOperationTimeout,

  @JsonValue(-14003)
  lockOperationPerforming,

  @JsonValue(-14004)
  lockAlreadyExist,

  @JsonValue(-14005)
  lockInvalidName,

  @JsonValue(-14006)
  lockNotAcquired,

  @JsonValue(-14007)
  lockAcquireFailed,

  @JsonValue(-14008)
  lockNotExist,

  @JsonValue(-14009)
  lockNotAvailable,
}

extension RtmErrorCodeExt on RtmErrorCode {
  /// @nodoc
  static RtmErrorCode fromValue(int value) {
    return $enumDecode(_$RtmErrorCodeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmErrorCodeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionState {
  @JsonValue(1)
  disconnected,

  @JsonValue(2)
  connecting,

  @JsonValue(3)
  connected,

  @JsonValue(4)
  reconnecting,

  @JsonValue(5)
  failed,
}

extension RtmConnectionStateExt on RtmConnectionState {
  /// @nodoc
  static RtmConnectionState fromValue(int value) {
    return $enumDecode(_$RtmConnectionStateEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmConnectionStateEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionChangeReason {
  @JsonValue(0)
  connecting,

  @JsonValue(1)
  joinSuccess,

  @JsonValue(2)
  interrupted,

  @JsonValue(3)
  bannedByServer,

  @JsonValue(4)
  joinFailed,

  @JsonValue(5)
  leaveChannel,

  @JsonValue(6)
  invalidAppId,

  @JsonValue(7)
  invalidChannelName,

  @JsonValue(8)
  invalidToken,

  @JsonValue(9)
  tokenExpired,

  @JsonValue(10)
  rejectedByServer,

  @JsonValue(11)
  settingProxyServer,

  @JsonValue(12)
  renewToken,

  @JsonValue(13)
  clientIpAddressChanged,

  @JsonValue(14)
  keepAliveTimeout,

  @JsonValue(15)
  rejoinSuccess,

  @JsonValue(16)
  lost,

  @JsonValue(17)
  echoTest,

  @JsonValue(18)
  clientIpAddressChangedByUser,

  @JsonValue(19)
  sameUidLogin,

  @JsonValue(20)
  tooManyBroadcasters,

  @JsonValue(21)
  licenseValidationFailure,

  @JsonValue(22)
  certificationVerifyFailure,

  @JsonValue(23)
  streamChannelNotAvailable,

  @JsonValue(24)
  inconsistentAppid,

  @JsonValue(10001)
  loginSuccess,

  @JsonValue(10002)
  logout,

  @JsonValue(10003)
  presenceNotReady,
}

extension RtmConnectionChangeReasonExt on RtmConnectionChangeReason {
  /// @nodoc
  static RtmConnectionChangeReason fromValue(int value) {
    return $enumDecode(_$RtmConnectionChangeReasonEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmConnectionChangeReasonEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmChannelType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  message,

  @JsonValue(2)
  stream,

  @JsonValue(3)
  user,
}

extension RtmChannelTypeExt on RtmChannelType {
  /// @nodoc
  static RtmChannelType fromValue(int value) {
    return $enumDecode(_$RtmChannelTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmChannelTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmMessageType {
  @JsonValue(0)
  binary,

  @JsonValue(1)
  string,
}

extension RtmMessageTypeExt on RtmMessageType {
  /// @nodoc
  static RtmMessageType fromValue(int value) {
    return $enumDecode(_$RtmMessageTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmMessageTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmStorageType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  user,

  @JsonValue(2)
  channel,
}

extension RtmStorageTypeExt on RtmStorageType {
  /// @nodoc
  static RtmStorageType fromValue(int value) {
    return $enumDecode(_$RtmStorageTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmStorageTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmStorageEventType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  snapshot,

  @JsonValue(2)
  set,

  @JsonValue(3)
  update,

  @JsonValue(4)
  remove,
}

extension RtmStorageEventTypeExt on RtmStorageEventType {
  /// @nodoc
  static RtmStorageEventType fromValue(int value) {
    return $enumDecode(_$RtmStorageEventTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmStorageEventTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmLockEventType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  snapshot,

  @JsonValue(2)
  lockSet,

  @JsonValue(3)
  lockRemoved,

  @JsonValue(4)
  lockAcquired,

  @JsonValue(5)
  lockReleased,

  @JsonValue(6)
  lockExpired,
}

extension RtmLockEventTypeExt on RtmLockEventType {
  /// @nodoc
  static RtmLockEventType fromValue(int value) {
    return $enumDecode(_$RtmLockEventTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmLockEventTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmProxyType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  http,

  @JsonValue(2)
  cloudTcp,
}

extension RtmProxyTypeExt on RtmProxyType {
  /// @nodoc
  static RtmProxyType fromValue(int value) {
    return $enumDecode(_$RtmProxyTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmProxyTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmTopicEventType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  snapshot,

  @JsonValue(2)
  remoteJoinTopic,

  @JsonValue(3)
  remoteLeaveTopic,
}

extension RtmTopicEventTypeExt on RtmTopicEventType {
  /// @nodoc
  static RtmTopicEventType fromValue(int value) {
    return $enumDecode(_$RtmTopicEventTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmTopicEventTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmPresenceEventType {
  @JsonValue(0)
  none,

  @JsonValue(1)
  snapshot,

  @JsonValue(2)
  interval,

  @JsonValue(3)
  remoteJoinChannel,

  @JsonValue(4)
  remoteLeaveChannel,

  @JsonValue(5)
  remoteTimeout,

  @JsonValue(6)
  remoteStateChanged,

  @JsonValue(7)
  errorOutOfService,
}

extension RtmPresenceEventTypeExt on RtmPresenceEventType {
  /// @nodoc
  static RtmPresenceEventType fromValue(int value) {
    return $enumDecode(_$RtmPresenceEventTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmPresenceEventTypeEnumMap[this]!;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmLogConfig {
  const RtmLogConfig(
      {this.filePath,
      this.fileSizeInKB = defaultLogSizeInKb,
      this.level = RtmLogLevel.info});

  @JsonKey(name: 'filePath')
  final String? filePath;

  @JsonKey(name: 'fileSizeInKB')
  final int? fileSizeInKB;

  @JsonKey(name: 'level')
  final RtmLogLevel? level;

  factory RtmLogConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmLogConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RtmLogConfigToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserList {
  const UserList({this.users});

  @JsonKey(name: 'users')
  final List<String>? users;

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);

  Map<String, dynamic> toJson() => _$UserListToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PublisherInfo {
  const PublisherInfo({this.publisherUserId, this.publisherMeta});

  @JsonKey(name: 'publisherUserId')
  final String? publisherUserId;

  @JsonKey(name: 'publisherMeta')
  final String? publisherMeta;

  factory PublisherInfo.fromJson(Map<String, dynamic> json) =>
      _$PublisherInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PublisherInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicInfo {
  const TopicInfo({this.topic, this.publishers});

  @JsonKey(name: 'topic')
  final String? topic;

  @JsonKey(name: 'publishers')
  final List<PublisherInfo>? publishers;

  factory TopicInfo.fromJson(Map<String, dynamic> json) =>
      _$TopicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TopicInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class StateItem {
  const StateItem({this.key, this.value});

  @JsonKey(name: 'key')
  final String? key;

  @JsonKey(name: 'value')
  final String? value;

  factory StateItem.fromJson(Map<String, dynamic> json) =>
      _$StateItemFromJson(json);

  Map<String, dynamic> toJson() => _$StateItemToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class LockDetail {
  const LockDetail({this.lockName, this.owner, this.ttl = 0});

  @JsonKey(name: 'lockName')
  final String? lockName;

  @JsonKey(name: 'owner')
  final String? owner;

  @JsonKey(name: 'ttl')
  final int? ttl;

  factory LockDetail.fromJson(Map<String, dynamic> json) =>
      _$LockDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LockDetailToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserState {
  const UserState({this.userId, this.states});

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'states')
  final List<StateItem>? states;

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SubscribeOptions {
  const SubscribeOptions(
      {this.withMessage = true,
      this.withMetadata = false,
      this.withPresence = true,
      this.withLock = false,
      this.beQuiet = false});

  @JsonKey(name: 'withMessage')
  final bool? withMessage;

  @JsonKey(name: 'withMetadata')
  final bool? withMetadata;

  @JsonKey(name: 'withPresence')
  final bool? withPresence;

  @JsonKey(name: 'withLock')
  final bool? withLock;

  @JsonKey(name: 'beQuiet')
  final bool? beQuiet;

  factory SubscribeOptions.fromJson(Map<String, dynamic> json) =>
      _$SubscribeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ChannelInfo {
  const ChannelInfo({this.channelName, this.channelType});

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  factory ChannelInfo.fromJson(Map<String, dynamic> json) =>
      _$ChannelInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelInfoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PresenceOptions {
  const PresenceOptions(
      {this.includeUserId = true, this.includeState = false, this.page = ''});

  @JsonKey(name: 'includeUserId')
  final bool? includeUserId;

  @JsonKey(name: 'includeState')
  final bool? includeState;

  @JsonKey(name: 'page')
  final String? page;

  factory PresenceOptions.fromJson(Map<String, dynamic> json) =>
      _$PresenceOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PresenceOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PublishOptions {
  const PublishOptions(
      {this.channelType = RtmChannelType.message,
      this.messageType = RtmMessageType.binary,
      this.customType});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'messageType')
  final RtmMessageType? messageType;

  @JsonKey(name: 'customType')
  final String? customType;

  factory PublishOptions.fromJson(Map<String, dynamic> json) =>
      _$PublishOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$PublishOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicMessageOptions {
  const TopicMessageOptions(
      {this.messageType = RtmMessageType.binary,
      this.sendTs = 0,
      this.customType});

  @JsonKey(name: 'messageType')
  final RtmMessageType? messageType;

  @JsonKey(name: 'sendTs')
  final int? sendTs;

  @JsonKey(name: 'customType')
  final String? customType;

  factory TopicMessageOptions.fromJson(Map<String, dynamic> json) =>
      _$TopicMessageOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$TopicMessageOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class GetOnlineUsersOptions {
  const GetOnlineUsersOptions(
      {this.includeUserId = true, this.includeState = false, this.page});

  @JsonKey(name: 'includeUserId')
  final bool? includeUserId;

  @JsonKey(name: 'includeState')
  final bool? includeState;

  @JsonKey(name: 'page')
  final String? page;

  factory GetOnlineUsersOptions.fromJson(Map<String, dynamic> json) =>
      _$GetOnlineUsersOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$GetOnlineUsersOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmProxyConfig {
  const RtmProxyConfig(
      {this.proxyType = RtmProxyType.none,
      this.server,
      this.port = 0,
      this.account,
      this.password});

  @JsonKey(name: 'proxyType')
  final RtmProxyType? proxyType;

  @JsonKey(name: 'server')
  final String? server;

  @JsonKey(name: 'port')
  final int? port;

  @JsonKey(name: 'account')
  final String? account;

  @JsonKey(name: 'password')
  final String? password;

  factory RtmProxyConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmProxyConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RtmProxyConfigToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmEncryptionConfig {
  const RtmEncryptionConfig(
      {this.encryptionMode = RtmEncryptionMode.none,
      this.encryptionKey,
      this.encryptionSalt});

  @JsonKey(name: 'encryptionMode')
  final RtmEncryptionMode? encryptionMode;

  @JsonKey(name: 'encryptionKey')
  final String? encryptionKey;

  @JsonKey(name: 'encryptionSalt', ignore: true)
  final Uint8List? encryptionSalt;

  factory RtmEncryptionConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmEncryptionConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RtmEncryptionConfigToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmPrivateConfig {
  const RtmPrivateConfig(
      {this.serviceType = const {RtmServiceType.none}, this.accessPointHosts});

  @RtmServiceTypeListConverter()
  @JsonKey(name: 'serviceType')
  final Set<RtmServiceType>? serviceType;

  @JsonKey(name: 'accessPointHosts')
  final List<String>? accessPointHosts;

  factory RtmPrivateConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmPrivateConfigFromJson(json);

  Map<String, dynamic> toJson() => _$RtmPrivateConfigToJson(this);
}
