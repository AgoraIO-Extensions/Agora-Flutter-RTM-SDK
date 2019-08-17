//
//  RTMClient.m
//  agora_rtm
//
//  Created by LY on 2019/8/15.
//

#import "RTMClient.h"

@implementation RTMClient
- (id) initWithAppId:(NSString *)appId
         clientIndex:(NSNumber *)clientIndex
           messenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _messenger = messenger;
    NSString *channelName = [NSString stringWithFormat:@"io.agora.rtm.client%@", [clientIndex stringValue]];
    _eventKit = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
    if (nil == _eventKit) {
      return nil;
    }
    [_eventKit setStreamHandler:self];
    _kit = [[AgoraRtmKit new] initWithAppId:appId delegate:self];
    if (nil == _kit) return nil;
    _callKit = [_kit getRtmCallKit];
    _localInvitations = [[NSMutableDictionary alloc] init];
    _remoteInvitations = [[NSMutableDictionary alloc] init];
    _channels = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void) dealloc {
  [_localInvitations removeAllObjects];
  [_remoteInvitations removeAllObjects];
  for (NSString *channelId in _channels) {
    [_kit destroyChannelWithId:channelId];
  }
  [_channels removeAllObjects];
  _eventKit = nil;
  _channels = nil;
  _callKit = nil;
  _kit = nil;
}

#pragma - FlutterStreamHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSender = nil;
  return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
  _eventSender = events;
  return nil;
}

- (void) sendClientEvent:(NSString *)name params:(NSDictionary*)params {
  if (_eventSender) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    dict[@"event"] = name;
    _eventSender([dict copy]);
  }
}

- (NSDictionary *)dicFromMember:(AgoraRtmMember *)member {
  return @{@"userId": member.userId, @"channelId": member.channelId};
}

- (NSDictionary *)dicFromMessage:(AgoraRtmMessage *)message {
  return @{@"text": message.text};
}

- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
  [self sendClientEvent:@"onConnectionStateChanged" params: @{@"state": @(state), @"reason": @(reason)}];
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId {
  [self sendClientEvent:@"onMessageReceived" params: @{@"message": message.text, @"peerId": peerId}];
}

- (void)rtmKitTokenDidExpire:(AgoraRtmKit *)kit {
    [self sendClientEvent:@"onTokenExpired" params: nil];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationReceivedByPeer:(AgoraRtmLocalInvitation *_Nonnull)localInvitation {
  [self sendClientEvent:@"onLocalInvitationReceivedByPeer" params:@{
                                               @"localInvitation": @{
                                                                 @"calleeId": localInvitation.calleeId,
                                                                 @"content": localInvitation.content,
                                                                 @"channelId": localInvitation.channelId,
                                                                 @"state": @(localInvitation.state),
                                                                 @"response": localInvitation.response
                                                             }
                                               }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationAccepted:(AgoraRtmLocalInvitation *_Nonnull)localInvitation withResponse:(NSString *_Nullable)response {
  [self sendClientEvent:@"onLocalInvitationAccepted" params:@{
                                               @"localInvitation": @{
                                                   @"calleeId": localInvitation.calleeId,
                                                   @"content": localInvitation.content,
                                                   @"channelId": localInvitation.channelId,
                                                   @"state": @(localInvitation.state),
                                                   @"response": localInvitation.response
                                                   }
                                               }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationRefused:(AgoraRtmLocalInvitation *_Nonnull)localInvitation withResponse:(NSString *_Nullable)response {
[self sendClientEvent:@"onLocalInvitationRefused" params:@{
                                               @"localInvitation": @{
                                                   @"calleeId": localInvitation.calleeId,
                                                   @"content": localInvitation.content,
                                                   @"channelId": localInvitation.channelId,
                                                   @"state": @(localInvitation.state),
                                                   @"response": localInvitation.response
                                                   }
                                               }];
}
   

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationCanceled:(AgoraRtmLocalInvitation *_Nonnull)localInvitation {
  [self sendClientEvent:@"onLocalInvitationCanceled" params:@{
                                                @"localInvitation": @{
                                                    @"calleeId": localInvitation.calleeId,
                                                    @"content": localInvitation.content,
                                                    @"channelId": localInvitation.channelId,
                                                    @"state": @(localInvitation.state),
                                                    @"response": localInvitation.response
                                                    }
                                                }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationFailure:(AgoraRtmLocalInvitation *_Nonnull)localInvitation errorCode:(AgoraRtmLocalInvitationErrorCode)errorCode {
  [self sendClientEvent:@"onLocalInvitationFailure" params:@{
                                               @"errorCode": @(errorCode),
                                               @"localInvitation": @{
                                                   @"calleeId": localInvitation.calleeId,
                                                   @"content": localInvitation.content,
                                                   @"channelId": localInvitation.channelId,
                                                   @"state": @(localInvitation.state),
                                                   @"response": localInvitation.response
                                                   }
                                               }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationReceived:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  [_remoteInvitations setObject:remoteInvitation forKey:remoteInvitation.callerId];
  [self sendClientEvent:@"onRemoteInvitationReceivedByPeer" params:@{
                                                   @"remoteInvitation": @{
                                                       @"callerId": remoteInvitation.callerId,
                                                       @"content": remoteInvitation.content,
                                                       @"channelId": remoteInvitation.channelId,
                                                       @"state": @(remoteInvitation.state),
                                                       @"response": remoteInvitation.response
                                                       }
                                                   }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationRefused:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  [_remoteInvitations setObject:remoteInvitation forKey:remoteInvitation.callerId];
  [self sendClientEvent:@"onRemoteInvitationRefused" params:@{
                                                    @"remoteInvitation": @{
                                                        @"calleeId": remoteInvitation.callerId,
                                                        @"content": remoteInvitation.content,
                                                        @"channelId": remoteInvitation.channelId,
                                                        @"state": @(remoteInvitation.state),
                                                        @"response": remoteInvitation.response
                                                        }
                                                    }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationAccepted:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  [_remoteInvitations removeObjectForKey:remoteInvitation.callerId];
  [self sendClientEvent:@"onRemoteInvitationAccepted" params:@{
                                                    @"remoteInvitation": @{
                                                        @"calleeId": remoteInvitation.callerId,
                                                        @"content": remoteInvitation.content,
                                                        @"channelId": remoteInvitation.channelId,
                                                        @"state": @(remoteInvitation.state),
                                                        @"response": remoteInvitation.response
                                                        }
                                                    }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationCanceled:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  [_remoteInvitations removeObjectForKey:remoteInvitation.callerId];
  [self sendClientEvent:@"onRemoteInvitationCanceled" params:@{
                                                    @"remoteInvitation": @{
                                                        @"calleeId": remoteInvitation.callerId,
                                                        @"content": remoteInvitation.content,
                                                        @"channelId": remoteInvitation.channelId,
                                                        @"state": @(remoteInvitation.state),
                                                        @"response": remoteInvitation.response
                                                        }
                                                    }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationFailure:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation errorCode:(AgoraRtmRemoteInvitationErrorCode)errorCode {
  [_remoteInvitations removeObjectForKey:remoteInvitation.callerId];
  [self sendClientEvent:@"onRemoteInvitationFailure" params:@{
                                                      @"errorCode": @(errorCode),
                                                      @"remoteInvitation": @{
                                                          @"calleeId": remoteInvitation.callerId,
                                                          @"content": remoteInvitation.content,
                                                          @"channelId": remoteInvitation.channelId,
                                                          @"state": @(remoteInvitation.state),
                                                          @"response": remoteInvitation.response
                                                          }
                                                      }];
}

@end
