import '../config.dart' as config;

String get appId {
  const appId = String.fromEnvironment('TEST_APP_ID', defaultValue: '');
  return appId.isNotEmpty ? appId : config.appId;
}

String get token {
  const token = String.fromEnvironment('TEST_TOKEN', defaultValue: '__UNSET__');
  return token == '__UNSET__' ? config.token : token;
}

String get channelId {
  const channelId = String.fromEnvironment('TEST_CHANNEL_ID', defaultValue: '');
  return channelId.isNotEmpty ? channelId : config.channelId;
}
