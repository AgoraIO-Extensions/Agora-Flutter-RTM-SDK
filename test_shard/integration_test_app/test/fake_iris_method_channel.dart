import 'package:mockito/mockito.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

class FakeIrisMethodChannel extends Fake implements IrisMethodChannel {
  final List<IrisMethodCall> methodCallQueue = [];

  @override
  Future<CallApiResult> invokeMethod(IrisMethodCall methodCall) async {
    methodCallQueue.add(methodCall);
    return CallApiResult(
        irisReturnCode: 0, data: {'result': 0, 'requestId': 1});
  }
}
