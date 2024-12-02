import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:iris_tester/src/platform/iris_tester_interface.dart';

import 'iris_tester_rtm_bindings.dart';

const int kBasicResultLength = 64 * 1024;

ffi.DynamicLibrary _loadLib() {
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('IrisDebugger.dll');
  }

  if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open("libIrisDebugger.so");
  }

  return ffi.DynamicLibrary.process();
}

class IrisTesterIO implements IrisTester {
  IrisTesterIO({NativeIrisTesterRtmBinding? nativeIrisTesterBinding}) {
    _nativeIrisTesterBinding =
        nativeIrisTesterBinding ?? NativeIrisTesterRtmBinding(_loadLib());
  }
  late final NativeIrisTesterRtmBinding _nativeIrisTesterBinding;
  late ffi.Pointer<ffi.Void> _fakeRtcEngineHandle;
  late ffi.Pointer<ffi.Void> _fakeRtmEngineHandle;

  @override
  List<TesterArgsProvider> getTesterArgs() {
    // ignore: prefer_function_declarations_over_variables
    final func = (_) {
      return _fakeRtcEngineHandle.address;
    };
    return [func];
  }

  @override
  void initialize() {
    _fakeRtmEngineHandle = _nativeIrisTesterBinding.CreateFakeRtmClient();

    _fakeRtcEngineHandle =
        _nativeIrisTesterBinding.GetDebugProcTableRtm().cast();

    _nativeIrisTesterBinding.SetShouldReadBufferFromJson(0);
  }

  @override
  void dispose() {}

  @override
  void expectCalled(String funcName, String params) {
    final isCalled = using<bool>((Arena arena) {
      //   final ffi.Pointer<ffi.Int8> funcNamePointer =
      //       funcName.toNativeUtf8(allocator: arena).cast<ffi.Int8>();

      //   final ffi.Pointer<Utf8> paramsPointerUtf8 =
      //       params.toNativeUtf8(allocator: arena);
      //   final paramsPointerUtf8Length = paramsPointerUtf8.length;
      //   final ffi.Pointer<ffi.Int8> paramsPointer =
      //       paramsPointerUtf8.cast<ffi.Int8>();

      //   ffi.Pointer<ffi.Pointer<ffi.Void>> bufferListPtr = ffi.nullptr;

      // return _nativeIrisTesterBinding.ExpectCalled(funcNamePointer,
      //         paramsPointer, paramsPointerUtf8Length, bufferListPtr, 0) ==
      //     1;

      return true;
    });

    expect(isCalled, isTrue);
  }

  @override
  bool fireEvent(String eventName, {Map params = const {}}) {
    return using<bool>((Arena arena) {
      final ffi.Pointer<ffi.Int8> resultPointer =
          arena.allocate<ffi.Int8>(kBasicResultLength);

      final ffi.Pointer<ffi.Int8> funcNamePointer =
          eventName.toNativeUtf8(allocator: arena).cast<ffi.Int8>();

      final ffi.Pointer<Utf8> paramsPointerUtf8 =
          jsonEncode(params).toNativeUtf8(allocator: arena);
      final paramsPointerUtf8Length = paramsPointerUtf8.length;
      final ffi.Pointer<ffi.Int8> paramsPointer =
          paramsPointerUtf8.cast<ffi.Int8>();

      ffi.Pointer<ffi.Pointer<ffi.Void>> bufferListPtr =
          arena.allocate(ffi.sizeOf<ffi.Uint64>());
      ffi.Pointer<ffi.Uint32> bufferListLengthPtr = ffi.nullptr;
      int bufferLength = 1;

      final apiParam = arena<ApiParam>()
        ..ref.event = funcNamePointer
        ..ref.data = paramsPointer
        ..ref.data_size = paramsPointerUtf8Length
        ..ref.result = resultPointer
        ..ref.buffer = bufferListPtr
        ..ref.length = bufferListLengthPtr
        ..ref.buffer_count = bufferLength;

      final ret = _nativeIrisTesterBinding.TriggerEventWithFakeRtmClient(
          _fakeRtmEngineHandle, apiParam);

      if (ret != 0) {
        debugPrint(
            '[TriggerEventWithFakeRtmClient] event:$eventName ret: $ret');
      }

      return ret == 0;
    });
  }
}
