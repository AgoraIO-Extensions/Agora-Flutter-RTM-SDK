//
//  RTMClient.m
//  agora_rtm
//
//  Created by LY on 2019/8/15.
//

#import "RTMClient.h"

@implementation RTMClient
- (instancetype) initWithAppId:(NSString *)appId
         clientIndex:(NSNumber *)clientIndex
           messenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _remoteInvitations = [[NSMutableDictionary alloc] init];
    _localInvitations = [[NSMutableDictionary alloc] init];
    _channels = [[NSMutableDictionary alloc] init];
    _messenger = messenger;
    NSString *channelName = [NSString stringWithFormat:@"io.agora.rtm.client%@", [clientIndex stringValue]];
    _eventChannel = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
    if (nil == _eventChannel) {
      return nil;
    }
    [_eventChannel setStreamHandler:self];
    _kit = [[AgoraRtmKit new] initWithAppId:appId delegate:self];
    if (nil == _kit) return nil;
    _callKit = [_kit getRtmCallKit];
    _callKit.callDelegate = self;
  }
  return self;
}

- (void) dealloc {
  [_remoteInvitations removeAllObjects];
  [_localInvitations removeAllObjects];
  for (NSString *channelId in _channels) {
    [_channels removeObjectForKey:channelId];
    [_kit destroyChannelWithId:channelId];
  }
  [_channels removeAllObjects];
  _eventChannel = nil;
  _channels = nil;
  _callKit = nil;
  _kit = nil;
}

#pragma - FlutterStreamHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
  _eventSink = events;
  return nil;
}

- (void) sendClientEvent:(NSString *)name params:(NSDictionary*)params {
  if (_eventSink) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:params];
    dict[@"event"] = name;
    _eventSink([dict copy]);
  }
}

#pragma - AgoraRtmDelegate
- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
  [self sendClientEvent:@"onConnectionStateChanged" params: @{@"state": @(state), @"reason": @(reason)}];
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId {
  [self sendClientEvent:@"onMessageReceived" params: @{
                 @"message": @{@"text":message.text,
                               @"ts": @(message.serverReceivedTs),
                               @"offline": @(message.isOfflineMessage)
                               },@"peerId": peerId}];
}

- (void)rtmKitTokenDidExpire:(AgoraRtmKit *)kit {
  [self sendClientEvent:@"onTokenExpired" params:@{}];
}

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit PeersOnlineStatusChanged:(NSArray< AgoraRtmPeerOnlineStatus *> * _Nonnull) onlineStatus {
    NSMutableDictionary<NSString*, NSNumber*> *members = [[NSMutableDictionary alloc] init];
    for (AgoraRtmPeerOnlineStatus *status in onlineStatus) {
      members[status.peerId] = [NSNumber numberWithBool:status.isOnline];
    }
    [self sendClientEvent:@"onPeersOnlineStatusChanged" params:@{
        @"peersOnlineStatus": members
    }];
}

#pragma - AgoraRtmCallDelegate
- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationReceivedByPeer:(AgoraRtmLocalInvitation *_Nonnull)localInvitation {
  [_localInvitations setObject:localInvitation forKey:localInvitation.calleeId];
  NSString *calleeId = localInvitation.calleeId != nil ? localInvitation.calleeId : (id)[NSNull null];
  NSString *content = localInvitation.content != nil ? localInvitation.content : (id)[NSNull null];
  NSString *channelId = localInvitation.channelId != nil ? localInvitation.channelId : (id)[NSNull null];
  NSString *_response = localInvitation.response != nil ? localInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onLocalInvitationReceivedByPeer" params:@{
                                               @"localInvitation": @{
                                                                 @"calleeId": calleeId,
                                                                 @"content": content,
                                                                 @"channelId": channelId,
                                                                 @"state": @(localInvitation.state),
                                                                 @"response": _response
                                                             }
                                               }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationAccepted:(AgoraRtmLocalInvitation *_Nonnull)localInvitation withResponse:(NSString *_Nullable)response {
  NSString *calleeId = localInvitation.calleeId != nil ? localInvitation.calleeId : (id)[NSNull null];
  NSString *content = localInvitation.content != nil ? localInvitation.content : (id)[NSNull null];
  NSString *channelId = localInvitation.channelId != nil ? localInvitation.channelId : (id)[NSNull null];
  NSString *_response = localInvitation.response != nil ? localInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onLocalInvitationAccepted" params:@{
                                              @"localInvitation": @{
                                                  @"calleeId": calleeId,
                                                  @"content": content,
                                                  @"channelId": channelId,
                                                  @"state": @(localInvitation.state),
                                                  @"response": _response
                                                  }
                                              }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationRefused:(AgoraRtmLocalInvitation *_Nonnull)localInvitation withResponse:(NSString *_Nullable)response {
  NSString *calleeId = localInvitation.calleeId != nil ? localInvitation.calleeId : (id)[NSNull null];
  NSString *content = localInvitation.content != nil ? localInvitation.content : (id)[NSNull null];
  NSString *channelId = localInvitation.channelId != nil ? localInvitation.channelId : (id)[NSNull null];
  NSString *_response = localInvitation.response != nil ? localInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onLocalInvitationRefused" params:@{
                                                @"localInvitation": @{
                                                    @"calleeId": calleeId,
                                                    @"content": content,
                                                    @"channelId": channelId,
                                                    @"state": @(localInvitation.state),
                                                    @"response": _response
                                                    }
                                                }];
}
   

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationCanceled:(AgoraRtmLocalInvitation *_Nonnull)localInvitation {
  NSString *calleeId = localInvitation.calleeId != nil ? localInvitation.calleeId : (id)[NSNull null];
  NSString *content = localInvitation.content != nil ? localInvitation.content : (id)[NSNull null];
  NSString *channelId = localInvitation.channelId != nil ? localInvitation.channelId : (id)[NSNull null];
  NSString *response = localInvitation.response != nil ? localInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onLocalInvitationCanceled" params:@{
                                                @"localInvitation": @{
                                                    @"calleeId": calleeId,
                                                    @"content": content,
                                                    @"channelId": channelId,
                                                    @"state": @(localInvitation.state),
                                                    @"response": response
                                                    }
                                                }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit localInvitationFailure:(AgoraRtmLocalInvitation *_Nonnull)localInvitation errorCode:(AgoraRtmLocalInvitationErrorCode)errorCode {
  NSString *calleeId = localInvitation.calleeId != nil ? localInvitation.calleeId : (id)[NSNull null];
  NSString *content = localInvitation.content != nil ? localInvitation.content : (id)[NSNull null];
  NSString *channelId = localInvitation.channelId != nil ? localInvitation.channelId : (id)[NSNull null];
  NSString *response = localInvitation.response != nil ? localInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onLocalInvitationFailure" params:@{
                                                  @"errorCode": @(errorCode),
                                                  @"localInvitation": @{
                                                      @"calleeId": calleeId,
                                                      @"content": content,
                                                      @"channelId": channelId,
                                                      @"state": @(localInvitation.state),
                                                      @"response": response
                                                      }
                                                  }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationReceived:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  [_remoteInvitations setObject:remoteInvitation forKey:remoteInvitation.callerId];
  NSString *callerId = remoteInvitation.callerId != nil ? remoteInvitation.callerId : (id)[NSNull null];
  NSString *content = remoteInvitation.content != nil ? remoteInvitation.content : (id)[NSNull null];
  NSString *channelId = remoteInvitation.channelId != nil ? remoteInvitation.channelId : (id)[NSNull null];
  NSString *response = remoteInvitation.response != nil ? remoteInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onRemoteInvitationReceivedByPeer" params:@{
                                                   @"remoteInvitation": @{
                                                       @"callerId": callerId,
                                                       @"content": content,
                                                       @"channelId": channelId,
                                                       @"state": @(remoteInvitation.state),
                                                       @"response": response
                                                       }
                                                   }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationRefused:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  NSString *callerId = remoteInvitation.callerId != nil ? remoteInvitation.callerId : (id)[NSNull null];
  NSString *content = remoteInvitation.content != nil ? remoteInvitation.content : (id)[NSNull null];
  NSString *channelId = remoteInvitation.channelId != nil ? remoteInvitation.channelId : (id)[NSNull null];
  NSString *response = remoteInvitation.response != nil ? remoteInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onRemoteInvitationRefused" params:@{
                                                   @"remoteInvitation": @{
                                                       @"callerId": callerId,
                                                       @"content": content,
                                                       @"channelId": channelId,
                                                       @"state": @(remoteInvitation.state),
                                                       @"response": response
                                                       }
                                                   }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationAccepted:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  NSString *callerId = remoteInvitation.callerId != nil ? remoteInvitation.callerId : (id)[NSNull null];
  NSString *content = remoteInvitation.content != nil ? remoteInvitation.content : (id)[NSNull null];
  NSString *channelId = remoteInvitation.channelId != nil ? remoteInvitation.channelId : (id)[NSNull null];
  NSString *response = remoteInvitation.response != nil ? remoteInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onRemoteInvitationAccepted" params:@{
                                                  @"remoteInvitation": @{
                                                      @"callerId": callerId,
                                                      @"content": content,
                                                      @"channelId": channelId,
                                                      @"state": @(remoteInvitation.state),
                                                      @"response": response
                                                      }
                                                  }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationCanceled:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation {
  NSString *callerId = remoteInvitation.callerId != nil ? remoteInvitation.callerId : (id)[NSNull null];
  NSString *content = remoteInvitation.content != nil ? remoteInvitation.content : (id)[NSNull null];
  NSString *channelId = remoteInvitation.channelId != nil ? remoteInvitation.channelId : (id)[NSNull null];
  NSString *response = remoteInvitation.response != nil ? remoteInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onRemoteInvitationCanceled" params:@{
                                                   @"remoteInvitation": @{
                                                       @"callerId": callerId,
                                                       @"content": content,
                                                       @"channelId": channelId,
                                                       @"state": @(remoteInvitation.state),
                                                       @"response": response
                                                       }
                                                   }];
}

- (void)rtmCallKit:(AgoraRtmCallKit *_Nonnull)callKit remoteInvitationFailure:(AgoraRtmRemoteInvitation *_Nonnull)remoteInvitation errorCode:(AgoraRtmRemoteInvitationErrorCode)errorCode {
  NSString *callerId = remoteInvitation.callerId != nil ? remoteInvitation.callerId : (id)[NSNull null];
  NSString *content = remoteInvitation.content != nil ? remoteInvitation.content : (id)[NSNull null];
  NSString *channelId = remoteInvitation.channelId != nil ? remoteInvitation.channelId : (id)[NSNull null];
  NSString *response = remoteInvitation.response != nil ? remoteInvitation.response : (id)[NSNull null];
  [self sendClientEvent:@"onRemoteInvitationFailure" params:@{
                                                  @"errorCode": @(errorCode),
                                                   @"remoteInvitation": @{
                                                       @"callerId": callerId,
                                                       @"content": content,
                                                       @"channelId": channelId,
                                                       @"state": @(remoteInvitation.state),
                                                       @"response": response
                                                       }
                                                   }];
}

@end
