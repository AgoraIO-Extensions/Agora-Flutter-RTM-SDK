//
//  RTMChannel.m
//  agora_rtm
//
//  Created by LY on 2019/8/16.
//

#import "RTMChannel.h"

@implementation RTMChannel

- (NSDictionary *)dicFromMember:(AgoraRtmMember *)member {
  return @{@"userId": member.userId, @"channelId": member.channelId};
}

- (NSDictionary *)dicFromMessage:(AgoraRtmMessage *)message {
  return @{@"text": message.text};
}

- (NSDictionary *)appendRtmChannelIndex:(NSNumber *)channelIndex toArguments:(NSDictionary *)arguments {
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:arguments];
  dic[@"objIndex"] = channelIndex;
  dic[@"obj"] = @"AgoraRtmChannel";
  return [dic copy];
}

- (void) sendMessage:(NSString *)methodName params:(NSDictionary*)params {
//  NSDictionary *arguments = [self appendRtmChannelIndex:self.channelIndex toArguments:params];
//  [self.methodChannel invokeMethod:methodName arguments:arguments];
}

- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member {
 
}

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member {

}

- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member {

}

@end
