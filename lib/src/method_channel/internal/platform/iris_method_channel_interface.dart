import 'dart:typed_data';

import 'package:flutter/foundation.dart' show VoidCallback, SynchronousFuture;
import 'package:agora_rtm/src/method_channel/internal/iris_handles.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_event_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/scoped_objects.dart';

// ignore_for_file: public_member_api_docs

const int kBasicResultLength = 64 * 1024;
const int kDisposedIrisMethodCallReturnCode = 1000;
const Map<String, int> kDisposedIrisMethodCallData = {'result': 0};

class BufferParam {
  const BufferParam(this.intPtr, this.length);
  final BufferParamHandle intPtr;
  final int length;
}

class CallApiResult {
  CallApiResult(
      {required this.irisReturnCode, required this.data, this.rawData = ''});

  final int irisReturnCode;

  final Map<String, dynamic> data;

  // TODO(littlegnal): Remove rawData after EP-253 landed.
  final String rawData;
}

class IrisMethodCall {
  const IrisMethodCall(this.funcName, this.params,
      {this.buffers, this.rawBufferParams});
  final String funcName;
  final String params;
  final List<Uint8List>? buffers;
  final List<BufferParam>? rawBufferParams;
}

abstract class InitilizationResult {}

abstract class Request {}

abstract class IrisMethodCallRequest implements Request {
  const IrisMethodCallRequest(this.methodCall);

  final IrisMethodCall methodCall;
}

abstract class IrisMethodCallListRequest implements Request {
  const IrisMethodCallListRequest(this.methodCalls);

  final List<IrisMethodCall> methodCalls;
}

class ApiCallRequest extends IrisMethodCallRequest {
  const ApiCallRequest(IrisMethodCall methodCall) : super(methodCall);
}

// ignore: unused_element
class ApiCallListRequest extends IrisMethodCallListRequest {
  const ApiCallListRequest(List<IrisMethodCall> methodCalls)
      : super(methodCalls);
}

class CreateNativeEventHandlerRequest extends IrisMethodCallRequest {
  const CreateNativeEventHandlerRequest(IrisMethodCall methodCall)
      : super(methodCall);
}

// ignore: unused_element
class CreateNativeEventHandlerListRequest extends IrisMethodCallListRequest {
  const CreateNativeEventHandlerListRequest(List<IrisMethodCall> methodCalls)
      : super(methodCalls);
}

class DestroyNativeEventHandlerRequest extends IrisMethodCallRequest {
  const DestroyNativeEventHandlerRequest(IrisMethodCall methodCall)
      : super(methodCall);
}

class DestroyNativeEventHandlerListRequest extends IrisMethodCallListRequest {
  const DestroyNativeEventHandlerListRequest(List<IrisMethodCall> methodCalls)
      : super(methodCalls);
}

/// Listener when hot restarted.
///
/// You can release some native resources, such like delete the pointer which is
/// created by ffi.
///
/// NOTE that:
/// * This listener is only received on debug mode.
/// * You should not comunicate with the `IrisMethodChannel` anymore inside this listener.
/// * You should not do some asynchronous jobs inside this listener.
typedef HotRestartListener = void Function(Object? message);

abstract class InitilizationArgProvider {
  IrisHandle provide(IrisApiEngineHandle apiEngineHandle);
}

abstract class IrisMethodChannelInternal {
  Future<InitilizationResult?> initilize(List<InitilizationArgProvider> args);

  // Future<CallApiResult> invokeMethod(IrisMethodCall methodCall);

  Future<CallApiResult> execute(Request request);

  Future<List<CallApiResult>> listExecute(Request request);

  int getApiEngineHandle();

  VoidCallback addHotRestartListener(HotRestartListener listener);

  void removeHotRestartListener(HotRestartListener listener);

  void setIrisEventMessageListener(IrisEventMessageListener listener);

  Future<void> dispose();
}

class ScopedEvent {
  const ScopedEvent({
    required this.scopedKey,
    required this.registerName,
    required this.unregisterName,
    // required this.params,
    required this.handler,
  });
  final TypedScopedKey scopedKey;
  final String registerName;
  final String unregisterName;
  // final String params;
  final EventLoopEventHandler handler;
}

abstract class IrisEventKey {
  const IrisEventKey({
    required this.registerName,
    required this.unregisterName,
  });
  final String registerName;
  final String unregisterName;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is IrisEventKey &&
        other.registerName == registerName &&
        other.unregisterName == unregisterName;
  }

  @override
  int get hashCode => Object.hash(registerName, unregisterName);
}

class EventHandlerHolder
    with ScopedDisposableObjectMixin
    implements DisposableObject {
  EventHandlerHolder({required this.key});
  final EventHandlerHolderKey key;
  final Set<EventLoopEventHandler> _eventHandlers = {};

  IrisEventHandlerHandle? eventHandlerHandle;

  void addEventHandler(EventLoopEventHandler eventHandler) {
    _eventHandlers.add(eventHandler);
  }

  Future<void> removeEventHandler(EventLoopEventHandler eventHandler) async {
    _eventHandlers.remove(eventHandler);
  }

  Set<EventLoopEventHandler> getEventHandlers() => _eventHandlers;

  @override
  Future<void> dispose() {
    _eventHandlers.clear();
    return SynchronousFuture(null);
  }
}

class EventHandlerHolderKey implements ScopedKey {
  const EventHandlerHolderKey({
    required this.registerName,
    required this.unregisterName,
  });
  final String registerName;
  final String unregisterName;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is EventHandlerHolderKey &&
        other.registerName == registerName &&
        other.unregisterName == unregisterName;
  }

  @override
  int get hashCode => Object.hash(registerName, unregisterName);
}
