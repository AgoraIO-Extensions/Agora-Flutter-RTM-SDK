import 'generated/rtmclient_unit_test.generated.dart' as rtmclient_unit_test;
import 'generated/rtmlock_unit_test.generated.dart' as rtmlock_unit_test;
import 'rtmpresence_unit_test_cases.dart' as rtmpresence_unit_test;
import 'generated/rtmstorage_unit_test.generated.dart' as rtmstorage_unit_test;
import 'generated/streamchannel_unit_test.generated.dart'
    as streamchannel_unit_test;

void main() {
  rtmclient_unit_test.testCases();
  rtmlock_unit_test.testCases();
  rtmpresence_unit_test.testCases();
  rtmstorage_unit_test.testCases();
  streamchannel_unit_test.testCases();
}
