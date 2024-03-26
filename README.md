# AgoraRtm Example

Demonstrates how to use the `agora_rtm` plugin.

## Before You Started
- This demo is written based on Flutter (Channel stable, 3.19.4), and the construction of the UI may not be compatible with lower versions. If your version is 2.x, it is recommended to disregard the UI modifications and refer only to the changes in the methods.
### Create an Account and Obtain an App ID

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/).
2. In the Agora.io Dashboard that appears, click **Projects** > **Project List** in the left navigation.
3. Copy the **App ID** from the Dashboard to a text file. You will use this ID later when you launch the app.

### Update and Run the Sample Application

Open the `main.dart` file. In the `_createClient()` method, update `<YOUR_APPID>` with your App ID.

```Dart
 _client = await AgoraRtmClient.createInstance('<YOUR_APPID>');
```

### Run example

Connect device and run.
