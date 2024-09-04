import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_lock_impl.dart'
    as native_binding;

class RtmLockImpl implements RtmLock {
  RtmLockImpl(this.nativeBindingRtmLockImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.RtmLockImpl nativeBindingRtmLockImpl;

  @override
  Future<(RtmStatus, SetLockResult?)> setLock(
      String channelName, RtmChannelType channelType, String lockName,
      {int ttl = 10}) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.setLock(
          channelName: channelName,
          channelType: channelType,
          lockName: lockName,
          ttl: ttl);
      final (SetLockResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'setLock');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'setLock');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetLocksResult?)> getLocks(
      String channelName, RtmChannelType channelType) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.getLocks(
          channelName: channelName, channelType: channelType);
      final (GetLocksResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getLocks');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getLocks');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RemoveLockResult?)> removeLock(
      String channelName, RtmChannelType channelType, String lockName) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.removeLock(
          channelName: channelName,
          channelType: channelType,
          lockName: lockName);
      final (RemoveLockResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'removeLock');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'removeLock');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, AcquireLockResult?)> acquireLock(
      String channelName, RtmChannelType channelType, String lockName,
      {bool retry = false}) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.acquireLock(
          channelName: channelName,
          channelType: channelType,
          lockName: lockName,
          retry: retry);
      final (AcquireLockResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'acquireLock');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'acquireLock');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, ReleaseLockResult?)> releaseLock(
      String channelName, RtmChannelType channelType, String lockName) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.releaseLock(
          channelName: channelName,
          channelType: channelType,
          lockName: lockName);
      final (ReleaseLockResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'releaseLock');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'releaseLock');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RevokeLockResult?)> revokeLock(String channelName,
      RtmChannelType channelType, String lockName, String owner) async {
    try {
      final requestId = await nativeBindingRtmLockImpl.revokeLock(
          channelName: channelName,
          channelType: channelType,
          lockName: lockName,
          owner: owner);
      final (RevokeLockResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'revokeLock');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmLockImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'revokeLock');
      return (status, null);
    }
  }
}
