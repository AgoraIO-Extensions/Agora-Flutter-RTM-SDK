class AgoraRtmMessage {
  String text;

  AgoraRtmMessage(String text) {
    this.text = text;
  }
}

class AgoraRtmMember {
  String userId;
  String channelId;

  AgoraRtmMember(String userId, String channelId) {
    this.userId = userId;
    this.channelId = channelId;
  }

  @override
  String toString() {
    return "{uid: " + userId + ", cid: " + channelId + "}";
  }
}

class AgoraRtmLocalInvitation {
  String calleeId;
  String content;
  String response;
  String channelId;
  String state;

  AgoraRtmLocalInvitation(Map<String, String> arguments) {
    this.calleeId = arguments['calleeId'];
    this.content = arguments['content'];
    this.response = arguments['response'];
    this.channelId = arguments['channelId'];
    this.state = arguments['state'];
  }

  @override
  String toString() {
    return "{calleeId: $calleeId, content: $content, response: $response, channelId: $channelId, state: $state}";
  }
}

class AgoraRtmRemoteInvitation {
  String callerId;
  String content;
  String response;
  String channelId;
  String state;

  AgoraRtmRemoteInvitation(Map<String, String> arguments) {
    this.callerId = arguments['callerId'];
    this.content = arguments['content'];
    this.response = arguments['response'];
    this.channelId = arguments['channelId'];
    this.state = arguments['state'];
  }

  @override
  String toString() {
    return "{callerId: $callerId, content: $content, response: $response, channelId: $channelId, state: $state}";
  }
}