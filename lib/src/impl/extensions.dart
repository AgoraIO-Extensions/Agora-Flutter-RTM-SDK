import 'dart:async';

import 'package:iris_method_channel/iris_method_channel.dart';

import '/src/binding_forward_export.dart';

extension IrisMethodChannelExt on IrisMethodChannel {
  Future<RtmStatus> wrapRtmStatus(
    int nativeReturnCode,
    String operation,
  ) async {
    if (nativeReturnCode == 0) {
      return Future.value(RtmStatus.success(operation: operation));
    }

    final param = {'error_code': nativeReturnCode};
    final callApiResult = await invokeMethod(
      IrisMethodCall('GetIrisRtmErrorReason', jsonEncode(param), buffers: null),
    );

    final rm = callApiResult.data;
    final result = rm['result'].toString();

    return RtmStatus.error(
      errorCode: nativeReturnCode.toString(),
      operation: operation,
      reason: result,
    );
  }
}
