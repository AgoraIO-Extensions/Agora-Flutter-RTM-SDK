import 'dart:async';

import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_client.dart';

abstract class RtmResultHandler {
  RtmResultHandler() {
    rtmEventHandler = RtmEventHandler(
      onLinkStateEvent: onLinkStateEvent,
      onMessageEvent: onMessageEvent,
      onPresenceEvent: onPresenceEvent,
      onTopicEvent: onTopicEvent,
      onLockEvent: onLockEvent,
      onStorageEvent: onStorageEvent,
      onJoinResult: onJoinResult,
      onLeaveResult: onLeaveResult,
      onPublishTopicMessageResult: onPublishTopicMessageResult,
      onJoinTopicResult: onJoinTopicResult,
      onLeaveTopicResult: onLeaveTopicResult,
      onSubscribeTopicResult: onSubscribeTopicResult,
      onUnsubscribeTopicResult: onUnsubscribeTopicResult,
      onGetSubscribedUserListResult: onGetSubscribedUserListResult,
      onConnectionStateChanged: onConnectionStateChanged,
      onTokenPrivilegeWillExpire: onTokenPrivilegeWillExpire,
      onSubscribeResult: onSubscribeResult,
      onUnsubscribeResult: onUnsubscribeResult,
      onPublishResult: onPublishResult,
      onLoginResult: onLoginResult,
      onLogoutResult: onLogoutResult,
      onRenewTokenResult: onRenewTokenResult,
      onSetChannelMetadataResult: onSetChannelMetadataResult,
      onUpdateChannelMetadataResult: onUpdateChannelMetadataResult,
      onRemoveChannelMetadataResult: onRemoveChannelMetadataResult,
      onGetChannelMetadataResult: onGetChannelMetadataResult,
      onSetUserMetadataResult: onSetUserMetadataResult,
      onUpdateUserMetadataResult: onUpdateUserMetadataResult,
      onRemoveUserMetadataResult: onRemoveUserMetadataResult,
      onGetUserMetadataResult: onGetUserMetadataResult,
      onSubscribeUserMetadataResult: onSubscribeUserMetadataResult,
      onUnsubscribeUserMetadataResult: onUnsubscribeUserMetadataResult,
      onSetLockResult: onSetLockResult,
      onRemoveLockResult: onRemoveLockResult,
      onReleaseLockResult: onReleaseLockResult,
      onAcquireLockResult: onAcquireLockResult,
      onRevokeLockResult: onRevokeLockResult,
      onGetLocksResult: onGetLocksResult,
      onWhoNowResult: onWhoNowResult,
      onGetOnlineUsersResult: onGetOnlineUsersResult,
      onWhereNowResult: onWhereNowResult,
      onGetUserChannelsResult: onGetUserChannelsResult,
      onPresenceSetStateResult: onPresenceSetStateResult,
      onPresenceRemoveStateResult: onPresenceRemoveStateResult,
      onPresenceGetStateResult: onPresenceGetStateResult,
    );
  }
  late final RtmEventHandler rtmEventHandler;

  Future<T> request<T>(int requestId);

  void response(int requestId, (Object result, RtmErrorCode errorCode) data);

  @visibleForTesting
  @protected
  void onLinkStateEvent(LinkStateEvent event) {}

  @visibleForTesting
  @protected
  void onMessageEvent(MessageEvent event) {}

  @visibleForTesting
  @protected
  void onPresenceEvent(PresenceEvent event) {}

  @visibleForTesting
  @protected
  void onTopicEvent(TopicEvent event) {}

  @visibleForTesting
  @protected
  void onLockEvent(LockEvent event) {}

  @visibleForTesting
  @protected
  void onStorageEvent(StorageEvent event) {}

  @visibleForTesting
  @protected
  void onJoinResult(int requestId, String channelName, String userId,
      RtmErrorCode errorCode) {
    final result = JoinResult(channelName: channelName, userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onLeaveResult(int requestId, String channelName, String userId,
      RtmErrorCode errorCode) {
    final result = LeaveResult(channelName: channelName, userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onPublishTopicMessageResult(
      int requestId, String channelName, String topic, RtmErrorCode errorCode) {
    final result =
        PublishTopicMessageResult(channelName: channelName, topic: topic);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onJoinTopicResult(int requestId, String channelName, String userId,
      String topic, String meta, RtmErrorCode errorCode) {
    final result = JoinTopicResult(
        channelName: channelName, userId: userId, topic: topic, meta: meta);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onLeaveTopicResult(int requestId, String channelName, String userId,
      String topic, String meta, RtmErrorCode errorCode) {
    final result = LeaveTopicResult(
        channelName: channelName, userId: userId, topic: topic, meta: meta);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onSubscribeTopicResult(
      int requestId,
      String channelName,
      String userId,
      String topic,
      UserList succeedUsers,
      UserList failedUsers,
      RtmErrorCode errorCode) {
    final succeedUsersUserList = succeedUsers.users ?? [];
    final failedUsersUserList = failedUsers.users ?? [];
    final result = SubscribeTopicResult(
        channelName: channelName,
        userId: userId,
        topic: topic,
        succeedUsers: succeedUsersUserList,
        failedUsers: failedUsersUserList);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onUnsubscribeTopicResult(
      int requestId, String channelName, String topic, RtmErrorCode errorCode) {
    final result =
        UnsubscribeTopicResult(channelName: channelName, topic: topic);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetSubscribedUserListResult(int requestId, String channelName,
      String topic, UserList users, RtmErrorCode errorCode) {
    final result = GetSubscribedUserListResult(
        channelName: channelName, topic: topic, users: users);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onConnectionStateChanged(String channelName, RtmConnectionState state,
      RtmConnectionChangeReason reason) {}

  @visibleForTesting
  @protected
  void onTokenPrivilegeWillExpire(String channelName) {}

  @visibleForTesting
  @protected
  void onSubscribeResult(
      int requestId, String channelName, RtmErrorCode errorCode) {
    final result = SubscribeResult(channelName: channelName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onUnsubscribeResult(
      int requestId, String channelName, RtmErrorCode errorCode) {
    final result = UnsubscribeResult(channelName: channelName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onPublishResult(int requestId, RtmErrorCode errorCode) {
    final result = PublishResult();
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onLoginResult(int requestId, RtmErrorCode errorCode) {
    final result = LoginResult();
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onLogoutResult(int requestId, RtmErrorCode errorCode) {
    final result = LogoutResult();
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onRenewTokenResult(int requestId, RtmServiceType serverType,
      String channelName, RtmErrorCode errorCode) {
    final result =
        RenewTokenResult(serverType: serverType, channelName: channelName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onSetChannelMetadataResult(int requestId, String channelName,
      RtmChannelType channelType, RtmErrorCode errorCode) {
    final result = SetChannelMetadataResult(
        channelName: channelName, channelType: channelType);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onUpdateChannelMetadataResult(int requestId, String channelName,
      RtmChannelType channelType, RtmErrorCode errorCode) {
    final result = UpdateChannelMetadataResult(
        channelName: channelName, channelType: channelType);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onRemoveChannelMetadataResult(int requestId, String channelName,
      RtmChannelType channelType, RtmErrorCode errorCode) {
    final result = RemoveChannelMetadataResult(
        channelName: channelName, channelType: channelType);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetChannelMetadataResult(int requestId, String channelName,
      RtmChannelType channelType, Metadata data, RtmErrorCode errorCode) {
    final result = GetChannelMetadataResult(
        channelName: channelName, channelType: channelType, data: data);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onSetUserMetadataResult(
      int requestId, String userId, RtmErrorCode errorCode) {
    final result = SetUserMetadataResult(userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onUpdateUserMetadataResult(
      int requestId, String userId, RtmErrorCode errorCode) {
    final result = UpdateUserMetadataResult(userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onRemoveUserMetadataResult(
      int requestId, String userId, RtmErrorCode errorCode) {
    final result = RemoveUserMetadataResult(userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetUserMetadataResult(
      int requestId, String userId, Metadata data, RtmErrorCode errorCode) {
    final result = GetUserMetadataResult(userId: userId, data: data);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onSubscribeUserMetadataResult(
      int requestId, String userId, RtmErrorCode errorCode) {
    final result = SubscribeUserMetadataResult(userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onUnsubscribeUserMetadataResult(
      int requestId, String userId, RtmErrorCode errorCode) {
    final result = UnsubscribeUserMetadataResult(userId: userId);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onSetLockResult(int requestId, String channelName,
      RtmChannelType channelType, String lockName, RtmErrorCode errorCode) {
    final result = SetLockResult(
        channelName: channelName, channelType: channelType, lockName: lockName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onRemoveLockResult(int requestId, String channelName,
      RtmChannelType channelType, String lockName, RtmErrorCode errorCode) {
    final result = RemoveLockResult(
        channelName: channelName, channelType: channelType, lockName: lockName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onReleaseLockResult(int requestId, String channelName,
      RtmChannelType channelType, String lockName, RtmErrorCode errorCode) {
    final result = ReleaseLockResult(
        channelName: channelName, channelType: channelType, lockName: lockName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onAcquireLockResult(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      String lockName,
      RtmErrorCode errorCode,
      String errorDetails) {
    final result = AcquireLockResult(
        channelName: channelName,
        channelType: channelType,
        lockName: lockName,
        errorDetails: errorDetails);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onRevokeLockResult(int requestId, String channelName,
      RtmChannelType channelType, String lockName, RtmErrorCode errorCode) {
    final result = RevokeLockResult(
        channelName: channelName, channelType: channelType, lockName: lockName);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetLocksResult(
      int requestId,
      String channelName,
      RtmChannelType channelType,
      List<LockDetail> lockDetailList,
      int count,
      RtmErrorCode errorCode) {
    final result = GetLocksResult(
        channelName: channelName,
        channelType: channelType,
        lockDetailList: lockDetailList,
        count: count);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onWhoNowResult(int requestId, List<UserState> userStateList, int count,
      String nextPage, RtmErrorCode errorCode) {
    final result = WhoNowResult(
        userStateList: userStateList, count: count, nextPage: nextPage);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetOnlineUsersResult(int requestId, List<UserState> userStateList,
      int count, String nextPage, RtmErrorCode errorCode) {
    final result = GetOnlineUsersResult(
        userStateList: userStateList, count: count, nextPage: nextPage);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onWhereNowResult(int requestId, List<ChannelInfo> channels, int count,
      RtmErrorCode errorCode) {
    final result = WhereNowResult(channels: channels, count: count);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onGetUserChannelsResult(
      int requestId, ChannelInfo channels, int count, RtmErrorCode errorCode) {
    final result = GetUserChannelsResult(channels: channels, count: count);
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onPresenceSetStateResult(int requestId, RtmErrorCode errorCode) {
    final result = SetStateResult();
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onPresenceRemoveStateResult(int requestId, RtmErrorCode errorCode) {
    final result = RemoveStateResult();
    response(requestId, (result, errorCode));
  }

  @visibleForTesting
  @protected
  void onPresenceGetStateResult(
      int requestId, UserState state, RtmErrorCode errorCode) {
    final result = GetStateResult(state: state);
    response(requestId, (result, errorCode));
  }
}
