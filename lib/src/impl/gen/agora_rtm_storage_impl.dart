import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_storage_impl.dart'
    as native_binding;

class RtmStorageImpl implements RtmStorage {
  RtmStorageImpl(this.nativeBindingRtmStorageImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.RtmStorageImpl nativeBindingRtmStorageImpl;

  @override
  Future<(RtmStatus, SetChannelMetadataResult?)> setChannelMetadata(
      String channelName,
      RtmChannelType channelType,
      List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.setChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName);
      final (SetChannelMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'setChannelMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'setChannelMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, UpdateChannelMetadataResult?)> updateChannelMetadata(
      String channelName,
      RtmChannelType channelType,
      List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.updateChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName);
      final (UpdateChannelMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'updateChannelMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'updateChannelMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RemoveChannelMetadataResult?)> removeChannelMetadata(
      String channelName, RtmChannelType channelType,
      {int majorRevision = -1,
      List<MetadataItem> metadata = const [],
      bool recordTs = false,
      bool recordUserId = false,
      String lockName = ''}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.removeChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName);
      final (RemoveChannelMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'removeChannelMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'removeChannelMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetChannelMetadataResult?)> getChannelMetadata(
      String channelName, RtmChannelType channelType) async {
    try {
      final requestId = await nativeBindingRtmStorageImpl.getChannelMetadata(
          channelName: channelName, channelType: channelType);
      final (GetChannelMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getChannelMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getChannelMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, SetUserMetadataResult?)> setUserMetadata(
      String userId, List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.setUserMetadata(
          userId: userId, data: data, options: options);
      final (SetUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'setUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'setUserMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, UpdateUserMetadataResult?)> updateUserMetadata(
      String userId, List<MetadataItem> metadata,
      {int majorRevision = -1,
      bool recordTs = false,
      bool recordUserId = false}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.updateUserMetadata(
          userId: userId, data: data, options: options);
      final (UpdateUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'updateUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'updateUserMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RemoveUserMetadataResult?)> removeUserMetadata(
      String userId,
      {int majorRevision = -1,
      List<MetadataItem> metadata = const [],
      bool recordTs = false,
      bool recordUserId = false}) async {
    final data = Metadata(
        majorRevision: majorRevision,
        items: metadata,
        itemCount: metadata.length);
    final options =
        MetadataOptions(recordTs: recordTs, recordUserId: recordUserId);
    try {
      final requestId = await nativeBindingRtmStorageImpl.removeUserMetadata(
          userId: userId, data: data, options: options);
      final (RemoveUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'removeUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'removeUserMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetUserMetadataResult?)> getUserMetadata(
      String userId) async {
    try {
      final requestId =
          await nativeBindingRtmStorageImpl.getUserMetadata(userId);
      final (GetUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getUserMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, SubscribeUserMetadataResult?)> subscribeUserMetadata(
      String userId) async {
    try {
      final requestId =
          await nativeBindingRtmStorageImpl.subscribeUserMetadata(userId);
      final (SubscribeUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'subscribeUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'subscribeUserMetadata');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, UnsubscribeUserMetadataResult?)> unsubscribeUserMetadata(
      String userId) async {
    try {
      final requestId =
          await nativeBindingRtmStorageImpl.unsubscribeUserMetadata(userId);
      final (UnsubscribeUserMetadataResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'unsubscribeUserMetadata');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmStorageImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'unsubscribeUserMetadata');
      return (status, null);
    }
  }
}
