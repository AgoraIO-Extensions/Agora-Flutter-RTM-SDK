#import "AgoraRtmPlugin.h"
#if __has_include(<agora_rtm/agora_rtm-Swift.h>)
#import <agora_rtm/agora_rtm-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agora_rtm-Swift.h"
#endif

@implementation AgoraRtmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftAgoraRtmPlugin registerWithRegistrar:registrar];
}
@end
