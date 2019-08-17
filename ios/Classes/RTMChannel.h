//
//  RTMChannel.h
//  agora_rtm
//
//  Created by LY on 2019/8/16.
//

#import <AgoraRtmKit/AgoraRtmKit.h>
#import <Flutter/Flutter.h>

//@interface RTMChannelEventHandler : NSObject<

@interface RTMChannel : NSObject<AgoraRtmChannelDelegate>
  @property (strong, nonatomic) FlutterEventChannel *eventChannel;
@end
