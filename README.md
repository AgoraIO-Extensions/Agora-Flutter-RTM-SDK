# AgoraRtm

This Flutter plugin is a wapper for [Agora RTM SDK](https://docs.agora.io/en).

Agora.io provides building blocks for you to add real-time messaging through a simple and powerful SDK. You can integrate the Agora RTM SDK to enable real-time messaging in your own application quickly.

*Note*: This plugin is still under development, and some APIs might not be available yet.

## Usage

To use this plugin, add `agora_rtm` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Getting Started

* See the [example](example) directory for a sample app using AgoraRtm.

## Error handling

### Kotlin version

if your version less than 0.9.9, remove `ext.kotlin_version = '1.3.0'` from `agora_rtm/build.gradle`

from 0.9.9, the plugin will use your root project kotlin version, make sure your setting is correct

### Release crash

it causes by code obfuscation because of flutter set `android.enableR8=true` by the default

Add the following line in the **app/proguard-rules.pro** file to prevent code obfuscation:
```
-keep class io.agora.**{*;}
```

## Note

### Flutter 1.12

if your MainActivity extends `io.flutter.embedding.android.FlutterActivity`

please remove this line
```
GeneratedPluginRegistrant.registerWith(this)
```

[you can refer to official documents](https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration)

### abiFilters

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

To help work on this sdk, see our [contributor guide](https://github.com/AgoraIO/Flutter-RTM/blob/master/CONTRIBUTING.md).
