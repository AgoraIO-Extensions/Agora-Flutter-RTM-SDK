import 'binding_forward_export.dart';

abstract class RtmStorage {
  Future<int> setChannelMetadata(
      {required String channelName,
      required RtmChannelType channelType,
      required Metadata data,
      required MetadataOptions options,
      required String lockName});

  Future<int> updateChannelMetadata(
      {required String channelName,
      required RtmChannelType channelType,
      required Metadata data,
      required MetadataOptions options,
      required String lockName});

  Future<int> removeChannelMetadata(
      {required String channelName,
      required RtmChannelType channelType,
      required Metadata data,
      required MetadataOptions options,
      required String lockName});

  Future<int> getChannelMetadata(
      {required String channelName, required RtmChannelType channelType});

  Future<int> setUserMetadata(
      {required String userId,
      required Metadata data,
      required MetadataOptions options});

  Future<int> updateUserMetadata(
      {required String userId,
      required Metadata data,
      required MetadataOptions options});

  Future<int> removeUserMetadata(
      {required String userId,
      required Metadata data,
      required MetadataOptions options});

  Future<int> getUserMetadata(String userId);

  Future<int> subscribeUserMetadata(String userId);

  Future<int> unsubscribeUserMetadata(String userId);
}
