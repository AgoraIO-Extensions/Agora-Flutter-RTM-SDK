import 'binding_forward_export.dart';

class RtmEventHandler {
  /// Construct the [RtmEventHandler].
  const RtmEventHandler({
    this.onLinkStateEvent,
    this.onMessageEvent,
    this.onPresenceEvent,
    this.onTopicEvent,
    this.onLockEvent,
    this.onStorageEvent,
    this.onJoinResult,
    this.onLeaveResult,
    this.onPublishTopicMessageResult,
    this.onJoinTopicResult,
    this.onLeaveTopicResult,
    this.onSubscribeTopicResult,
    this.onUnsubscribeTopicResult,
    this.onGetSubscribedUserListResult,
    this.onConnectionStateChanged,
    this.onTokenPrivilegeWillExpire,
    this.onSubscribeResult,
    this.onUnsubscribeResult,
    this.onPublishResult,
    this.onLoginResult,
    this.onLogoutResult,
    this.onRenewTokenResult,
    this.onSetChannelMetadataResult,
    this.onUpdateChannelMetadataResult,
    this.onRemoveChannelMetadataResult,
    this.onGetChannelMetadataResult,
    this.onSetUserMetadataResult,
    this.onUpdateUserMetadataResult,
    this.onRemoveUserMetadataResult,
    this.onGetUserMetadataResult,
    this.onSubscribeUserMetadataResult,
    this.onUnsubscribeUserMetadataResult,
    this.onSetLockResult,
    this.onRemoveLockResult,
    this.onReleaseLockResult,
    this.onAcquireLockResult,
    this.onRevokeLockResult,
    this.onGetLocksResult,
    this.onWhoNowResult,
    this.onGetOnlineUsersResult,
    this.onWhereNowResult,
    this.onGetUserChannelsResult,
    this.onPresenceSetStateResult,
    this.onPresenceRemoveStateResult,
    this.onPresenceGetStateResult,
  });

  final void Function(LinkStateEvent event)? onLinkStateEvent;

  final void Function(MessageEvent event)? onMessageEvent;

  final void Function(PresenceEvent event)? onPresenceEvent;

  final void Function(TopicEvent event)? onTopicEvent;

  final void Function(LockEvent event)? onLockEvent;

  final void Function(StorageEvent event)? onStorageEvent;

  final void Function(int requestId, String channelName, String userId,
      RtmErrorCode errorCode)? onJoinResult;

  final void Function(int requestId, String channelName, String userId,
      RtmErrorCode errorCode)? onLeaveResult;

  final void Function(int requestId, String channelName, String topic,
      RtmErrorCode errorCode)? onPublishTopicMessageResult;

  final void Function(int requestId, String channelName, String userId,
      String topic, String meta, RtmErrorCode errorCode)? onJoinTopicResult;

  final void Function(int requestId, String channelName, String userId,
      String topic, String meta, RtmErrorCode errorCode)? onLeaveTopicResult;

  final void Function(
      int requestId,
      String channelName,
      String userId,
      String topic,
      UserList succeedUsers,
      UserList failedUsers,
      RtmErrorCode errorCode)? onSubscribeTopicResult;

  final void Function(int requestId, String channelName, String topic,
      RtmErrorCode errorCode)? onUnsubscribeTopicResult;

  final void Function(int requestId, String channelName, String topic,
      UserList users, RtmErrorCode errorCode)? onGetSubscribedUserListResult;

  final void Function(String channelName, RtmConnectionState state,
      RtmConnectionChangeReason reason)? onConnectionStateChanged;

  final void Function(String channelName)? onTokenPrivilegeWillExpire;

  final void Function(
          int requestId, String channelName, RtmErrorCode errorCode)?
      onSubscribeResult;

  final void Function(
          int requestId, String channelName, RtmErrorCode errorCode)?
      onUnsubscribeResult;

  final void Function(int requestId, RtmErrorCode errorCode)? onPublishResult;

  final void Function(int requestId, RtmErrorCode errorCode)? onLoginResult;

  final void Function(int requestId, RtmErrorCode errorCode)? onLogoutResult;

  final void Function(int requestId, RtmServiceType serverType,
      String channelName, RtmErrorCode errorCode)? onRenewTokenResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      RtmErrorCode errorCode)? onSetChannelMetadataResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      RtmErrorCode errorCode)? onUpdateChannelMetadataResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      RtmErrorCode errorCode)? onRemoveChannelMetadataResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      Metadata data,
      RtmErrorCode errorCode)? onGetChannelMetadataResult;

  final void Function(int requestId, String userId, RtmErrorCode errorCode)?
      onSetUserMetadataResult;

  final void Function(int requestId, String userId, RtmErrorCode errorCode)?
      onUpdateUserMetadataResult;

  final void Function(int requestId, String userId, RtmErrorCode errorCode)?
      onRemoveUserMetadataResult;

  final void Function(
          int requestId, String userId, Metadata data, RtmErrorCode errorCode)?
      onGetUserMetadataResult;

  final void Function(int requestId, String userId, RtmErrorCode errorCode)?
      onSubscribeUserMetadataResult;

  final void Function(int requestId, String userId, RtmErrorCode errorCode)?
      onUnsubscribeUserMetadataResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode)? onSetLockResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode)? onRemoveLockResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode)? onReleaseLockResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode,
      String errorDetails)? onAcquireLockResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode)? onRevokeLockResult;

  final void Function(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      List<LockDetail> lockDetailList,
      int count,
      RtmErrorCode errorCode)? onGetLocksResult;

  final void Function(int requestId, List<UserState> userStateList, int count,
      String nextPage, RtmErrorCode errorCode)? onWhoNowResult;

  final void Function(int requestId, List<UserState> userStateList, int count,
      String nextPage, RtmErrorCode errorCode)? onGetOnlineUsersResult;

  final void Function(int requestId, List<ChannelInfo> channels, int count,
      RtmErrorCode errorCode)? onWhereNowResult;

  final void Function(int requestId, ChannelInfo channels, int count,
      RtmErrorCode errorCode)? onGetUserChannelsResult;

  final void Function(int requestId, RtmErrorCode errorCode)?
      onPresenceSetStateResult;

  final void Function(int requestId, RtmErrorCode errorCode)?
      onPresenceRemoveStateResult;

  final void Function(int requestId, UserState state, RtmErrorCode errorCode)?
      onPresenceGetStateResult;
}

abstract class RtmClient {
  Future<void> release();

  Future<int> login(String token);

  Future<int> logout();

  Future<RtmStorage> getStorage();

  Future<RtmLock> getLock();

  Future<RtmPresence> getPresence();

  Future<int> renewToken(String token);

  Future<int> publish(
      {required String channelName,
      required String message,
      required int length,
      required PublishOptions option});

  Future<int> subscribe(
      {required String channelName, required SubscribeOptions options});

  Future<int> unsubscribe(String channelName);

  Future<StreamChannel> createStreamChannel(String channelName);

  Future<void> setParameters(String parameters);

  Future<int> publishBinaryMessage(
      {required String channelName,
      required Uint8List message,
      required int length,
      required PublishOptions option});
}
