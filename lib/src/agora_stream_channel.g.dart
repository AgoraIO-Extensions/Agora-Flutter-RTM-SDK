// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_stream_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinChannelOptions _$JoinChannelOptionsFromJson(Map<String, dynamic> json) =>
    JoinChannelOptions(
      token: json['token'] as String?,
      withMetadata: json['withMetadata'] as bool? ?? false,
      withPresence: json['withPresence'] as bool? ?? true,
      withLock: json['withLock'] as bool? ?? false,
      beQuiet: json['beQuiet'] as bool? ?? false,
    );

Map<String, dynamic> _$JoinChannelOptionsToJson(JoinChannelOptions instance) =>
    <String, dynamic>{
      if (instance.token case final value?) 'token': value,
      if (instance.withMetadata case final value?) 'withMetadata': value,
      if (instance.withPresence case final value?) 'withPresence': value,
      if (instance.withLock case final value?) 'withLock': value,
      if (instance.beQuiet case final value?) 'beQuiet': value,
    };

JoinTopicOptions _$JoinTopicOptionsFromJson(Map<String, dynamic> json) =>
    JoinTopicOptions(
      qos: $enumDecodeNullable(_$RtmMessageQosEnumMap, json['qos']) ??
          RtmMessageQos.unordered,
      priority:
          $enumDecodeNullable(_$RtmMessagePriorityEnumMap, json['priority']) ??
              RtmMessagePriority.normal,
      meta: json['meta'] as String? ?? '',
      syncWithMedia: json['syncWithMedia'] as bool? ?? false,
    );

Map<String, dynamic> _$JoinTopicOptionsToJson(JoinTopicOptions instance) =>
    <String, dynamic>{
      if (_$RtmMessageQosEnumMap[instance.qos] case final value?) 'qos': value,
      if (_$RtmMessagePriorityEnumMap[instance.priority] case final value?)
        'priority': value,
      if (instance.meta case final value?) 'meta': value,
      if (instance.syncWithMedia case final value?) 'syncWithMedia': value,
    };

const _$RtmMessageQosEnumMap = {
  RtmMessageQos.unordered: 0,
  RtmMessageQos.ordered: 1,
};

const _$RtmMessagePriorityEnumMap = {
  RtmMessagePriority.highest: 0,
  RtmMessagePriority.high: 1,
  RtmMessagePriority.normal: 4,
  RtmMessagePriority.low: 8,
};

TopicOptions _$TopicOptionsFromJson(Map<String, dynamic> json) => TopicOptions(
      users:
          (json['users'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userCount: (json['userCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TopicOptionsToJson(TopicOptions instance) =>
    <String, dynamic>{
      if (instance.users case final value?) 'users': value,
      if (instance.userCount case final value?) 'userCount': value,
    };
