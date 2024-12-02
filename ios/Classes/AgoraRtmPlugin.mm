#import "AgoraRtmPlugin.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#include "../../src/iris_event.cc"
#pragma clang diagnostic pop

// Ignore warning of [-Wdocumentation/-Wstrict-prototypes] of dart_api_dl.c
// #pragma clang diagnostic push
// #pragma clang diagnostic ignored "-Wdocumentation"
// #pragma clang diagnostic ignored "-Wstrict-prototypes"
// #include "../../src/dart-sdk/include/dart_api_dl.c"
// #pragma clang diagnostic pop

#include "../../src/iris_life_cycle_observer.mm"

@implementation AgoraRtmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"agora_rtm"
            binaryMessenger:[registrar messenger]];
  AgoraRtmPlugin* instance = [[AgoraRtmPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
