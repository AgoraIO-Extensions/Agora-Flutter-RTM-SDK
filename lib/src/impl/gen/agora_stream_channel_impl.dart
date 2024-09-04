import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_stream_channel_impl.dart'
    as native_binding;

class StreamChannelImpl implements StreamChannel {
  StreamChannelImpl(this.nativeBindingStreamChannelImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.StreamChannelImpl nativeBindingStreamChannelImpl;

  @override
  Future<(RtmStatus, JoinResult?)> join(
      {String? token,
      bool withMetadata = false,
      bool withPresence = true,
      bool withLock = false,
      bool beQuiet = false}) async {
    final options = JoinChannelOptions(
        token: token,
        withMetadata: withMetadata,
        withPresence: withPresence,
        withLock: withLock,
        beQuiet: beQuiet);
    try {
      final requestId = await nativeBindingStreamChannelImpl.join(options);
      final (JoinResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'join');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'join');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, RenewTokenResult?)> renewToken(String token) async {
    try {
      final requestId = await nativeBindingStreamChannelImpl.renewToken(token);
      final (RenewTokenResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'renewToken');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'renewToken');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, LeaveResult?)> leave() async {
    try {
      final requestId = await nativeBindingStreamChannelImpl.leave();
      final (LeaveResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'leave');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'leave');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, String?)> getChannelName() async {
    try {
      final result = await nativeBindingStreamChannelImpl.getChannelName();
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(0, 'getChannelName');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getChannelName');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, JoinTopicResult?)> joinTopic(String topic,
      {RtmMessageQos qos = RtmMessageQos.unordered,
      RtmMessagePriority priority = RtmMessagePriority.normal,
      String meta = '',
      bool syncWithMedia = false}) async {
    final options = JoinTopicOptions(
        qos: qos, priority: priority, meta: meta, syncWithMedia: syncWithMedia);
    try {
      final requestId = await nativeBindingStreamChannelImpl.joinTopic(
          topic: topic, options: options);
      final (JoinTopicResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'joinTopic');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'joinTopic');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, LeaveTopicResult?)> leaveTopic(String topic) async {
    try {
      final requestId = await nativeBindingStreamChannelImpl.leaveTopic(topic);
      final (LeaveTopicResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'leaveTopic');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'leaveTopic');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, SubscribeTopicResult?)> subscribeTopic(String topic,
      {List<String> users = const []}) async {
    final options = TopicOptions(users: users, userCount: users.length);
    try {
      final requestId = await nativeBindingStreamChannelImpl.subscribeTopic(
          topic: topic, options: options);
      final (SubscribeTopicResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'subscribeTopic');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'subscribeTopic');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, UnsubscribeTopicResult?)> unsubscribeTopic(String topic,
      {List<String> users = const []}) async {
    final options = TopicOptions(users: users, userCount: users.length);
    try {
      final requestId = await nativeBindingStreamChannelImpl.unsubscribeTopic(
          topic: topic, options: options);
      final (UnsubscribeTopicResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'unsubscribeTopic');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'unsubscribeTopic');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, GetSubscribedUserListResult?)> getSubscribedUserList(
      String topic) async {
    try {
      final requestId =
          await nativeBindingStreamChannelImpl.getSubscribedUserList(topic);
      final (GetSubscribedUserListResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getSubscribedUserList');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getSubscribedUserList');
      return (status, null);
    }
  }

  @override
  Future<RtmStatus> release() async {
    try {
      await nativeBindingStreamChannelImpl.release();
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(0, 'release');
      return status;
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'release');
      return status;
    }
  }

  @override
  Future<(RtmStatus, PublishTopicMessageResult?)> publishTextMessage(
      String topic, String message,
      {int sendTs = 0, String? customType}) async {
    final option = TopicMessageOptions(sendTs: sendTs, customType: customType);
    try {
      final requestId = await nativeBindingStreamChannelImpl.publishTextMessage(
          topic: topic,
          message: message,
          length: message.length,
          option: option);
      final (PublishTopicMessageResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'publishTextMessage');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'publishTextMessage');
      return (status, null);
    }
  }

  @override
  Future<(RtmStatus, PublishTopicMessageResult?)> publishBinaryMessage(
      String topic, Uint8List message,
      {int sendTs = 0, String? customType}) async {
    final option = TopicMessageOptions(sendTs: sendTs, customType: customType);
    try {
      final requestId =
          await nativeBindingStreamChannelImpl.publishBinaryMessage(
              topic: topic,
              message: message,
              length: message.length,
              option: option);
      final (PublishTopicMessageResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'publishBinaryMessage');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingStreamChannelImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'publishBinaryMessage');
      return (status, null);
    }
  }
}
