import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart'
    show VoidCallback, debugPrint, visibleForTesting;
import 'package:agora_rtm/src/method_channel/iris_method_channel.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/io/bindings/native_iris_api_common_bindings.dart'
    as iris;
import 'package:agora_rtm/src/method_channel/internal/platform/io/iris_event_io.dart';

// ignore_for_file: public_member_api_docs

class _Messenger implements DisposableObject {
  _Messenger(this.requestPort, this.responseQueue);
  final SendPort requestPort;
  final StreamQueue<dynamic> responseQueue;
  bool _isDisposed = false;

  Future<CallApiResult> send(Request request) async {
    if (_isDisposed) {
      return CallApiResult(
          irisReturnCode: kDisposedIrisMethodCallReturnCode,
          data: kDisposedIrisMethodCallData);
    }
    requestPort.send(request);
    return await responseQueue.next;
  }

  Future<List<CallApiResult>> listSend(Request request) async {
    if (_isDisposed) {
      return [
        CallApiResult(
            irisReturnCode: kDisposedIrisMethodCallReturnCode,
            data: kDisposedIrisMethodCallData)
      ];
    }
    requestPort.send(request);
    return await responseQueue.next;
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    requestPort.send(null);
    // Wait for `executor.dispose` done in isolate.
    await responseQueue.next;
    responseQueue.cancel();
  }
}

class _InitilizationArgs {
  _InitilizationArgs(
    this.apiCallPortSendPort,
    this.eventPortSendPort,
    this.onExitSendPort,
    this.provider,
    this.argNativeHandles,
  );

  final SendPort apiCallPortSendPort;
  final SendPort eventPortSendPort;
  final SendPort? onExitSendPort;
  final PlatformBindingsProvider provider;
  final List<InitilizationArgProvider> argNativeHandles;
}

class InitilizationResultIO implements InitilizationResult {
  InitilizationResultIO(
    this._apiCallPortSendPort,
    this.irisApiEngineNativeHandle,
    this.extraData,
    this._debugIrisCEventHandlerNativeHandle,
    this._debugIrisEventHandlerNativeHandle,
  );

  final SendPort _apiCallPortSendPort;
  final int irisApiEngineNativeHandle;

  /// Same as [CreateApiEngineResult.extraData]
  final Map<String, Object> extraData;

  final int? _debugIrisCEventHandlerNativeHandle;
  final int? _debugIrisEventHandlerNativeHandle;
}

class _HotRestartFinalizer {
  _HotRestartFinalizer(this.provider) {
    assert(() {
      _onExitPort = ReceivePort();
      _onExitSubscription = _onExitPort?.listen(_finalize);

      return true;
    }());
  }

  final PlatformBindingsProvider provider;

  final List<HotRestartListener> _hotRestartListeners = [];

  ReceivePort? _onExitPort;
  StreamSubscription? _onExitSubscription;

  SendPort? get onExitSendPort => _onExitPort?.sendPort;

  bool _isFinalize = false;

  int? _debugIrisApiEngineNativeHandle;
  set debugIrisApiEngineNativeHandle(int value) {
    _debugIrisApiEngineNativeHandle = value;
  }

  int? _debugIrisCEventHandlerNativeHandle;
  set debugIrisCEventHandlerNativeHandle(int? value) {
    _debugIrisCEventHandlerNativeHandle = value;
  }

  int? _debugIrisEventHandlerNativeHandle;
  set debugIrisEventHandlerNativeHandle(int? value) {
    _debugIrisEventHandlerNativeHandle = value;
  }

  // ignore: avoid_annotating_with_dynamic
  void _finalize(dynamic msg) {
    if (_isFinalize) {
      return;
    }
    _isFinalize = true;

    // We will receive a value of `0` as message when the `IrisMethodChannel.dispose`
    // is called normally, which will call the `Isolate.exit(onExitSendPort, 0)`
    // to send a value of `0` as a exit response. See `_execute` function for more detail.
    if (msg != null && msg == 0) {
      return;
    }

    for (final listener in _hotRestartListeners.reversed) {
      listener(msg);
    }

    // When hot restart happen, the `IrisMethodChannel.dispose` function will not
    // be called normally, cause the native API engine can not be destroy correctly,
    // so we need to release the native resources which create by the
    // `NativeBindingDelegate` explicitly.
    final nativeBindingDelegate = provider.provideNativeBindingDelegate();
    nativeBindingDelegate.initialize();

    nativeBindingDelegate.destroyNativeApiEngine(IrisApiEngineHandle(
        ffi.Pointer<ffi.Void>.fromAddress(_debugIrisApiEngineNativeHandle!)));

    calloc.free(ffi.Pointer<ffi.Void>.fromAddress(
        _debugIrisCEventHandlerNativeHandle!));
    nativeBindingDelegate.destroyIrisEventHandler(IrisEventHandlerHandle(
        ffi.Pointer<ffi.Void>.fromAddress(
            _debugIrisEventHandlerNativeHandle!)));

    final irisEvent =
        (provider.provideIrisEvent() ?? IrisEventIO()) as IrisEventIO;
    irisEvent.dispose();

    _onExitSubscription?.cancel();
  }

  VoidCallback addHotRestartListener(HotRestartListener listener) {
    assert(() {
      final Object? debugCheckForReturnedFuture = listener as dynamic;
      if (debugCheckForReturnedFuture is Future) {
        throw UnsupportedError(
            'HotRestartListener must be a void method without an `async` keyword.');
      }
      return true;
    }());

    _hotRestartListeners.add(listener);
    return () {
      removeHotRestartListener(listener);
    };
  }

  void removeHotRestartListener(HotRestartListener listener) {
    _hotRestartListeners.remove(listener);
  }

  void dispose() {
    _hotRestartListeners.clear();
  }
}

/// Extension functions of `PlatformBindingsDelegateInterfaceIO`
extension PlatformBindingsDelegateInterfaceIOExt
    on PlatformBindingsDelegateInterface {
  CallApiResult invokeMethod(
    IrisApiEngineHandle irisApiEnginePtr,
    IrisMethodCall methodCall,
  ) {
    return using<CallApiResult>((Arena arena) {
      final funcName = methodCall.funcName;
      final params = methodCall.params;
      final buffers = methodCall.buffers;
      final rawBufferParams = methodCall.rawBufferParams;
      assert(!(buffers != null && rawBufferParams != null));

      List<BufferParam>? bufferParamList = [];

      if (buffers != null) {
        for (int i = 0; i < buffers.length; i++) {
          final buffer = buffers[i];
          if (buffer.isEmpty) {
            bufferParamList.add(const BufferParam(BufferParamHandle(0), 0));
            continue;
          }
          final ffi.Pointer<ffi.Uint8> bufferData =
              arena.allocate<ffi.Uint8>(buffer.length);

          final pointerList = bufferData.asTypedList(buffer.length);
          pointerList.setAll(0, buffer);

          bufferParamList.add(BufferParam(
              BufferParamHandle(bufferData.address), buffer.length));
        }
      } else {
        bufferParamList = rawBufferParams;
      }

      final ffi.Pointer<ffi.Int8> resultPointer =
          arena.allocate<ffi.Int8>(kBasicResultLength);

      final ffi.Pointer<ffi.Int8> funcNamePointer =
          funcName.toNativeUtf8(allocator: arena).cast();

      final ffi.Pointer<Utf8> paramsPointerUtf8 =
          params.toNativeUtf8(allocator: arena);
      final paramsPointerUtf8Length = paramsPointerUtf8.length;
      final ffi.Pointer<ffi.Int8> paramsPointer = paramsPointerUtf8.cast();

      ffi.Pointer<ffi.Pointer<ffi.Void>> bufferListPtr;
      ffi.Pointer<ffi.Uint32> bufferListLengthPtr = ffi.nullptr;
      final bufferLengthLength = bufferParamList?.length ?? 0;

      if (bufferParamList != null) {
        bufferListPtr =
            arena.allocate(bufferParamList.length * ffi.sizeOf<ffi.Uint64>());

        for (int i = 0; i < bufferParamList.length; i++) {
          final bufferParam = bufferParamList[i];
          bufferListPtr[i] =
              ffi.Pointer.fromAddress(bufferParam.intPtr() as int);
        }
      } else {
        bufferListPtr = ffi.nullptr;
        bufferListLengthPtr = ffi.nullptr;
      }

      try {
        final apiParam = arena<iris.ApiParam>()
          ..ref.event = funcNamePointer
          ..ref.data = paramsPointer
          ..ref.data_size = paramsPointerUtf8Length
          ..ref.result = resultPointer
          ..ref.buffer = bufferListPtr
          ..ref.length = bufferListLengthPtr
          ..ref.buffer_count = bufferLengthLength;

        final irisReturnCode = callApi(
          methodCall,
          irisApiEnginePtr,
          IrisApiParamHandle(apiParam),
        );

        if (irisReturnCode != 0) {
          return CallApiResult(irisReturnCode: irisReturnCode, data: const {});
        }

        final result = resultPointer.cast<Utf8>().toDartString();

        final resultMap = Map<String, dynamic>.from(jsonDecode(result));

        return CallApiResult(
          irisReturnCode: irisReturnCode,
          data: resultMap,
          rawData: result,
        );
      } catch (e) {
        debugPrint('[_ApiCallExecutor] $funcName, params: $params\nerror: $e');
        return CallApiResult(irisReturnCode: -1, data: const {});
      }
    });
  }
}

class _IrisMethodChannelNative {
  _IrisMethodChannelNative(this._nativeIrisApiEngineBinding, this._irisEvent);
  final PlatformBindingsDelegateInterface _nativeIrisApiEngineBinding;

  ffi.Pointer<ffi.Void>? _irisApiEnginePtr;
  int get irisApiEngineNativeHandle {
    assert(_irisApiEnginePtr != null);
    return _irisApiEnginePtr!.address;
  }

  final IrisEventIO _irisEvent;
  ffi.Pointer<iris.IrisCEventHandler>? _irisCEventHandler;
  int get irisCEventHandlerNativeHandle {
    assert(_irisCEventHandler != null);
    return _irisCEventHandler!.address;
  }

  ffi.Pointer<ffi.Void>? _irisEventHandler;
  int get irisEventHandlerNativeHandle {
    assert(_irisEventHandler != null);
    return _irisEventHandler!.address;
  }

  CreateApiEngineResult initilize(
      SendPort sendPort, List<InitilizationArgProvider> args) {
    _irisEvent.initialize();
    _irisEvent.registerEventHandler(sendPort);

    _nativeIrisApiEngineBinding.initialize();
    final createResult = _nativeIrisApiEngineBinding.createApiEngine(args);
    _irisApiEnginePtr = createResult.apiEnginePtr() as ffi.Pointer<ffi.Void>?;

    _irisCEventHandler = calloc<iris.IrisCEventHandler>()
      ..ref.OnEvent = _irisEvent.onEventPtr.cast();

    _irisEventHandler = _nativeIrisApiEngineBinding.createIrisEventHandler(
            IrisCEventHandlerHandle(_irisCEventHandler!))()
        as ffi.Pointer<ffi.Void>?;

    return createResult;
  }

  CallApiResult _invokeMethod(IrisMethodCall methodCall) {
    assert(_irisApiEnginePtr != null, 'Make sure initilize() has been called.');

    return _nativeIrisApiEngineBinding.invokeMethod(
        IrisApiEngineHandle(_irisApiEnginePtr!), methodCall);
  }

  CallApiResult invokeMethod(IrisMethodCall methodCall) {
    return _invokeMethod(methodCall);
  }

  void dispose() {
    assert(_irisApiEnginePtr != null);

    _nativeIrisApiEngineBinding
        .destroyNativeApiEngine(IrisApiEngineHandle(_irisApiEnginePtr!));
    _irisApiEnginePtr = null;

    _irisEvent.dispose();

    _nativeIrisApiEngineBinding
        .destroyIrisEventHandler(IrisEventHandlerHandle(_irisEventHandler!));
    _irisEventHandler = null;

    calloc.free(_irisCEventHandler!);
    _irisCEventHandler = null;
  }

  CallApiResult createNativeEventHandler(IrisMethodCall methodCall) {
    final eventHandlerIntPtr = _irisEventHandler!.address;
    final result = _invokeMethod(IrisMethodCall(
      methodCall.funcName,
      methodCall.params,
      rawBufferParams: [BufferParam(BufferParamHandle(eventHandlerIntPtr), 1)],
    ));
    result.data['observerIntPtr'] = IrisEventHandlerHandle(eventHandlerIntPtr);
    return result;
  }

  CallApiResult destroyNativeEventHandler(IrisMethodCall methodCall) {
    assert(methodCall.rawBufferParams != null);
    assert(methodCall.rawBufferParams!.length == 1);

    CallApiResult result;
    if (methodCall.funcName.isEmpty) {
      result = CallApiResult(irisReturnCode: 0, data: {'result': 0});
    } else {
      result = _invokeMethod(methodCall);
    }

    return result;
  }
}

class IrisMethodChannelInternalIO implements IrisMethodChannelInternal {
  IrisMethodChannelInternalIO(this._nativeBindingsProvider);

  final PlatformBindingsProvider _nativeBindingsProvider;

  bool _initilized = false;
  late _Messenger _messenger;
  late StreamSubscription _evntSubscription;
  // @visibleForTesting
  // final ScopedObjects scopedEventHandlers = ScopedObjects();
  late int _nativeHandle;

  IrisEventMessageListener? _irisEventMessageListener;

  @visibleForTesting
  late Isolate workerIsolate;
  late _HotRestartFinalizer _hotRestartFinalizer;

  AsyncMemoizer? _initializeCallOnce;

  static Future<void> _execute(_InitilizationArgs args) async {
    final SendPort mainApiCallSendPort = args.apiCallPortSendPort;
    final SendPort mainEventSendPort = args.eventPortSendPort;
    final SendPort? onExitSendPort = args.onExitSendPort;
    final PlatformBindingsProvider provider = args.provider;

    final apiCallPort = ReceivePort();

    final nativeBindingDelegate = provider.provideNativeBindingDelegate();

    final IrisEvent irisEvent = provider.provideIrisEvent() ?? IrisEventIO();
    // assert(irisEvent != null);

    // final irisEvent = provider.provideIrisEvent();

    final _IrisMethodChannelNative executor = _IrisMethodChannelNative(
        nativeBindingDelegate, irisEvent as IrisEventIO);
    final CreateApiEngineResult executorInitilizationResult =
        executor.initilize(mainEventSendPort, args.argNativeHandles);

    int? debugIrisCEventHandlerNativeHandle;
    int? debugIrisEventHandlerNativeHandle;

    assert(() {
      debugIrisCEventHandlerNativeHandle =
          executor.irisCEventHandlerNativeHandle;
      debugIrisEventHandlerNativeHandle = executor.irisEventHandlerNativeHandle;

      return true;
    }());

    final InitilizationResult initilizationResponse = InitilizationResultIO(
      apiCallPort.sendPort,
      executor.irisApiEngineNativeHandle,
      executorInitilizationResult.extraData,
      debugIrisCEventHandlerNativeHandle,
      debugIrisEventHandlerNativeHandle,
    );

    mainApiCallSendPort.send(initilizationResponse);

    // Wait for messages from the main isolate.
    await for (final request in apiCallPort) {
      if (request == null) {
        executor.dispose();
        mainApiCallSendPort.send(null);
        // Ready exit the isolate.
        break;
      }

      assert(request is Request);

      if (request is ApiCallRequest) {
        final result = executor.invokeMethod(request.methodCall);

        mainApiCallSendPort.send(result);
      } else if (request is ApiCallListRequest) {
        final results = <CallApiResult>[];
        for (final methodCall in request.methodCalls) {
          final result = executor.invokeMethod(methodCall);
          results.add(result);
        }

        mainApiCallSendPort.send(results);
      } else if (request is CreateNativeEventHandlerRequest) {
        final result = executor.createNativeEventHandler(request.methodCall);
        mainApiCallSendPort.send(result);
      } else if (request is CreateNativeEventHandlerListRequest) {
        final results = <CallApiResult>[];
        for (final methodCall in request.methodCalls) {
          final result = executor.createNativeEventHandler(methodCall);
          results.add(result);
        }

        mainApiCallSendPort.send(results);
      } else if (request is DestroyNativeEventHandlerRequest) {
        final result = executor.destroyNativeEventHandler(request.methodCall);
        mainApiCallSendPort.send(result);
      } else if (request is DestroyNativeEventHandlerListRequest) {
        final results = <CallApiResult>[];
        for (final methodCall in request.methodCalls) {
          final result = executor.destroyNativeEventHandler(methodCall);
          results.add(result);
        }

        mainApiCallSendPort.send(results);
      }
    }

    Isolate.exit(onExitSendPort, 0);
  }

  @override
  Future<InitilizationResult?> initilize(
      List<InitilizationArgProvider> args) async {
    if (_initilized) {
      return null;
    }

    late InitilizationResultIO initilizationResult;
    _initializeCallOnce ??= AsyncMemoizer();
    await _initializeCallOnce!.runOnce(() async {
      final apiCallPort = ReceivePort();
      final eventPort = ReceivePort();

      _hotRestartFinalizer = _HotRestartFinalizer(_nativeBindingsProvider);

      workerIsolate = await Isolate.spawn(
        _execute,
        _InitilizationArgs(
          apiCallPort.sendPort,
          eventPort.sendPort,
          _hotRestartFinalizer.onExitSendPort,
          _nativeBindingsProvider,
          args,
        ),
        onExit: _hotRestartFinalizer.onExitSendPort,
      );

      final responseQueue = StreamQueue<dynamic>(apiCallPort);

      final msg = await responseQueue.next;
      assert(msg is InitilizationResult);
      initilizationResult = msg as InitilizationResultIO;
      final requestPort = initilizationResult._apiCallPortSendPort;
      _nativeHandle = initilizationResult.irisApiEngineNativeHandle;

      assert(() {
        _hotRestartFinalizer.debugIrisApiEngineNativeHandle =
            initilizationResult.irisApiEngineNativeHandle;
        _hotRestartFinalizer.debugIrisCEventHandlerNativeHandle =
            initilizationResult._debugIrisCEventHandlerNativeHandle;
        _hotRestartFinalizer.debugIrisEventHandlerNativeHandle =
            initilizationResult._debugIrisEventHandlerNativeHandle;

        return true;
      }());

      _messenger = _Messenger(requestPort, responseQueue);

      _evntSubscription = eventPort.listen((message) {
        if (!_initilized) {
          return;
        }

        final eventMessage = parseMessage(message);

        _irisEventMessageListener?.call(eventMessage);
      });

      _initilized = true;
    });

    return initilizationResult;
  }

  @override
  Future<void> dispose() async {
    if (!_initilized) {
      return;
    }
    _initilized = false;
    _irisEventMessageListener = null;
    _hotRestartFinalizer.dispose();
    await _evntSubscription.cancel();
    await _messenger.dispose();
    _initializeCallOnce = null;
  }

  @override
  VoidCallback addHotRestartListener(HotRestartListener listener) {
    return _hotRestartFinalizer.addHotRestartListener(listener);
  }

  @override
  void removeHotRestartListener(HotRestartListener listener) {
    _hotRestartFinalizer.removeHotRestartListener(listener);
  }

  @override
  Future<CallApiResult> execute(Request request) {
    return _messenger.send(request);
  }

  @override
  int getApiEngineHandle() {
    if (!_initilized) {
      return 0;
    }

    return _nativeHandle;
  }

  @override
  Future<List<CallApiResult>> listExecute(Request request) {
    return _messenger.listSend(request);
  }

  @override
  void setIrisEventMessageListener(IrisEventMessageListener listener) {
    _irisEventMessageListener = listener;
  }
}
