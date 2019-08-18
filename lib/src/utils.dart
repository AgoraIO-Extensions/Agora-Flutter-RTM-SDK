class AgoraRtmMessage {
  String text;

  AgoraRtmMessage(String text) {
    this.text = text;
  }
}

class AgoraRtmMember {
  String userId;
  String channelId;

  AgoraRtmMember(this.userId, this.channelId);

  AgoraRtmMember.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      channelId = json['channelId'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'channelId': channelId,
  };

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

  AgoraRtmLocalInvitation(
    this.calleeId,
    this.content,
    this.response,
    this.channelId,
    this.state);

  AgoraRtmLocalInvitation.fromJson(Map<String, String> json)
    : calleeId = json['calleeId'],
      content = json['content'],
      response = json['response'],
      channelId = json['channelId'],
      state = json['state'];
  
  Map<String, dynamic> toJson() => {
    'calleeId': calleeId,
    'content': content,
    'response': response,
    'channelId': channelId,
    'state': state,
  };

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

  AgoraRtmRemoteInvitation(
    this.callerId,
    this.content,
    this.response,
    this.channelId,
    this.state);

  AgoraRtmRemoteInvitation.fromJson(Map<String, String> json)
    : callerId = json['callerId'],
      content = json['content'],
      response = json['response'],
      channelId = json['channelId'],
      state = json['state'];
  
  Map<String, dynamic> toJson() => {
    'callerId': callerId,
    'content': content,
    'response': response,
    'channelId': channelId,
    'state': state,
  };

  @override
  String toString() {
    return "{callerId: $callerId, content: $content, response: $response, channelId: $channelId, state: $state}";
  }
}