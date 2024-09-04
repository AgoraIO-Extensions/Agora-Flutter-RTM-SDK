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
    'RtmStorage.setChannelMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        String lockName = "hello";
        await rtmStorage.setChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.setChannelMetadata] error: ${e.toString()}');
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
    'RtmStorage.updateChannelMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        String lockName = "hello";
        await rtmStorage.updateChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint(
              '[RtmStorage.updateChannelMetadata] error: ${e.toString()}');
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
    'RtmStorage.removeChannelMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        String lockName = "hello";
        await rtmStorage.removeChannelMetadata(
          channelName: channelName,
          channelType: channelType,
          data: data,
          options: options,
          lockName: lockName,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint(
              '[RtmStorage.removeChannelMetadata] error: ${e.toString()}');
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
    'RtmStorage.getChannelMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String channelName = "hello";
        RtmChannelType channelType = RtmChannelType.none;
        await rtmStorage.getChannelMetadata(
          channelName: channelName,
          channelType: channelType,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.getChannelMetadata] error: ${e.toString()}');
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
    'RtmStorage.setUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        await rtmStorage.setUserMetadata(
          userId: userId,
          data: data,
          options: options,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.setUserMetadata] error: ${e.toString()}');
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
    'RtmStorage.updateUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        await rtmStorage.updateUserMetadata(
          userId: userId,
          data: data,
          options: options,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.updateUserMetadata] error: ${e.toString()}');
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
    'RtmStorage.removeUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        int dataMajorRevision = 5;
        List<MetadataItem> dataItems = [];
        int dataItemCount = 5;
        Metadata data = Metadata(
          majorRevision: dataMajorRevision,
          items: dataItems,
          itemCount: dataItemCount,
        );
        bool optionsRecordTs = true;
        bool optionsRecordUserId = true;
        MetadataOptions options = MetadataOptions(
          recordTs: optionsRecordTs,
          recordUserId: optionsRecordUserId,
        );
        await rtmStorage.removeUserMetadata(
          userId: userId,
          data: data,
          options: options,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.removeUserMetadata] error: ${e.toString()}');
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
    'RtmStorage.getUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        await rtmStorage.getUserMetadata(
          userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint('[RtmStorage.getUserMetadata] error: ${e.toString()}');
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
    'RtmStorage.subscribeUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        await rtmStorage.subscribeUserMetadata(
          userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint(
              '[RtmStorage.subscribeUserMetadata] error: ${e.toString()}');
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
    'RtmStorage.unsubscribeUserMetadata',
    (WidgetTester tester) async {
      final rtmClient = await _createBindingRtmClient();
      await rtmClient.setParameters('{"rtm.log_filter":2063}');
      final rtmStorage = RtmStorageImpl(rtmClient.getIrisMethodChannel());

      try {
        String userId = "hello";
        await rtmStorage.unsubscribeUserMetadata(
          userId,
        );
      } catch (e) {
        if (e is! AgoraRtmException) {
          debugPrint(
              '[RtmStorage.unsubscribeUserMetadata] error: ${e.toString()}');
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
