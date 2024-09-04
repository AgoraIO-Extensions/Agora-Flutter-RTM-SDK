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

Map<String, dynamic> _$MetadataOptionsToJson(MetadataOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('recordTs', instance.recordTs);
  writeNotNull('recordUserId', instance.recordUserId);
  return val;
}

MetadataItem _$MetadataItemFromJson(Map<String, dynamic> json) => MetadataItem(
      key: json['key'] as String?,
      value: json['value'] as String?,
      authorUserId: json['authorUserId'] as String?,
      revision: (json['revision'] as num?)?.toInt() ?? -1,
      updateTs: (json['updateTs'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MetadataItemToJson(MetadataItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('key', instance.key);
  writeNotNull('value', instance.value);
  writeNotNull('authorUserId', instance.authorUserId);
  writeNotNull('revision', instance.revision);
  writeNotNull('updateTs', instance.updateTs);
  return val;
}

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
      majorRevision: (json['majorRevision'] as num?)?.toInt() ?? -1,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => MetadataItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MetadataToJson(Metadata instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('majorRevision', instance.majorRevision);
  writeNotNull('items', instance.items?.map((e) => e.toJson()).toList());
  writeNotNull('itemCount', instance.itemCount);
  return val;
}
