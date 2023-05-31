import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/services.dart';

mixin AgoraRtmPlugin {
  static const MethodChannel _methodChannel = MethodChannel("io.agora.rtm");

  static Future<dynamic> _sendMethodMessage(
      String caller, String method, Map? arguments) {
    return _methodChannel
        .invokeMethod(method, {"caller": caller, "arguments": arguments});
  }

  static Future<dynamic> callMethodForStatic(String method, Map? arguments) {
    return _sendMethodMessage("AgoraRtmClient#static", method, arguments)
        .then((res) {
      if (res["errorCode"] != 0) {
        throw AgoraRtmClientException(
            "AgoraRtmClient $method failed errorCode: ${res['errorCode']}",
            res["errorCode"]);
      }
      return res['result'];
    });
  }

  static Future<dynamic> callMethodForClient(String method, Map arguments) {
    return _sendMethodMessage("AgoraRtmClient", method, arguments).then((res) {
      if (res["errorCode"] != 0) {
        throw AgoraRtmClientException(
            "AgoraRtmClient $method failed errorCode: ${res['errorCode']}",
            res["errorCode"]);
      }
      return res['result'];
    });
  }

  static Future<dynamic> callMethodForChannel(String method, Map arguments) {
    return _sendMethodMessage("AgoraRtmChannel", method, arguments).then((res) {
      if (res["errorCode"] != 0) {
        throw AgoraRtmChannelException(
            "AgoraRtmChannel $method failed errorCode: ${res['errorCode']}",
            res["errorCode"]);
      }
      return res['result'];
    });
  }

  static Future<dynamic> callMethodForCallManager(
      String method, Map arguments) {
    return _sendMethodMessage("AgoraRtmCallManager", method, arguments)
        .then((res) {
      if (res["errorCode"] != 0) {
        throw AgoraRtmCallManagerException(
            "AgoraRtmCallManager $method failed errorCode: ${res['errorCode']}",
            res["errorCode"]);
      }
      return res['result'];
    });
  }
}
