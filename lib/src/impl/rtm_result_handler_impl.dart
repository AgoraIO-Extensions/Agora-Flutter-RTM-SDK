import 'dart:async';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart' as rtm_result;

class RtmResultHandlerImpl extends rtm_result.RtmResultHandler {
  final Map<int, Completer<(Object result, RtmErrorCode errorCode)>>
      _pendingRequests = {};
  final Map<int, (Object result, RtmErrorCode errorCode)> _pendingResponses =
      {};
  final Map<String, Object> _listenerMap = {};

  @override
  Future<T> request<T>(int requestId) {
    if (_pendingResponses.containsKey(requestId)) {
      final response = _pendingResponses.remove(requestId);
      return Future.value(response! as T);
    }

    final completer =
        _pendingRequests.putIfAbsent(requestId, () => Completer());
    return completer.future.then((v) => v as T);
  }

  @override
  void response(int requestId, (Object result, RtmErrorCode errorCode) data) {
    if (_pendingRequests.containsKey(requestId)) {
      final completer = _pendingRequests.remove(requestId);
      completer?.complete(data);
      return;
    }

    _pendingResponses.putIfAbsent(requestId, () => data);
  }

  Function? _funcOf(String key) {
    return _listenerMap[key] as Function?;
  }

  @override
  void onLinkStateEvent(LinkStateEvent event) {
    _funcOf('linkState')?.call(event);
  }

  @override
  void onMessageEvent(MessageEvent event) {
    _funcOf('message')?.call(event);
  }

  @override
  void onPresenceEvent(PresenceEvent event) {
    _funcOf('presence')?.call(event);
  }

  @override
  void onTopicEvent(TopicEvent event) {
    _funcOf('topic')?.call(event);
  }

  @override
  void onLockEvent(LockEvent event) {
    _funcOf('lock')?.call(event);
  }

  @override
  void onStorageEvent(StorageEvent event) {
    _funcOf('storage')?.call(event);
  }

  @override
  void onConnectionStateChanged(String channelName, RtmConnectionState state,
      RtmConnectionChangeReason reason) {
    _funcOf('connection')?.call(channelName, state, reason);
  }

  @override
  void onTokenPrivilegeWillExpire(String channelName) {
    _funcOf('token')?.call(TokenEvent(channelName));
  }

  void setListener(String key, Object listener) {
    _listenerMap.putIfAbsent(key, () => listener);
  }

  void removeListener(String key) {
    _listenerMap.remove(key);
  }
}
