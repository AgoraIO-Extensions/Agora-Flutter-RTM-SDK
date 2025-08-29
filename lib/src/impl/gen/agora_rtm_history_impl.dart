import 'package:agora_rtm/src/impl/gen/rtm_result_handler.dart';
import 'package:agora_rtm/src/impl/extensions.dart';
import 'package:agora_rtm/src/binding_forward_export.dart';
import 'package:agora_rtm/src/bindings/gen/agora_rtm_history_impl.dart'
    as native_binding;

class RtmHistoryImpl implements RtmHistory {
  RtmHistoryImpl(this.nativeBindingRtmHistoryImpl, this.rtmResultHandler);

  final RtmResultHandler rtmResultHandler;

  final native_binding.RtmHistoryImpl nativeBindingRtmHistoryImpl;

  @override
  Future<(RtmStatus, GetMessagesResult?)> getMessages(
      String channelName, RtmChannelType channelType,
      {int messageCount = 100, int start = 0, int end = 0}) async {
    final options = GetHistoryMessagesOptions(
        messageCount: messageCount, start: start, end: end);
    try {
      final requestId = await nativeBindingRtmHistoryImpl.getMessages(
          channelName: channelName, channelType: channelType, options: options);
      final (GetMessagesResult result, RtmErrorCode errorCode) =
          await rtmResultHandler.request(requestId);
      final status = await nativeBindingRtmHistoryImpl.irisMethodChannel
          .wrapRtmStatus(errorCode.value(), 'getMessages');
      return (status, result);
    } on AgoraRtmException catch (e) {
      final status = await nativeBindingRtmHistoryImpl.irisMethodChannel
          .wrapRtmStatus(e.code, 'getMessages');
      return (status, null);
    }
  }
}
