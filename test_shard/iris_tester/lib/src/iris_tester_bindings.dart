// ignore_for_file: camel_case_types, non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

/// Bindings to IrisApiEngine
class NativeIrisTesterRtmBinding {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeIrisTesterRtmBinding(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeIrisTesterRtmBinding.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  ffi.Pointer<ffi.Void> CreateFakeRtmClient() {
    return _CreateFakeRtmClient();
  }

  late final _CreateFakeRtmClientPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Void> Function()>>(
          'CreateFakeRtmClient');
  late final _CreateFakeRtmClient =
      _CreateFakeRtmClientPtr.asFunction<ffi.Pointer<ffi.Void> Function()>();

  int TriggerEventWithFakeRtmClient(
    ffi.Pointer<ffi.Void> rtm_client,
    ffi.Pointer<ApiParam> param,
  ) {
    return _TriggerEventWithFakeRtmClient(
      rtm_client,
      param,
    );
  }

  late final _TriggerEventWithFakeRtmClientPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int32 Function(ffi.Pointer<ffi.Void>,
              ffi.Pointer<ApiParam>)>>('TriggerEventWithFakeRtmClient');
  late final _TriggerEventWithFakeRtmClient = _TriggerEventWithFakeRtmClientPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ApiParam>)>();

  /// @brief Whether read buffer from json. Some frameworks, for example Flutter does not support pass the buffer as a pointer in test yet,
  /// maybe support in the future.
  void SetShouldReadBufferFromJson(
    int readBufferFromJson,
  ) {
    return _SetShouldReadBufferFromJson(
      readBufferFromJson,
    );
  }

  late final _SetShouldReadBufferFromJsonPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int32)>>(
          'SetShouldReadBufferFromJson');
  late final _SetShouldReadBufferFromJson =
      _SetShouldReadBufferFromJsonPtr.asFunction<void Function(int)>();

  int GetShouldReadBufferFromJson() {
    return _GetShouldReadBufferFromJson();
  }

  late final _GetShouldReadBufferFromJsonPtr =
      _lookup<ffi.NativeFunction<ffi.Int32 Function()>>(
          'GetShouldReadBufferFromJson');
  late final _GetShouldReadBufferFromJson =
      _GetShouldReadBufferFromJsonPtr.asFunction<int Function()>();
}

typedef ApiParam = EventParam;

class EventParam extends ffi.Struct {
  external ffi.Pointer<ffi.Int8> event;

  external ffi.Pointer<ffi.Int8> data;

  @ffi.Uint32()
  external int data_size;

  external ffi.Pointer<ffi.Int8> result;

  external ffi.Pointer<ffi.Pointer<ffi.Void>> buffer;

  external ffi.Pointer<ffi.Uint32> length;

  @ffi.Uint32()
  external int buffer_count;
}
