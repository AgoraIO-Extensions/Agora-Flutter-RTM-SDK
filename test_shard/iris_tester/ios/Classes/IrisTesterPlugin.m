#import "IrisTesterPlugin.h"
#if __has_include(<iris_tester/iris_tester-Swift.h>)
#import <iris_tester/iris_tester-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "iris_tester-Swift.h"
#endif

extern const char *GetRtmFixtureVersion(void);
@implementation IrisTesterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  // Keep the test framework linked so its FFI exports exist in the process.
  (void)GetRtmFixtureVersion();
  [SwiftIrisTesterPlugin registerWithRegistrar:registrar];
}
@end
