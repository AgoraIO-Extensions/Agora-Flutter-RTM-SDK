import 'package:agora_rtm/src/agora_rtm_base.dart';
import 'package:agora_rtm/src/agora_rtm_client.dart';
import 'package:agora_rtm/src/agora_rtm_client_ext.dart'
    show AgoraRtmException, RtmStatus;
import 'package:agora_rtm/src/agora_rtm_lock.dart';
import 'package:agora_rtm/src/agora_rtm_presence.dart';
import 'package:agora_rtm/src/agora_rtm_storage.dart';
import 'package:agora_rtm/src/agora_stream_channel.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/impl/agora_stream_channel_impl_override.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/impl/gen/agora_rtm_lock_impl.dart'
    as rtm_lock_impl;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_lock_impl.dart'
    as rtm_lock_impl_binding;
import 'package:agora_rtm/src/impl/gen/agora_rtm_storage_impl.dart'
    as rtm_storage_impl;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_storage_impl.dart'
    as rtm_storage_impl_binding;
import 'package:agora_rtm/src/impl/gen/agora_rtm_presence_impl.dart'
    as rtm_presence_impl;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_presence_impl.dart'
    as rtm_presence_impl_binding;
import 'package:agora_rtm/src/bindings/gen/agora_stream_channel_impl.dart'
    as stream_channel_impl_binding;

import 'package:agora_rtm/src/impl/gen/agora_rtm_client_impl.dart'
    as rtm_client_impl;
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart'
    as rtm_client_impl_override;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_client_impl.dart'
    as rtm_client_native_binding;
import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

InitilizationArgProvider? _mockSharedNativeHandleProvider;
@visibleForTesting
void setMockSharedNativeHandleProvider(
    InitilizationArgProvider? mockSharedNativeHandleProvider) {
  assert(() {
    _mockSharedNativeHandleProvider = mockSharedNativeHandleProvider;
    return true;
  }());
}

class RtmClientImplOverride extends rtm_client_impl.RtmClientImpl {
  // ignore: use_super_parameters
  RtmClientImplOverride(
      rtm_client_native_binding.RtmClientImpl nativeBindingRtmClientImpl,
      RtmResultHandler rtmResultHandler)
      : super(nativeBindingRtmClientImpl, rtmResultHandler);

  static Future<(RtmStatus, RtmClient)> create(
    String appId,
    String userId, {
    RtmConfig? config,
    RtmResultHandlerImpl? rtmResultHandlerImpl,
    rtm_client_impl_override.RtmClientImplOverride? rtmClientNativeBinding,
  }) async {
    if (_initializedStatus != null &&
        !_initializedStatus!.error &&
        _instance != null) {
      return (_initializedStatus!, _instance!);
    }

    final rtmResultHandler = rtmResultHandlerImpl ?? RtmResultHandlerImpl();

    List<InitilizationArgProvider> args = [];

    // We only want to set it in testing.
    assert(() {
      if (_mockSharedNativeHandleProvider != null) {
        args.add(_mockSharedNativeHandleProvider!);
      }
      return true;
    }());

    final bindingRtmClientImpl = rtmClientNativeBinding ??
        rtm_client_impl_override.RtmClientImplOverride.create(
          IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
        );

    _initializedStatus = await bindingRtmClientImpl.initialize(
      appId,
      userId,
      rtmResultHandler.rtmEventHandler,
      config: config,
      args: args,
    );

    _instance = RtmClientImplOverride(bindingRtmClientImpl, rtmResultHandler);

    return (_initializedStatus!, _instance!);
  }

  static RtmClientImplOverride? _instance;
  static RtmStatus? _initializedStatus;

  RtmStorage? _storage;
  RtmLock? _lock;
  RtmPresence? _presence;

  void _setListenerIfNeeded(String key, Object? listener) {
    if (listener != null) {
      (rtmResultHandler as RtmResultHandlerImpl).setListener(key, listener);
    }
  }

  void _removeListenerIfNeeded(String key, Object? listener) {
    if (listener != null) {
      (rtmResultHandler as RtmResultHandlerImpl).removeListener(key);
    }
  }

  @override
  void addListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token}) {
    _setListenerIfNeeded('linkState', linkState);
    _setListenerIfNeeded('message', message);
    _setListenerIfNeeded('presence', presence);
    _setListenerIfNeeded('topic', topic);
    _setListenerIfNeeded('lock', lock);
    _setListenerIfNeeded('storage', storage);
    _setListenerIfNeeded('token', token);
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
    _removeListenerIfNeeded('linkState', linkState);
    _removeListenerIfNeeded('message', message);
    _removeListenerIfNeeded('presence', presence);
    _removeListenerIfNeeded('topic', topic);
    _removeListenerIfNeeded('lock', lock);
    _removeListenerIfNeeded('storage', storage);
    _removeListenerIfNeeded('token', token);
  }

  @override
  RtmStorage getStorage() {
    final irisMethodChannel = (nativeBindingRtmClientImpl
            as rtm_client_impl_override.RtmClientImplOverride)
        .getIrisMethodChannel();
    return (_storage ??= rtm_storage_impl.RtmStorageImpl(
      rtm_storage_impl_binding.RtmStorageImpl(irisMethodChannel),
      rtmResultHandler,
    ));
  }

  @override
  RtmLock getLock() {
    final irisMethodChannel = (nativeBindingRtmClientImpl
            as rtm_client_impl_override.RtmClientImplOverride)
        .getIrisMethodChannel();
    return (_lock ??= rtm_lock_impl.RtmLockImpl(
      rtm_lock_impl_binding.RtmLockImpl(irisMethodChannel),
      rtmResultHandler,
    ));
  }

  @override
  RtmPresence getPresence() {
    final irisMethodChannel = (nativeBindingRtmClientImpl
            as rtm_client_impl_override.RtmClientImplOverride)
        .getIrisMethodChannel();

    return (_presence ??= rtm_presence_impl.RtmPresenceImpl(
      rtm_presence_impl_binding.RtmPresenceImpl(irisMethodChannel),
      rtmResultHandler,
    ));
  }

  @override
  Future<(RtmStatus, StreamChannel?)> createStreamChannel(
    String channelName,
  ) async {
    try {
      final streamChannel = await (nativeBindingRtmClientImpl
              as rtm_client_impl_override.RtmClientImplOverride)
          .createStreamChannel(channelName);

      final streamChannelImpl = StreamChannelImplOverride(
        streamChannel as stream_channel_impl_binding.StreamChannelImpl,
        rtmResultHandler,
      );
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(0, 'createStreamChannel');
      return (status, streamChannelImpl);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmClientImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'createStreamChannel');
      return (status, null);
    }
  }

  @override
  Future<RtmStatus> release() async {
    try {
      return await super.release();
    } finally {
      _instance = null;
      _initializedStatus = null;
    }
  }

  @override
  Future<(RtmStatus, PublishResult?)> publish(
      String channelName, String message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType}) async {
    // final option = PublishOptions(
    //     channelType: channelType,
    //     messageType: RtmMessageType.string,
    //     customType: customType);
    // final requestId = await nativeBindingRtmClientImpl.publish(
    //     channelName: channelName,
    //     message: message,
    //     length: message.length,
    //     option: option);
    // return rtmResultHandler.request(requestId);

    final option = PublishOptions(
        channelType: channelType,
        messageType: RtmMessageType.string,
        customType: customType);
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
  Future<(RtmStatus, PublishResult?)> publishBinaryMessage(
      String channelName, Uint8List message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType}) async {
    // final option = PublishOptions(
    //     channelType: channelType,
    //     messageType: RtmMessageType.binary,
    //     customType: customType);
    // final requestId = await nativeBindingRtmClientImpl.publishBinaryMessage(
    //     channelName: channelName,
    //     message: message,
    //     length: message.length,
    //     option: option);
    // return rtmResultHandler.request(requestId);

    final option = PublishOptions(
        channelType: channelType,
        messageType: RtmMessageType.binary,
        customType: customType);
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
