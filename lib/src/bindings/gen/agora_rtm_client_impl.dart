/// GENERATED BY terra, DO NOT MODIFY BY HAND.

// ignore_for_file: public_member_api_docs, unused_local_variable, unused_import, annotate_overrides

import 'binding_forward_export.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

class RtmClientImpl implements RtmClient {
  RtmClientImpl(this.irisMethodChannel);

  final IrisMethodChannel irisMethodChannel;

  @protected
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return param;
  }

  @protected
  bool get isOverrideClassName => false;

  @protected
  String get className => 'RtmClient';

  @override
  Future<void> release() async {
    final apiType = '${isOverrideClassName ? className : 'RtmClient'}_release';
    final param = createParams({});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
  }

  @override
  Future<int> login(String token) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_login_1fa04dd';
    final param = createParams({'token': token});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final loginJson = RtmClientLoginJson.fromJson(rm);
    return loginJson.requestId;
  }

  @override
  Future<int> logout() async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_logout_90386a9';
    final param = createParams({});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final logoutJson = RtmClientLogoutJson.fromJson(rm);
    return logoutJson.requestId;
  }

  @override
  Future<RtmStorage> getStorage() async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_getStorage';
    final param = createParams({});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    return result as RtmStorage;
  }

  @override
  Future<RtmLock> getLock() async {
    final apiType = '${isOverrideClassName ? className : 'RtmClient'}_getLock';
    final param = createParams({});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    return result as RtmLock;
  }

  @override
  Future<RtmPresence> getPresence() async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_getPresence';
    final param = createParams({});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    return result as RtmPresence;
  }

  @override
  Future<int> renewToken(String token) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_renewToken_1fa04dd';
    final param = createParams({'token': token});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final renewTokenJson = RtmClientRenewTokenJson.fromJson(rm);
    return renewTokenJson.requestId;
  }

  @override
  Future<int> publish(
      {required String channelName,
      required String message,
      required int length,
      required PublishOptions option}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_publish_2d36e93';
    final param = createParams({
      'channelName': channelName,
      'message': message,
      'length': length,
      'option': option.toJson()
    });
    final List<Uint8List> buffers = [];
    buffers.addAll(option.collectBufferList());
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: buffers));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final publishJson = RtmClientPublishJson.fromJson(rm);
    return publishJson.requestId;
  }

  @override
  Future<int> subscribe(
      {required String channelName, required SubscribeOptions options}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_subscribe_3fae92d';
    final param =
        createParams({'channelName': channelName, 'options': options.toJson()});
    final List<Uint8List> buffers = [];
    buffers.addAll(options.collectBufferList());
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: buffers));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final subscribeJson = RtmClientSubscribeJson.fromJson(rm);
    return subscribeJson.requestId;
  }

  @override
  Future<int> unsubscribe(String channelName) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_unsubscribe_1fa04dd';
    final param = createParams({'channelName': channelName});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final unsubscribeJson = RtmClientUnsubscribeJson.fromJson(rm);
    return unsubscribeJson.requestId;
  }

  @override
  Future<StreamChannel> createStreamChannel(String channelName) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_createStreamChannel_ae3d0cf';
    final param = createParams({'channelName': channelName});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    return result as StreamChannel;
  }

  @override
  Future<void> setParameters(String parameters) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_setParameters_3a2037f';
    final param = createParams({'parameters': parameters});
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
  }

  @override
  Future<int> publishBinaryMessage(
      {required String channelName,
      required Uint8List message,
      required int length,
      required PublishOptions option}) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_publish_2d36e93';
    final param = createParams({
      'channelName': channelName,
      'length': length,
      'option': option.toJson()
    });
    final List<Uint8List> buffers = [];
    buffers.add(message);
    buffers.addAll(option.collectBufferList());
    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: buffers));
    if (callApiResult.irisReturnCode < 0) {
      throwExceptionHandler(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throwExceptionHandler(code: result);
    }
    final publishBinaryMessageJson =
        RtmClientPublishBinaryMessageJson.fromJson(rm);
    return publishBinaryMessageJson.requestId;
  }
}
