# Change log

## 0.9.12
* make channel and client listeners null-safe

## 0.9.11
* upgrade to rtm 1.2.2
* support channel attributes

## 0.9.10
* fix iOS native crash

## 0.9.9
* fix Android `Kotlin Gradle plugin version` bug, now use your root project kotlin version

## 0.9.8
* fix Android `flutter pub get` `Please verify that this file has read permission and try again`

## 0.9.7
* fix iOS cocoapods `target has transitive dependencies that include static binaries`

## 0.9.6
* upgrade to rtm 1.0.1: Support all agora_rtm native api.
* refactor: ios & android, use FlutterEventChannel to serve agora_rtm event handler
* fix multiple instance conflicts

## 0.9.5
* upgrade to rtm 1.0.0
* add method: setLocalUserAttributes, addOrUpdateLocalUserAttributes, deleteLocalUserAttributesByKeys clearLocalUserAttributes getUserAttributes getUserAttributesByKeys

## 0.9.4
* fix android pending exception java.lang.RuntimeException: Methods marked with @UiThread must be executed on the main thread

## 0.9.3

* Bump kotlin version to 1.3.0

## 0.9.2

* Flutter for Agora RTM SDK first release
