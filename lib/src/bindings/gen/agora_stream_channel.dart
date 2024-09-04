import 'binding_forward_export.dart';

abstract class StreamChannel {
  Future<int> join(JoinChannelOptions options);

  Future<int> renewToken(String token);

  Future<int> leave();

  Future<String> getChannelName();

  Future<int> joinTopic(
      {required String topic, required JoinTopicOptions options});

  Future<int> publishTopicMessage(
      {required String topic,
      required String message,
      required int length,
      required TopicMessageOptions option});

  Future<int> leaveTopic(String topic);

  Future<int> subscribeTopic(
      {required String topic, required TopicOptions options});

  Future<int> unsubscribeTopic(
      {required String topic, required TopicOptions options});

  Future<int> getSubscribedUserList(String topic);

  Future<void> release();

  Future<int> publishTextMessage(
      {required String topic,
      required String message,
      required int length,
      required TopicMessageOptions option});

  Future<int> publishBinaryMessage(
      {required String topic,
      required Uint8List message,
      required int length,
      required TopicMessageOptions option});
}
