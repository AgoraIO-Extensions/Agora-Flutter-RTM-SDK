import 'binding_forward_export.dart';

class WhoNowResult {
  WhoNowResult(
      {required this.userStateList,
      required this.count,
      required this.nextPage});

  final List<UserState> userStateList;

  final int count;

  final String nextPage;
}

class WhereNowResult {
  WhereNowResult({required this.channels, required this.count});

  final List<ChannelInfo> channels;

  final int count;
}

class SetStateResult {
  SetStateResult();
}

class RemoveStateResult {
  RemoveStateResult();
}

class GetStateResult {
  GetStateResult({required this.state});

  final UserState state;
}

class GetOnlineUsersResult {
  GetOnlineUsersResult(
      {required this.userStateList,
      required this.count,
      required this.nextPage});

  final List<UserState> userStateList;

  final int count;

  final String nextPage;
}

class GetUserChannelsResult {
  GetUserChannelsResult({required this.channels, required this.count});

  final ChannelInfo channels;

  final int count;
}

abstract class RtmPresence {
  Future<(RtmStatus, WhoNowResult?)> whoNow(
      String channelName, RtmChannelType channelType,
      {bool includeUserId = true, bool includeState = false, String page = ''});

  Future<(RtmStatus, WhereNowResult?)> whereNow(String userId);

  Future<(RtmStatus, SetStateResult?)> setState(String channelName,
      RtmChannelType channelType, Map<String, String> state);

  Future<(RtmStatus, RemoveStateResult?)> removeState(
      String channelName, RtmChannelType channelType,
      {List<String> states = const []});

  Future<(RtmStatus, GetStateResult?)> getState(
      String channelName, RtmChannelType channelType, String userId);

  Future<(RtmStatus, GetOnlineUsersResult?)> getOnlineUsers(
      String channelName, RtmChannelType channelType,
      {bool includeUserId = true, bool includeState = false, String? page});

  Future<(RtmStatus, GetUserChannelsResult?)> getUserChannels(String userId);
}
