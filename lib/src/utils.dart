import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'utils.g.dart';

@JsonEnum(alwaysCreate: true)
enum RtmMessageType {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  text,
  @JsonValue(2)
  raw,
}

extension RtmMessageTypeExtension on RtmMessageType {
  static RtmMessageType fromJson(int json) =>
      $enumDecode(_$RtmMessageTypeEnumMap, json);

  int toJson() => _$RtmMessageTypeEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionState {
  @JsonValue(1)
  disconnected,
  @JsonValue(2)
  connecting,
  @JsonValue(3)
  connected,
  @JsonValue(4)
  reconnecting,
  @JsonValue(5)
  aborted,
}

extension RtmConnectionStateExtension on RtmConnectionState {
  static RtmConnectionState fromJson(int json) =>
      $enumDecode(_$RtmConnectionStateEnumMap, json);

  int toJson() => _$RtmConnectionStateEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionChangeReason {
  @JsonValue(1)
  login,
  @JsonValue(2)
  loginSuccess,
  @JsonValue(3)
  loginFailure,
  @JsonValue(4)
  loginTimeout,
  @JsonValue(5)
  interrupt,
  @JsonValue(6)
  logout,
  @JsonValue(7)
  bannedByServer,
  @JsonValue(8)
  remoteLogin,
  @JsonValue(9)
  tokenExpired,
}

extension RtmConnectionChangeReasonExtension on RtmConnectionChangeReason {
  static RtmConnectionChangeReason fromJson(int json) =>
      $enumDecode(_$RtmConnectionChangeReasonEnumMap, json);

  int toJson() => _$RtmConnectionChangeReasonEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmPeerOnlineState {
  @JsonValue(0)
  online,
  @JsonValue(1)
  unreachable,
  @JsonValue(2)
  offline,
}

extension RtmPeerOnlineStateExtension on RtmPeerOnlineState {
  static RtmPeerOnlineState fromJson(int json) =>
      $enumDecode(_$RtmPeerOnlineStateEnumMap, json);

  int toJson() => _$RtmPeerOnlineStateEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmPeerSubscriptionOption {
  @JsonValue(0)
  onlineStatus,
}

extension RtmPeerSubscriptionOptionExtension on RtmPeerSubscriptionOption {
  static RtmPeerSubscriptionOption fromJson(int json) =>
      $enumDecode(_$RtmPeerSubscriptionOptionEnumMap, json);

  int toJson() => _$RtmPeerSubscriptionOptionEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmLogFilter {
  @JsonValue(0)
  off,
  @JsonValue(15)
  info,
  @JsonValue(14)
  warn,
  @JsonValue(12)
  error,
  @JsonValue(8)
  critical,
  @JsonValue(2063)
  mask,
}

extension RtmLogFilterExtension on RtmLogFilter {
  static RtmLogFilter fromJson(int json) =>
      $enumDecode(_$RtmLogFilterEnumMap, json);

  int toJson() => _$RtmLogFilterEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmLocalInvitationState {
  @JsonValue(0)
  idle,
  @JsonValue(1)
  sentToRemote,
  @JsonValue(2)
  receivedByRemote,
  @JsonValue(3)
  acceptedByRemote,
  @JsonValue(4)
  refusedByLocal,
  @JsonValue(5)
  canceled,
  @JsonValue(6)
  failure,
}

extension RtmLocalInvitationStateExtension on RtmLocalInvitationState {
  static RtmLocalInvitationState fromJson(int json) =>
      $enumDecode(_$RtmLocalInvitationStateEnumMap, json);

  int toJson() => _$RtmLocalInvitationStateEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmRemoteInvitationState {
  @JsonValue(0)
  idle,
  @JsonValue(1)
  invitationReceived,
  @JsonValue(2)
  acceptSentToLocal,
  @JsonValue(3)
  refused,
  @JsonValue(4)
  accepted,
  @JsonValue(5)
  canceled,
  @JsonValue(6)
  failure,
}

extension RtmRemoteInvitationStateExtension on RtmRemoteInvitationState {
  static RtmRemoteInvitationState fromJson(int json) =>
      $enumDecode(_$RtmRemoteInvitationStateEnumMap, json);

  int toJson() => _$RtmRemoteInvitationStateEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmAreaCode {
  @JsonValue(0)
  CN,
  @JsonValue(2)
  NA,
  @JsonValue(4)
  EU,
  @JsonValue(8)
  AS,
  @JsonValue(16)
  JP,
  @JsonValue(32)
  IN,
  @JsonValue(-1)
  GLOB,
}

extension RtmAreaCodeExtension on RtmAreaCode {
  static RtmAreaCode fromJson(int json) =>
      $enumDecode(_$RtmAreaCodeEnumMap, json);

  int toJson() => _$RtmAreaCodeEnumMap[this]!;
}

@JsonEnum(alwaysCreate: true)
enum RtmCloudProxyType {
  @JsonValue(0)
  noneProxy,
  @JsonValue(1)
  tcpProxy,
}

extension RtmCloudProxyTypeExtension on RtmCloudProxyType {
  static RtmCloudProxyType fromJson(int json) =>
      $enumDecode(_$RtmCloudProxyTypeEnumMap, json);

  int toJson() => _$RtmCloudProxyTypeEnumMap[this]!;
}

@JsonSerializable(anyMap: true, constructor: '_')
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

  factory RtmMessage.fromJson(Map json) => _$RtmMessageFromJson(json);

  Map<String, dynamic> toJson() => _$RtmMessageToJson(this);

  static Uint8List? _rawMessage(Uint8List? rawMessage) => rawMessage;
}

@JsonSerializable(anyMap: true)
class RtmChannelMember {
  String userId;
  String channelId;

  RtmChannelMember(
    this.userId,
    this.channelId,
  );

  factory RtmChannelMember.fromJson(Map json) =>
      _$RtmChannelMemberFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelMemberToJson(this);
}

@JsonSerializable(anyMap: true)
class RtmAttribute {
  String key;
  String value;

  RtmAttribute(
    this.key,
    this.value,
  );

  factory RtmAttribute.fromJson(Map json) => _$RtmAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$RtmAttributeToJson(this);
}

@JsonSerializable(anyMap: true)
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

  factory RtmChannelAttribute.fromJson(Map json) =>
      _$RtmChannelAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelAttributeToJson(this);
}

@JsonSerializable(anyMap: true, constructor: '_')
class LocalInvitation {
  String calleeId;
  String? content;
  String? response;
  String? channelId;
  RtmLocalInvitationState state;
  @JsonKey(name: 'hashCode')
  int handle;

  LocalInvitation._(
    this.calleeId, {
    this.content,
    this.response,
    this.channelId,
    this.state = RtmLocalInvitationState.idle,
    this.handle = 0,
  });

  factory LocalInvitation.fromJson(Map json) => _$LocalInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$LocalInvitationToJson(this);
}

@JsonSerializable(anyMap: true, constructor: '_')
class RemoteInvitation {
  String callerId;
  String? content;
  String? response;
  String? channelId;
  RtmRemoteInvitationState state;
  @JsonKey(name: 'hashCode')
  int handle;

  RemoteInvitation._(
    this.callerId, {
    this.content,
    this.response,
    this.channelId,
    this.state = RtmRemoteInvitationState.idle,
    this.handle = 0,
  });

  factory RemoteInvitation.fromJson(Map json) =>
      _$RemoteInvitationFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteInvitationToJson(this);
}

@JsonSerializable(anyMap: true)
class ChannelAttributeOptions {
  bool enableNotificationToChannelMembers;

  ChannelAttributeOptions(
    this.enableNotificationToChannelMembers,
  );

  factory ChannelAttributeOptions.fromJson(Map json) =>
      _$ChannelAttributeOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelAttributeOptionsToJson(this);
}

@JsonSerializable(anyMap: true)
class SendMessageOptions {
  @Deprecated('Removed in v1.5.0')
  bool? enableOfflineMessaging;
  @Deprecated('Removed in v1.5.0')
  bool? enableHistoricalMessaging;

  SendMessageOptions({
    this.enableOfflineMessaging,
    this.enableHistoricalMessaging,
  });

  factory SendMessageOptions.fromJson(Map json) =>
      _$SendMessageOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageOptionsToJson(this);
}

@JsonSerializable(anyMap: true)
class RtmChannelMemberCount {
  String channelId;
  int memberCount;

  RtmChannelMemberCount(
    this.channelId,
    this.memberCount,
  );

  factory RtmChannelMemberCount.fromJson(Map json) =>
      _$RtmChannelMemberCountFromJson(json);

  Map<String, dynamic> toJson() => _$RtmChannelMemberCountToJson(this);
}

@JsonSerializable(anyMap: true)
class RtmServiceContext {
  List<RtmAreaCode> areaCode;
  RtmCloudProxyType proxyType;

  RtmServiceContext({
    this.areaCode = const [RtmAreaCode.GLOB],
    this.proxyType = RtmCloudProxyType.noneProxy,
  });

  factory RtmServiceContext.fromJson(Map json) =>
      _$RtmServiceContextFromJson(json);

  Map<String, dynamic> toJson() => _$RtmServiceContextToJson(this);
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
