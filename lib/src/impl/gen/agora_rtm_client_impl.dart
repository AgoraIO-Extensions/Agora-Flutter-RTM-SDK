import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_client_impl.dart'
    as native_binding;

class RtmClientImpl implements RtmClient {
  RtmClientImpl(this.nativeBindingRtmClientImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.RtmClientImpl nativeBindingRtmClientImpl;

  @override
  void addListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token}) {
    throw UnimplementedError('Implement this function in sub-class.');
  }

  @override
  void removeListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token}) {
    throw UnimplementedError('Implement this function in sub-class.');
  }

  @override
  Future<RtmStatus> release() async {
    try {
      await nativeBindingRtmClientImpl.release();
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(0, 'release');
      return status;
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'release');
      return status;
    }
  }

  @override
  Future<(RtmStatus, LoginResult?)> login(String token) async {
    try {
      final requestId = await nativeBindingRtmClientImpl.login(token);
      final (LoginResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'login');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'login');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, LogoutResult?)> logout() async {
    try {
      final requestId = await nativeBindingRtmClientImpl.logout();
      final (LogoutResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'logout');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'logout');
      return (status, null);
    }
  }

  @override
  RtmStorage getStorage() {
    // This function's implementation can't be generated automatically, please implement it manually.
    throw UnimplementedError();
  }

  @override
  RtmLock getLock() {
    // This function's implementation can't be generated automatically, please implement it manually.
    throw UnimplementedError();
  }

  @override
  RtmPresence getPresence() {
    // This function's implementation can't be generated automatically, please implement it manually.
    throw UnimplementedError();
  }

  @override
  Future<(RtmStatus, RenewTokenResult?)> renewToken(String token) async {
    try {
      final requestId = await nativeBindingRtmClientImpl.renewToken(token);
      final (RenewTokenResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'renewToken');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'renewToken');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, PublishResult?)> publish(
      String channelName, String message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType}) async {
    final option =
        PublishOptions(channelType: channelType, customType: customType);
    try {
      final requestId = await nativeBindingRtmClientImpl.publish(
          channelName: channelName,
          message: message,
          length: message.length,
          option: option);
      final (PublishResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'publish');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'publish');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, SubscribeResult?)> subscribe(String channelName,
      {bool withMessage = true,
      bool withMetadata = false,
      bool withPresence = true,
      bool withLock = false,
      bool beQuiet = false}) async {
    final options = SubscribeOptions(
        withMessage: withMessage,
        withMetadata: withMetadata,
        withPresence: withPresence,
        withLock: withLock,
        beQuiet: beQuiet);
    try {
      final requestId = await nativeBindingRtmClientImpl.subscribe(
          channelName: channelName, options: options);
      final (SubscribeResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'subscribe');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'subscribe');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, UnsubscribeResult?)> unsubscribe(
      String channelName) async {
    try {
      final requestId =
          await nativeBindingRtmClientImpl.unsubscribe(channelName);
      final (UnsubscribeResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'unsubscribe');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'unsubscribe');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, StreamChannel?)> createStreamChannel(
      String channelName) async {
    // This function's implementation can't be generated automatically, please implement it manually.
    throw UnimplementedError();
  }

  @override
  Future<RtmStatus> setParameters(String parameters) async {
    try {
      await nativeBindingRtmClientImpl.setParameters(parameters);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(0, 'setParameters');
      return status;
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'setParameters');
      return status;
    }
  }

  @override
  Future<(RtmStatus, PublishResult?)> publishBinaryMessage(
      String channelName, Uint8List message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType}) async {
    final option =
        PublishOptions(channelType: channelType, customType: customType);
    try {
      final requestId = await nativeBindingRtmClientImpl.publishBinaryMessage(
          channelName: channelName,
          message: message,
          length: message.length,
          option: option);
      final (PublishResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'publishBinaryMessage');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'publishBinaryMessage');
      return (status, null);
    }
  }
}
