import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('static fromValue() with enums', () {
    test('RtmLinkState', () {
      for (final e in RtmLinkState.values) {
        expect(RtmLinkState.fromValue(e.value()), e);
      }
    });
    test('RtmLinkOperation', () {
      for (final e in RtmLinkOperation.values) {
        expect(RtmLinkOperation.fromValue(e.value()), e);
      }
    });
    test('RtmServiceType', () {
      for (final e in RtmServiceType.values) {
        expect(RtmServiceType.fromValue(e.value()), e);
      }
    });
    test('RtmProtocolType', () {
      for (final e in RtmProtocolType.values) {
        expect(RtmProtocolType.fromValue(e.value()), e);
      }
    });
    test('RtmAreaCode', () {
      for (final e in RtmAreaCode.values) {
        expect(RtmAreaCode.fromValue(e.value()), e);
      }
    });
    test('RtmLogLevel', () {
      for (final e in RtmLogLevel.values) {
        expect(RtmLogLevel.fromValue(e.value()), e);
      }
    });
    test('RtmEncryptionMode', () {
      for (final e in RtmEncryptionMode.values) {
        expect(RtmEncryptionMode.fromValue(e.value()), e);
      }
    });
    test('RtmErrorCode', () {
      for (final e in RtmErrorCode.values) {
        expect(RtmErrorCode.fromValue(e.value()), e);
      }
    });
    test('RtmConnectionState', () {
      for (final e in RtmConnectionState.values) {
        expect(RtmConnectionState.fromValue(e.value()), e);
      }
    });
    test('RtmConnectionChangeReason', () {
      for (final e in RtmConnectionChangeReason.values) {
        expect(RtmConnectionChangeReason.fromValue(e.value()), e);
      }
    });
    test('RtmChannelType', () {
      for (final e in RtmChannelType.values) {
        expect(RtmChannelType.fromValue(e.value()), e);
      }
    });
    test('RtmMessageType', () {
      for (final e in RtmMessageType.values) {
        expect(RtmMessageType.fromValue(e.value()), e);
      }
    });
    test('RtmStorageType', () {
      for (final e in RtmStorageType.values) {
        expect(RtmStorageType.fromValue(e.value()), e);
      }
    });
    test('RtmStorageEventType', () {
      for (final e in RtmStorageEventType.values) {
        expect(RtmStorageEventType.fromValue(e.value()), e);
      }
    });
    test('RtmLockEventType', () {
      for (final e in RtmLockEventType.values) {
        expect(RtmLockEventType.fromValue(e.value()), e);
      }
    });
    test('RtmProxyType', () {
      for (final e in RtmProxyType.values) {
        expect(RtmProxyType.fromValue(e.value()), e);
      }
    });
    test('RtmTopicEventType', () {
      for (final e in RtmTopicEventType.values) {
        expect(RtmTopicEventType.fromValue(e.value()), e);
      }
    });
    test('RtmPresenceEventType', () {
      for (final e in RtmPresenceEventType.values) {
        expect(RtmPresenceEventType.fromValue(e.value()), e);
      }
    });
    test('RtmMessageQos', () {
      for (final e in RtmMessageQos.values) {
        expect(RtmMessageQos.fromValue(e.value()), e);
      }
    });
    test('RtmMessageQos', () {
      for (final e in RtmMessageQos.values) {
        expect(RtmMessageQos.fromValue(e.value()), e);
      }
    });
  });
}
