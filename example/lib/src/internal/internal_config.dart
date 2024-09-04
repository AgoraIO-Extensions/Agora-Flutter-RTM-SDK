import '../config.dart' as config;

String get appId {
  const appId = String.fromEnvironment('TEST_RTM_APP_ID', defaultValue: '');
  return appId.isNotEmpty ? appId : config.appId;
}

String get token {
  const token = String.fromEnvironment('TEST_RTM_TOKEN', defaultValue: '');
  return token.isNotEmpty ? token : config.token;
}

String get channelId {
  const channelId = String.fromEnvironment('TEST_CHANNEL_ID', defaultValue: '');
  return channelId.isNotEmpty ? channelId : config.channelId;
}
