//
//  RTMClient.h
//  agora_rtm
//
//  Created by LY on 2019/8/15.
//

#import <AgoraRtmKit/AgoraRtmKit.h>
#import <Flutter/Flutter.h>
#import "RTMChannel.h"

@interface RTMClient : NSObject<FlutterStreamHandler, AgoraRtmDelegate, AgoraRtmCallDelegate>
  @property (strong, nonatomic) FlutterMethodChannel *methodChannel;
  @property (strong, nonatomic) NSObject<FlutterBinaryMessenger> *messenger;
  @property (strong, nonatomic) AgoraRtmKit *kit;
  @property (strong, nonatomic) AgoraRtmCallKit *callKit;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray*> *channels;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, AgoraRtmLocalInvitation *> *localInvitations;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, AgoraRtmRemoteInvitation *> *remoteInvitations;
  @property (strong, nonatomic) NSNumber *clientIndex;
  @property (strong, nonatomic) FlutterEventChannel *eventKit;
//  @property (strong, nonatomic) RTMClientEventHandler *eventHandler;
  @property (strong, nonatomic) FlutterEventSink eventSender;

  - (id) initWithAppId:(NSString *)appId
         clientIndex:(NSNumber *)clientIndex
           messenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
