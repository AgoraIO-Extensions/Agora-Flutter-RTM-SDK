# [1.1.1](https://github.com/AgoraIO/Flutter-RTM/compare/v1.1.0...v1.1.1) (2022-03-08)

* Update package contents to pass all pub.dev\'s checks

> No significant code changes

# [1.1.0](https://github.com/AgoraIO/Flutter-RTM/compare/v1.0.1...v1.1.0) (2022-03-08)


### Features

* upgrade to 1.4.10 ([52ef541](https://github.com/AgoraIO/Flutter-RTM/commit/52ef5414d8a4c1fedb897ffc12f87143a4b7ff42))

## [1.0.1](https://github.com/AgoraIO/Flutter-RTM/compare/v1.0.0...v1.0.1) (2021-09-27)


### Bug Fixes

* null-safety error [#96](https://github.com/AgoraIO/Flutter-RTM/issues/96) ([62ab0f4](https://github.com/AgoraIO/Flutter-RTM/commit/62ab0f45feafc4d6b0bee9d588f90f996956e80b))
* pub get error on flutter 2.5 [#98](https://github.com/AgoraIO/Flutter-RTM/issues/98) ([5beb5f7](https://github.com/AgoraIO/Flutter-RTM/commit/5beb5f7e23684785ec28eaca38aeb1b6e0131f9f))

# [1.0.0](https://github.com/AgoraIO/Flutter-RTM/compare/v1.0.0-rc.1...v1.0.0) (2021-08-25)


### Bug Fixes

* Removed unnecessary blank in `README.md` ([0e64bc3](https://github.com/AgoraIO/Flutter-RTM/commit/0e64bc352952ca0fb04f062352462bb4375251a9))


### Features

* upgrade to native 1.4.+ ([39dda38](https://github.com/AgoraIO/Flutter-RTM/commit/39dda380a23b94b077e3bd19b2c830b6bd816501))



# [1.0.0-rc.0](https://github.com/AgoraIO/Flutter-RTM/compare/v1.0.0-rc.1...v1.0.0) (2021-04-21)

# Change log

## 1.0.0-rc.1
* fix error of get value

## 1.0.0-rc.0
* support null safety

## 0.9.14
* fix iOS build error

## 0.9.13
* add `offline` and `historical` for `sendMessage` and `sendMessageToPeer`

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
