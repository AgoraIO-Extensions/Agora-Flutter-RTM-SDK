/// GENERATED BY testcase_gen. DO NOT MODIFY BY HAND.

// ignore_for_file: deprecated_member_use,constant_identifier_names,unused_local_variable,unused_import,unnecessary_import

import 'package:agora_rtm/agora_rtm.dart' show AgoraRtmException;
import 'package:agora_rtm/src/bindings/gen/binding_forward_export.dart';
import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';
import 'package:agora_rtm/src/bindings/native_iris_api_engine_binding_delegate.dart';
import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:iris_method_channel/iris_method_channel.dart';

void testCases(
    ValueGetter<List<InitilizationArgProvider>>
        irisMethodChannelInitilizationArgs) {
  Future<RtmClientImplOverride> _createBindingRtmClient() async {
    String appId = const String.fromEnvironment('TEST_APP_ID',
        defaultValue: '<YOUR_APP_ID>');
    final rtmResultHandler = RtmResultHandlerImpl();
    final client = RtmClientImplOverride.create(
      IrisMethodChannel(IrisApiEngineNativeBindingDelegateProvider()),
    );
    await client.initialize(
      appId,
      'user_id',
      rtmResultHandler.rtmEventHandler,
      args: irisMethodChannelInitilizationArgs(),
    );
    return client;
  }

  testWidgets(
    'RtmPresence.whoNow',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        bool optionsIncludeUserId = true;
        bool optionsIncludeState = true;
        String optionsPage = "hello";
        PresenceOptions options = PresenceOptions(
          includeUserId: optionsIncludeUserId,
          includeState: optionsIncludeState,
          page: optionsPage,
        );
        await rtmPresence.whoNow(
          channelName: channelName,
          channelType: channelType,
          options: options,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.whoNow] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.whereNow',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        await rtmPresence.whereNow(
          userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.whereNow] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.setState',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        final List<StateItem> items = () {
          String itemsItemKey = "hello";
          String itemsItemValue = "hello";
          StateItem itemsItem = StateItem(
            key: itemsItemKey,
            value: itemsItemValue,
          );

          return List.filled(5, itemsItem);
        }();

        int count = 5;
        await rtmPresence.setState(
          channelName: channelName,
          channelType: channelType,
          items: items,
          count: count,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.setState] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.removeState',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        List<String> keys = List.filled(5, "hello");
        int count = 5;
        await rtmPresence.removeState(
          channelName: channelName,
          channelType: channelType,
          keys: keys,
          count: count,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.removeState] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.getState',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        String userId = "hello";
        await rtmPresence.getState(
          channelName: channelName,
          channelType: channelType,
          userId: userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.getState] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.getOnlineUsers',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        bool optionsIncludeUserId = true;
        bool optionsIncludeState = true;
        String optionsPage = "hello";
        GetOnlineUsersOptions options = GetOnlineUsersOptions(
          includeUserId: optionsIncludeUserId,
          includeState: optionsIncludeState,
          page: optionsPage,
        );
        await rtmPresence.getOnlineUsers(
          channelName: channelName,
          channelType: channelType,
          options: options,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.getOnlineUsers] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );

  testWidgets(
    'RtmPresence.getUserChannels',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmPresence = RtmPresenceImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        await rtmPresence.getUserChannels(
          userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmPresence.getUserChannels] error: ${e.toString()}');
          rethrow;
        }

        if (e.code != -4) {
          // Only not supported error supported.
          rethrow;
        }
      }

      await rtmClient.release();
    },
  );
}
