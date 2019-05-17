# AgoraRtm

This Flutter plugin is a wapper for [Agora RTM SDK](https://docs.agora.io/en).

Agora.io provides building blocks for you to add real-time messaging through a simple and powerful SDK. You can integrate the Agora RTM SDK to enable real-time messaging in your own application quickly.

*Note*: This plugin is still under development, and some APIs might not be available yet.

## Usage

To use this plugin, add `agora_rtm` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Getting Started

* See the [example](example) directory for a sample app using AgoraRtm.

## Note

Agora RTM sdk contain arm64 architecture, but Flutter is not shipping “libflutter.so” in arm64 currently. You need add "abiFilters" in *build.gradle* if you need build release apk.

```
android {
    ..
    defaultConfig {
        ..
         ndk {
             abiFilters 'armeabi-v7a'
        }
        ..
    }
    ..
}
```

## How to contribute

To help work on this sdk, see our [contributor guide](CONTRIBUTING.md).
