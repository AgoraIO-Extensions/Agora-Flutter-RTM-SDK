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

Map<String, dynamic> _$JoinChannelOptionsToJson(JoinChannelOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('token', instance.token);
  writeNotNull('withMetadata', instance.withMetadata);
  writeNotNull('withPresence', instance.withPresence);
  writeNotNull('withLock', instance.withLock);
  writeNotNull('beQuiet', instance.beQuiet);
  return val;
}

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

Map<String, dynamic> _$JoinTopicOptionsToJson(JoinTopicOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('qos', _$RtmMessageQosEnumMap[instance.qos]);
  writeNotNull('priority', _$RtmMessagePriorityEnumMap[instance.priority]);
  writeNotNull('meta', instance.meta);
  writeNotNull('syncWithMedia', instance.syncWithMedia);
  return val;
}

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

Map<String, dynamic> _$TopicOptionsToJson(TopicOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('users', instance.users);
  writeNotNull('userCount', instance.userCount);
  return val;
}
