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
  @property (strong, nonatomic) AgoraRtmKit *kit;
  @property (strong, nonatomic) AgoraRtmCallKit *callKit;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, RTMChannel*> *channels;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, AgoraRtmRemoteInvitation *> *remoteInvitations;
  @property (strong, nonatomic) NSMutableDictionary<NSString *, AgoraRtmLocalInvitation *> *localInvitations;

  @property (strong, nonatomic) NSObject<FlutterBinaryMessenger> *messenger;
  @property (strong, nonatomic) NSNumber *clientIndex;
  @property (strong, nonatomic) FlutterEventChannel *eventChannel;
  @property (strong, nonatomic) FlutterEventSink eventSink;

  - (instancetype) initWithAppId:(NSString *)appId
         clientIndex:(NSNumber *)clientIndex
           messenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
