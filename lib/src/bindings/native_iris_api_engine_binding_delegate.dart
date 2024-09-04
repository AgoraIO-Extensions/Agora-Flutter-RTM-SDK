import 'dart:convert';
import 'dart:io';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'gen/native_iris_api_engine_bindings.dart' as bindings;
import 'package:iris_method_channel/iris_method_channel.dart';
import 'package:iris_method_channel/iris_method_channel_bindings_io.dart'
    as iris_bindings;

// ignore_for_file: public_member_api_docs

const _libName = 'AgoraRtmWrapper';

const _doNotInterceptCall = -1000000;

ffi.DynamicLibrary _loadLib() {
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }

  if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open("lib$_libName.so");
  }

  return ffi.DynamicLibrary.process();
}

class NativeIrisApiEngineBindingsDelegate
    extends PlatformBindingsDelegateInterface {
  late final bindings.NativeIrisApiEngineBinding _binding;
  bindings.NativeIrisApiEngineBinding get binding => _binding;

  @override
  void initialize() {
    _binding = bindings.NativeIrisApiEngineBinding(_loadLib());
  }

  @override
  CreateApiEngineResult createApiEngine(List<InitilizationArgProvider> args) {
    ffi.Pointer<bindings.ProcTableRtm> enginePtr = ffi.nullptr;
    if (args.isNotEmpty) {
      assert(args.length == 1);
      final engineIntPtr =
          args[0].provide(const IrisApiEngineHandle(0))() as int;
      if (engineIntPtr != 0) {
        enginePtr =
            ffi.Pointer<bindings.ProcTableRtm>.fromAddress(engineIntPtr);
      }
    }

    final apiEnginePtr = _binding.CreateIrisRtmEngineWithProcTable(enginePtr);

    return CreateApiEngineResult(IrisApiEngineHandle(apiEnginePtr));
  }

  void _response(
      ffi.Pointer<iris_bindings.ApiParam> param, Map<String, Object> result) {
    using<void>((Arena arena) {
      final ffi.Pointer<Utf8> resultMapPointerUtf8 =
          jsonEncode(result).toNativeUtf8(allocator: arena);
      final ffi.Pointer<ffi.Int8> resultMapPointerInt8 =
          resultMapPointerUtf8.cast();

      for (int i = 0; i < kBasicResultLength; i++) {
        if (i >= resultMapPointerUtf8.length) {
          break;
        }

        param.ref.result[i] = resultMapPointerInt8[i];
      }
    });
  }

  /// The value of `methoCall.funcName` should be same as the C function name
  int _interceptCall(
    IrisMethodCall methodCall,
    ffi.Pointer<ffi.Void> apiEnginePtr,
    ffi.Pointer<iris_bindings.ApiParam> param,
  ) {
    switch (methodCall.funcName) {
      case 'GetIrisRtmErrorReason':
        {
          final data = jsonDecode(methodCall.params);
          final errorCode = data['error_code'];
          final reasonPtr = _binding.GetIrisRtmErrorReason(errorCode);
          final reason = reasonPtr.cast<Utf8>().toDartString();

          final result = {'result': reason};
          _response(param, result);

          return 0;
        }
      default:
        break;
    }
    return _doNotInterceptCall;
  }

  @override
  int callApi(
    IrisMethodCall methodCall,
    IrisApiEngineHandle apiEnginePtr,
    IrisApiParamHandle param,
  ) {
    final nApiEnginePtr = apiEnginePtr() as ffi.Pointer<ffi.Void>;
    final nParam = param() as ffi.Pointer<iris_bindings.ApiParam>;
    final interceptRet = _interceptCall(methodCall, nApiEnginePtr, nParam);
    if (interceptRet != _doNotInterceptCall) {
      return interceptRet;
    }

    return _binding.CallIrisRtmApi(nApiEnginePtr, nParam.cast());
  }

  @override
  IrisEventHandlerHandle createIrisEventHandler(
    IrisCEventHandlerHandle eventHandler,
  ) {
    return IrisEventHandlerHandle(_binding.CreateIrisRtmEventHandler(
        (eventHandler() as ffi.Pointer<iris_bindings.IrisCEventHandler>)
            .cast()));
  }

  @override
  void destroyIrisEventHandler(
    IrisEventHandlerHandle handler,
  ) {
    _binding.DestroyIrisRtmEventHandler(handler() as ffi.Pointer<ffi.Void>);
  }

  @override
  void destroyNativeApiEngine(IrisApiEngineHandle apiEnginePtr) {
    _binding.DestroyIrisRtmEngine(apiEnginePtr() as ffi.Pointer<ffi.Void>);
  }

  @override
  Future<CallApiResult> callApiAsync(IrisMethodCall methodCall,
      IrisApiEngineHandle apiEnginePtr, IrisApiParamHandle param) {
    throw UnsupportedError(
        '`callApiAsync` not support on native implementation.');
  }
}

class IrisApiEngineNativeBindingDelegateProvider
    extends PlatformBindingsProvider {
  @override
  PlatformBindingsDelegateInterface provideNativeBindingDelegate() {
    return NativeIrisApiEngineBindingsDelegate();
  }
}
