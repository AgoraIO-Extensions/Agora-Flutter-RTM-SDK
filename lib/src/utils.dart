import 'dart:typed_data';

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

@JsonSerializable(constructor: '_')
class RtmMessage {
  String text;
  @JsonKey(fromJson: _rawMessage, toJson: _rawMessage)
  Uint8List? rawMessage;
  RtmMessageType messageType;
  int? serverReceivedTs;
  bool? isOfflineMessage;

  RtmMessage._(
    this.text,
    this.messageType, {
    this.rawMessage,
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
  String? lastUpdateUserId;
  int? lastUpdateTs;

  RtmChannelAttribute(
    this.key,
    this.value, {
    this.lastUpdateUserId,
    this.lastUpdateTs,
  });

  factory RtmChannelAttribute.fromJson(Map<String, dynamic> json) =>
      _$RtmChannelAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelAttributeToJson(this);
}

@JsonSerializable(constructor: '_')
class LocalInvitation {
  String calleeId;
  String? content;
  String? response;
  String? channelId;
  int state;
  @JsonKey(name: 'hashCode')
  int handle;

  LocalInvitation._(
    this.calleeId, {
    this.content,
    this.response,
    this.channelId,
    this.state = 0,
    this.handle = 0,
  });

  factory LocalInvitation.fromJson(Map<String, dynamic> json) =>
      _$LocalInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$LocalInvitationToJson(this);
}

@JsonSerializable(constructor: '_')
class RemoteInvitation {
  String callerId;
  String? content;
  String? response;
  String? channelId;
  int state;
  @JsonKey(name: 'hashCode')
  int handle;

  RemoteInvitation._(
    this.callerId, {
    this.content,
    this.response,
    this.channelId,
    this.state = 0,
    this.handle = 0,
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
  @Deprecated('Removed in v1.5.0')
  bool? enableOfflineMessaging;
  @Deprecated('Removed in v1.5.0')
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
  String channelId;
  int memberCount;

  RtmChannelMemberCount(
    this.channelId,
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
