import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';

import 'package:agora_rtm/src/method_channel/internal/platform/io/bindings/native_iris_event_bindings.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_event_interface.dart';

const _libName = 'agora_rtm';

ffi.DynamicLibrary _loadLib() {
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }

  if (Platform.isAndroid) {
    return ffi.DynamicLibrary.open('lib$_libName.so');
  }

  return ffi.DynamicLibrary.process();
}

/// [IrisEvent] implementation of `dart:io`
class IrisEventIO implements IrisEvent {
  /// Construct [IrisEventIO]
  IrisEventIO() {
    _nativeIrisEventBinding = NativeIrisEventBinding(_loadLib());
  }

  late final NativeIrisEventBinding _nativeIrisEventBinding;

  /// Initialize the [IrisEvent], which call `RtmInitDartApiDL` directly
  void initialize() {
    _nativeIrisEventBinding.RtmInitDartApiDL(ffi.NativeApi.initializeApiDLData);
  }

  /// Register dart [SendPort] to send the message from native
  void registerEventHandler(SendPort sendPort) {
    _nativeIrisEventBinding.RtmRegisterDartPort(sendPort.nativePort);
  }

  /// Unregister dart [SendPort] which used to send the message from native
  void unregisterEventHandler(SendPort sendPort) {
    _nativeIrisEventBinding.RtmUnregisterDartPort(sendPort.nativePort);
  }

  /// Clean up native resources
  void dispose() {
    _nativeIrisEventBinding.RtmDispose();
  }

  /// Get the onEvent function pointer from C
  ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<EventParam>)>>
      get onEventPtr => _nativeIrisEventBinding.addresses.RtmOnEvent;
}
