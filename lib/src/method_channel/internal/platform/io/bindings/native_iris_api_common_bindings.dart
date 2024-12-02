// ignore_for_file: camel_case_types, non_constant_identifier_names, public_member_api_docs

import 'dart:ffi' as ffi;

final class ApiParam extends ffi.Struct {
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

// typedef IrisEventHandlerHandle = ffi.Pointer<ffi.Void>;

final class IrisCEventHandler extends ffi.Struct {
  external Func_Event OnEvent;
}

typedef Func_Event = ffi
    .Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<EventParam>)>>;

final class EventParam extends ffi.Struct {
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
