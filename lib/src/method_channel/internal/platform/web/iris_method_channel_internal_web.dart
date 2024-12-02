import 'dart:async';
import 'dart:js';
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:agora_rtm/src/method_channel/iris_method_channel.dart';

import 'package:agora_rtm/src/method_channel/internal/platform/web/bindings/iris_api_common_bindings_js.dart'
    as js_binding;

// ignore_for_file: public_member_api_docs

class InitilizationResultWeb implements InitilizationResult {
  InitilizationResultWeb();
}

class IrisMethodChannelInternalWeb implements IrisMethodChannelInternal {
  IrisMethodChannelInternalWeb(this._nativeBindingsProvider);

  final PlatformBindingsProvider _nativeBindingsProvider;
  IrisApiEngineHandle? _irisApiEngine;
  PlatformBindingsDelegateInterface? _platformBindingsDelegate;

  IrisEventMessageListener? _irisEventMessageListener;

  js_binding.IrisCEventHandler? _irisEventHandlerFuncJS;

  IrisEventHandlerHandle? _irisEventHandlerHandle;

  @override
  VoidCallback addHotRestartListener(HotRestartListener listener) {
    return () {};
  }

  @override
  Future<void> dispose() async {
    assert(_irisApiEngine != null);

    _platformBindingsDelegate?.destroyNativeApiEngine(_irisApiEngine!);

    _platformBindingsDelegate
        ?.destroyIrisEventHandler(_irisEventHandlerHandle!);

    _platformBindingsDelegate = null;
    _irisApiEngine = null;
    _irisEventHandlerFuncJS = null;
    _irisEventHandlerHandle = null;
    _irisEventMessageListener = null;
  }

  @override
  Future<CallApiResult> execute(Request request) async {
    if (request is CreateNativeEventHandlerRequest) {
      final methodCall = request.methodCall;

      await _executeMethodCall(IrisMethodCall(
        methodCall.funcName,
        methodCall.params,
        rawBufferParams: [
          BufferParam(BufferParamHandle(_irisEventHandlerHandle!()), 1)
        ],
      ));

      return CallApiResult(
        irisReturnCode: 0,
        data: {'observerIntPtr': _irisEventHandlerHandle},
      );
    } else if (request is DestroyNativeEventHandlerRequest) {
      final methodCall = request.methodCall;
      if (methodCall.funcName.isEmpty) {
        return CallApiResult(irisReturnCode: 0, data: {'result': 0});
      }

      return _executeMethodCall(methodCall);
    } else if (request is ApiCallRequest) {
      final IrisMethodCall methodCall = request.methodCall;
      return _executeMethodCall(methodCall);
    } else {
      return CallApiResult(irisReturnCode: 0, data: {'result': 0});
    }
  }

  Future<CallApiResult> _executeMethodCall(IrisMethodCall methodCall) async {
    // On web, we do not create a `IrisApiParamHandle` directly, but pass the `methodCall`
    // to the `callApiAsync` implementation to create their platform specific parameters
    // instead.
    final ret = await _platformBindingsDelegate!
        .callApiAsync(methodCall, _irisApiEngine!, const IrisApiParamHandle(0));

    return ret;
  }

  @override
  int getApiEngineHandle() {
    return 0;
  }

  void _onEventFromJS(js_binding.EventParam param) {
    if (_irisEventMessageListener != null) {
      _irisEventMessageListener?.call(js_binding.toIrisEventMessage(param));
    }
  }

  @override
  Future<InitilizationResult?> initilize(
      List<InitilizationArgProvider> args) async {
    _platformBindingsDelegate =
        _nativeBindingsProvider.provideNativeBindingDelegate();
    final createApiEngineResult =
        _platformBindingsDelegate!.createApiEngine(args);
    _irisApiEngine = createApiEngineResult.apiEnginePtr;

    _irisEventHandlerFuncJS = allowInterop(_onEventFromJS);
    _irisEventHandlerHandle = _platformBindingsDelegate!.createIrisEventHandler(
        IrisCEventHandlerHandle(_irisEventHandlerFuncJS!));

    return InitilizationResultWeb();
  }

  @override
  Future<List<CallApiResult>> listExecute(Request request) async {
    final results = <CallApiResult>[];
    if (request is ApiCallListRequest) {
      final methodCalls = request.methodCalls;
      for (final methodCall in methodCalls) {
        final result = await _executeMethodCall(methodCall);
        results.add(result);
      }
    } else if (request is DestroyNativeEventHandlerListRequest) {
      final methodCalls = request.methodCalls;
      for (final methodCall in methodCalls) {
        final result = await _executeMethodCall(methodCall);
        results.add(result);
      }
    }

    return results;
  }

  @override
  void removeHotRestartListener(HotRestartListener listener) {}

  @override
  void setIrisEventMessageListener(IrisEventMessageListener listener) {
    _irisEventMessageListener = listener;
  }
}
