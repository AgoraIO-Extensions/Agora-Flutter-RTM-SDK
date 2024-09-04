import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart'
    as agora_rtm_client_impl;
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:mockito/mockito.dart';

import 'all_mocks.mocks.dart';

void main() {
  test(
    'addListener token',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final fakeRtmResultHandlerImpl = RtmResultHandlerImpl();

      when(mockRtmClientNativeBinding.initialize(
        'app_id',
        'user_id',
        fakeRtmResultHandlerImpl.rtmEventHandler,
        config: argThat(isNull, named: 'config'),
        args: argThat(isNotNull, named: 'args'),
      )).thenAnswer((_) async => const RtmStatus.success(operation: 'RTM'));

      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: fakeRtmResultHandlerImpl,
      );

      final tokenCompleter = Completer<String>();

      rtmClient.addListener(
        token: (event) {
          if (!tokenCompleter.isCompleted) {
            tokenCompleter.complete(event.channelName);
          }
        },
      );

      fakeRtmResultHandlerImpl.onTokenPrivilegeWillExpire('channelName');

      final channelName = await tokenCompleter.future;
      expect(channelName, 'channelName');
    },
  );

  test(
    'addListener token',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final fakeRtmResultHandlerImpl = RtmResultHandlerImpl();

      when(mockRtmClientNativeBinding.initialize(
        'app_id',
        'user_id',
        fakeRtmResultHandlerImpl.rtmEventHandler,
        config: argThat(isNull, named: 'config'),
        args: argThat(isNotNull, named: 'args'),
      )).thenAnswer((_) async => const RtmStatus.success(operation: 'RTM'));

      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: fakeRtmResultHandlerImpl,
      );

      final tokenCompleter = Completer<String>();

      rtmClient.addListener(
        token: (event) {
          if (!tokenCompleter.isCompleted) {
            tokenCompleter.complete(event.channelName);
          }
        },
      );

      rtmClient.removeListener(
        token: (event) {
          if (!tokenCompleter.isCompleted) {
            tokenCompleter.complete(event.channelName);
          }
        },
      );

      fakeRtmResultHandlerImpl.onTokenPrivilegeWillExpire('channelName');

      String channelName = '';
      try {
        channelName = await tokenCompleter.future
            .timeout(const Duration(milliseconds: 10));
      } on TimeoutException {
        expect(channelName, '');
      }
    },
  );
}
