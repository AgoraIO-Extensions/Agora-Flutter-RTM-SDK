import 'dart:async';

import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/foundation.dart'
    show VoidCallback, debugPrint, visibleForTesting;
import 'package:flutter/services.dart' show MethodChannel;
import 'package:agora_rtm/src/method_channel/iris_method_channel.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_method_channel_internal.dart';

// ignore_for_file: public_member_api_docs

@pragma('vm:prefer-inline')
ThrowExceptionHandler throwExceptionHandler = _defaultThrowExceptionHandler;
@pragma('vm:prefer-inline')
void _defaultThrowExceptionHandler({required int code, String? message}) {
  throw Exception();
}

typedef ThrowExceptionHandler = void Function(
    {required int code, String? message});

class IrisMethodChannel {
  IrisMethodChannel(this._nativeBindingsProvider) {
    _irisMethodChannelInternal =
        createIrisMethodChannelInternal(_nativeBindingsProvider);
  }

  final PlatformBindingsProvider _nativeBindingsProvider;

  late final IrisMethodChannelInternal _irisMethodChannelInternal;

  final MethodChannel _channel = const MethodChannel('iris_method_channel');

  bool _initilized = false;
  @visibleForTesting
  final ScopedObjects scopedEventHandlers = ScopedObjects();

  AsyncMemoizer? _initializeCallOnce;

  void _setuponDetachedFromEngineListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDetachedFromEngine_fromPlatform') {
        debugPrint(
            'Receive the onDetachedFromEngine callback, clean the native resources.');
        dispose();
        return true;
      }

      return false;
    });
  }

  Future<InitilizationResult?> initilize(
      List<InitilizationArgProvider> args) async {
    if (_initilized) {
      return null;
    }

    InitilizationResult? initilizationResult;
    _initializeCallOnce ??= AsyncMemoizer();
    await _initializeCallOnce!.runOnce(() async {
      _setuponDetachedFromEngineListener();

      initilizationResult = await _irisMethodChannelInternal.initilize(args);

      _irisMethodChannelInternal.setIrisEventMessageListener((eventMessage) {
        bool handled = false;
        for (final sub in scopedEventHandlers.values) {
          final scopedObjects = sub as DisposableScopedObjects;
          for (final es in scopedObjects.values) {
            final EventHandlerHolder eh = es as EventHandlerHolder;
            // We need the event handlers with the same _EventHandlerHolderKey consume the message.
            for (final e in eh.getEventHandlers()) {
              if (e.handleEvent(eventMessage.event, eventMessage.data,
                  eventMessage.buffers)) {
                handled = true;
              }
            }

            // Break the loop after the event handlers in the same EventHandlerHolder
            // consume the message.
            if (handled) {
              break;
            }
          }

          // Break the loop if there is an EventHandlerHolder consume the message.
          if (handled) {
            break;
          }
        }
      });

      _initilized = true;
    });

    return initilizationResult;
  }

  Future<CallApiResult> invokeMethod(IrisMethodCall methodCall) async {
    if (!_initilized) {
      return CallApiResult(
          irisReturnCode: kDisposedIrisMethodCallReturnCode,
          data: kDisposedIrisMethodCallData);
    }

    final CallApiResult result =
        await _irisMethodChannelInternal.execute(ApiCallRequest(methodCall));

    return result;
  }

  Future<List<CallApiResult>> invokeMethodList(
      List<IrisMethodCall> methodCalls) async {
    if (!_initilized) {
      return methodCalls
          .map((e) => CallApiResult(
              irisReturnCode: kDisposedIrisMethodCallReturnCode,
              data: kDisposedIrisMethodCallData))
          .toList();
    }

    final List<CallApiResult> result = await _irisMethodChannelInternal
        .listExecute(ApiCallListRequest(methodCalls));

    return result;
  }

  Future<void> dispose() async {
    if (!_initilized) {
      return;
    }
    _initilized = false;

    await _irisMethodChannelInternal.dispose();
    _initializeCallOnce = null;
  }

  Future<CallApiResult> registerEventHandler(
      ScopedEvent scopedEvent, String params) async {
    if (!_initilized) {
      return CallApiResult(
          irisReturnCode: kDisposedIrisMethodCallReturnCode,
          data: kDisposedIrisMethodCallData);
    }

    final DisposableScopedObjects subScopedObjects = scopedEventHandlers
        .putIfAbsent(scopedEvent.scopedKey, () => DisposableScopedObjects());
    final eventKey = EventHandlerHolderKey(
      registerName: scopedEvent.registerName,
      unregisterName: scopedEvent.unregisterName,
    );
    final EventHandlerHolder holder = subScopedObjects.putIfAbsent(
        eventKey,
        () => EventHandlerHolder(
              key: EventHandlerHolderKey(
                registerName: scopedEvent.registerName,
                unregisterName: scopedEvent.unregisterName,
              ),
            ));

    late CallApiResult result;
    if (holder.getEventHandlers().isEmpty) {
      result = await _irisMethodChannelInternal.execute(
          CreateNativeEventHandlerRequest(
              IrisMethodCall(eventKey.registerName, params)));

      final nativeEventHandlerIntPtr = result.data['observerIntPtr'];
      holder.eventHandlerHandle = nativeEventHandlerIntPtr;
    } else {
      result = CallApiResult(irisReturnCode: 0, data: {'result': 0});
    }

    holder.addEventHandler(scopedEvent.handler);

    return result;
  }

  Future<CallApiResult> unregisterEventHandler(
      ScopedEvent scopedEvent, String params) async {
    if (!_initilized) {
      return CallApiResult(
          irisReturnCode: kDisposedIrisMethodCallReturnCode,
          data: kDisposedIrisMethodCallData);
    }

    final DisposableScopedObjects? subScopedObjects =
        scopedEventHandlers.get(scopedEvent.scopedKey);
    final eventKey = EventHandlerHolderKey(
      registerName: scopedEvent.registerName,
      unregisterName: scopedEvent.unregisterName,
    );
    final EventHandlerHolder? holder = subScopedObjects?.get(eventKey);
    if (holder != null) {
      holder.removeEventHandler(scopedEvent.handler);
      if (holder.getEventHandlers().isEmpty) {
        final eventHandlerHandle = holder.eventHandlerHandle;
        assert(eventHandlerHandle != null);
        return _irisMethodChannelInternal
            .execute(DestroyNativeEventHandlerRequest(
          IrisMethodCall(
            scopedEvent.unregisterName,
            params,
            rawBufferParams: [
              BufferParam(BufferParamHandle(eventHandlerHandle!()), 1)
            ],
          ),
        ));
      }
    }

    return CallApiResult(irisReturnCode: 0, data: {'result': 0});
  }

  Future<void> unregisterEventHandlers(TypedScopedKey scopedKey) async {
    if (!_initilized) {
      return;
    }

    final DisposableScopedObjects? subScopedObjects =
        scopedEventHandlers.remove(scopedKey);
    if (subScopedObjects != null) {
      for (final eventKey in subScopedObjects.keys) {
        final EventHandlerHolder? holder = subScopedObjects.get(eventKey);
        if (holder != null) {
          final methodCalls = holder
              .getEventHandlers()
              .map((e) => IrisMethodCall(
                    holder.key.unregisterName,
                    '',
                    rawBufferParams: [
                      BufferParam(
                          BufferParamHandle(holder.eventHandlerHandle!()), 1)
                    ],
                  ))
              .toList();

          await _irisMethodChannelInternal
              .listExecute(DestroyNativeEventHandlerListRequest(methodCalls));

          await holder.dispose();
        }
      }

      await subScopedObjects.dispose();
    }
  }

  int getApiEngineHandle() {
    if (!_initilized) {
      return 0;
    }

    return _irisMethodChannelInternal.getApiEngineHandle();
  }

  VoidCallback addHotRestartListener(HotRestartListener listener) {
    return _irisMethodChannelInternal.addHotRestartListener(listener);
  }

  void removeHotRestartListener(HotRestartListener listener) {
    _irisMethodChannelInternal.removeHotRestartListener(listener);
  }

  @visibleForTesting
  IrisMethodChannelInternal getIrisMethodChannelInternal() {
    return _irisMethodChannelInternal;
  }
}
