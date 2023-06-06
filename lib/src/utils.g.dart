// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtmMessage _$RtmMessageFromJson(Map json) => RtmMessage._(
      json['text'] as String,
      $enumDecode(_$RtmMessageTypeEnumMap, json['messageType']),
      rawMessage: RtmMessage._rawMessage(json['rawMessage'] as Uint8List?),
      serverReceivedTs: json['serverReceivedTs'] as int?,
      isOfflineMessage: json['isOfflineMessage'] as bool?,
    );

Map<String, dynamic> _$RtmMessageToJson(RtmMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'rawMessage': RtmMessage._rawMessage(instance.rawMessage),
      'messageType': _$RtmMessageTypeEnumMap[instance.messageType]!,
      'serverReceivedTs': instance.serverReceivedTs,
      'isOfflineMessage': instance.isOfflineMessage,
    };

const _$RtmMessageTypeEnumMap = {
  RtmMessageType.undefined: 0,
  RtmMessageType.text: 1,
  RtmMessageType.raw: 2,
};

RtmChannelMember _$RtmChannelMemberFromJson(Map json) => RtmChannelMember(
      json['userId'] as String,
      json['channelId'] as String,
    );

Map<String, dynamic> _$RtmChannelMemberToJson(RtmChannelMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'channelId': instance.channelId,
    };

RtmAttribute _$RtmAttributeFromJson(Map json) => RtmAttribute(
      json['key'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$RtmAttributeToJson(RtmAttribute instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

RtmChannelAttribute _$RtmChannelAttributeFromJson(Map json) =>
    RtmChannelAttribute(
      json['key'] as String,
      json['value'] as String,
      lastUpdateUserId: json['lastUpdateUserId'] as String?,
      lastUpdateTs: json['lastUpdateTs'] as int?,
    );

Map<String, dynamic> _$RtmChannelAttributeToJson(
        RtmChannelAttribute instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'lastUpdateUserId': instance.lastUpdateUserId,
      'lastUpdateTs': instance.lastUpdateTs,
    };

LocalInvitation _$LocalInvitationFromJson(Map json) => LocalInvitation._(
      json['calleeId'] as String,
      content: json['content'] as String?,
      response: json['response'] as String?,
      channelId: json['channelId'] as String?,
      state: $enumDecodeNullable(
              _$RtmLocalInvitationStateEnumMap, json['state']) ??
          RtmLocalInvitationState.idle,
      handle: json['hashCode'] as int? ?? 0,
    );

Map<String, dynamic> _$LocalInvitationToJson(LocalInvitation instance) =>
    <String, dynamic>{
      'calleeId': instance.calleeId,
      'content': instance.content,
      'response': instance.response,
      'channelId': instance.channelId,
      'state': _$RtmLocalInvitationStateEnumMap[instance.state]!,
      'hashCode': instance.handle,
    };

const _$RtmLocalInvitationStateEnumMap = {
  RtmLocalInvitationState.idle: 0,
  RtmLocalInvitationState.sentToRemote: 1,
  RtmLocalInvitationState.receivedByRemote: 2,
  RtmLocalInvitationState.acceptedByRemote: 3,
  RtmLocalInvitationState.refusedByLocal: 4,
  RtmLocalInvitationState.canceled: 5,
  RtmLocalInvitationState.failure: 6,
};

RemoteInvitation _$RemoteInvitationFromJson(Map json) => RemoteInvitation._(
      json['callerId'] as String,
      content: json['content'] as String?,
      response: json['response'] as String?,
      channelId: json['channelId'] as String?,
      state: $enumDecodeNullable(
              _$RtmRemoteInvitationStateEnumMap, json['state']) ??
          RtmRemoteInvitationState.idle,
      handle: json['hashCode'] as int? ?? 0,
    );

Map<String, dynamic> _$RemoteInvitationToJson(RemoteInvitation instance) =>
    <String, dynamic>{
      'callerId': instance.callerId,
      'content': instance.content,
      'response': instance.response,
      'channelId': instance.channelId,
      'state': _$RtmRemoteInvitationStateEnumMap[instance.state]!,
      'hashCode': instance.handle,
    };

const _$RtmRemoteInvitationStateEnumMap = {
  RtmRemoteInvitationState.idle: 0,
  RtmRemoteInvitationState.invitationReceived: 1,
  RtmRemoteInvitationState.acceptSentToLocal: 2,
  RtmRemoteInvitationState.refused: 3,
  RtmRemoteInvitationState.accepted: 4,
  RtmRemoteInvitationState.canceled: 5,
  RtmRemoteInvitationState.failure: 6,
};

ChannelAttributeOptions _$ChannelAttributeOptionsFromJson(Map json) =>
    ChannelAttributeOptions(
      json['enableNotificationToChannelMembers'] as bool,
    );

Map<String, dynamic> _$ChannelAttributeOptionsToJson(
        ChannelAttributeOptions instance) =>
    <String, dynamic>{
      'enableNotificationToChannelMembers':
          instance.enableNotificationToChannelMembers,
    };

SendMessageOptions _$SendMessageOptionsFromJson(Map json) => SendMessageOptions(
      enableOfflineMessaging: json['enableOfflineMessaging'] as bool?,
      enableHistoricalMessaging: json['enableHistoricalMessaging'] as bool?,
    );

Map<String, dynamic> _$SendMessageOptionsToJson(SendMessageOptions instance) =>
    <String, dynamic>{
      'enableOfflineMessaging': instance.enableOfflineMessaging,
      'enableHistoricalMessaging': instance.enableHistoricalMessaging,
    };

RtmChannelMemberCount _$RtmChannelMemberCountFromJson(Map json) =>
    RtmChannelMemberCount(
      json['channelId'] as String,
      json['memberCount'] as int,
    );

Map<String, dynamic> _$RtmChannelMemberCountToJson(
        RtmChannelMemberCount instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'memberCount': instance.memberCount,
    };

RtmServiceContext _$RtmServiceContextFromJson(Map json) => RtmServiceContext(
      areaCode: (json['areaCode'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$RtmAreaCodeEnumMap, e))
              .toList() ??
          const [RtmAreaCode.GLOB],
      proxyType:
          $enumDecodeNullable(_$RtmCloudProxyTypeEnumMap, json['proxyType']) ??
              RtmCloudProxyType.noneProxy,
    );

Map<String, dynamic> _$RtmServiceContextToJson(RtmServiceContext instance) =>
    <String, dynamic>{
      'areaCode':
          instance.areaCode.map((e) => _$RtmAreaCodeEnumMap[e]!).toList(),
      'proxyType': _$RtmCloudProxyTypeEnumMap[instance.proxyType]!,
    };

const _$RtmAreaCodeEnumMap = {
  RtmAreaCode.CN: 0,
  RtmAreaCode.NA: 2,
  RtmAreaCode.EU: 4,
  RtmAreaCode.AS: 8,
  RtmAreaCode.JP: 16,
  RtmAreaCode.IN: 32,
  RtmAreaCode.GLOB: -1,
};

const _$RtmCloudProxyTypeEnumMap = {
  RtmCloudProxyType.noneProxy: 0,
  RtmCloudProxyType.tcpProxy: 1,
};

const _$RtmConnectionStateEnumMap = {
  RtmConnectionState.disconnected: 1,
  RtmConnectionState.connecting: 2,
  RtmConnectionState.connected: 3,
  RtmConnectionState.reconnecting: 4,
  RtmConnectionState.aborted: 5,
};

const _$RtmConnectionChangeReasonEnumMap = {
  RtmConnectionChangeReason.login: 1,
  RtmConnectionChangeReason.loginSuccess: 2,
  RtmConnectionChangeReason.loginFailure: 3,
  RtmConnectionChangeReason.loginTimeout: 4,
  RtmConnectionChangeReason.interrupt: 5,
  RtmConnectionChangeReason.logout: 6,
  RtmConnectionChangeReason.bannedByServer: 7,
  RtmConnectionChangeReason.remoteLogin: 8,
  RtmConnectionChangeReason.tokenExpired: 9,
};

const _$RtmPeerOnlineStateEnumMap = {
  RtmPeerOnlineState.online: 0,
  RtmPeerOnlineState.unreachable: 1,
  RtmPeerOnlineState.offline: 2,
};

const _$RtmPeerSubscriptionOptionEnumMap = {
  RtmPeerSubscriptionOption.onlineStatus: 0,
};

const _$RtmLogFilterEnumMap = {
  RtmLogFilter.off: 0,
  RtmLogFilter.info: 15,
  RtmLogFilter.warn: 14,
  RtmLogFilter.error: 12,
  RtmLogFilter.critical: 8,
  RtmLogFilter.mask: 2063,
};
