#import "AgoraRtmPlugin.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface AgoraRtmPlugin() <AgoraRtmDelegate, AgoraRtmChannelDelegate>
@property (strong, nonatomic) FlutterMethodChannel *methodChannel;
@property (assign, nonatomic) NSInteger nextClientIndex;
@property (assign, nonatomic) NSInteger nextChannelIndex;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, AgoraRtmKit *> *clients;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, AgoraRtmChannel *> *channels;
@end

@implementation AgoraRtmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"io.agora.rtm"
                                   binaryMessenger:[registrar messenger]];
  AgoraRtmPlugin* instance = [[AgoraRtmPlugin alloc] init];
  instance.methodChannel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *callMethod = call.method;
  NSDictionary *callArguments = call.arguments;
  NSLog(@"plugin handleMethodCall: %@, argus: %@", callMethod, callArguments);
  
  // client
  if ([@"AgoraRtmClient_createInstance" isEqualToString:callMethod]) {
    NSString *appId = [self stringFromArguments:callArguments key:@"appId"];
    AgoraRtmKit *kit = [[AgoraRtmKit alloc] initWithAppId:appId delegate:self];
    if (kit) {
      NSNumber *key = [NSNumber numberWithInteger:self.nextClientIndex];
      self.clients[key] = kit;
      self.nextClientIndex ++;
      result(key);
    } else {
      result(@(-1));
    }
  } else if ([@"AgoraRtmClient_login" isEqualToString:callMethod]) {
    NSString *token = [self stringFromArguments:callArguments key:@"token"];
    NSString *userId = [self stringFromArguments:callArguments key:@"userId"];
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    [client loginByToken:token user:userId completion:^(AgoraRtmLoginErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                               toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmClient_login"
                             arguments:arguments];
    }];
  } else if ([@"AgoraRtmClient_logout" isEqualToString:callMethod]) {
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    [client logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                               toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmClient_logout"
                             arguments:arguments];
    }];
  } else if ([@"AgoraRtmClient_queryPeersOnlineStatus" isEqualToString:callMethod]) {
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    NSArray *peerIds = [self arrayFromArguments:callArguments key:@"peerIds"];
    [client queryPeersOnlineStatus:peerIds completion:^(NSArray<AgoraRtmPeerOnlineStatus *> *peerOnlineStatus, AgoraRtmQueryPeersOnlineErrorCode errorCode) {
      NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
      for (AgoraRtmPeerOnlineStatus *status in peerOnlineStatus) {
        results[status.peerId] = [NSNumber numberWithBool:status.isOnline];
      }
      NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                               toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode],
                                                             @"results": results,
                                                             }];
      [self.methodChannel invokeMethod:@"AgoraRtmClient_queryPeersOnlineStatus"
                             arguments:arguments];
    }];
  } else if ([@"AgoraRtmClient_sendMessageToPeer" isEqualToString:callMethod]) {
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    NSString *peerId = [self stringFromArguments:callArguments key:@"peerId"];
    NSDictionary *messageDic = [self dictionaryFromArguments:callArguments key:@"message"];
    AgoraRtmMessage *message = [self messageFromDic:messageDic];
    [client sendMessage:message toPeer:peerId completion:^(AgoraRtmSendPeerMessageErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                               toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmClient_sendMessageToPeer" arguments:arguments];
    }];
  } else if ([@"AgoraRtmClient_createChannel" isEqualToString:callMethod]) {
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    NSString *channelId = [self stringFromArguments:callArguments key:@"channelId"];
    AgoraRtmChannel *channel = [client createChannelWithId:channelId delegate:self];
    if (channel) {
      NSNumber *key = [NSNumber numberWithInteger:self.nextChannelIndex];
      self.channels[key] = channel;
      self.nextChannelIndex++;
      result(key);
    } else {
      result(@(-1));
    }
  }
  
  // channel
  else if ([@"AgoraRtmChannel_join" isEqualToString:callMethod]) {
    NSNumber *channelIndex = [self numberFromArguments:callArguments key:@"channelIndex"];
    AgoraRtmChannel *channel = self.channels[channelIndex];
    [channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                                toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmChannel_join" arguments:arguments];
    }];
  } else if ([@"AgoraRtmChannel_leave" isEqualToString:callMethod]) {
    NSNumber *channelIndex = [self numberFromArguments:callArguments key:@"channelIndex"];
    AgoraRtmChannel *channel = self.channels[channelIndex];
    [channel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                                toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmChannel_leave" arguments:arguments];
    }];
  } else if ([@"AgoraRtmChannel_sendMessage" isEqualToString:callMethod]) {
    NSNumber *channelIndex = [self numberFromArguments:callArguments key:@"channelIndex"];
    AgoraRtmChannel *channel = self.channels[channelIndex];
    NSDictionary *messageDic = [self dictionaryFromArguments:callArguments key:@"message"];
    AgoraRtmMessage *message = [self messageFromDic:messageDic];
    [channel sendMessage:message completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
      NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                                toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode]}];
      [self.methodChannel invokeMethod:@"AgoraRtmChannel_sendMessage" arguments:arguments];
    }];
  } else if ([@"AgoraRtmChannel_getMembers" isEqualToString:callMethod]) {
    NSNumber *channelIndex = [self numberFromArguments:callArguments key:@"channelIndex"];
    AgoraRtmChannel *channel = self.channels[channelIndex];
    [channel getMembersWithCompletion:^(NSArray<AgoraRtmMember *> * _Nullable members, AgoraRtmGetMembersErrorCode errorCode) {
      NSMutableArray *membersList = [[NSMutableArray alloc] init];
      for (AgoraRtmMember *member in members) {
        [membersList addObject:[self dicFromMember:member]];
      }
      NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                                toArguments:@{@"errorCode": [NSNumber numberWithInteger:errorCode], @"members": membersList}];
      [self.methodChannel invokeMethod:@"AgoraRtmChannel_getMembers" arguments:arguments];
    }];
  } else if ([@"AgoraRtmChannel_release" isEqualToString:callMethod]) {
    NSNumber *clientIndex = [self numberFromArguments:callArguments key:@"clientIndex"];
    AgoraRtmKit *client = self.clients[clientIndex];
    NSString *channelId = [self stringFromArguments:callArguments key:@"channelId"];
    [client destroyChannelWithId:channelId];
    self.clients[clientIndex] = nil;
  }
  
  else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - client
- (NSMutableDictionary<NSNumber *, AgoraRtmKit *> *)clients {
  if (!_clients) {
    _clients = [[NSMutableDictionary<NSNumber *, AgoraRtmKit *> alloc] init];
  }
  return _clients;
}

- (NSNumber *)indexOfClient:(AgoraRtmKit *)client {
  for (NSNumber *key in self.clients.allKeys) {
    if ([self.clients[key] isEqual:client]) {
      return key;
    }
  }
  return nil;
}

- (NSDictionary *)appendRtmClientIndex:(NSNumber *)clientIndex toArguments:(NSDictionary *)arguments {
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:arguments];
  dic[@"objIndex"] = clientIndex;
  dic[@"obj"] = @"AgoraRtmClient";
  return [dic copy];
}

#pragma mark - channels
- (NSMutableDictionary<NSNumber *, AgoraRtmChannel *> *)channels {
  if (!_channels) {
    _channels = [[NSMutableDictionary<NSNumber *, AgoraRtmChannel *> alloc] init];
  }
  return _channels;
}

- (NSNumber *)indexOfChannel:(AgoraRtmChannel *)channel {
  for (NSNumber *key in self.channels.allKeys) {
    if ([self.channels[key] isEqual:channel]) {
      return key;
    }
  }
  return nil;
}

- (NSDictionary *)appendRtmChannelIndex:(NSNumber *)channelIndex toArguments:(NSDictionary *)arguments {
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:arguments];
  dic[@"objIndex"] = channelIndex;
  dic[@"obj"] = @"AgoraRtmChannel";
  return [dic copy];
}


#pragma mark - client delegate
- (void)rtmKit:(AgoraRtmKit *)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
  NSNumber *clientIndex = [self indexOfClient:kit];
  NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                           toArguments:@{@"state": @(state),
                                                         @"reason": @(reason)}];
  [self.methodChannel invokeMethod:@"AgoraRtmClient_onConnectionStateChanged"
                         arguments:arguments];
}

- (void)rtmKit:(AgoraRtmKit *)kit messageReceived:(AgoraRtmMessage *)message fromPeer:(NSString *)peerId {
  NSNumber *clientIndex = [self indexOfClient:kit];
  NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                           toArguments:@{@"message": [self dicFromMessage:message],
                                                         @"peerId": peerId}];
  [self.methodChannel invokeMethod:@"AgoraRtmClient_onMessageReceived"
                         arguments:arguments];
}

- (void)rtmKitTokenDidExpire:(AgoraRtmKit *)kit {
  NSNumber *clientIndex = [self indexOfClient:kit];
  NSDictionary *arguments = [self appendRtmClientIndex:clientIndex
                                           toArguments:nil];
  [self.methodChannel invokeMethod:@"AgoraRtmClient_onTokenExpired"
                         arguments:arguments];
}

#pragma mark - channel delegate
- (void)channel:(AgoraRtmChannel *)channel memberJoined:(AgoraRtmMember *)member {
  NSNumber *channelIndex = [self indexOfChannel:channel];
  NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                            toArguments:@{@"member": [self dicFromMember:member]}];
  [self.methodChannel invokeMethod:@"AgoraRtmChannel_onMemberJoined" arguments:arguments];
}

- (void)channel:(AgoraRtmChannel *)channel memberLeft:(AgoraRtmMember *)member {
  NSNumber *channelIndex = [self indexOfChannel:channel];
  NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                            toArguments:@{@"member": [self dicFromMember:member]}];
  [self.methodChannel invokeMethod:@"AgoraRtmChannel_onMemberLeft" arguments:arguments];
}

- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member {
  NSNumber *channelIndex = [self indexOfChannel:channel];
  NSDictionary *arguments = [self appendRtmChannelIndex:channelIndex
                                            toArguments:@{@"member": [self dicFromMember:member],
                                                          @"message": [self dicFromMessage:message]}];
  [self.methodChannel invokeMethod:@"AgoraRtmChannel_onMessageReceived" arguments:arguments];
}

#pragma mark - helper
- (NSString *)stringFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSString *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSString class]]) {
    return nil;
  } else {
    return value;
  }
}

- (NSNumber *)numberFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return 0;
  }
  
  NSNumber *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSNumber class]]) {
    return nil;
  } else {
    return value;
  }
}

- (NSInteger)intFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return 0;
  }
  
  NSNumber *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSNumber class]]) {
    return 0;
  } else {
    return [value integerValue];
  }
}

- (double)doubleFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return 0;
  }
  
  NSNumber *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSNumber class]]) {
    return 0;
  } else {
    return [value doubleValue];
  }
}

- (BOOL)boolFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return NO;
  }
  
  NSNumber *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSNumber class]]) {
    return NO;
  } else {
    return [value boolValue];
  }
}

- (NSDictionary *)dictionaryFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSDictionary *value = [arguments valueForKey:key];
  if (![value isKindOfClass:[NSDictionary class]]) {
    return nil;
  } else {
    return value;
  }
}

- (NSArray *)arrayFromArguments:(NSDictionary *)arguments key:(NSString *)key {
  if (![arguments isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSArray *value = [arguments valueForKey:key];
  if ([value isKindOfClass:[NSArray class]]) {
    return value;
  } else {
    return nil;
  }
}

#pragma mark -
- (NSDictionary *)dicFromMessage:(AgoraRtmMessage *)message {
  return @{@"text": message.text};
}

- (AgoraRtmMessage *)messageFromDic:(NSDictionary *)dictionary {
  NSString *text = @"";
  if (dictionary) {
    text = [self stringFromArguments:dictionary key:@"text"];
  }
  return [[AgoraRtmMessage alloc] initWithText:text];
}

- (NSDictionary *)dicFromMember:(AgoraRtmMember *)member {
  return @{@"userId": member.userId, @"channelId": member.channelId};
}
@end
