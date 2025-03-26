import 'package:flutter_test/flutter_test.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

void main() {
  testWidgets('Integration.call_rtc_and_rtm_without_crash',
      (WidgetTester tester) async {
    try {
      final (_, rtmClient) = await RTM("test_app_id", "test_user_id");
      await rtmClient.release();
    } catch (e) {
      print('all exception is allowed: $e');
    }

    try {
      final rtcEngine = createAgoraRtcEngine();
      const context = RtcEngineContext(appId: "test_app_id");
      await rtcEngine.initialize(context);
      await rtcEngine.release();
    } catch (e) {
      print('all exception is allowed: $e');
    }
  });
}
