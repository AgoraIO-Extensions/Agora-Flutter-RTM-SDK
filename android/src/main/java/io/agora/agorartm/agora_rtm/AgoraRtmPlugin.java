package io.agora.agorartm.agora_rtm;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AgoraRtmPlugin */
public class AgoraRtmPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "agora_rtm");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("androidInit".equals(call.method)) {
      // dart ffi DynamicLibrary.open do not trigger JNI_OnLoad in iris, so we need call java
      // System.loadLibrary here to trigger the JNI_OnLoad explicitly.
      try {
        System.loadLibrary("AgoraRtmWrapper");
      } catch (Exception e) {
        Log.e("AgoraRtmPlugin", "androidInit error:\n" + e);
      }
      result.success(0);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
