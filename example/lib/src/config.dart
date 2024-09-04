/// Get your own App ID at https://dashboard.agora.io/
const String appId = '<YOUR_APP_ID>';

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
const String token = '<YOUR_TOKEN>';

/// Your channel ID
const String channelId = '<YOUR_CHANNEL_ID>';

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';

String get musicCenterAppId {
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
  return const String.fromEnvironment('MUSIC_CENTER_APPID',
      defaultValue: '<MUSIC_CENTER_APPID>');
}
