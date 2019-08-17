#import "AgoraRtmPlugin.h"
#import "RTMChannel.h"
#import "RTMClient.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface AgoraRtmPlugin() <AgoraRtmDelegate>
  @property (strong, nonatomic) FlutterMethodChannel *methodChannel;
  @property (assign, nonatomic) NSInteger nextClientIndex;
  @property (assign, nonatomic) NSInteger nextChannelIndex;
  @property (strong, nonatomic) NSMutableDictionary<NSNumber *, RTMClient *> *agoraClients;
  @property (strong, nonatomic) id registrar;
  @property (strong, nonatomic) id messenger;
@end

@implementation AgoraRtmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"io.agora.rtm"
                                   binaryMessenger:[registrar messenger]];
  AgoraRtmPlugin* instance = [[AgoraRtmPlugin alloc] init];
  instance.methodChannel = channel;
  instance.registrar = registrar;
  instance.messenger = [registrar messenger];
  instance.agoraClients = [NSMutableDictionary new];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleStaticMethod:(NSString *)name
                    params:(NSDictionary *)params
                    result:(FlutterResult)result {
  if ([@"createInstance" isEqualToString:name]) {
    NSString *appId = params[@"appId"];
    RTMClient *rtmClient = [[RTMClient new] initWithAppId:appId clientIndex:@(self.nextClientIndex)
        messenger:_messenger];
    if (nil == rtmClient) {
      return result(@(-1));
    }
    _agoraClients[@(self.nextClientIndex)] = rtmClient;
    result(@(self.nextClientIndex));
    self.nextClientIndex++;
  } else if ([@"getSdkVersion" isEqualToString:name]) {
    result([AgoraRtmKit getSDKVersion]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handleAgoraRtmClientMethod:(NSString *)name
                    params:(NSDictionary *)params
                    result:(FlutterResult)result {
  NSNumber *clientIndex = params[@"clientIndex"];
  NSDictionary *args = params[@"args"];
  RTMClient *rtmClient = _agoraClients[clientIndex];
  if (nil == rtmClient) return result(@(-1));

  if ([@"destroy" isEqualToString:name]) {
    rtmClient.channels = nil;
    rtmClient = nil;
    result(nil);
  }
  else if ([@"login" isEqualToString:name]) {
    NSString *token = args[@"token"] != [NSNull null] ? args[@"token"] : nil;
    NSString *userId = args[@"userId"];
    [rtmClient.kit loginByToken:token user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"logout" isEqualToString:name]) {
    [rtmClient.kit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"renewToken" isEqualToString:name]) {
    NSString *token = args[@"token"];
    [rtmClient.kit renewToken:token completion:^(NSString *token, AgoraRtmRenewTokenErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"queryPeersOnlineStatus" isEqualToString:name]) {
    NSArray *peerIds = args[@"peerIds"];
    [rtmClient.kit queryPeersOnlineStatus:peerIds completion:^(NSArray<AgoraRtmPeerOnlineStatus *> *peerOnlineStatus, AgoraRtmQueryPeersOnlineErrorCode errorCode) {
      NSMutableDictionary *members = [[NSMutableDictionary alloc] init];
      for (AgoraRtmPeerOnlineStatus *status in peerOnlineStatus) {
        members[status.peerId] = [NSNumber numberWithBool:status.isOnline];
      }
      result(@{@"errorCode": @(errorCode), @"results":members});
    }];
  }
  else if ([@"sendMessageToPeer" isEqualToString:name]) {
    NSString *peerId = args[@"peerId"];
    NSString *text = args[@"message"];
    AgoraRtmSendMessageOptions *sendMessageOption = [[AgoraRtmSendMessageOptions alloc] init];
    sendMessageOption.enableOfflineMessaging = (BOOL)[args[@"offline"] boolValue];
    [rtmClient.kit sendMessage:[[AgoraRtmMessage new] initWithText:text]  toPeer:peerId sendMessageOptions:sendMessageOption completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"setLocalUserAttributes" isEqualToString:name]) {
    NSArray *attributes = args[@"attributes"];
    NSMutableArray *rtmAttributes = [[NSMutableArray alloc] init];
    for (NSDictionary* item in attributes) {
      AgoraRtmAttribute *attribute = [[AgoraRtmAttribute alloc] init];
      attribute.key = item[@"key"];
      attribute.value = item[@"value"];
      [rtmAttributes addObject:attribute];
    }
    [rtmClient.kit setLocalUserAttributes:rtmAttributes completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"addOrUpdateLocalUserAttributes" isEqualToString:name]) {
    NSArray *attributes = args[@"attributes"];
    NSMutableArray *rtmAttributes = [[NSMutableArray alloc] init];
    for (NSDictionary* item in attributes) {
      AgoraRtmAttribute *attribute = [[AgoraRtmAttribute alloc] init];
      attribute.key = item[@"key"];
      attribute.value = item[@"value"];
      [rtmAttributes addObject:attribute];
    }
    [rtmClient.kit addOrUpdateLocalUserAttributes:rtmAttributes completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"deleteLocalUserAttributesByKeys" isEqualToString:name]) {
    NSArray *keys = args[@"keys"];
    [rtmClient.kit deleteLocalUserAttributesByKeys:keys completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"clearLocalUserAttributes" isEqualToString:name]) {
    [rtmClient.kit clearLocalUserAttributesWithCompletion :^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"getUserAttributes" isEqualToString:name]) {
    NSString *userId = args[@"userId"];
    [rtmClient.kit getUserAllAttributes:userId completion:^(NSArray<AgoraRtmAttribute *> * _Nullable attributes, NSString *userId, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableDictionary *userAttributes = [[NSMutableDictionary alloc] init];
      for (AgoraRtmAttribute *item in attributes) {
        [userAttributes setObject:item.value forKey:item.key];
      }
      result(@{@"errorCode": @(errorCode),
               @"userId": userId,
               @"attributes": userAttributes});
    }];
  }
  else if ([@"getUserAttributesByKeys" isEqualToString:name]) {
    NSString *userId = args[@"userId"];
    NSArray *keys = args[@"keys"];
    [rtmClient.kit getUserAttributes:userId ByKeys:keys completion:^(NSArray<AgoraRtmAttribute *> * _Nullable attributes, NSString *userId, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableDictionary *userAttributes = [[NSMutableDictionary alloc] init];
      for (AgoraRtmAttribute *item in attributes) {
        [userAttributes setObject:item.value forKey:item.key];
      }
      result(@{@"errorCode": @(errorCode),
               @"userId": userId,
               @"attributes": userAttributes});
    }];
  }
  else if ([@"sendLocalInvitation" isEqualToString:name]) {
    NSString *calleeId = args[@"calleeId"];
    NSString *content = args[@"content"];
    NSString *channelId = args[@"channelId"];
    AgoraRtmLocalInvitation *invitation = [[AgoraRtmLocalInvitation new] initWithCalleeId:calleeId];
    invitation.content = content;
    invitation.channelId = channelId;
    [rtmClient.callKit sendLocalInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"cancelLocalInvitation" isEqualToString:name]) {
    NSString *calleeId = args[@"calleeId"];
    NSString *content = args[@"content"];
    NSString *channelId = args[@"channelId"];
    AgoraRtmLocalInvitation *invitation = [[AgoraRtmLocalInvitation new] initWithCalleeId:calleeId];
    invitation.content = content;
    invitation.channelId = channelId;
    [rtmClient.callKit cancelLocalInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"acceptRemoteInvitation" isEqualToString:name]) {
    NSString *response = args[@"response"];
    NSString *callerId = args[@"callerId"];
    AgoraRtmRemoteInvitation *invitation = rtmClient.remoteInvitations[callerId];
    if (nil == invitation) return result(@(-1));
    invitation.response = response;
    [rtmClient.callKit acceptRemoteInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (rtmClient.remoteInvitations[callerId]) {
        [rtmClient.remoteInvitations removeObjectForKey:callerId];
      }
      result(@(errorCode));
    }];
  }
  else if ([@"refuseRemoteInvitation" isEqualToString:name]) {
    NSString *response = args[@"response"];
    NSString *callerId = args[@"callerId"];
    AgoraRtmRemoteInvitation *invitation = rtmClient.remoteInvitations[callerId];
    if (nil == invitation) return result(@(-1));
    invitation.response = response;
    [rtmClient.callKit refuseRemoteInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (rtmClient.remoteInvitations[callerId]) {
        [rtmClient.remoteInvitations removeObjectForKey:callerId];
      }
      result(@(errorCode));
    }];
  }
  else if ([@"createChannel" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"];
    RTMChannel *rtmChannel = [[RTMChannel alloc] init];
    if (nil != rtmClient.channels[channelId]) return result(@(-1));
    AgoraRtmChannel *channel = [rtmClient.kit createChannelWithId:channelId
                              delegate:rtmChannel];
    if (nil != channel || nil != rtmChannel) return result(@(-1));
    rtmClient.channels[channelId] = @[channel, rtmChannel];
    result(nil);
  }
  else if ([@"releaseChannel" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"];
    if (nil == rtmClient.channels[channelId]) return result(@(-1));
    [rtmClient.kit destroyChannelWithId:channelId];
    [rtmClient.channels removeObjectForKey:channelId];
    result(nil);
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)handleAgoraRtmChannelMethod:(NSString *)name
                    params:(NSDictionary *)params
                    result:(FlutterResult)result {
  NSNumber *clientIndex = params[@"clientIndex"];
  NSString *channelId = params[@"channelId"];
  NSDictionary *args = params[@"args"];
  RTMClient *rtmClient = _agoraClients[clientIndex];
  
  NSArray *agoraChannel = rtmClient.channels[channelId];
  
  if (nil != agoraChannel) return result(@(-1));

  AgoraRtmChannel *channel = agoraChannel[0];
  if ([@"join" isEqualToString:name]) {
    [channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"sendMessage" isEqualToString:name]) {
    AgoraRtmMessage *message = [[AgoraRtmMessage new] initWithText:args[@"message"]];
    [channel sendMessage:message
              completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        result(@(errorCode));
    }];
  }
  else if ([@"leave" isEqualToString:name]) {
    [channel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else if ([@"getMembers" isEqualToString:name]) {
    [channel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> * _Nullable members, AgoraRtmGetMembersErrorCode errorCode) {
      result(@(errorCode));
    }];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handleMethodCall:(FlutterMethodCall*)methodCall result:(FlutterResult)result {
  NSString *methodName = methodCall.method;
  NSDictionary *callArguments = methodCall.arguments;
  NSString *call = callArguments[@"call"];
  NSDictionary *params = callArguments[@"params"];
  
  if ([@"static" isEqualToString:call]) {
    [self handleStaticMethod:methodName params:params result:result];
  } else if ([@"AgoraRtmClient" isEqualToString:call]) {
    [self handleAgoraRtmClientMethod:methodName params:params result:result];
  } else if ([@"AgoraRtmChannel" isEqualToString:call]) {
    [self handleAgoraRtmChannelMethod:methodName params:params result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
