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

// const Map<String, dynamic> kOverrideDisposedIrisMethodCallData = {
//   'result': 0,
//   'requestId': 0,
// };

// class IrisMethodOverride extends IrisMethodChannel {
//   IrisMethodOverride(super.provider);

//   @override
//   Future<CallApiResult> invokeMethod(IrisMethodCall methodCall) async {
//     var result = await super.invokeMethod(methodCall);
//     if (result.irisReturnCode == kDisposedIrisMethodCallReturnCode) {
//       return CallApiResult(
//         irisReturnCode: result.irisReturnCode,
//         data: kOverrideDisposedIrisMethodCallData,
//       );
//     }

//     return result;
//   }
// }
//
// All API methods are designed to throw exceptions rather than return error codes.
// Only AgoraRtmException needs special handling as it contains well-defined error codes.
// All other exceptions should be handled by the user directly.
// Instead of returning an Override CallApiResult (e.g., kOverrideDisposedIrisMethodCallData),
// throw the exception to allow proper error handling by the caller.
class IrisMethodOverride extends IrisMethodChannel {
  IrisMethodOverride(super.provider);

  @override
  Future<CallApiResult> invokeMethod(IrisMethodCall methodCall) async {
    var result = await super.invokeMethod(methodCall);
    if (result.irisReturnCode == kDisposedIrisMethodCallReturnCode) {
      throwExceptionHandler(code: result.irisReturnCode);
    }

    return result;
  }
}
