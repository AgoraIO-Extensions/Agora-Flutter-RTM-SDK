import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:flutter_test/flutter_test.dart';
import '../integration_test/fixture_json.dart';

void main() {
  test('native fixtures retain message and nested history bytes', () {
    final bytes = Uint8List.fromList([0, 128, 255]);
    final event = MessageEvent(message: bytes, messageLength: bytes.length);
    final history = HistoryMessage(message: bytes, messageLength: bytes.length);
    final encoded = jsonDecode(jsonEncode({
      'event': fixtureJsonValue(event),
      'messageList': fixtureJsonValue([history]),
    }));
    expect(encoded['event']['message'], [0, 128, 255]);
    expect(encoded['messageList'][0]['message'], [0, 128, 255]);
    expect(encoded['event']['messageLength'], 3);
  });
}
