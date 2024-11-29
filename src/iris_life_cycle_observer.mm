#include "iris_life_cycle_observer.h"

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif

namespace irisevent {

ILifeCycleObserver::ILifeCycleObserver(std::function<void()> cb){
  callback_ = cb;
}

void ILifeCycleObserver::addApplicationObserver() {
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

  applicationWillTerminateObserver = (__bridge void *)
#if TARGET_OS_IPHONE
      [center addObserverForName:UIApplicationWillTerminateNotification 
#elif TARGET_OS_MAC
      [center addObserverForName:NSApplicationWillTerminateNotification
#endif
                          object:nil
                           queue:[NSOperationQueue mainQueue]
                      usingBlock:^(NSNotification *notification){
                          callback_();
                      }];
}

void ILifeCycleObserver::removeApplicationObserver() {
  if (applicationWillTerminateObserver != nullptr) {
    id observer = (__bridge id) applicationWillTerminateObserver;
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    applicationWillTerminateObserver = nullptr;
  }
}
}