import 'dart:io';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'utils.g.dart';

@JsonEnum()
enum RtmMessageType {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  text,
  @JsonValue(2)
  raw
}

@JsonSerializable()
class RtmMessage {
  String? text;
  @JsonKey(fromJson: _rawMessage, toJson: _rawMessage)
  Uint8List? rawMessage;
  RtmMessageType? messageType;
  int? serverReceivedTs;
  bool? isOfflineMessage;

  RtmMessage({
    this.text,
    this.rawMessage,
    this.messageType,
    this.serverReceivedTs,
    this.isOfflineMessage,
  });

  RtmMessage.fromText(this.text) : messageType = RtmMessageType.text;

  RtmMessage.fromRaw(this.rawMessage, this.text)
      : messageType = RtmMessageType.raw;

  factory RtmMessage.fromJson(Map<String, dynamic> json) =>
      _$RtmMessageFromJson(json);

  Map<String, dynamic> toJson() => _$RtmMessageToJson(this);

  static Uint8List? _rawMessage(Uint8List? rawMessage) => rawMessage;
}

@JsonSerializable()
class RtmChannelMember {
  String userId;
  String channelId;

  RtmChannelMember(
    this.userId,
    this.channelId,
  );

  factory RtmChannelMember.fromJson(Map<String, dynamic> json) =>
      _$RtmChannelMemberFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelMemberToJson(this);
}

@JsonSerializable()
class RtmAttribute {
  String key;
  String value;

  RtmAttribute(
    this.key,
    this.value,
  );

  factory RtmAttribute.fromJson(Map<String, dynamic> json) =>
      _$RtmAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$RtmAttributeToJson(this);
}

@JsonSerializable()
class RtmChannelAttribute {
  String key;
  String value;
  String lastUpdateUserId;
  int lastUpdateTs;

  RtmChannelAttribute(
    this.key,
    this.value, {
    this.lastUpdateUserId = "",
    this.lastUpdateTs = 0,
  });

  factory RtmChannelAttribute.fromJson(Map<String, dynamic> json) =>
      _$RtmChannelAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelAttributeToJson(this);
}

@JsonSerializable()
class LocalInvitation {
  String calleeId;
  String? content;
  String? response;
  String? channelId;
  int state;

  LocalInvitation(
    this.calleeId, {
    this.content,
    this.response,
    this.channelId,
    this.state = 0,
  });

  factory LocalInvitation.fromJson(Map<String, dynamic> json) =>
      _$LocalInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$LocalInvitationToJson(this);
}

@JsonSerializable()
class RemoteInvitation {
  String callerId;
  String? content;
  String? response;
  String? channelId;
  int state;

  RemoteInvitation(
    this.callerId, {
    this.content,
    this.response,
    this.channelId,
    this.state = 0,
  });

  factory RemoteInvitation.fromJson(Map<String, dynamic> json) =>
      _$RemoteInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteInvitationToJson(this);
}

@JsonSerializable()
class ChannelAttributeOptions {
  bool enableNotificationToChannelMembers;

  ChannelAttributeOptions(
    this.enableNotificationToChannelMembers,
  );

  factory ChannelAttributeOptions.fromJson(Map<String, dynamic> json) =>
      _$ChannelAttributeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelAttributeOptionsToJson(this);
}

@JsonSerializable()
class SendMessageOptions {
  bool? enableOfflineMessaging;
  bool? enableHistoricalMessaging;

  SendMessageOptions({
    this.enableOfflineMessaging,
    this.enableHistoricalMessaging,
  });

  factory SendMessageOptions.fromJson(Map<String, dynamic> json) =>
      _$SendMessageOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageOptionsToJson(this);
}

@JsonSerializable()
class RtmChannelMemberCount {
  String channelID;
  int memberCount;

  RtmChannelMemberCount(
    this.channelID,
    this.memberCount,
  );

  factory RtmChannelMemberCount.fromJson(Map<String, dynamic> json) =>
      _$RtmChannelMemberCountFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelMemberCountToJson(this);
}

/// [RtmMessage]
@Deprecated('Use RtmMessage instead of.')
typedef AgoraRtmMessage = RtmMessage;

/// [RtmChannelMember]
@Deprecated('Use RtmChannelMember instead of.')
typedef AgoraRtmMember = RtmChannelMember;

/// [RtmChannelAttribute]
@Deprecated('Use RtmChannelAttribute instead of.')
typedef AgoraRtmChannelAttribute = RtmChannelAttribute;

/// [LocalInvitation]
@Deprecated('Use LocalInvitation instead of.')
typedef AgoraRtmLocalInvitation = LocalInvitation;

/// [RemoteInvitation]
@Deprecated('Use RemoteInvitation instead of.')
typedef AgoraRtmRemoteInvitation = RemoteInvitation;
