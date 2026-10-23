import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';

// SDK JSON omits binary buffers because production carries them out of band.
// Native test fixtures need those bytes explicitly, including nested history.
Object? fixtureJsonValue(Object? value) {
  if (value is MessageEvent) {
    return {...value.toJson(), 'message': value.message?.toList()};
  }
  if (value is HistoryMessage) {
    return {...value.toJson(), 'message': value.message?.toList()};
  }
  if (value is List) return value.map(fixtureJsonValue).toList();
  return value;
}
