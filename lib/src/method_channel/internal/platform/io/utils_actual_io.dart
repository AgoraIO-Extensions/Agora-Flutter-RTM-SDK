import 'dart:ffi' as ffi;
import 'dart:typed_data';

// ignore_for_file: public_member_api_docs

Uint8List uint8ListFromPtr(int intPtr, int length) {
  final ptr = ffi.Pointer<ffi.Uint8>.fromAddress(intPtr);
  final memoryList = ptr.asTypedList(length);
  return Uint8List.fromList(memoryList);
}
