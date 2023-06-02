// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtmMessage _$RtmMessageFromJson(Map<String, dynamic> json) => RtmMessage._(
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

RtmChannelMember _$RtmChannelMemberFromJson(Map<String, dynamic> json) =>
    RtmChannelMember(
      json['userId'] as String,
      json['channelId'] as String,
    );

Map<String, dynamic> _$RtmChannelMemberToJson(RtmChannelMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'channelId': instance.channelId,
    };

RtmAttribute _$RtmAttributeFromJson(Map<String, dynamic> json) => RtmAttribute(
      json['key'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$RtmAttributeToJson(RtmAttribute instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

RtmChannelAttribute _$RtmChannelAttributeFromJson(Map<String, dynamic> json) =>
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

LocalInvitation _$LocalInvitationFromJson(Map<String, dynamic> json) =>
    LocalInvitation._(
      json['calleeId'] as String,
      content: json['content'] as String?,
      response: json['response'] as String?,
      channelId: json['channelId'] as String?,
      state: json['state'] as int? ?? 0,
      handle: json['hashCode'] as int? ?? 0,
    );

Map<String, dynamic> _$LocalInvitationToJson(LocalInvitation instance) =>
    <String, dynamic>{
      'calleeId': instance.calleeId,
      'content': instance.content,
      'response': instance.response,
      'channelId': instance.channelId,
      'state': instance.state,
      'hashCode': instance.handle,
    };

RemoteInvitation _$RemoteInvitationFromJson(Map<String, dynamic> json) =>
    RemoteInvitation._(
      json['callerId'] as String,
      content: json['content'] as String?,
      response: json['response'] as String?,
      channelId: json['channelId'] as String?,
      state: json['state'] as int? ?? 0,
      handle: json['hashCode'] as int? ?? 0,
    );

Map<String, dynamic> _$RemoteInvitationToJson(RemoteInvitation instance) =>
    <String, dynamic>{
      'callerId': instance.callerId,
      'content': instance.content,
      'response': instance.response,
      'channelId': instance.channelId,
      'state': instance.state,
      'hashCode': instance.handle,
    };

ChannelAttributeOptions _$ChannelAttributeOptionsFromJson(
        Map<String, dynamic> json) =>
    ChannelAttributeOptions(
      json['enableNotificationToChannelMembers'] as bool,
    );

Map<String, dynamic> _$ChannelAttributeOptionsToJson(
        ChannelAttributeOptions instance) =>
    <String, dynamic>{
      'enableNotificationToChannelMembers':
          instance.enableNotificationToChannelMembers,
    };

SendMessageOptions _$SendMessageOptionsFromJson(Map<String, dynamic> json) =>
    SendMessageOptions(
      enableOfflineMessaging: json['enableOfflineMessaging'] as bool?,
      enableHistoricalMessaging: json['enableHistoricalMessaging'] as bool?,
    );

Map<String, dynamic> _$SendMessageOptionsToJson(SendMessageOptions instance) =>
    <String, dynamic>{
      'enableOfflineMessaging': instance.enableOfflineMessaging,
      'enableHistoricalMessaging': instance.enableHistoricalMessaging,
    };

RtmChannelMemberCount _$RtmChannelMemberCountFromJson(
        Map<String, dynamic> json) =>
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
