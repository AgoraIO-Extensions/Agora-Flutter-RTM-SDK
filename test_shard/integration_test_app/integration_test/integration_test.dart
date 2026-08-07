import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

    // Delay to let background native threads clean up their resources
    // before Dart VM exits, preventing native crashes like -7 or OOM.
    await Future.delayed(const Duration(seconds: 2));
    
    // Explicitly assert so that flutter test runner will not fail with exit code 79
    // or report "No tests were found."
    expect(true, isTrue);
  });
}
