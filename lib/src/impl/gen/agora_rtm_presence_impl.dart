import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_presence_impl.dart'
    as native_binding;

class RtmPresenceImpl implements RtmPresence {
  RtmPresenceImpl(this.nativeBindingRtmPresenceImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.RtmPresenceImpl nativeBindingRtmPresenceImpl;

  @override
  Future<(RtmStatus, WhoNowResult?)> whoNow(
      String channelName, RtmChannelType channelType,
      {bool includeUserId = true,
      bool includeState = false,
      String page = ''}) async {
    final options = PresenceOptions(
        includeUserId: includeUserId, includeState: includeState, page: page);
    try {
      final requestId = await nativeBindingRtmPresenceImpl.whoNow(
          channelName: channelName, channelType: channelType, options: options);
      final (WhoNowResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'whoNow');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'whoNow');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, WhereNowResult?)> whereNow(String userId) async {
    try {
      final requestId = await nativeBindingRtmPresenceImpl.whereNow(userId);
      final (WhereNowResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'whereNow');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'whereNow');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, SetStateResult?)> setState(String channelName,
      RtmChannelType channelType, Map<String, String> state) async {
    final itemsStateItem = state.entries
        .map((entry) => StateItem(key: entry.key, value: entry.value))
        .toList();
    try {
      final requestId = await nativeBindingRtmPresenceImpl.setState(
          channelName: channelName,
          channelType: channelType,
          items: itemsStateItem,
          count: itemsStateItem.length);
      final (SetStateResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'setState');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'setState');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RemoveStateResult?)> removeState(
      String channelName, RtmChannelType channelType,
      {List<String> states = const []}) async {
    try {
      final requestId = await nativeBindingRtmPresenceImpl.removeState(
          channelName: channelName,
          channelType: channelType,
          keys: states,
          count: states.length);
      final (RemoveStateResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'removeState');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'removeState');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetStateResult?)> getState(
      String channelName, RtmChannelType channelType, String userId) async {
    try {
      final requestId = await nativeBindingRtmPresenceImpl.getState(
          channelName: channelName, channelType: channelType, userId: userId);
      final (GetStateResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getState');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getState');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetOnlineUsersResult?)> getOnlineUsers(
      String channelName, RtmChannelType channelType,
      {bool includeUserId = true,
      bool includeState = false,
      String? page}) async {
    final options = GetOnlineUsersOptions(
        includeUserId: includeUserId, includeState: includeState, page: page);
    try {
      final requestId = await nativeBindingRtmPresenceImpl.getOnlineUsers(
          channelName: channelName, channelType: channelType, options: options);
      final (GetOnlineUsersResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getOnlineUsers');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getOnlineUsers');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetUserChannelsResult?)> getUserChannels(
      String userId) async {
    try {
      final requestId =
          await nativeBindingRtmPresenceImpl.getUserChannels(userId);
      final (GetUserChannelsResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getUserChannels');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmPresenceImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getUserChannels');
      return (status, null);
    }
  }
}
