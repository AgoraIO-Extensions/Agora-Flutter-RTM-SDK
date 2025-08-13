// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_rtm_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtmLogConfig _$RtmLogConfigFromJson(Map<String, dynamic> json) => RtmLogConfig(
      filePath: json['filePath'] as String?,
      fileSizeInKB:
          (json['fileSizeInKB'] as num?)?.toInt() ?? defaultLogSizeInKb,
      level: $enumDecodeNullable(_$RtmLogLevelEnumMap, json['level']) ??
          RtmLogLevel.info,
    );

Map<String, dynamic> _$RtmLogConfigToJson(RtmLogConfig instance) =>
    <String, dynamic>{
      if (instance.filePath case final value?) 'filePath': value,
      if (instance.fileSizeInKB case final value?) 'fileSizeInKB': value,
      if (_$RtmLogLevelEnumMap[instance.level] case final value?)
        'level': value,
    };

const _$RtmLogLevelEnumMap = {
  RtmLogLevel.none: 0,
  RtmLogLevel.info: 1,
  RtmLogLevel.warn: 2,
  RtmLogLevel.error: 4,
  RtmLogLevel.fatal: 8,
};

UserList _$UserListFromJson(Map<String, dynamic> json) => UserList(
      users:
          (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserListToJson(UserList instance) => <String, dynamic>{
      if (instance.users case final value?) 'users': value,
    };

PublisherInfo _$PublisherInfoFromJson(Map<String, dynamic> json) =>
    PublisherInfo(
      publisherUserId: json['publisherUserId'] as String?,
      publisherMeta: json['publisherMeta'] as String?,
    );

Map<String, dynamic> _$PublisherInfoToJson(PublisherInfo instance) =>
    <String, dynamic>{
      if (instance.publisherUserId case final value?) 'publisherUserId': value,
      if (instance.publisherMeta case final value?) 'publisherMeta': value,
    };

TopicInfo _$TopicInfoFromJson(Map<String, dynamic> json) => TopicInfo(
      topic: json['topic'] as String?,
      publishers: (json['publishers'] as List<dynamic>?)
          ?.map((e) => PublisherInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopicInfoToJson(TopicInfo instance) => <String, dynamic>{
      if (instance.topic case final value?) 'topic': value,
      if (instance.publishers?.map((e) => e.toJson()).toList()
          case final value?)
        'publishers': value,
    };

StateItem _$StateItemFromJson(Map<String, dynamic> json) => StateItem(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$StateItemToJson(StateItem instance) => <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
    };

LockDetail _$LockDetailFromJson(Map<String, dynamic> json) => LockDetail(
      lockName: json['lockName'] as String?,
      owner: json['owner'] as String?,
      ttl: (json['ttl'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LockDetailToJson(LockDetail instance) =>
    <String, dynamic>{
      if (instance.lockName case final value?) 'lockName': value,
      if (instance.owner case final value?) 'owner': value,
      if (instance.ttl case final value?) 'ttl': value,
    };

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      userId: json['userId'] as String?,
      states: (json['states'] as List<dynamic>?)
          ?.map((e) => StateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      if (instance.userId case final value?) 'userId': value,
      if (instance.states?.map((e) => e.toJson()).toList() case final value?)
        'states': value,
    };

SubscribeOptions _$SubscribeOptionsFromJson(Map<String, dynamic> json) =>
    SubscribeOptions(
      withMessage: json['withMessage'] as bool? ?? true,
      withMetadata: json['withMetadata'] as bool? ?? false,
      withPresence: json['withPresence'] as bool? ?? true,
      withLock: json['withLock'] as bool? ?? false,
      beQuiet: json['beQuiet'] as bool? ?? false,
    );

Map<String, dynamic> _$SubscribeOptionsToJson(SubscribeOptions instance) =>
    <String, dynamic>{
      if (instance.withMessage case final value?) 'withMessage': value,
      if (instance.withMetadata case final value?) 'withMetadata': value,
      if (instance.withPresence case final value?) 'withPresence': value,
      if (instance.withLock case final value?) 'withLock': value,
      if (instance.beQuiet case final value?) 'beQuiet': value,
    };

ChannelInfo _$ChannelInfoFromJson(Map<String, dynamic> json) => ChannelInfo(
      channelName: json['channelName'] as String?,
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
    );

Map<String, dynamic> _$ChannelInfoToJson(ChannelInfo instance) =>
    <String, dynamic>{
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
    };

const _$RtmChannelTypeEnumMap = {
  RtmChannelType.none: 0,
  RtmChannelType.message: 1,
  RtmChannelType.stream: 2,
  RtmChannelType.user: 3,
};

PresenceOptions _$PresenceOptionsFromJson(Map<String, dynamic> json) =>
    PresenceOptions(
      includeUserId: json['includeUserId'] as bool? ?? true,
      includeState: json['includeState'] as bool? ?? false,
      page: json['page'] as String? ?? '',
    );

Map<String, dynamic> _$PresenceOptionsToJson(PresenceOptions instance) =>
    <String, dynamic>{
      if (instance.includeUserId case final value?) 'includeUserId': value,
      if (instance.includeState case final value?) 'includeState': value,
      if (instance.page case final value?) 'page': value,
    };

PublishOptions _$PublishOptionsFromJson(Map<String, dynamic> json) =>
    PublishOptions(
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']) ??
              RtmChannelType.message,
      messageType:
          $enumDecodeNullable(_$RtmMessageTypeEnumMap, json['messageType']) ??
              RtmMessageType.binary,
      customType: json['customType'] as String?,
      storeInHistory: json['storeInHistory'] as bool? ?? false,
    );

Map<String, dynamic> _$PublishOptionsToJson(PublishOptions instance) =>
    <String, dynamic>{
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmMessageTypeEnumMap[instance.messageType] case final value?)
        'messageType': value,
      if (instance.customType case final value?) 'customType': value,
      if (instance.storeInHistory case final value?) 'storeInHistory': value,
    };

const _$RtmMessageTypeEnumMap = {
  RtmMessageType.binary: 0,
  RtmMessageType.string: 1,
};

TopicMessageOptions _$TopicMessageOptionsFromJson(Map<String, dynamic> json) =>
    TopicMessageOptions(
      messageType:
          $enumDecodeNullable(_$RtmMessageTypeEnumMap, json['messageType']) ??
              RtmMessageType.binary,
      sendTs: (json['sendTs'] as num?)?.toInt() ?? 0,
      customType: json['customType'] as String?,
    );

Map<String, dynamic> _$TopicMessageOptionsToJson(
        TopicMessageOptions instance) =>
    <String, dynamic>{
      if (_$RtmMessageTypeEnumMap[instance.messageType] case final value?)
        'messageType': value,
      if (instance.sendTs case final value?) 'sendTs': value,
      if (instance.customType case final value?) 'customType': value,
    };

GetOnlineUsersOptions _$GetOnlineUsersOptionsFromJson(
        Map<String, dynamic> json) =>
    GetOnlineUsersOptions(
      includeUserId: json['includeUserId'] as bool? ?? true,
      includeState: json['includeState'] as bool? ?? false,
      page: json['page'] as String?,
    );

Map<String, dynamic> _$GetOnlineUsersOptionsToJson(
        GetOnlineUsersOptions instance) =>
    <String, dynamic>{
      if (instance.includeUserId case final value?) 'includeUserId': value,
      if (instance.includeState case final value?) 'includeState': value,
      if (instance.page case final value?) 'page': value,
    };

RtmProxyConfig _$RtmProxyConfigFromJson(Map<String, dynamic> json) =>
    RtmProxyConfig(
      proxyType:
          $enumDecodeNullable(_$RtmProxyTypeEnumMap, json['proxyType']) ??
              RtmProxyType.none,
      server: json['server'] as String?,
      port: (json['port'] as num?)?.toInt() ?? 0,
      account: json['account'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$RtmProxyConfigToJson(RtmProxyConfig instance) =>
    <String, dynamic>{
      if (_$RtmProxyTypeEnumMap[instance.proxyType] case final value?)
        'proxyType': value,
      if (instance.server case final value?) 'server': value,
      if (instance.port case final value?) 'port': value,
      if (instance.account case final value?) 'account': value,
      if (instance.password case final value?) 'password': value,
    };

const _$RtmProxyTypeEnumMap = {
  RtmProxyType.none: 0,
  RtmProxyType.http: 1,
  RtmProxyType.cloudTcp: 2,
};

RtmEncryptionConfig _$RtmEncryptionConfigFromJson(Map<String, dynamic> json) =>
    RtmEncryptionConfig(
      encryptionMode: $enumDecodeNullable(
              _$RtmEncryptionModeEnumMap, json['encryptionMode']) ??
          RtmEncryptionMode.none,
      encryptionKey: json['encryptionKey'] as String?,
    );

Map<String, dynamic> _$RtmEncryptionConfigToJson(
        RtmEncryptionConfig instance) =>
    <String, dynamic>{
      if (_$RtmEncryptionModeEnumMap[instance.encryptionMode] case final value?)
        'encryptionMode': value,
      if (instance.encryptionKey case final value?) 'encryptionKey': value,
    };

const _$RtmEncryptionModeEnumMap = {
  RtmEncryptionMode.none: 0,
  RtmEncryptionMode.aes128Gcm: 1,
  RtmEncryptionMode.aes256Gcm: 2,
};

RtmPrivateConfig _$RtmPrivateConfigFromJson(Map<String, dynamic> json) =>
    RtmPrivateConfig(
      serviceType: json['serviceType'] == null
          ? const {RtmServiceType.none}
          : const RtmServiceTypeListConverter()
              .fromJson((json['serviceType'] as num?)?.toInt()),
      accessPointHosts: (json['accessPointHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RtmPrivateConfigToJson(RtmPrivateConfig instance) =>
    <String, dynamic>{
      if (const RtmServiceTypeListConverter().toJson(instance.serviceType)
          case final value?)
        'serviceType': value,
      if (instance.accessPointHosts case final value?)
        'accessPointHosts': value,
    };

GetHistoryMessagesOptions _$GetHistoryMessagesOptionsFromJson(
        Map<String, dynamic> json) =>
    GetHistoryMessagesOptions(
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 100,
      start: (json['start'] as num?)?.toInt() ?? 0,
      end: (json['end'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GetHistoryMessagesOptionsToJson(
        GetHistoryMessagesOptions instance) =>
    <String, dynamic>{
      if (instance.messageCount case final value?) 'messageCount': value,
      if (instance.start case final value?) 'start': value,
      if (instance.end case final value?) 'end': value,
    };

HistoryMessage _$HistoryMessageFromJson(Map<String, dynamic> json) =>
    HistoryMessage(
      messageType:
          $enumDecodeNullable(_$RtmMessageTypeEnumMap, json['messageType']) ??
              RtmMessageType.binary,
      publisher: json['publisher'] as String?,
      messageLength: (json['messageLength'] as num?)?.toInt() ?? 0,
      customType: json['customType'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HistoryMessageToJson(HistoryMessage instance) =>
    <String, dynamic>{
      if (_$RtmMessageTypeEnumMap[instance.messageType] case final value?)
        'messageType': value,
      if (instance.publisher case final value?) 'publisher': value,
      if (instance.messageLength case final value?) 'messageLength': value,
      if (instance.customType case final value?) 'customType': value,
      if (instance.timestamp case final value?) 'timestamp': value,
    };

const _$RtmLinkStateEnumMap = {
  RtmLinkState.idle: 0,
  RtmLinkState.connecting: 1,
  RtmLinkState.connected: 2,
  RtmLinkState.disconnected: 3,
  RtmLinkState.suspended: 4,
  RtmLinkState.failed: 5,
};

const _$RtmLinkOperationEnumMap = {
  RtmLinkOperation.login: 0,
  RtmLinkOperation.logout: 1,
  RtmLinkOperation.join: 2,
  RtmLinkOperation.leave: 3,
  RtmLinkOperation.serverReject: 4,
  RtmLinkOperation.autoReconnect: 5,
  RtmLinkOperation.reconnected: 6,
  RtmLinkOperation.heartbeatLost: 7,
  RtmLinkOperation.serverTimeout: 8,
  RtmLinkOperation.networkChange: 9,
};

const _$RtmServiceTypeEnumMap = {
  RtmServiceType.none: 0,
  RtmServiceType.message: 1,
  RtmServiceType.stream: 2,
};

const _$RtmLinkStateChangeReasonEnumMap = {
  RtmLinkStateChangeReason.unknown: 0,
  RtmLinkStateChangeReason.login: 1,
  RtmLinkStateChangeReason.loginSuccess: 2,
  RtmLinkStateChangeReason.loginTimeout: 3,
  RtmLinkStateChangeReason.loginNotAuthorized: 4,
  RtmLinkStateChangeReason.loginRejected: 5,
  RtmLinkStateChangeReason.relogin: 6,
  RtmLinkStateChangeReason.logout: 7,
  RtmLinkStateChangeReason.autoReconnect: 8,
  RtmLinkStateChangeReason.reconnectTimeout: 9,
  RtmLinkStateChangeReason.reconnectSuccess: 10,
  RtmLinkStateChangeReason.join: 11,
  RtmLinkStateChangeReason.joinSuccess: 12,
  RtmLinkStateChangeReason.joinFailed: 13,
  RtmLinkStateChangeReason.rejoin: 14,
  RtmLinkStateChangeReason.leave: 15,
  RtmLinkStateChangeReason.invalidToken: 16,
  RtmLinkStateChangeReason.tokenExpired: 17,
  RtmLinkStateChangeReason.inconsistentAppId: 18,
  RtmLinkStateChangeReason.invalidChannelName: 19,
  RtmLinkStateChangeReason.invalidUserId: 20,
  RtmLinkStateChangeReason.notInitialized: 21,
  RtmLinkStateChangeReason.rtmServiceNotConnected: 22,
  RtmLinkStateChangeReason.channelInstanceExceedLimitation: 23,
  RtmLinkStateChangeReason.operationRateExceedLimitation: 24,
  RtmLinkStateChangeReason.channelInErrorState: 25,
  RtmLinkStateChangeReason.presenceNotConnected: 26,
  RtmLinkStateChangeReason.sameUidLogin: 27,
  RtmLinkStateChangeReason.kickedOutByServer: 28,
  RtmLinkStateChangeReason.keepAliveTimeout: 29,
  RtmLinkStateChangeReason.connectionError: 30,
  RtmLinkStateChangeReason.presenceNotReady: 31,
  RtmLinkStateChangeReason.networkChange: 32,
  RtmLinkStateChangeReason.serviceNotSupported: 33,
  RtmLinkStateChangeReason.streamChannelNotAvailable: 34,
  RtmLinkStateChangeReason.storageNotAvailable: 35,
  RtmLinkStateChangeReason.lockNotAvailable: 36,
  RtmLinkStateChangeReason.loginTooFrequent: 37,
};

const _$RtmProtocolTypeEnumMap = {
  RtmProtocolType.tcpUdp: 0,
  RtmProtocolType.tcpOnly: 1,
};

const _$RtmAreaCodeEnumMap = {
  RtmAreaCode.cn: 1,
  RtmAreaCode.na: 2,
  RtmAreaCode.eu: 4,
  RtmAreaCode.asm: 8,
  RtmAreaCode.jp: 16,
  RtmAreaCode.ind: 32,
  RtmAreaCode.glob: 4294967295,
};

const _$RtmErrorCodeEnumMap = {
  RtmErrorCode.ok: 0,
  RtmErrorCode.notInitialized: -10001,
  RtmErrorCode.notLogin: -10002,
  RtmErrorCode.invalidAppId: -10003,
  RtmErrorCode.invalidEventHandler: -10004,
  RtmErrorCode.invalidToken: -10005,
  RtmErrorCode.invalidUserId: -10006,
  RtmErrorCode.initServiceFailed: -10007,
  RtmErrorCode.invalidChannelName: -10008,
  RtmErrorCode.tokenExpired: -10009,
  RtmErrorCode.loginNoServerResources: -10010,
  RtmErrorCode.loginTimeout: -10011,
  RtmErrorCode.loginRejected: -10012,
  RtmErrorCode.loginAborted: -10013,
  RtmErrorCode.invalidParameter: -10014,
  RtmErrorCode.loginNotAuthorized: -10015,
  RtmErrorCode.inconsistentAppid: -10016,
  RtmErrorCode.duplicateOperation: -10017,
  RtmErrorCode.instanceAlreadyReleased: -10018,
  RtmErrorCode.invalidChannelType: -10019,
  RtmErrorCode.invalidEncryptionParameter: -10020,
  RtmErrorCode.operationRateExceedLimitation: -10021,
  RtmErrorCode.serviceNotSupported: -10022,
  RtmErrorCode.loginCanceled: -10023,
  RtmErrorCode.invalidPrivateConfig: -10024,
  RtmErrorCode.notConnected: -10025,
  RtmErrorCode.renewTokenTimeout: -10026,
  RtmErrorCode.channelNotJoined: -11001,
  RtmErrorCode.channelNotSubscribed: -11002,
  RtmErrorCode.channelExceedTopicUserLimitation: -11003,
  RtmErrorCode.channelInReuse: -11004,
  RtmErrorCode.channelInstanceExceedLimitation: -11005,
  RtmErrorCode.channelInErrorState: -11006,
  RtmErrorCode.channelJoinFailed: -11007,
  RtmErrorCode.channelInvalidTopicName: -11008,
  RtmErrorCode.channelInvalidMessage: -11009,
  RtmErrorCode.channelMessageLengthExceedLimitation: -11010,
  RtmErrorCode.channelInvalidUserList: -11011,
  RtmErrorCode.channelNotAvailable: -11012,
  RtmErrorCode.channelTopicNotSubscribed: -11013,
  RtmErrorCode.channelExceedTopicLimitation: -11014,
  RtmErrorCode.channelJoinTopicFailed: -11015,
  RtmErrorCode.channelTopicNotJoined: -11016,
  RtmErrorCode.channelTopicNotExist: -11017,
  RtmErrorCode.channelInvalidTopicMeta: -11018,
  RtmErrorCode.channelSubscribeTimeout: -11019,
  RtmErrorCode.channelSubscribeTooFrequent: -11020,
  RtmErrorCode.channelSubscribeFailed: -11021,
  RtmErrorCode.channelUnsubscribeFailed: -11022,
  RtmErrorCode.channelEncryptMessageFailed: -11023,
  RtmErrorCode.channelPublishMessageFailed: -11024,
  RtmErrorCode.channelPublishMessageTooFrequent: -11025,
  RtmErrorCode.channelPublishMessageTimeout: -11026,
  RtmErrorCode.channelNotConnected: -11027,
  RtmErrorCode.channelLeaveFailed: -11028,
  RtmErrorCode.channelCustomTypeLengthOverflow: -11029,
  RtmErrorCode.channelInvalidCustomType: -11030,
  RtmErrorCode.channelUnsupportedMessageType: -11031,
  RtmErrorCode.channelPresenceNotReady: -11032,
  RtmErrorCode.channelReceiverOffline: -11033,
  RtmErrorCode.channelJoinCanceled: -11034,
  RtmErrorCode.channelReceiverOfflineButStoreSucceeded: -11035,
  RtmErrorCode.channelReceiverOfflineAndStoreFailed: -11036,
  RtmErrorCode.channelMessageDeliveredButStoreFailed: -11037,
  RtmErrorCode.storageOperationFailed: -12001,
  RtmErrorCode.storageMetadataItemExceedLimitation: -12002,
  RtmErrorCode.storageInvalidMetadataItem: -12003,
  RtmErrorCode.storageInvalidArgument: -12004,
  RtmErrorCode.storageInvalidRevision: -12005,
  RtmErrorCode.storageMetadataLengthOverflow: -12006,
  RtmErrorCode.storageInvalidLockName: -12007,
  RtmErrorCode.storageLockNotAcquired: -12008,
  RtmErrorCode.storageInvalidKey: -12009,
  RtmErrorCode.storageInvalidValue: -12010,
  RtmErrorCode.storageKeyLengthOverflow: -12011,
  RtmErrorCode.storageValueLengthOverflow: -12012,
  RtmErrorCode.storageDuplicateKey: -12013,
  RtmErrorCode.storageOutdatedRevision: -12014,
  RtmErrorCode.storageNotSubscribe: -12015,
  RtmErrorCode.storageInvalidMetadataInstance: -12016,
  RtmErrorCode.storageSubscribeUserExceedLimitation: -12017,
  RtmErrorCode.storageOperationTimeout: -12018,
  RtmErrorCode.storageNotAvailable: -12019,
  RtmErrorCode.presenceNotConnected: -13001,
  RtmErrorCode.presenceNotWritable: -13002,
  RtmErrorCode.presenceInvalidArgument: -13003,
  RtmErrorCode.presenceCachedTooManyStates: -13004,
  RtmErrorCode.presenceStateCountOverflow: -13005,
  RtmErrorCode.presenceInvalidStateKey: -13006,
  RtmErrorCode.presenceInvalidStateValue: -13007,
  RtmErrorCode.presenceStateKeySizeOverflow: -13008,
  RtmErrorCode.presenceStateValueSizeOverflow: -13009,
  RtmErrorCode.presenceStateDuplicateKey: -13010,
  RtmErrorCode.presenceUserNotExist: -13011,
  RtmErrorCode.presenceOperationTimeout: -13012,
  RtmErrorCode.presenceOperationFailed: -13013,
  RtmErrorCode.lockOperationFailed: -14001,
  RtmErrorCode.lockOperationTimeout: -14002,
  RtmErrorCode.lockOperationPerforming: -14003,
  RtmErrorCode.lockAlreadyExist: -14004,
  RtmErrorCode.lockInvalidName: -14005,
  RtmErrorCode.lockNotAcquired: -14006,
  RtmErrorCode.lockAcquireFailed: -14007,
  RtmErrorCode.lockNotExist: -14008,
  RtmErrorCode.lockNotAvailable: -14009,
  RtmErrorCode.historyOperationFailed: -15001,
  RtmErrorCode.historyInvalidTimestamp: -15002,
  RtmErrorCode.historyOperationTimeout: -15003,
  RtmErrorCode.historyOperationNotPermitted: -15004,
  RtmErrorCode.historyNotAvailable: -15005,
};

const _$RtmConnectionStateEnumMap = {
  RtmConnectionState.disconnected: 1,
  RtmConnectionState.connecting: 2,
  RtmConnectionState.connected: 3,
  RtmConnectionState.reconnecting: 4,
  RtmConnectionState.failed: 5,
};

const _$RtmConnectionChangeReasonEnumMap = {
  RtmConnectionChangeReason.connecting: 0,
  RtmConnectionChangeReason.joinSuccess: 1,
  RtmConnectionChangeReason.interrupted: 2,
  RtmConnectionChangeReason.bannedByServer: 3,
  RtmConnectionChangeReason.joinFailed: 4,
  RtmConnectionChangeReason.leaveChannel: 5,
  RtmConnectionChangeReason.invalidAppId: 6,
  RtmConnectionChangeReason.invalidChannelName: 7,
  RtmConnectionChangeReason.invalidToken: 8,
  RtmConnectionChangeReason.tokenExpired: 9,
  RtmConnectionChangeReason.rejectedByServer: 10,
  RtmConnectionChangeReason.settingProxyServer: 11,
  RtmConnectionChangeReason.renewToken: 12,
  RtmConnectionChangeReason.clientIpAddressChanged: 13,
  RtmConnectionChangeReason.keepAliveTimeout: 14,
  RtmConnectionChangeReason.rejoinSuccess: 15,
  RtmConnectionChangeReason.lost: 16,
  RtmConnectionChangeReason.echoTest: 17,
  RtmConnectionChangeReason.clientIpAddressChangedByUser: 18,
  RtmConnectionChangeReason.sameUidLogin: 19,
  RtmConnectionChangeReason.tooManyBroadcasters: 20,
  RtmConnectionChangeReason.licenseValidationFailure: 21,
  RtmConnectionChangeReason.certificationVerifyFailure: 22,
  RtmConnectionChangeReason.streamChannelNotAvailable: 23,
  RtmConnectionChangeReason.inconsistentAppid: 24,
  RtmConnectionChangeReason.loginSuccess: 10001,
  RtmConnectionChangeReason.logout: 10002,
  RtmConnectionChangeReason.presenceNotReady: 10003,
};

const _$RtmStorageTypeEnumMap = {
  RtmStorageType.none: 0,
  RtmStorageType.user: 1,
  RtmStorageType.channel: 2,
};

const _$RtmStorageEventTypeEnumMap = {
  RtmStorageEventType.none: 0,
  RtmStorageEventType.snapshot: 1,
  RtmStorageEventType.set: 2,
  RtmStorageEventType.update: 3,
  RtmStorageEventType.remove: 4,
};

const _$RtmLockEventTypeEnumMap = {
  RtmLockEventType.none: 0,
  RtmLockEventType.snapshot: 1,
  RtmLockEventType.lockSet: 2,
  RtmLockEventType.lockRemoved: 3,
  RtmLockEventType.lockAcquired: 4,
  RtmLockEventType.lockReleased: 5,
  RtmLockEventType.lockExpired: 6,
};

const _$RtmTopicEventTypeEnumMap = {
  RtmTopicEventType.none: 0,
  RtmTopicEventType.snapshot: 1,
  RtmTopicEventType.remoteJoinTopic: 2,
  RtmTopicEventType.remoteLeaveTopic: 3,
};

const _$RtmPresenceEventTypeEnumMap = {
  RtmPresenceEventType.none: 0,
  RtmPresenceEventType.snapshot: 1,
  RtmPresenceEventType.interval: 2,
  RtmPresenceEventType.remoteJoinChannel: 3,
  RtmPresenceEventType.remoteLeaveChannel: 4,
  RtmPresenceEventType.remoteTimeout: 5,
  RtmPresenceEventType.remoteStateChanged: 6,
  RtmPresenceEventType.errorOutOfService: 7,
};
