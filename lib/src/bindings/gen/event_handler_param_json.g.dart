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
    RtmEventHandlerOnLinkStateEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnMessageEventJson _$RtmEventHandlerOnMessageEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnMessageEventJson(
      event: json['event'] == null
          ? null
          : MessageEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnMessageEventJsonToJson(
    RtmEventHandlerOnMessageEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnPresenceEventJson _$RtmEventHandlerOnPresenceEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnPresenceEventJson(
      event: json['event'] == null
          ? null
          : PresenceEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnPresenceEventJsonToJson(
    RtmEventHandlerOnPresenceEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnTopicEventJson _$RtmEventHandlerOnTopicEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnTopicEventJson(
      event: json['event'] == null
          ? null
          : TopicEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnTopicEventJsonToJson(
    RtmEventHandlerOnTopicEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnLockEventJson _$RtmEventHandlerOnLockEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLockEventJson(
      event: json['event'] == null
          ? null
          : LockEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnLockEventJsonToJson(
    RtmEventHandlerOnLockEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnStorageEventJson _$RtmEventHandlerOnStorageEventJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnStorageEventJson(
      event: json['event'] == null
          ? null
          : StorageEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmEventHandlerOnStorageEventJsonToJson(
    RtmEventHandlerOnStorageEventJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event', instance.event?.toJson());
  return val;
}

RtmEventHandlerOnJoinResultJson _$RtmEventHandlerOnJoinResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnJoinResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      channelName: json['channelName'] as String?,
      userId: json['userId'] as String?,
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnJoinResultJsonToJson(
    RtmEventHandlerOnJoinResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnLeaveResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnPublishTopicMessageResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('topic', instance.topic);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnJoinTopicResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('userId', instance.userId);
  writeNotNull('topic', instance.topic);
  writeNotNull('meta', instance.meta);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnLeaveTopicResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('userId', instance.userId);
  writeNotNull('topic', instance.topic);
  writeNotNull('meta', instance.meta);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnSubscribeTopicResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('userId', instance.userId);
  writeNotNull('topic', instance.topic);
  writeNotNull('succeedUsers', instance.succeedUsers?.toJson());
  writeNotNull('failedUsers', instance.failedUsers?.toJson());
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnUnsubscribeTopicResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('topic', instance.topic);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetSubscribedUserListResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('topic', instance.topic);
  writeNotNull('users', instance.users?.toJson());
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnConnectionStateChangedJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('channelName', instance.channelName);
  writeNotNull('state', _$RtmConnectionStateEnumMap[instance.state]);
  writeNotNull('reason', _$RtmConnectionChangeReasonEnumMap[instance.reason]);
  return val;
}

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
    RtmEventHandlerOnTokenPrivilegeWillExpireJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('channelName', instance.channelName);
  return val;
}

RtmEventHandlerOnSubscribeResultJson
    _$RtmEventHandlerOnSubscribeResultJsonFromJson(Map<String, dynamic> json) =>
        RtmEventHandlerOnSubscribeResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          channelName: json['channelName'] as String?,
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnSubscribeResultJsonToJson(
    RtmEventHandlerOnSubscribeResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnUnsubscribeResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

RtmEventHandlerOnPublishResultJson _$RtmEventHandlerOnPublishResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnPublishResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnPublishResultJsonToJson(
    RtmEventHandlerOnPublishResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

RtmEventHandlerOnLoginResultJson _$RtmEventHandlerOnLoginResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLoginResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnLoginResultJsonToJson(
    RtmEventHandlerOnLoginResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

RtmEventHandlerOnLogoutResultJson _$RtmEventHandlerOnLogoutResultJsonFromJson(
        Map<String, dynamic> json) =>
    RtmEventHandlerOnLogoutResultJson(
      requestId: (json['requestId'] as num?)?.toInt(),
      errorCode: $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$RtmEventHandlerOnLogoutResultJsonToJson(
    RtmEventHandlerOnLogoutResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnRenewTokenResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('serverType', _$RtmServiceTypeEnumMap[instance.serverType]);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnSetChannelMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnUpdateChannelMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnRemoveChannelMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetChannelMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('data', instance.data?.toJson());
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnSetUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnUpdateUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnRemoveUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('data', instance.data?.toJson());
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnSubscribeUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnUnsubscribeUserMetadataResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('userId', instance.userId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnSetLockResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockName', instance.lockName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnRemoveLockResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockName', instance.lockName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnReleaseLockResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockName', instance.lockName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnAcquireLockResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockName', instance.lockName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  writeNotNull('errorDetails', instance.errorDetails);
  return val;
}

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
    RtmEventHandlerOnRevokeLockResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockName', instance.lockName);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetLocksResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channelName', instance.channelName);
  writeNotNull('channelType', _$RtmChannelTypeEnumMap[instance.channelType]);
  writeNotNull('lockDetailList',
      instance.lockDetailList?.map((e) => e.toJson()).toList());
  writeNotNull('count', instance.count);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnWhoNowResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull(
      'userStateList', instance.userStateList?.map((e) => e.toJson()).toList());
  writeNotNull('count', instance.count);
  writeNotNull('nextPage', instance.nextPage);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetOnlineUsersResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull(
      'userStateList', instance.userStateList?.map((e) => e.toJson()).toList());
  writeNotNull('count', instance.count);
  writeNotNull('nextPage', instance.nextPage);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnWhereNowResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channels', instance.channels?.map((e) => e.toJson()).toList());
  writeNotNull('count', instance.count);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnGetUserChannelsResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('channels', instance.channels?.toJson());
  writeNotNull('count', instance.count);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

RtmEventHandlerOnPresenceSetStateResultJson
    _$RtmEventHandlerOnPresenceSetStateResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPresenceSetStateResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPresenceSetStateResultJsonToJson(
    RtmEventHandlerOnPresenceSetStateResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

RtmEventHandlerOnPresenceRemoveStateResultJson
    _$RtmEventHandlerOnPresenceRemoveStateResultJsonFromJson(
            Map<String, dynamic> json) =>
        RtmEventHandlerOnPresenceRemoveStateResultJson(
          requestId: (json['requestId'] as num?)?.toInt(),
          errorCode:
              $enumDecodeNullable(_$RtmErrorCodeEnumMap, json['errorCode']),
        );

Map<String, dynamic> _$RtmEventHandlerOnPresenceRemoveStateResultJsonToJson(
    RtmEventHandlerOnPresenceRemoveStateResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}

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
    RtmEventHandlerOnPresenceGetStateResultJson instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('requestId', instance.requestId);
  writeNotNull('state', instance.state?.toJson());
  writeNotNull('errorCode', _$RtmErrorCodeEnumMap[instance.errorCode]);
  return val;
}
