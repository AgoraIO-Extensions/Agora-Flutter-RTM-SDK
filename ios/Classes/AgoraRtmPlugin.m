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

+ (BOOL) isNSNull:(id)value {
  return value == [NSNull null];
}

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
    if (nil == appId) return result(@{@"errorCode": @(-1)});
    while (nil != _agoraClients[@(self.nextClientIndex)]) {
      self.nextClientIndex++;
    }
    RTMClient *rtmClient = [[RTMClient new] initWithAppId:appId clientIndex:@(self.nextClientIndex)
        messenger:_messenger];
    if (nil == rtmClient) {
      return result(@{@"errorCode": @(-1)});
    }
    _agoraClients[@(self.nextClientIndex)] = rtmClient;
    result(@{@"errorCode": @(0), @"index": @(self.nextClientIndex)});
    self.nextClientIndex++;
  } else if ([@"getSdkVersion" isEqualToString:name]) {
    result(@{@"errorCode": @(0), @"version": [AgoraRtmKit getSDKVersion]});
  } else {
    result(@{@"errorCode": @(-2), @"reason": FlutterMethodNotImplemented});
  }
}

- (void)handleAgoraRtmClientMethod:(NSString *)name
                    params:(NSDictionary *)params
                    result:(FlutterResult)result {
  NSNumber *clientIndex = params[@"clientIndex"];
  NSDictionary *args = params[@"args"];
  RTMClient *rtmClient = _agoraClients[clientIndex];
  if (nil == rtmClient) return result(@{@"errorCode": @(-1)});

  
  if ([@"destroy" isEqualToString:name]) {
    rtmClient = nil;
    [_agoraClients removeObjectForKey:clientIndex];
    result(@{@"errorCode": @(0)});
  }
  else if ([@"setLog" isEqualToString:name]) {
    NSInteger size = args[@"size"] != [NSNull null] ? [args[@"size"] integerValue] : 524288;
    NSString *path = args[@"path"] != [NSNull null] ? args[@"path"] : nil;
    if (nil != path) {
      NSString *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
      path = [NSString stringWithFormat:@"%@/%@", dirPath, path];
    }
    NSNumber *level = args[@"level"] != [NSNull null] ? args[@"level"] : nil;
    result(@{
             @"errorCode": @(0),
             @"results": @{
                 @"setLogFileSize": @([rtmClient.kit setLogFileSize:(int)size]),
                 @"setLogLevel": @([rtmClient.kit setLogFilters:[level integerValue]]),
                 @"setLogFile": @([rtmClient.kit setLogFile:path]),
                 }
             });
  }
  else if ([@"login" isEqualToString:name]) {
    NSString *token = args[@"token"] != [NSNull null] ? args[@"token"] : nil;
    NSString *userId = args[@"userId"];
    [rtmClient.kit loginByToken:token user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"logout" isEqualToString:name]) {
    [rtmClient.kit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"renewToken" isEqualToString:name]) {
    NSString *token = args[@"token"] != [NSNull null] ? args[@"token"] : nil;
    [rtmClient.kit renewToken:token completion:^(NSString *token, AgoraRtmRenewTokenErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"queryPeersOnlineStatus" isEqualToString:name]) {
    NSArray *peerIds = args[@"peerIds"] != [NSNull null] ? args[@"peerIds"] : nil;
    [rtmClient.kit queryPeersOnlineStatus:peerIds completion:^(NSArray<AgoraRtmPeerOnlineStatus *> *peerOnlineStatus, AgoraRtmQueryPeersOnlineErrorCode errorCode) {
      NSMutableDictionary *members = [[NSMutableDictionary alloc] init];
      for (AgoraRtmPeerOnlineStatus *status in peerOnlineStatus) {
        members[status.peerId] = [NSNumber numberWithBool:status.isOnline];
      }
      result(@{@"errorCode": @(errorCode), @"results":members});
    }];
  }
  else if ([@"sendMessageToPeer" isEqualToString:name]) {
    NSString *peerId = args[@"peerId"] != [NSNull null] ? args[@"peerId"] : nil;
    NSString *text = args[@"message"] != [NSNull null] ? args[@"message"] : nil;
    BOOL offline = args[@"offline"] != [NSNull null] ? args[@"offline"] : false;
    BOOL historical = args[@"historical"] != [NSNull null] ? args[@"historical"] : false;
    AgoraRtmSendMessageOptions *sendMessageOption = [[AgoraRtmSendMessageOptions alloc] init];
    sendMessageOption.enableOfflineMessaging = offline;
    sendMessageOption.enableHistoricalMessaging = historical;
    [rtmClient.kit sendMessage:[[AgoraRtmMessage new] initWithText:text]  toPeer:peerId sendMessageOptions:sendMessageOption completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
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
      result(@{@"errorCode": @(errorCode)});
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
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"deleteLocalUserAttributesByKeys" isEqualToString:name]) {
    NSArray *keys = args[@"keys"] != [NSNull null] ? args[@"keys"] : nil;
    [rtmClient.kit deleteLocalUserAttributesByKeys:keys completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"clearLocalUserAttributes" isEqualToString:name]) {
    [rtmClient.kit clearLocalUserAttributesWithCompletion :^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"getUserAttributes" isEqualToString:name]) {
    NSString *userId = args[@"userId"] != [NSNull null] ? args[@"userId"] : nil;
    [rtmClient.kit getUserAllAttributes:userId completion:^(NSArray<AgoraRtmAttribute *> * _Nullable attributes, NSString *userId, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableDictionary *userAttributes = [[NSMutableDictionary alloc] init];
      for (AgoraRtmAttribute *item in attributes) {
        [userAttributes setObject:item.value forKey:item.key];
      }
      result(@{@"errorCode": @(errorCode),
               @"attributes": userAttributes});
    }];
  }
  else if ([@"getUserAttributesByKeys" isEqualToString:name]) {
    NSString *userId = args[@"userId"] != [NSNull null] ? args[@"userId"] : nil;
    NSArray *keys = args[@"keys"] != [NSNull null] ? args[@"keys"] : nil;
    [rtmClient.kit getUserAttributes:userId ByKeys:keys completion:^(NSArray<AgoraRtmAttribute *> * _Nullable attributes, NSString *userId, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableDictionary *userAttributes = [[NSMutableDictionary alloc] init];
      for (AgoraRtmAttribute *item in attributes) {
        [userAttributes setObject:item.value forKey:item.key];
      }
      result(@{@"errorCode": @(errorCode),
               @"attributes": userAttributes});
    }];
  }
  else if ([@"setChannelAttributes" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    NSArray *attributes = args[@"attributes"];
    BOOL notify = args[@"enableNotificationToChannelMembers"] != [NSNull null] ? args[@"enableNotificationToChannelMembers"] : false;
    NSMutableArray *rtmChannelAttributes = [[NSMutableArray alloc] init];
    for (NSDictionary* item in attributes) {
      AgoraRtmChannelAttribute *attribute = [[AgoraRtmChannelAttribute alloc] init];
      attribute.key = item[@"key"];
      attribute.value = item[@"value"];
      [rtmChannelAttributes addObject:attribute];
    }
    AgoraRtmChannelAttributeOptions *channelAttributeOption = [[AgoraRtmChannelAttributeOptions alloc] init];
    channelAttributeOption.enableNotificationToChannelMembers = notify;
    [rtmClient.kit setChannel:channelId Attributes:rtmChannelAttributes Options:channelAttributeOption  completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"addOrUpdateChannelAttributes" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    NSArray *attributes = args[@"attributes"];
    BOOL notify = args[@"enableNotificationToChannelMembers"] != [NSNull null] ? args[@"enableNotificationToChannelMembers"] : false;
    NSMutableArray *rtmChannelAttributes = [[NSMutableArray alloc] init];
    for (NSDictionary* item in attributes) {
      AgoraRtmChannelAttribute *attribute = [[AgoraRtmChannelAttribute alloc] init];
      attribute.key = item[@"key"];
      attribute.value = item[@"value"];
      [rtmChannelAttributes addObject:attribute];
    }
    AgoraRtmChannelAttributeOptions *channelAttributeOption = [[AgoraRtmChannelAttributeOptions alloc] init];
    channelAttributeOption.enableNotificationToChannelMembers = notify;
    [rtmClient.kit addOrUpdateChannel:channelId Attributes:rtmChannelAttributes Options:channelAttributeOption  completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"deleteChannelAttributesByKeys" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    NSArray *keys = args[@"keys"] != [NSNull null] ? args[@"keys"] : nil;
    BOOL notify = args[@"enableNotificationToChannelMembers"] != [NSNull null] ? args[@"enableNotificationToChannelMembers"] : false;
    AgoraRtmChannelAttributeOptions *channelAttributeOption = [[AgoraRtmChannelAttributeOptions alloc] init];
    channelAttributeOption.enableNotificationToChannelMembers = notify;
    [rtmClient.kit deleteChannel:channelId AttributesByKeys:keys Options:channelAttributeOption  completion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"clearChannelAttributes" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    BOOL notify = args[@"enableNotificationToChannelMembers"] != [NSNull null] ? args[@"enableNotificationToChannelMembers"] : false;
    AgoraRtmChannelAttributeOptions *channelAttributeOption = [[AgoraRtmChannelAttributeOptions alloc] init];
    channelAttributeOption.enableNotificationToChannelMembers = notify;
    [rtmClient.kit clearChannel:channelId Options:channelAttributeOption  AttributesWithCompletion:^(AgoraRtmProcessAttributeErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"getChannelAttributes" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    [rtmClient.kit getChannelAllAttributes:channelId completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableArray<NSDictionary*> *channelAttributes = [NSMutableArray new];
      for(AgoraRtmChannelAttribute *attribute in attributes) {
        [channelAttributes addObject:@{
                                   @"key": attribute.key,
                                   @"value": attribute.value,
                                   @"userId": attribute.lastUpdateUserId,
                                   @"updateTs": [NSNumber numberWithLongLong:attribute.lastUpdateTs]
                                   }];
      }
      result(@{@"errorCode": @(errorCode),
               @"attributes": channelAttributes});
    }];
  }
  else if ([@"getChannelAttributesByKeys" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    NSArray *keys = args[@"keys"] != [NSNull null] ? args[@"keys"] : nil;
    [rtmClient.kit getChannelAttributes:channelId ByKeys:keys completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
      NSMutableArray<NSDictionary*> *channelAttributes = [NSMutableArray new];
      for(AgoraRtmChannelAttribute *attribute in attributes) {
        [channelAttributes addObject:@{
                                   @"key": attribute.key,
                                   @"value": attribute.value,
                                   @"userId": attribute.lastUpdateUserId,
                                   @"updateTs": [NSNumber numberWithLongLong:attribute.lastUpdateTs]
                                   }];
      }
      result(@{@"errorCode": @(errorCode),
               @"attributes": channelAttributes});
    }];
  }
  else if ([@"sendLocalInvitation" isEqualToString:name]) {
    NSString *calleeId = args[@"calleeId"] != [NSNull null] ? args[@"calleeId"] : nil;
    NSString *content = args[@"content"] != [NSNull null] ? args[@"content"] : nil;
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    AgoraRtmLocalInvitation *invitation = [[AgoraRtmLocalInvitation new] initWithCalleeId:calleeId];
    if (nil == invitation) return result(@{@"errorCode": @(-1)});
    if (nil != content) {
      invitation.content = content;
    }
    if (nil != channelId) {
      invitation.channelId = channelId;
    }
    [rtmClient.callKit sendLocalInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (errorCode == 0) {
        [rtmClient.localInvitations setObject:invitation forKey:invitation.calleeId];
      }
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"cancelLocalInvitation" isEqualToString:name]) {
    NSString *calleeId = args[@"calleeId"] != [NSNull null] ? args[@"calleeId"] : nil;
    NSString *content = args[@"content"] != [NSNull null] ? args[@"content"] : nil;
    NSString *channelId = args[@"channelId"] != [NSNull null] ? args[@"channelId"] : nil;
    AgoraRtmLocalInvitation *invitation = rtmClient.localInvitations[calleeId];
    if (nil == invitation) return result(@{@"errorCode": @(-1)});
    if (nil != content) {
      invitation.content = content;
    }
    if (nil != channelId) {
      invitation.channelId = channelId;
    }
    [rtmClient.callKit cancelLocalInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (errorCode == 0 && rtmClient.localInvitations[invitation.calleeId] != nil) {
        [rtmClient.localInvitations removeObjectForKey:invitation.calleeId];
      }
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"acceptRemoteInvitation" isEqualToString:name]) {
    NSString *response = args[@"response"] != [NSNull null] ? args[@"response"] : nil;
    NSString *callerId = args[@"callerId"] != [NSNull null] ? args[@"callerId"] : nil;
    AgoraRtmRemoteInvitation *invitation = rtmClient.remoteInvitations[callerId];
    if (nil == invitation) return result(@{@"errorCode": @(-1)});
    if (response != nil) {
      invitation.response = response;
    }
    [rtmClient.callKit acceptRemoteInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (errorCode == 0 && rtmClient.remoteInvitations[callerId] != nil) {
        [rtmClient.remoteInvitations removeObjectForKey:callerId];
      }
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"refuseRemoteInvitation" isEqualToString:name]) {
    NSString *response = args[@"response"] != [NSNull null] ? args[@"response"] : nil;
    NSString *callerId = args[@"callerId"] != [NSNull null] ? args[@"callerId"] : nil;
    AgoraRtmRemoteInvitation *invitation = rtmClient.remoteInvitations[callerId];
    if (nil == invitation) return result(@{@"errorCode": @(-1)});
    if (response != nil) {
      invitation.response = response;
    }
    [rtmClient.callKit refuseRemoteInvitation:invitation completion:^(AgoraRtmInvitationApiCallErrorCode errorCode) {
      if (errorCode == 0 && rtmClient.remoteInvitations[callerId] != nil) {
        [rtmClient.remoteInvitations removeObjectForKey:callerId];
      }
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"createChannel" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"];
    RTMChannel *rtmChannel = [[RTMChannel alloc] initWithClientIndex:clientIndex channelId:channelId messenger:_messenger kit:rtmClient.kit];
    if (nil == rtmChannel) return result(@{@"errorCode": @(-1)});
    rtmClient.channels[channelId] = rtmChannel;
    result(@{@"errorCode": @(0)});
  }
  else if ([@"releaseChannel" isEqualToString:name]) {
    NSString *channelId = args[@"channelId"];
    if (nil == rtmClient.channels[channelId]) return result(@{@"errorCode": @(-1)});
    [rtmClient.kit destroyChannelWithId:channelId];
    [rtmClient.channels removeObjectForKey:channelId];
    result(@{@"errorCode": @(0)});
  }
  else {
    result(@{@"errorCode": @(-2), @"reason": FlutterMethodNotImplemented});
  }
}


- (void)handleAgoraRtmChannelMethod:(NSString *)name
                    params:(NSDictionary *)params
                    result:(FlutterResult)result {
  NSNumber *clientIndex = params[@"clientIndex"];
  NSString *channelId = params[@"channelId"];
  NSDictionary *args = params[@"args"];
  RTMClient *rtmClient = _agoraClients[clientIndex];
  
  RTMChannel *rtmChannel = rtmClient.channels[channelId];
  
  if (nil == rtmChannel) return result(@{@"errorCode": @(-1)});

  AgoraRtmChannel *channel = rtmChannel.channel;
  if ([@"join" isEqualToString:name]) {
    [channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"sendMessage" isEqualToString:name]) {
    NSString *text = args[@"message"] != [NSNull null] ? args[@"message"] : nil;
    AgoraRtmMessage *message = [[AgoraRtmMessage new] initWithText:text];
    BOOL offline = args[@"offline"] != [NSNull null] ? args[@"offline"] : false;
    BOOL historical = args[@"historical"] != [NSNull null] ? args[@"historical"] : false;
    AgoraRtmSendMessageOptions *sendMessageOption = [[AgoraRtmSendMessageOptions alloc] init];
    sendMessageOption.enableOfflineMessaging = offline;
    sendMessageOption.enableHistoricalMessaging = historical;
    [channel sendMessage:message sendMessageOptions: sendMessageOption completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"leave" isEqualToString:name]) {
    [channel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
      result(@{@"errorCode": @(errorCode)});
    }];
  }
  else if ([@"getMembers" isEqualToString:name]) {
    [channel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> * _Nullable members, AgoraRtmGetMembersErrorCode errorCode) {
      NSMutableArray<NSDictionary*> *exportMembers = [NSMutableArray new];
      for(AgoraRtmMember *member in members) {
        [exportMembers addObject:@{
                                   @"userId": member.userId,
                                   @"channelId": member.channelId
                                   }];
      }
      result(@{@"errorCode": @(errorCode), @"members": exportMembers});
    }];
  }
  else {
    result(@{@"errorCode": @(-2), @"reason": FlutterMethodNotImplemented});
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
    result(@{@"errorCode": @(-2), @"reason": FlutterMethodNotImplemented});
  }
}

@end
