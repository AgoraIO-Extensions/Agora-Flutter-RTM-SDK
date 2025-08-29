import 'binding_forward_export.dart';

class GetMessagesResult {
  GetMessagesResult(
      {required this.messageList, required this.count, required this.newStart});

  final List<HistoryMessage> messageList;

  final int count;

  final int newStart;
}

abstract class RtmHistory {
  Future<(RtmStatus, GetMessagesResult?)> getMessages(
      String channelName, RtmChannelType channelType,
      {int messageCount = 100, int start = 0, int end = 0});
}
