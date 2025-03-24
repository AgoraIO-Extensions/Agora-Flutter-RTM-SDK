// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_rtm_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtmConfig _$RtmConfigFromJson(Map<String, dynamic> json) => RtmConfig(
      areaCode: json['areaCode'] == null
          ? const {RtmAreaCode.glob}
          : const RtmAreaCodeListConverter()
              .fromJson((json['areaCode'] as num?)?.toInt()),
      protocolType:
          $enumDecodeNullable(_$RtmProtocolTypeEnumMap, json['protocolType']) ??
              RtmProtocolType.tcpUdp,
      presenceTimeout: (json['presenceTimeout'] as num?)?.toInt(),
      heartbeatInterval: (json['heartbeatInterval'] as num?)?.toInt(),
      useStringUserId: json['useStringUserId'] as bool? ?? true,
      logConfig: json['logConfig'] == null
          ? null
          : RtmLogConfig.fromJson(json['logConfig'] as Map<String, dynamic>),
      proxyConfig: json['proxyConfig'] == null
          ? null
          : RtmProxyConfig.fromJson(
              json['proxyConfig'] as Map<String, dynamic>),
      encryptionConfig: json['encryptionConfig'] == null
          ? null
          : RtmEncryptionConfig.fromJson(
              json['encryptionConfig'] as Map<String, dynamic>),
      privateConfig: json['privateConfig'] == null
          ? null
          : RtmPrivateConfig.fromJson(
              json['privateConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RtmConfigToJson(RtmConfig instance) => <String, dynamic>{
      if (const RtmAreaCodeListConverter().toJson(instance.areaCode)
          case final value?)
        'areaCode': value,
      if (_$RtmProtocolTypeEnumMap[instance.protocolType] case final value?)
        'protocolType': value,
      if (instance.presenceTimeout case final value?) 'presenceTimeout': value,
      if (instance.heartbeatInterval case final value?)
        'heartbeatInterval': value,
      if (instance.useStringUserId case final value?) 'useStringUserId': value,
      if (instance.logConfig?.toJson() case final value?) 'logConfig': value,
      if (instance.proxyConfig?.toJson() case final value?)
        'proxyConfig': value,
      if (instance.encryptionConfig?.toJson() case final value?)
        'encryptionConfig': value,
      if (instance.privateConfig?.toJson() case final value?)
        'privateConfig': value,
    };

const _$RtmProtocolTypeEnumMap = {
  RtmProtocolType.tcpUdp: 0,
  RtmProtocolType.tcpOnly: 1,
};

LinkStateEvent _$LinkStateEventFromJson(Map<String, dynamic> json) =>
    LinkStateEvent(
      currentState:
          $enumDecodeNullable(_$RtmLinkStateEnumMap, json['currentState']),
      previousState:
          $enumDecodeNullable(_$RtmLinkStateEnumMap, json['previousState']),
      serviceType:
          $enumDecodeNullable(_$RtmServiceTypeEnumMap, json['serviceType']),
      operation:
          $enumDecodeNullable(_$RtmLinkOperationEnumMap, json['operation']),
      reason: json['reason'] as String?,
      affectedChannels: (json['affectedChannels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      unrestoredChannels: (json['unrestoredChannels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isResumed: json['isResumed'] as bool?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LinkStateEventToJson(LinkStateEvent instance) =>
    <String, dynamic>{
      if (_$RtmLinkStateEnumMap[instance.currentState] case final value?)
        'currentState': value,
      if (_$RtmLinkStateEnumMap[instance.previousState] case final value?)
        'previousState': value,
      if (_$RtmServiceTypeEnumMap[instance.serviceType] case final value?)
        'serviceType': value,
      if (_$RtmLinkOperationEnumMap[instance.operation] case final value?)
        'operation': value,
      if (instance.reason case final value?) 'reason': value,
      if (instance.affectedChannels case final value?)
        'affectedChannels': value,
      if (instance.unrestoredChannels case final value?)
        'unrestoredChannels': value,
      if (instance.isResumed case final value?) 'isResumed': value,
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

const _$RtmServiceTypeEnumMap = {
  RtmServiceType.none: 0,
  RtmServiceType.message: 1,
  RtmServiceType.stream: 2,
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

MessageEvent _$MessageEventFromJson(Map<String, dynamic> json) => MessageEvent(
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
      messageType:
          $enumDecodeNullable(_$RtmMessageTypeEnumMap, json['messageType']),
      channelName: json['channelName'] as String?,
      channelTopic: json['channelTopic'] as String?,
      messageLength: (json['messageLength'] as num?)?.toInt(),
      publisher: json['publisher'] as String?,
      customType: json['customType'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageEventToJson(MessageEvent instance) =>
    <String, dynamic>{
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmMessageTypeEnumMap[instance.messageType] case final value?)
        'messageType': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.channelTopic case final value?) 'channelTopic': value,
      if (instance.messageLength case final value?) 'messageLength': value,
      if (instance.publisher case final value?) 'publisher': value,
      if (instance.customType case final value?) 'customType': value,
      if (instance.timestamp case final value?) 'timestamp': value,
    };

const _$RtmChannelTypeEnumMap = {
  RtmChannelType.none: 0,
  RtmChannelType.message: 1,
  RtmChannelType.stream: 2,
  RtmChannelType.user: 3,
};

const _$RtmMessageTypeEnumMap = {
  RtmMessageType.binary: 0,
  RtmMessageType.string: 1,
};

PresenceEvent _$PresenceEventFromJson(Map<String, dynamic> json) =>
    PresenceEvent(
      type: $enumDecodeNullable(_$RtmPresenceEventTypeEnumMap, json['type']),
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
      channelName: json['channelName'] as String?,
      publisher: json['publisher'] as String?,
      stateItems: (json['stateItems'] as List<dynamic>?)
          ?.map((e) => StateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      interval: json['interval'] == null
          ? null
          : IntervalInfo.fromJson(json['interval'] as Map<String, dynamic>),
      snapshot: json['snapshot'] == null
          ? null
          : SnapshotInfo.fromJson(json['snapshot'] as Map<String, dynamic>),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PresenceEventToJson(PresenceEvent instance) =>
    <String, dynamic>{
      if (_$RtmPresenceEventTypeEnumMap[instance.type] case final value?)
        'type': value,
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.publisher case final value?) 'publisher': value,
      if (instance.stateItems?.map((e) => e.toJson()).toList()
          case final value?)
        'stateItems': value,
      if (instance.interval?.toJson() case final value?) 'interval': value,
      if (instance.snapshot?.toJson() case final value?) 'snapshot': value,
      if (instance.timestamp case final value?) 'timestamp': value,
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

IntervalInfo _$IntervalInfoFromJson(Map<String, dynamic> json) => IntervalInfo(
      joinUserList: json['joinUserList'] == null
          ? null
          : UserList.fromJson(json['joinUserList'] as Map<String, dynamic>),
      leaveUserList: json['leaveUserList'] == null
          ? null
          : UserList.fromJson(json['leaveUserList'] as Map<String, dynamic>),
      timeoutUserList: json['timeoutUserList'] == null
          ? null
          : UserList.fromJson(json['timeoutUserList'] as Map<String, dynamic>),
      userStateList: (json['userStateList'] as List<dynamic>?)
          ?.map((e) => UserState.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IntervalInfoToJson(IntervalInfo instance) =>
    <String, dynamic>{
      if (instance.joinUserList?.toJson() case final value?)
        'joinUserList': value,
      if (instance.leaveUserList?.toJson() case final value?)
        'leaveUserList': value,
      if (instance.timeoutUserList?.toJson() case final value?)
        'timeoutUserList': value,
      if (instance.userStateList?.map((e) => e.toJson()).toList()
          case final value?)
        'userStateList': value,
    };

SnapshotInfo _$SnapshotInfoFromJson(Map<String, dynamic> json) => SnapshotInfo(
      userStateList: (json['userStateList'] as List<dynamic>?)
          ?.map((e) => UserState.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SnapshotInfoToJson(SnapshotInfo instance) =>
    <String, dynamic>{
      if (instance.userStateList?.map((e) => e.toJson()).toList()
          case final value?)
        'userStateList': value,
    };

TopicEvent _$TopicEventFromJson(Map<String, dynamic> json) => TopicEvent(
      type: $enumDecodeNullable(_$RtmTopicEventTypeEnumMap, json['type']),
      channelName: json['channelName'] as String?,
      publisher: json['publisher'] as String?,
      topicInfos: (json['topicInfos'] as List<dynamic>?)
          ?.map((e) => TopicInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TopicEventToJson(TopicEvent instance) =>
    <String, dynamic>{
      if (_$RtmTopicEventTypeEnumMap[instance.type] case final value?)
        'type': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.publisher case final value?) 'publisher': value,
      if (instance.topicInfos?.map((e) => e.toJson()).toList()
          case final value?)
        'topicInfos': value,
      if (instance.timestamp case final value?) 'timestamp': value,
    };

const _$RtmTopicEventTypeEnumMap = {
  RtmTopicEventType.none: 0,
  RtmTopicEventType.snapshot: 1,
  RtmTopicEventType.remoteJoinTopic: 2,
  RtmTopicEventType.remoteLeaveTopic: 3,
};

LockEvent _$LockEventFromJson(Map<String, dynamic> json) => LockEvent(
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
      eventType:
          $enumDecodeNullable(_$RtmLockEventTypeEnumMap, json['eventType']),
      channelName: json['channelName'] as String?,
      lockDetailList: (json['lockDetailList'] as List<dynamic>?)
          ?.map((e) => LockDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LockEventToJson(LockEvent instance) => <String, dynamic>{
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmLockEventTypeEnumMap[instance.eventType] case final value?)
        'eventType': value,
      if (instance.channelName case final value?) 'channelName': value,
      if (instance.lockDetailList?.map((e) => e.toJson()).toList()
          case final value?)
        'lockDetailList': value,
      if (instance.timestamp case final value?) 'timestamp': value,
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

StorageEvent _$StorageEventFromJson(Map<String, dynamic> json) => StorageEvent(
      channelType:
          $enumDecodeNullable(_$RtmChannelTypeEnumMap, json['channelType']),
      storageType:
          $enumDecodeNullable(_$RtmStorageTypeEnumMap, json['storageType']),
      eventType:
          $enumDecodeNullable(_$RtmStorageEventTypeEnumMap, json['eventType']),
      target: json['target'] as String?,
      data: json['data'] == null
          ? null
          : Metadata.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StorageEventToJson(StorageEvent instance) =>
    <String, dynamic>{
      if (_$RtmChannelTypeEnumMap[instance.channelType] case final value?)
        'channelType': value,
      if (_$RtmStorageTypeEnumMap[instance.storageType] case final value?)
        'storageType': value,
      if (_$RtmStorageEventTypeEnumMap[instance.eventType] case final value?)
        'eventType': value,
      if (instance.target case final value?) 'target': value,
      if (instance.data?.toJson() case final value?) 'data': value,
      if (instance.timestamp case final value?) 'timestamp': value,
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
