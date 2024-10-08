/// GENERATED BY terra, DO NOT MODIFY BY HAND.

// ignore_for_file: public_member_api_docs, unused_local_variable, unused_import, prefer_is_empty

import 'package:agora_rtm/src/binding_forward_export.dart';

extension RtmLogConfigBufferExt on RtmLogConfig {
  RtmLogConfig fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension UserListBufferExt on UserList {
  UserList fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension PublisherInfoBufferExt on PublisherInfo {
  PublisherInfo fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension TopicInfoBufferExt on TopicInfo {
  TopicInfo fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension StateItemBufferExt on StateItem {
  StateItem fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension LockDetailBufferExt on LockDetail {
  LockDetail fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension UserStateBufferExt on UserState {
  UserState fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension SubscribeOptionsBufferExt on SubscribeOptions {
  SubscribeOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension ChannelInfoBufferExt on ChannelInfo {
  ChannelInfo fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension PresenceOptionsBufferExt on PresenceOptions {
  PresenceOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension PublishOptionsBufferExt on PublishOptions {
  PublishOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension TopicMessageOptionsBufferExt on TopicMessageOptions {
  TopicMessageOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension GetOnlineUsersOptionsBufferExt on GetOnlineUsersOptions {
  GetOnlineUsersOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension RtmProxyConfigBufferExt on RtmProxyConfig {
  RtmProxyConfig fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension RtmEncryptionConfigBufferExt on RtmEncryptionConfig {
  RtmEncryptionConfig fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    Uint8List? encryptionSalt;
    if (bufferList.length > 0) {
      encryptionSalt = bufferList[0];
    }
    return RtmEncryptionConfig(
        encryptionMode: encryptionMode,
        encryptionKey: encryptionKey,
        encryptionSalt: encryptionSalt);
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    if (encryptionSalt != null) {
      bufferList.add(encryptionSalt!);
    }
    return bufferList;
  }
}

extension RtmPrivateConfigBufferExt on RtmPrivateConfig {
  RtmPrivateConfig fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension RtmConfigBufferExt on RtmConfig {
  RtmConfig fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension LinkStateEventBufferExt on LinkStateEvent {
  LinkStateEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension MessageEventBufferExt on MessageEvent {
  MessageEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    Uint8List? message;
    if (bufferList.length > 0) {
      message = bufferList[0];
    }
    return MessageEvent(
        channelType: channelType,
        messageType: messageType,
        channelName: channelName,
        channelTopic: channelTopic,
        message: message,
        messageLength: messageLength,
        publisher: publisher,
        customType: customType,
        timestamp: timestamp);
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    if (message != null) {
      bufferList.add(message!);
    }
    return bufferList;
  }
}

extension PresenceEventBufferExt on PresenceEvent {
  PresenceEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension IntervalInfoBufferExt on IntervalInfo {
  IntervalInfo fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension SnapshotInfoBufferExt on SnapshotInfo {
  SnapshotInfo fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension TopicEventBufferExt on TopicEvent {
  TopicEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension LockEventBufferExt on LockEvent {
  LockEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension StorageEventBufferExt on StorageEvent {
  StorageEvent fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension MetadataOptionsBufferExt on MetadataOptions {
  MetadataOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension MetadataItemBufferExt on MetadataItem {
  MetadataItem fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension MetadataBufferExt on Metadata {
  Metadata fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension JoinChannelOptionsBufferExt on JoinChannelOptions {
  JoinChannelOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension JoinTopicOptionsBufferExt on JoinTopicOptions {
  JoinTopicOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}

extension TopicOptionsBufferExt on TopicOptions {
  TopicOptions fillBuffers(List<Uint8List> bufferList) {
    if (bufferList.isEmpty) return this;
    return this;
  }

  List<Uint8List> collectBufferList() {
    final bufferList = <Uint8List>[];
    return bufferList;
  }
}
