import 'binding_forward_export.dart';

abstract class RtmPresence {
  Future<int> whoNow(
      {required String channelName,
      required RtmChannelType channelType,
      required PresenceOptions options});

  Future<int> whereNow(String userId);

  Future<int> setState(
      {required String channelName,
      required RtmChannelType channelType,
      required List<StateItem> items,
      required int count});

  Future<int> removeState(
      {required String channelName,
      required RtmChannelType channelType,
      required List<String> keys,
      required int count});

  Future<int> getState(
      {required String channelName,
      required RtmChannelType channelType,
      required String userId});

  Future<int> getOnlineUsers(
      {required String channelName,
      required RtmChannelType channelType,
      required GetOnlineUsersOptions options});

  Future<int> getUserChannels(String userId);
}
