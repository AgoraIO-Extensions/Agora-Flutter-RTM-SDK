import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'all_mocks.mocks.dart';
import 'generated/rtmpresence_unit_test.generated.dart' as generated;
import 'package:agora_rtm/src/impl/gen/agora_rtm_presence_impl.dart'
    as rtm_presence_impl;

void testCases() {
  generated.testCases();

  test(
    'RtmPresence.setState',
    () async {
      final mockRtmPresenceNativeBinding = MockRtmPresenceImpl();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      RtmPresence rtmPresence = rtm_presence_impl.RtmPresenceImpl(
        mockRtmPresenceNativeBinding,
        mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'setState');
      int mockRequestId = 1;
      SetStateResult setStateResult = SetStateResult();
      final mockResultHandlerReturnValue = (setStateResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, setStateResult);
      {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;

        when(mockRtmPresenceNativeBinding.setState(
          channelName: channelName,
          channelType: channelType,
          items: argThat(
            isA<List<StateItem>>(),
            named: 'items',
          ),
          count: 1,
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String channelName = "hello";
      RtmChannelType channelType = RtmChannelType.none;
      Map<String, String> items = {'key1': 'value1'};

      final ret = await rtmPresence.setState(
        channelName,
        channelType,
        items,
      );
      expect(ret, expectedResultHandlerReturnValue);
    },
  );
}
