/// Callable class that represent the `Handle` type. You can get the actual handle
/// value as a callable function. e.g.,
/// ```dart
/// final IrisHandle handle = IrisApiEngineHandle(10);
/// final value = handle(); // value = 10
/// ```
abstract class IrisHandle {
  /// Construct the [IrisHandle]
  const IrisHandle();

  /// Callable function that allow you to get the handle value as function.
  Object call();
}

/// [IrisHandle] implementation that hold a value of [Object] type. And return the
/// value when the callable function is called.
class ObjectIrisHandle extends IrisHandle {
  /// Construct the [ObjectIrisHandle]
  const ObjectIrisHandle(this._h);

  final Object _h;

  @override
  Object call() {
    return _h;
  }
}

/// The [IrisHandle] of the iris's `IrisApiEngine`
class IrisApiEngineHandle extends ObjectIrisHandle {
  /// Construct the [IrisApiEngineHandle]
  const IrisApiEngineHandle(Object h) : super(h);
}

/// The [IrisHandle] of the iris's `ApiParam`
class IrisApiParamHandle extends ObjectIrisHandle {
  /// Construct the [IrisApiParamHandle]
  const IrisApiParamHandle(Object h) : super(h);
}

/// The [IrisHandle] of the iris's `IrisCEventHandler`
class IrisCEventHandlerHandle extends ObjectIrisHandle {
  /// Construct the [IrisCEventHandlerHandle]
  const IrisCEventHandlerHandle(Object h) : super(h);
}

/// The [IrisHandle] of the iris's `IrisEventHandler`
class IrisEventHandlerHandle extends ObjectIrisHandle {
  /// Construct the [IrisEventHandlerHandle]
  const IrisEventHandlerHandle(Object h) : super(h);
}

/// The [IrisHandle] of the `BufferParam`
class BufferParamHandle extends ObjectIrisHandle {
  /// Construct the [BufferParamHandle]
  const BufferParamHandle(Object h) : super(h);
}
