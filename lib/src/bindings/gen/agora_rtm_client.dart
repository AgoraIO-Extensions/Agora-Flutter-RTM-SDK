import 'binding_forward_export.dart';

abstract class RtmClient {
  Future<void> release();

  Future<int> login(String token);

  Future<int> logout();

  Future<RtmStorage> getStorage();

  Future<RtmLock> getLock();

  Future<RtmPresence> getPresence();

  Future<RtmHistory> getHistory();

  Future<int> renewToken(String token);

  Future<int> publish(
      {required String channelName,
      required String message,
      required int length,
      required PublishOptions option});

  Future<int> subscribe(
      {required String channelName, required SubscribeOptions options});

  Future<int> unsubscribe(String channelName);

  Future<StreamChannel> createStreamChannel(String channelName);

  Future<void> setParameters(String parameters);

  Future<int> publishBinaryMessage(
      {required String channelName,
      required Uint8List message,
      required int length,
      required PublishOptions option});
}
