/// GENERATED BY testcase_gen. DO NOT MODIFY BY HAND.

// ignore_for_file: deprecated_member_use,constant_identifier_names,unused_local_variable,unused_import,unnecessary_import

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart'
    as agora_rtm_client_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {
  test(
    'RtmClient.login',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'login');
      LoginResult theLoginResult = LoginResult();
      final mockResultHandlerReturnValue = (theLoginResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, theLoginResult);
      int mockRequestId = 1;
      {
        String token = "hello";
        when(mockRtmClientNativeBinding.login(
          token,
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String token = "hello";
      final ret = await rtmClient.login(
        token,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.logout',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'logout');
      LogoutResult theLogoutResult = LogoutResult();
      final mockResultHandlerReturnValue = (theLogoutResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, theLogoutResult);
      int mockRequestId = 1;
      {
        when(mockRtmClientNativeBinding.logout())
            .thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      final ret = await rtmClient.logout();
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.getStorage',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      {}

      rtmClient.getStorage();

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.getLock',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      {}

      rtmClient.getLock();

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.getPresence',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      {}

      rtmClient.getPresence();

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.renewToken',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'renewToken');
      RtmServiceType theRenewTokenResultServerType = RtmServiceType.none;
      String theRenewTokenResultChannelName = "hello";
      RenewTokenResult theRenewTokenResult = RenewTokenResult(
        serverType: theRenewTokenResultServerType,
        channelName: theRenewTokenResultChannelName,
      );
      final mockResultHandlerReturnValue =
          (theRenewTokenResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, theRenewTokenResult);
      int mockRequestId = 1;
      {
        String token = "hello";
        when(mockRtmClientNativeBinding.renewToken(
          token,
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String token = "hello";
      final ret = await rtmClient.renewToken(
        token,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.publish',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'publish');
      PublishResult thePublishResult = PublishResult();
      final mockResultHandlerReturnValue = (thePublishResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, thePublishResult);
      int mockRequestId = 1;
      {
        String channelName = "hello";
        String message = "hello";
        int length = 5;
        RtmChannelType optionChannelType = RtmChannelType.none;
        RtmMessageType optionMessageType = RtmMessageType.binary;
        String optionCustomType = "hello";
        PublishOptions option = PublishOptions(
          channelType: optionChannelType,
          messageType: optionMessageType,
          customType: optionCustomType,
        );
        when(mockRtmClientNativeBinding.publish(
          channelName: channelName,
          message: message,
          length: length,
          option: argThat(
            isA<PublishOptions>(),
            named: 'option',
          ),
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String channelName = "hello";
      String message = "hello";
      RtmChannelType channelType = RtmChannelType.none;
      String customType = "hello";
      final ret = await rtmClient.publish(
        channelName,
        message,
        channelType: channelType,
        customType: customType,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.subscribe',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'subscribe');
      String theSubscribeResultChannelName = "hello";
      SubscribeResult theSubscribeResult = SubscribeResult(
        channelName: theSubscribeResultChannelName,
      );
      final mockResultHandlerReturnValue =
          (theSubscribeResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, theSubscribeResult);
      int mockRequestId = 1;
      {
        String channelName = "hello";
        bool optionsWithMessage = true;
        bool optionsWithMetadata = true;
        bool optionsWithPresence = true;
        bool optionsWithLock = true;
        bool optionsBeQuiet = true;
        SubscribeOptions options = SubscribeOptions(
          withMessage: optionsWithMessage,
          withMetadata: optionsWithMetadata,
          withPresence: optionsWithPresence,
          withLock: optionsWithLock,
          beQuiet: optionsBeQuiet,
        );
        when(mockRtmClientNativeBinding.subscribe(
          channelName: channelName,
          options: argThat(
            isA<SubscribeOptions>(),
            named: 'options',
          ),
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String channelName = "hello";
      bool withMessage = true;
      bool withMetadata = true;
      bool withPresence = true;
      bool withLock = true;
      bool beQuiet = true;
      final ret = await rtmClient.subscribe(
        channelName,
        withMessage: withMessage,
        withMetadata: withMetadata,
        withPresence: withPresence,
        withLock: withLock,
        beQuiet: beQuiet,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.unsubscribe',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'unsubscribe');
      String theUnsubscribeResultChannelName = "hello";
      UnsubscribeResult theUnsubscribeResult = UnsubscribeResult(
        channelName: theUnsubscribeResultChannelName,
      );
      final mockResultHandlerReturnValue =
          (theUnsubscribeResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue =
          (rtmStatus, theUnsubscribeResult);
      int mockRequestId = 1;
      {
        String channelName = "hello";
        when(mockRtmClientNativeBinding.unsubscribe(
          channelName,
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String channelName = "hello";
      final ret = await rtmClient.unsubscribe(
        channelName,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.setParameters',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      {
        String parameters = "hello";
      }

      String parameters = "hello";
      await rtmClient.setParameters(
        parameters,
      );

      await rtmClient.release();
    },
  );

  test(
    'RtmClient.publishBinaryMessage',
    () async {
      final mockRtmClientNativeBinding = MockRtmClientImplOverride();
      final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
      final (_, rtmClient) =
          await agora_rtm_client_impl.RtmClientImplOverride.create(
        'app_id',
        'user_id',
        rtmClientNativeBinding: mockRtmClientNativeBinding,
        rtmResultHandlerImpl: mockRtmResultHandlerImpl,
      );

      const rtmStatus = RtmStatus.success(operation: 'publishBinaryMessage');
      PublishResult thePublishResult = PublishResult();
      final mockResultHandlerReturnValue = (thePublishResult, RtmErrorCode.ok);
      final expectedResultHandlerReturnValue = (rtmStatus, thePublishResult);
      int mockRequestId = 1;
      {
        String channelName = "hello";
        Uint8List message = Uint8List.fromList([1, 1, 1, 1, 1]);
        int length = 5;
        RtmChannelType optionChannelType = RtmChannelType.none;
        RtmMessageType optionMessageType = RtmMessageType.binary;
        String optionCustomType = "hello";
        PublishOptions option = PublishOptions(
          channelType: optionChannelType,
          messageType: optionMessageType,
          customType: optionCustomType,
        );
        when(mockRtmClientNativeBinding.publishBinaryMessage(
          channelName: channelName,
          message: message,
          length: length,
          option: argThat(
            isA<PublishOptions>(),
            named: 'option',
          ),
        )).thenAnswer((_) async => mockRequestId);
        when(mockRtmResultHandlerImpl.request(mockRequestId))
            .thenAnswer((_) async => mockResultHandlerReturnValue);
      }

      String channelName = "hello";
      Uint8List message = Uint8List.fromList([1, 1, 1, 1, 1]);
      RtmChannelType channelType = RtmChannelType.none;
      String customType = "hello";
      final ret = await rtmClient.publishBinaryMessage(
        channelName,
        message,
        channelType: channelType,
        customType: customType,
      );
      expect(ret, expectedResultHandlerReturnValue);

      await rtmClient.release();
    },
  );
}
