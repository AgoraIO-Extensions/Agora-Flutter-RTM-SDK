import 'binding_forward_export.dart';

abstract class RtmHistory {
  Future<int> getMessages(
      {required String channelName,
      required RtmChannelType channelType,
      required GetHistoryMessagesOptions options});
}
