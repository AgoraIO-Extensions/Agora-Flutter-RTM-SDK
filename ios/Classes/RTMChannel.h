//
//  RTMChannel.h
//  agora_rtm
//
//  Created by LY on 2019/8/16.
//

#import <AgoraRtmKit/AgoraRtmKit.h>
#import <Flutter/Flutter.h>

@interface RTMChannel : NSObject<FlutterStreamHandler, AgoraRtmChannelDelegate>
  @property (strong, nonatomic) NSObject<FlutterBinaryMessenger> *messenger;
  @property (strong, nonatomic) AgoraRtmChannel *channel;
  @property (strong, nonatomic) NSNumber *clientIndex;
  @property (strong, nonatomic) NSString *channelId;
  @property (strong, nonatomic) FlutterEventChannel *eventChannel;
  @property (strong, nonatomic) FlutterEventSink eventSink;

  - (instancetype) initWithClientIndex:(NSNumber *)clientIndex
                   channelId:(NSString *)channelId
                   messenger:(id)messenger
                         kit:(AgoraRtmKit*)kit;
@end
