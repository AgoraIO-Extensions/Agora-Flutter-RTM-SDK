import 'binding_forward_export.dart';

class LoginResult {
  LoginResult();
}

class LogoutResult {
  LogoutResult();
}

class RenewTokenResult {
  RenewTokenResult({required this.serverType, required this.channelName});

  final RtmServiceType serverType;

  final String channelName;
}

class PublishResult {
  PublishResult();
}

class SubscribeResult {
  SubscribeResult({required this.channelName});

  final String channelName;
}

class UnsubscribeResult {
  UnsubscribeResult({required this.channelName});

  final String channelName;
}

abstract class RtmClient {
  void addListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token});

  void removeListener(
      {void Function(LinkStateEvent event)? linkState,
      void Function(MessageEvent event)? message,
      void Function(PresenceEvent event)? presence,
      void Function(TopicEvent event)? topic,
      void Function(LockEvent event)? lock,
      void Function(StorageEvent event)? storage,
      void Function(TokenEvent event)? token});

  Future<RtmStatus> release();

  Future<(RtmStatus, LoginResult?)> login(String token);

  Future<(RtmStatus, LogoutResult?)> logout();

  RtmStorage getStorage();

  RtmLock getLock();

  RtmPresence getPresence();

  RtmHistory getHistory();

  Future<(RtmStatus, RenewTokenResult?)> renewToken(String token);

  Future<(RtmStatus, PublishResult?)> publish(
      String channelName, String message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType,
      bool storeInHistory = false});

  Future<(RtmStatus, SubscribeResult?)> subscribe(String channelName,
      {bool withMessage = true,
      bool withMetadata = false,
      bool withPresence = true,
      bool withLock = false,
      bool beQuiet = false});

  Future<(RtmStatus, UnsubscribeResult?)> unsubscribe(String channelName);

  Future<(RtmStatus, StreamChannel?)> createStreamChannel(String channelName);

  Future<RtmStatus> setParameters(String parameters);

  Future<(RtmStatus, PublishResult?)> publishBinaryMessage(
      String channelName, Uint8List message,
      {RtmChannelType channelType = RtmChannelType.message,
      String? customType,
      bool storeInHistory = false});
}
