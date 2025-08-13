// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agora_rtm_storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataOptions _$MetadataOptionsFromJson(Map<String, dynamic> json) =>
    MetadataOptions(
      recordTs: json['recordTs'] as bool? ?? false,
      recordUserId: json['recordUserId'] as bool? ?? false,
    );

Map<String, dynamic> _$MetadataOptionsToJson(MetadataOptions instance) =>
    <String, dynamic>{
      if (instance.recordTs case final value?) 'recordTs': value,
      if (instance.recordUserId case final value?) 'recordUserId': value,
    };

MetadataItem _$MetadataItemFromJson(Map<String, dynamic> json) => MetadataItem(
      key: json['key'] as String?,
      value: json['value'] as String?,
      authorUserId: json['authorUserId'] as String?,
      revision: (json['revision'] as num?)?.toInt() ?? -1,
      updateTs: (json['updateTs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MetadataItemToJson(MetadataItem instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.value case final value?) 'value': value,
      if (instance.authorUserId case final value?) 'authorUserId': value,
      if (instance.revision case final value?) 'revision': value,
      if (instance.updateTs case final value?) 'updateTs': value,
    };

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
      majorRevision: (json['majorRevision'] as num?)?.toInt() ?? -1,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MetadataItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{
      if (instance.majorRevision case final value?) 'majorRevision': value,
      if (instance.items?.map((e) => e.toJson()).toList() case final value?)
        'items': value,
      if (instance.itemCount case final value?) 'itemCount': value,
    };
