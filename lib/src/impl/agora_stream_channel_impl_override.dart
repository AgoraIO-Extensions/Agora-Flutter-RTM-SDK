import 'dart:typed_data' show Uint8List;

import 'package:agora_rtm/src/agora_rtm_base.dart'
    show RtmErrorCode, RtmErrorCodeExt, RtmMessageType, TopicMessageOptions;
import 'package:agora_rtm/src/agora_rtm_client_ext.dart' show RtmStatus;
import 'package:agora_rtm/src/agora_stream_channel.dart'
    show PublishTopicMessageResult;
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/impl/gen/agora_stream_channel_impl.dart'
    as stream_channel_impl;

class StreamChannelImplOverride extends stream_channel_impl.StreamChannelImpl {
  StreamChannelImplOverride(
      super.nativeBindingStreamChannelImpl, super.rtmResultHandler);

  @override
  Future<(RtmStatus, PublishTopicMessageResult?)> publishTextMessage(
      String topic, String message,
      {int sendTs = 0, String? customType}) async {
    final option = TopicMessageOptions(
        messageType: RtmMessageType.string,
        sendTs: sendTs,
        customType: customType);
    final requestId = await nativeBindingStreamChannelImpl.publishTextMessage(
        topic: topic, message: message, length: message.length, option: option);
    final (PublishTopicMessageResult result, RtmErrorCode errorCode) =
        await rtmResultHandler.request(requestId);
    final status = await nativeBindingStreamChannelImpl.irisMethodChannel
        .wrapRtmStatus(errorCode.value(), 'publishTextMessage');
    return (status, result);
  }

  @override
  Future<(RtmStatus, PublishTopicMessageResult?)> publishBinaryMessage(
      String topic, Uint8List message,
      {int sendTs = 0, String? customType}) async {
    final option = TopicMessageOptions(
        messageType: RtmMessageType.binary,
        sendTs: sendTs,
        customType: customType);
    final requestId = await nativeBindingStreamChannelImpl.publishBinaryMessage(
        topic: topic, message: message, length: message.length, option: option);
    final (PublishTopicMessageResult result, RtmErrorCode errorCode) =
        await rtmResultHandler.request(requestId);
    final status = await nativeBindingStreamChannelImpl.irisMethodChannel
        .wrapRtmStatus(errorCode.value(), 'publishBinaryMessage');
    return (status, result);
  }
}
