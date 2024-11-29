import 'package:agora_rtm/src/method_channel/internal/iris_handles.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_event_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_method_channel_interface.dart';

// ignore_for_file: public_member_api_docs

class CreateApiEngineResult {
  const CreateApiEngineResult(this.apiEnginePtr, {this.extraData = const {}});
  final IrisApiEngineHandle apiEnginePtr;
  final Map<String, Object> extraData;
}

/// Unified interface for iris API engine of different platforms.
/// On IO, the [PlatformBindingsDelegateInterface] is running inside a seperate isolate which is
/// spawned by the main isolate, so you should not share any objects in this class.
abstract class PlatformBindingsDelegateInterface {
  void initialize();

  CreateApiEngineResult createApiEngine(List<InitilizationArgProvider> args);

  int callApi(
    IrisMethodCall methodCall,
    IrisApiEngineHandle apiEnginePtr,
    IrisApiParamHandle param,
  );

  Future<CallApiResult> callApiAsync(
    IrisMethodCall methodCall,
    IrisApiEngineHandle apiEnginePtr,
    IrisApiParamHandle param,
  );

  IrisEventHandlerHandle createIrisEventHandler(
    IrisCEventHandlerHandle eventHandler,
  );

  void destroyIrisEventHandler(
    IrisEventHandlerHandle handler,
  );

  void destroyNativeApiEngine(IrisApiEngineHandle apiEnginePtr);
}

/// Provider class that allow the user passing the custom implemetation of [PlatformBindingsDelegateInterface],
/// and [IrisEvent].
///
/// On IO, a provider for provide the ffi bindings of native implementation(such like
/// [PlatformBindingsDelegateInterface], [IrisEvent]), which is passed to the isolate, you
/// should not sotre any objects with type that `SendPort` not allowed.
abstract class PlatformBindingsProvider {
  /// Provide the implementation of [PlatformBindingsDelegateInterface].
  PlatformBindingsDelegateInterface provideNativeBindingDelegate();

  /// Provide the implementation of [IrisEvent].
  IrisEvent? provideIrisEvent() => null;
}
