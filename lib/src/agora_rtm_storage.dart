import 'binding_forward_export.dart';
part 'agora_rtm_storage.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MetadataOptions {
  const MetadataOptions({this.recordTs = false, this.recordUserId = false});

  @JsonKey(name: 'recordTs')
  final bool? recordTs;

  @JsonKey(name: 'recordUserId')
  final bool? recordUserId;

  factory MetadataOptions.fromJson(Map<String, dynamic> json) =>
      _$MetadataOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MetadataItem {
  const MetadataItem(
      {this.key,
      this.value,
      this.authorUserId,
      this.revision = -1,
      this.updateTs = 0});

  @JsonKey(name: 'key')
  final String? key;

  @JsonKey(name: 'value')
  final String? value;

  @JsonKey(name: 'authorUserId')
  final String? authorUserId;

  @JsonKey(name: 'revision')
  final int? revision;

  @JsonKey(name: 'updateTs')
  final int? updateTs;

  factory MetadataItem.fromJson(Map<String, dynamic> json) =>
      _$MetadataItemFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataItemToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Metadata {
  const Metadata(
      {this.majorRevision = -1, this.items = const [], this.itemCount = 0});

  @JsonKey(name: 'majorRevision')
  final int? majorRevision;

  @JsonKey(name: 'items')
  final List<MetadataItem>? items;

  @JsonKey(name: 'itemCount')
  final int? itemCount;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

class SetChannelMetadataResult {
  SetChannelMetadataResult(
      {required this.channelName, required this.channelType});

  final String channelName;

  final RtmChannelType channelType;
}

class UpdateChannelMetadataResult {
  UpdateChannelMetadataResult(
      {required this.channelName, required this.channelType});

  final String channelName;

  final RtmChannelType channelType;
}

class RemoveChannelMetadataResult {
  RemoveChannelMetadataResult(
      {required this.channelName, required this.channelType});

  final String channelName;

  final RtmChannelType channelType;
}

class GetChannelMetadataResult {
  GetChannelMetadataResult(
      {required this.channelName,
      required this.channelType,
      required this.data});

  final String channelName;

  final RtmChannelType channelType;

  final Metadata data;
}

class SetUserMetadataResult {
  SetUserMetadataResult({required this.userId});

  final String userId;
}

class UpdateUserMetadataResult {
  UpdateUserMetadataResult({required this.userId});

  final String userId;
}

class RemoveUserMetadataResult {
  RemoveUserMetadataResult({required this.userId});

  final String userId;
}

class GetUserMetadataResult {
  GetUserMetadataResult({required this.userId, required this.data});

  final String userId;

  final Metadata data;
}

class SubscribeUserMetadataResult {
  SubscribeUserMetadataResult({required this.userId});

  final String userId;
}

class UnsubscribeUserMetadataResult {
  UnsubscribeUserMetadataResult({required this.userId});

  final String userId;
}

abstract class RtmStorage {
  Future<(RtmStatus, SetChannelMetadataResult?)> setChannelMetadata(
      String channelName,
      RtmChannelType channelType,
      List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''});

  Future<(RtmStatus, UpdateChannelMetadataResult?)> updateChannelMetadata(
      String channelName,
      RtmChannelType channelType,
      List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''});

  Future<(RtmStatus, RemoveChannelMetadataResult?)> removeChannelMetadata(
      String channelName, RtmChannelType channelType,
      {int majorRevision = -1,
      List<MetadataItem> metadata = const [],
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''});

  Future<(RtmStatus, GetChannelMetadataResult?)> getChannelMetadata(
      String channelName, RtmChannelType channelType);

  Future<(RtmStatus, SetUserMetadataResult?)> setUserMetadata(
      String userId, List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false});

  Future<(RtmStatus, UpdateUserMetadataResult?)> updateUserMetadata(
      String userId, List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false});

  Future<(RtmStatus, RemoveUserMetadataResult?)> removeUserMetadata(
      String userId,
      {int majorRevision = -1,
      List<MetadataItem> metadata = const [],
      bool recordTs = false,
      bool recordUserId = false});

  Future<(RtmStatus, GetUserMetadataResult?)> getUserMetadata(String userId);

  Future<(RtmStatus, SubscribeUserMetadataResult?)> subscribeUserMetadata(
      String userId);

  Future<(RtmStatus, UnsubscribeUserMetadataResult?)> unsubscribeUserMetadata(
      String userId);
}
