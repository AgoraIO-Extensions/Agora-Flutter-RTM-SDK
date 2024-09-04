import 'binding_forward_export.dart';

abstract class RtmLock {
  Future<int> setLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required int ttl});

  Future<int> getLocks(
      {required String channelName, required RtmChannelType channelType});

  Future<int> removeLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName});

  Future<int> acquireLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required bool retry});

  Future<int> releaseLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName});

  Future<int> revokeLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required String owner});
}
