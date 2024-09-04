import 'package:agora_rtm/src/agora_rtm_base.dart';
import 'package:json_annotation/json_annotation.dart';

class IgnoreableJsonConverter<T, S> implements JsonConverter<T?, S?> {
  const IgnoreableJsonConverter();
  @override
  T? fromJson(S? json) {
    return null;
  }

  @override
  S? toJson(T? object) {
    return null;
  }
}

class RtmAreaCodeListConverter
    implements JsonConverter<Set<RtmAreaCode>?, int?> {
  const RtmAreaCodeListConverter();

  @override
  Set<RtmAreaCode>? fromJson(int? json) => null;

  @override
  int? toJson(Set<RtmAreaCode>? areaCodeSet) {
    if (areaCodeSet?.isNotEmpty == true) {
      late int value;
      int index = 0;
      for (final v in areaCodeSet!) {
        if (index == 0) {
          value = v.value();
        } else {
          value = value | v.value();
        }
        ++index;
      }
      return value;
    }

    return null;
  }
}

class RtmServiceTypeListConverter
    implements JsonConverter<Set<RtmServiceType>?, int?> {
  const RtmServiceTypeListConverter();

  @override
  Set<RtmServiceType>? fromJson(int? json) => null;

  @override
  int? toJson(Set<RtmServiceType>? rtmServiceTypeSet) {
    if (rtmServiceTypeSet?.isNotEmpty == true) {
      late int value;
      int index = 0;
      for (final v in rtmServiceTypeSet!) {
        if (index == 0) {
          value = v.value();
        } else {
          value = value | v.value();
        }
        ++index;
      }
      return value;
    }

    return null;
  }
}

int _intPtrStr2Int(String value) {
  // In 64-bits system, the c++ int ptr value (unsigned long 64) can be 2^64 - 1,
  // which may greater than the dart int max value (2^63 - 1), so we can not decode
  // the json with big int c++ int ptr value and parse it directly.
  //
  // After dart sdk 2.0 support parse hexadecimal in unsigned int64 range.
  // https://github.com/dart-lang/language/blob/ee1135e0c22391cee17bf3ee262d6a04582d25de/archive/newsletter/20170929.md#semantics
  //
  // So we retrive the c++ int ptr value from the json string directly, and
  // parse an int from hexadecimal here.
  BigInt valueBI = BigInt.parse(value);
  return int.tryParse('0x${valueBI.toRadixString(16)}') ?? 0;
}

/// Parse a c++ int ptr value from the json key `<key>_str`
Object? readIntPtr(Map json, String key) {
  final newKey = '${key}_str';
  if (json.containsKey(newKey)) {
    final value = json[newKey];
    assert(value is String);
    return _intPtrStr2Int(value);
  }

  return json[key];
}

/// Same as `readIntPtr`, but for list of int ptr.
Object? readIntPtrList(Map json, String key) {
  final newKey = '${key}_str';
  if (json.containsKey(newKey)) {
    final value = json[newKey];
    assert(value is List);
    return List.from(value.map((e) => _intPtrStr2Int(e)));
  }

  return json[key];
}
