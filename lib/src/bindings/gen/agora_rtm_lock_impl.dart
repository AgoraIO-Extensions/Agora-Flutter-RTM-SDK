/// GENERATED BY terra, DO NOT MODIFY BY HAND.

// ignore_for_file: public_member_api_docs, unused_local_variable, unused_import, annotate_overrides

import 'binding_forward_export.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

class RtmLockImpl implements RtmLock {
  RtmLockImpl(this.irisMethodChannel);

  final IrisMethodChannel irisMethodChannel;

  @protected
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return param;
  }

  @protected
  bool get isOverrideClassName => false;

  @protected
  String get className => 'RtmLock';

  @override
  Future<int> setLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required int ttl}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_setLock_89e5672';
    final param = createParams({
      'channelName': channelName,
      'channelType': channelType.value(),
      'lockName': lockName,
      'ttl': ttl
    });
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final setLockJson = RtmLockSetLockJson.fromJson(rm);
    return setLockJson.requestId;
  }

  @override
  Future<int> getLocks(
      {required String channelName,
      required RtmChannelType channelType}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_getLocks_ad8568b';
    final param = createParams(
        {'channelName': channelName, 'channelType': channelType.value()});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final getLocksJson = RtmLockGetLocksJson.fromJson(rm);
    return getLocksJson.requestId;
  }

  @override
  Future<int> removeLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_removeLock_4ffa44d';
    final param = createParams({
      'channelName': channelName,
      'channelType': channelType.value(),
      'lockName': lockName
    });
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final removeLockJson = RtmLockRemoveLockJson.fromJson(rm);
    return removeLockJson.requestId;
  }

  @override
  Future<int> acquireLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required bool retry}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_acquireLock_cd2dbc2';
    final param = createParams({
      'channelName': channelName,
      'channelType': channelType.value(),
      'lockName': lockName,
      'retry': retry
    });
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final acquireLockJson = RtmLockAcquireLockJson.fromJson(rm);
    return acquireLockJson.requestId;
  }

  @override
  Future<int> releaseLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_releaseLock_4ffa44d';
    final param = createParams({
      'channelName': channelName,
      'channelType': channelType.value(),
      'lockName': lockName
    });
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final releaseLockJson = RtmLockReleaseLockJson.fromJson(rm);
    return releaseLockJson.requestId;
  }

  @override
  Future<int> revokeLock(
      {required String channelName,
      required RtmChannelType channelType,
      required String lockName,
      required String owner}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmLock'}_revokeLock_fc4a9d7';
    final param = createParams({
      'channelName': channelName,
      'channelType': channelType.value(),
      'lockName': lockName,
      'owner': owner
    });
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final revokeLockJson = RtmLockRevokeLockJson.fromJson(rm);
    return revokeLockJson.requestId;
  }
}
