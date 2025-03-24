// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_handler_param_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtmEventHandlerOnLinkStateEventJson
    _$RtmEventHandlerOnLinkStateEventJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnLinkStateEventJson(
          event: json['event'] == null
              ? null
              : LinkStateEvent.fromJson(json['event'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$RtmEventHandlerOnLinkStateEventJsonToJson(
        RtmEventHandlerOnLinkStateEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnMessageEventJson _$RtmEventHandlerOnMessageEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnMessageEventJson(
      event: json['event'] == null
          ? null
          : MessageEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnMessageEventJsonToJson(
        RtmEventHandlerOnMessageEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnPresenceEventJson _$RtmEventHandlerOnPresenceEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnPresenceEventJson(
      event: json['event'] == null
          ? null
          : PresenceEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnPresenceEventJsonToJson(
        RtmEventHandlerOnPresenceEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnTopicEventJson _$RtmEventHandlerOnTopicEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnTopicEventJson(
      event: json['event'] == null
          ? null
          : TopicEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnTopicEventJsonToJson(
        RtmEventHandlerOnTopicEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnLockEventJson _$RtmEventHandlerOnLockEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLockEventJson(
      event: json['event'] == null
          ? null
          : LockEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnLockEventJsonToJson(
        RtmEventHandlerOnLockEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnStorageEventJson _$RtmEventHandlerOnStorageEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnStorageEventJson(
      event: json['event'] == null
          ? null
          : StorageEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnStorageEventJsonToJson(
        RtmEventHandlerOnStorageEventJson instance) =>
    <String, dynamic>{
      if (instance.event?.toJson() case final value?) 'event': value,
    };

RtmEventHandlerOnJoinResultJson _$RtmEventHandlerOnJoinResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnJoinResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      channelName: json['channelName'] as String?,
      userId: json['userId'] as String?,
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnJoinResultJsonToJson(
        RtmEventHandlerOnJoinResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
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
};

RtmEventHandlerOnLeaveResultJson _$RtmEventHandlerOnLeaveResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLeaveResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      channelName: json['channelName'] as String?,
      userId: json['userId'] as String?,
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnLeaveResultJsonToJson(
        RtmEventHandlerOnLeaveResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnPublishTopicMessageResultJson
    _$RtmEventHandlerOnPublishTopicMessageResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPublishTopicMessageResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          topic: json['topic'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPublishTopicMessageResultJsonToJson(
        RtmEventHandlerOnPublishTopicMessageResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.topic case final value?) 'topic': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnJoinTopicResultJson
    _$RtmEventHandlerOnJoinTopicResultJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnJoinTopicResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          userId: json['userId'] as String?,
          topic: json['topic'] as String?,
          meta: json['meta'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnJoinTopicResultJsonToJson(
        RtmEventHandlerOnJoinTopicResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.meta case final value?) 'meta': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnLeaveTopicResultJson
    _$RtmEventHandlerOnLeaveTopicResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnLeaveTopicResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          userId: json['userId'] as String?,
          topic: json['topic'] as String?,
          meta: json['meta'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnLeaveTopicResultJsonToJson(
        RtmEventHandlerOnLeaveTopicResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.meta case final value?) 'meta': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnSubscribeTopicResultJson
    _$RtmEventHandlerOnSubscribeTopicResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnSubscribeTopicResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          userId: json['userId'] as String?,
          topic: json['topic'] as String?,
          succeedUsers: json['succeedUsers'] == null
              ? null
              : UserList.fromJson(json['succeedUsers'] as Map<String, dynamic>),
          failedUsers: json['failedUsers'] == null
              ? null
              : UserList.fromJson(json['failedUsers'] as Map<String, dynamic>),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSubscribeTopicResultJsonToJson(
        RtmEventHandlerOnSubscribeTopicResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.succeedUsers?.toJson() case final value?)
        'succeedUsers': value,
      if (instance.failedUsers?.toJson() case final value?)
        'failedUsers': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnUnsubscribeTopicResultJson
    _$RtmEventHandlerOnUnsubscribeTopicResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnUnsubscribeTopicResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          topic: json['topic'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnUnsubscribeTopicResultJsonToJson(
        RtmEventHandlerOnUnsubscribeTopicResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.topic case final value?) 'topic': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetSubscribedUserListResultJson
    _$RtmEventHandlerOnGetSubscribedUserListResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnGetSubscribedUserListResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          topic: json['topic'] as String?,
          users: json['users'] == null
              ? null
              : UserList.fromJson(json['users'] as Map<String, dynamic>),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetSubscribedUserListResultJsonToJson(
        RtmEventHandlerOnGetSubscribedUserListResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.topic case final value?) 'topic': value,
      if (instance.users?.toJson() case final value?) 'users': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnConnectionStateChangedJson
    _$RtmEventHandlerOnConnectionStateChangedJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnConnectionStateChangedJson(
          channelName: json['channelName'] as String?,
          state:
              $enumDecodeNullable(_$RtmConnectionStateEnumMap, json['state']),
          reason: $enumDecodeNullable(
              _$RtmConnectionChangeReasonEnumMap, json['reason']),
        );

Map<String, dynamic> _$RtmEventHandlerOnConnectionStateChangedJsonToJson(
        RtmEventHandlerOnConnectionStateChangedJson instance) =>
    <String, dynamic>{
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmConnectionStateEnumMap[instance.state] case final value?)
        'state': value,
      if (_$RtmConnectionChangeReasonEnumMap[instance.reason] case final value?)
        'reason': value,
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

RtmEventHandlerOnTokenPrivilegeWillExpireJson
    _$RtmEventHandlerOnTokenPrivilegeWillExpireJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnTokenPrivilegeWillExpireJson(
          channelName: json['channelName'] as String?,
        );

Map<String, dynamic> _$RtmEventHandlerOnTokenPrivilegeWillExpireJsonToJson(
        RtmEventHandlerOnTokenPrivilegeWillExpireJson instance) =>
    <String, dynamic>{
      if (instance.channelName case final value?) 'channelName': value,
    };

RtmEventHandlerOnSubscribeResultJson
    _$RtmEventHandlerOnSubscribeResultJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnSubscribeResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSubscribeResultJsonToJson(
        RtmEventHandlerOnSubscribeResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnUnsubscribeResultJson
    _$RtmEventHandlerOnUnsubscribeResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnUnsubscribeResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnUnsubscribeResultJsonToJson(
        RtmEventHandlerOnUnsubscribeResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnPublishResultJson _$RtmEventHandlerOnPublishResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnPublishResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnPublishResultJsonToJson(
        RtmEventHandlerOnPublishResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnLoginResultJson _$RtmEventHandlerOnLoginResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLoginResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnLoginResultJsonToJson(
        RtmEventHandlerOnLoginResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnLogoutResultJson _$RtmEventHandlerOnLogoutResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLogoutResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnLogoutResultJsonToJson(
        RtmEventHandlerOnLogoutResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnRenewTokenResultJson
    _$RtmEventHandlerOnRenewTokenResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnRenewTokenResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          serverType:
              $enumDecodeNullable(_$RtmServiceTypeEnumMap, json['serverType']),
          channelName: json['channelName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnRenewTokenResultJsonToJson(
        RtmEventHandlerOnRenewTokenResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmServiceTypeEnumMap[instance.serverType] case final value?)
        'serverType': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

const _$RtmServiceTypeEnumMap = {
  RtmServiceType.none: 0,
  RtmServiceType.message: 1,
  RtmServiceType.stream: 2,
};

RtmEventHandlerOnSetChannelMetadataResultJson
    _$RtmEventHandlerOnSetChannelMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnSetChannelMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSetChannelMetadataResultJsonToJson(
        RtmEventHandlerOnSetChannelMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

const _$RtmChannelTypeEnumMap = {
  RtmChannelType.none: 0,
  RtmChannelType.message: 1,
  RtmChannelType.stream: 2,
  RtmChannelType.user: 3,
};

RtmEventHandlerOnUpdateChannelMetadataResultJson
    _$RtmEventHandlerOnUpdateChannelMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnUpdateChannelMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnUpdateChannelMetadataResultJsonToJson(
        RtmEventHandlerOnUpdateChannelMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnRemoveChannelMetadataResultJson
    _$RtmEventHandlerOnRemoveChannelMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnRemoveChannelMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnRemoveChannelMetadataResultJsonToJson(
        RtmEventHandlerOnRemoveChannelMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetChannelMetadataResultJson
    _$RtmEventHandlerOnGetChannelMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnGetChannelMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          data: json['data'] == null
              ? null
              : Metadata.fromJson(json['data'] as Map<String, dynamic>),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetChannelMetadataResultJsonToJson(
        RtmEventHandlerOnGetChannelMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.data?.toJson() case final value?) 'data': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnSetUserMetadataResultJson
    _$RtmEventHandlerOnSetUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnSetUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSetUserMetadataResultJsonToJson(
        RtmEventHandlerOnSetUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnUpdateUserMetadataResultJson
    _$RtmEventHandlerOnUpdateUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnUpdateUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnUpdateUserMetadataResultJsonToJson(
        RtmEventHandlerOnUpdateUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnRemoveUserMetadataResultJson
    _$RtmEventHandlerOnRemoveUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnRemoveUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnRemoveUserMetadataResultJsonToJson(
        RtmEventHandlerOnRemoveUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetUserMetadataResultJson
    _$RtmEventHandlerOnGetUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnGetUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          data: json['data'] == null
              ? null
              : Metadata.fromJson(json['data'] as Map<String, dynamic>),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetUserMetadataResultJsonToJson(
        RtmEventHandlerOnGetUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.data?.toJson() case final value?) 'data': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnSubscribeUserMetadataResultJson
    _$RtmEventHandlerOnSubscribeUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnSubscribeUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSubscribeUserMetadataResultJsonToJson(
        RtmEventHandlerOnSubscribeUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnUnsubscribeUserMetadataResultJson
    _$RtmEventHandlerOnUnsubscribeUserMetadataResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnUnsubscribeUserMetadataResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userId: json['userId'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnUnsubscribeUserMetadataResultJsonToJson(
        RtmEventHandlerOnUnsubscribeUserMetadataResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userId case final value?) 'userId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnSetLockResultJson _$RtmEventHandlerOnSetLockResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnSetLockResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      channelName: json['channelName'] as String?,
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
      lockName: json['lockName'] as String?,
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnSetLockResultJsonToJson(
        RtmEventHandlerOnSetLockResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockName case final value?) 'lockName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnRemoveLockResultJson
    _$RtmEventHandlerOnRemoveLockResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnRemoveLockResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          lockName: json['lockName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnRemoveLockResultJsonToJson(
        RtmEventHandlerOnRemoveLockResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockName case final value?) 'lockName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnReleaseLockResultJson
    _$RtmEventHandlerOnReleaseLockResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnReleaseLockResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          lockName: json['lockName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnReleaseLockResultJsonToJson(
        RtmEventHandlerOnReleaseLockResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockName case final value?) 'lockName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnAcquireLockResultJson
    _$RtmEventHandlerOnAcquireLockResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnAcquireLockResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          lockName: json['lockName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
          errorDetails: json['errorDetails'] as String?,
        );

Map<String, dynamic> _$RtmEventHandlerOnAcquireLockResultJsonToJson(
        RtmEventHandlerOnAcquireLockResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockName case final value?) 'lockName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
      if (instance.errorDetails case final value?) 'errorDetails': value,
    };

RtmEventHandlerOnRevokeLockResultJson
    _$RtmEventHandlerOnRevokeLockResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnRevokeLockResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          lockName: json['lockName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnRevokeLockResultJsonToJson(
        RtmEventHandlerOnRevokeLockResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockName case final value?) 'lockName': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetLocksResultJson
    _$RtmEventHandlerOnGetLocksResultJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnGetLocksResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          channelType:
              $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
          lockDetailList: (json['lockDetailList'] as List<dynamic>?)
              ?.map((e) => LockDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
          count: (json['count'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetLocksResultJsonToJson(
        RtmEventHandlerOnGetLocksResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.lockDetailList?.map((e) => e.toJson()).toList()
          case final value?)
        'lockDetailList': value,
      if (instance.count case final value?) 'count': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnWhoNowResultJson _$RtmEventHandlerOnWhoNowResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnWhoNowResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      userStateList: (json['userStateList'] as List<dynamic>?)
          ?.map((e) => UserState.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
      nextPage: json['nextPage'] as String?,
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnWhoNowResultJsonToJson(
        RtmEventHandlerOnWhoNowResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userStateList?.map((e) => e.toJson()).toList()
          case final value?)
        'userStateList': value,
      if (instance.count case final value?) 'count': value,
      if (instance.nextPage case final value?) 'nextPage': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetOnlineUsersResultJson
    _$RtmEventHandlerOnGetOnlineUsersResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnGetOnlineUsersResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          userStateList: (json['userStateList'] as List<dynamic>?)
              ?.map((e) => UserState.fromJson(e as Map<String, dynamic>))
              .toList(),
          count: (json['count'] as num?)?.toInt(),
          nextPage: json['nextPage'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetOnlineUsersResultJsonToJson(
        RtmEventHandlerOnGetOnlineUsersResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.userStateList?.map((e) => e.toJson()).toList()
          case final value?)
        'userStateList': value,
      if (instance.count case final value?) 'count': value,
      if (instance.nextPage case final value?) 'nextPage': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnWhereNowResultJson
    _$RtmEventHandlerOnWhereNowResultJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnWhereNowResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channels: (json['channels'] as List<dynamic>?)
              ?.map((e) => ChannelInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
          count: (json['count'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnWhereNowResultJsonToJson(
        RtmEventHandlerOnWhereNowResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channels?.map((e) => e.toJson()).toList() case final value?)
        'channels': value,
      if (instance.count case final value?) 'count': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnGetUserChannelsResultJson
    _$RtmEventHandlerOnGetUserChannelsResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnGetUserChannelsResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channels: json['channels'] == null
              ? null
              : ChannelInfo.fromJson(json['channels'] as Map<String, dynamic>),
          count: (json['count'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnGetUserChannelsResultJsonToJson(
        RtmEventHandlerOnGetUserChannelsResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.channels?.toJson() case final value?) 'channels': value,
      if (instance.count case final value?) 'count': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnPresenceSetStateResultJson
    _$RtmEventHandlerOnPresenceSetStateResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPresenceSetStateResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPresenceSetStateResultJsonToJson(
        RtmEventHandlerOnPresenceSetStateResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnPresenceRemoveStateResultJson
    _$RtmEventHandlerOnPresenceRemoveStateResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPresenceRemoveStateResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPresenceRemoveStateResultJsonToJson(
        RtmEventHandlerOnPresenceRemoveStateResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };

RtmEventHandlerOnPresenceGetStateResultJson
    _$RtmEventHandlerOnPresenceGetStateResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPresenceGetStateResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          state: json['state'] == null
              ? null
              : UserState.fromJson(json['state'] as Map<String, dynamic>),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPresenceGetStateResultJsonToJson(
        RtmEventHandlerOnPresenceGetStateResultJson instance) =>
    <String, dynamic>{
      if (instance.requestId case final value?) 'requestId': value,
      if (instance.state?.toJson() case final value?) 'state': value,
      if (_$RtmErrorCodeEnumMap[instance.errorCode] case final value?)
        'errorCode': value,
    };
