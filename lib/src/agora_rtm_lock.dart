import 'binding_forward_export.dart';

class SetLockResult {
  SetLockResult(
      {required this.channelName,
      required this.channelType,
      required this.lockName});

  final String channelName;

  final RtmChannelType channelType;

  final String lockName;
}

class GetLocksResult {
  GetLocksResult(
      {required this.channelName,
      required this.channelType,
      required this.lockDetailList,
      required this.count});

  final String channelName;

  final RtmChannelType channelType;

  final List<LockDetail> lockDetailList;

  final int count;
}

class RemoveLockResult {
  RemoveLockResult(
      {required this.channelName,
      required this.channelType,
      required this.lockName});

  final String channelName;

  final RtmChannelType channelType;

  final String lockName;
}

class AcquireLockResult {
  AcquireLockResult(
      {required this.channelName,
      required this.channelType,
      required this.lockName,
      required this.errorDetails});

  final String channelName;

  final RtmChannelType channelType;

  final String lockName;

  final String errorDetails;
}

class ReleaseLockResult {
  ReleaseLockResult(
      {required this.channelName,
      required this.channelType,
      required this.lockName});

  final String channelName;

  final RtmChannelType channelType;

  final String lockName;
}

class RevokeLockResult {
  RevokeLockResult(
      {required this.channelName,
      required this.channelType,
      required this.lockName});

  final String channelName;

  final RtmChannelType channelType;

  final String lockName;
}

abstract class RtmLock {
  Future<(RtmStatus, SetLockResult?)> setLock(
      String channelName, RtmChannelType channelType, String lockName,
      {int ttl = 10});

  Future<(RtmStatus, GetLocksResult?)> getLocks(
      String channelName, RtmChannelType channelType);

  Future<(RtmStatus, RemoveLockResult?)> removeLock(
      String channelName, RtmChannelType channelType, String lockName);

  Future<(RtmStatus, AcquireLockResult?)> acquireLock(
      String channelName, RtmChannelType channelType, String lockName,
      {bool retry = false});

  Future<(RtmStatus, ReleaseLockResult?)> releaseLock(
      String channelName, RtmChannelType channelType, String lockName);

  Future<(RtmStatus, RevokeLockResult?)> revokeLock(String channelName,
      RtmChannelType channelType, String lockName, String owner);
}
