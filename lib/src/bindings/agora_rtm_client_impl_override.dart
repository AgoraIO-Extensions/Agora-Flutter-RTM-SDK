import 'dart:convert' show utf8, jsonEncode;
import 'dart:typed_data' show Uint8List;

import 'package:agora_rtm/src/agora_rtm_client_ext.dart';
import 'package:agora_rtm/src/agora_rtm_base.dart' show PublishOptions;
import 'package:agora_rtm/src/agora_rtm_client.dart' show RtmConfig;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_client.dart';
import 'package:agora_rtm/src/bindings/gen/agora_stream_channel.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:flutter/services.dart' show MethodChannel;

import 'gen/agora_rtm_client_event_impl.dart';
import 'gen/agora_rtm_client_impl.dart' as rtmc_binding;
import 'package:iris_method_channel/iris_method_channel.dart';
import 'agora_stream_channel_impl_override.dart';
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:meta/meta.dart';

class SharedNativeHandleInitilizationArgProvider
    implements InitilizationArgProvider {
  const SharedNativeHandleInitilizationArgProvider(this.sharedNativeHandle);

  final Object sharedNativeHandle;
  @override
  IrisHandle provide(IrisApiEngineHandle apiEngineHandle) {
    return ObjectIrisHandle(sharedNativeHandle);
  }
}

class _StreamChannelScopedKey implements ScopedKey {
  const _StreamChannelScopedKey(this.channelName);
  final String channelName;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _StreamChannelScopedKey && other.channelName == channelName;
  }

  @override
  int get hashCode => channelName.hashCode;
}

class RtmClientImplOverride extends rtmc_binding.RtmClientImpl {
  RtmClientImplOverride._(IrisMethodChannel irisMethodChannel)
      : super(irisMethodChannel);

  static RtmClientImplOverride create(
    IrisMethodChannel irisMethodChannel,
  ) {
    final instance = RtmClientImplOverride._(irisMethodChannel);
    return instance;
  }

  Future<RtmStatus> initialize(
    String appId,
    String userId,
    RtmEventHandler rtmEventHandler, {
    RtmConfig? config,
    List<InitilizationArgProvider> args = const [],
  }) async {
    int errorCode = 0;
    try {
      await _initialize(
        appId,
        userId,
        rtmEventHandler,
        config: config,
        args: args,
      );
    } catch (e) {
      assert(e is AgoraRtmException);
      errorCode = (e as AgoraRtmException).code;
    }

    final status = await irisMethodChannel.wrapRtmStatus(errorCode, 'RTM');

    return status;
  }

  final _rtmClientImplScopedKey = const TypedScopedKey(RtmClientImplOverride);

  final ScopedObjects _scopedObjects = ScopedObjects();

  final DisposableScopedObjects _streamChannelObjects =
      DisposableScopedObjects();

  @internal
  late MethodChannel rtmMethodChannel;

  AsyncMemoizer? _initializeCallOnce;

  IrisMethodChannel getIrisMethodChannel() {
    return irisMethodChannel;
  }

  @override
  Future<StreamChannel> createStreamChannel(String channelName) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_createStreamChannel_ae3d0cf';
    final param = createParams({'channelName': channelName});

    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));

    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final errorCode = rm['errorCode'];
    if (errorCode < 0) {
      throwExceptionHandler(code: errorCode);
    }

    final streamChannel = _streamChannelObjects.putIfAbsent<StreamChannelImpl>(
      _StreamChannelScopedKey(channelName),
      () {
        StreamChannelImpl streamChannel =
            StreamChannelImpl(irisMethodChannel, channelName);
        return streamChannel;
      },
    );
    _scopedObjects.putIfAbsent(
      _rtmClientImplScopedKey,
      () {
        return _streamChannelObjects;
      },
    );

    return streamChannel;
  }

  @pragma('vm:prefer-inline')
  void _throwRtmException({required int code, String? message}) {
    throw AgoraRtmException(code: code, message: message);
  }

  Future<void> _initialize(
    String appId,
    String userId,
    RtmEventHandler rtmEventHandler, {
    RtmConfig? config,
    List<InitilizationArgProvider> args = const [],
  }) async {
    _initializeCallOnce ??= AsyncMemoizer();
    await _initializeCallOnce!.runOnce(() async {
      rtmMethodChannel = const MethodChannel('agora_rtm');

      // From `iris_method_channel`
      throwExceptionHandler = _throwRtmException;

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await rtmMethodChannel.invokeMethod('androidInit');
      }

      await irisMethodChannel.initilize(args);
      _scopedObjects.putIfAbsent(
        const TypedScopedKey(RtmClientImplOverride),
        () => _streamChannelObjects,
      );
    });

    late RtmConfig adjustedConfig;
    if (config != null) {
      adjustedConfig = config;
    } else {
      adjustedConfig = const RtmConfig();
    }

    final configJsonMap = adjustedConfig.toJson();
    if (adjustedConfig.encryptionConfig?.encryptionSalt != null) {
      configJsonMap['encryptionConfig']['encryptionSalt'] =
          adjustedConfig.encryptionConfig?.encryptionSalt!.toList();
    }

    configJsonMap['appId'] = appId;
    configJsonMap['userId'] = userId;

    final param = {'config': configJsonMap};

    final eventHandlerWrapper = RtmEventHandlerWrapper(rtmEventHandler);
    final callApiResult = await irisMethodChannel.registerEventHandler(
        ScopedEvent(
            scopedKey: _rtmClientImplScopedKey,
            registerName: 'RtmClient_create',
            unregisterName: '',
            handler: eventHandlerWrapper),
        jsonEncode(param));

    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;

    final result = rm['result'];

    if (result < 0) {
      throwExceptionHandler(code: result);
    }

    await irisMethodChannel.invokeMethod(IrisMethodCall(
      'RtmClient_setAppType',
      jsonEncode({'appType': 4}),
    ));
  }

  @override
  Future<void> release() async {
    await _scopedObjects.clear();

    try {
      await super.release();
    } catch (e) {
      debugPrint('RtmClient release error: ${e.toString()}');
    }

    await irisMethodChannel.dispose();
    // _instance = null;
  }

  @override
  Future<int> publish(
      {required String channelName,
      required String message,
      required int length,
      required PublishOptions option}) async {
    return publishBinaryMessage(
        channelName: channelName,
        message: Uint8List.fromList(utf8.encode(message)),
        length: length,
        option: option);
  }
}
