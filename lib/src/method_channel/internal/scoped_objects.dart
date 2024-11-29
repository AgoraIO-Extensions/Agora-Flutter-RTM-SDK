import 'package:flutter/foundation.dart'
    show SynchronousFuture, visibleForTesting;

/// Disposable [ScopedObjects] which will clear all the objects from [ScopedObjects]
/// in [dispose]
class DisposableScopedObjects extends ScopedObjects
    with ScopedDisposableObjectMixin {
  @override
  Future<void> dispose() async {
    await clear();
  }
}

/// Interface to indicate the object is disposable.
abstract class DisposableObject {
  /// Callback when the object is being disposed. DO NOT call this function directly.
  /// If you want to mark the object as disposed, use the [ScopedDisposableObjectMixin.markDisposed]
  /// instead.
  ///
  /// See also:
  /// * [ScopedDisposableObjectMixin], mixin for [DisposableObject]
  Future<void> dispose();
}

/// Mixin for [DisposableObject], to let the [DisposableObject] work with
/// the [ScopedObjects]
mixin ScopedDisposableObjectMixin implements DisposableObject {
  ScopedObjects? _scopedObjects;
  ScopedKey? _scopedKey;
  bool _isDisposed = false;

  void _setScopedKey(ScopedKey scopedKey) {
    _scopedKey = scopedKey;
  }

  void _setOwner(ScopedObjects scopedObjects) {
    _scopedObjects = scopedObjects;
  }

  /// Explicitly mark the object as disposed, which will remove the object from
  /// the [ScopedObjects].
  ///
  /// NOTE that this function will not trigger the [DisposableObject.dispose].
  void markDisposed() {
    assert(_scopedKey != null);
    assert(_scopedObjects != null);

    _scopedObjects!._markDisposed(_scopedKey!);

    _isDisposed = true;
  }

  Future<void> _disposeOnParentClear() async {
    if (_isDisposed) {
      return SynchronousFuture(null);
    }

    await dispose();

    markDisposed();
  }
}

/// Provider function for [DisposableObject]
typedef DisposableObjectProvider = ScopedDisposableObjectMixin Function();

/// A key object which used with [ScopedObjects]
abstract class ScopedKey {}

/// A [ScopedKey] assosiate with [Type]
class TypedScopedKey implements ScopedKey {
  /// Construct [TypedScopedKey]
  const TypedScopedKey(this.type);

  /// A [Type]
  final Type type;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TypedScopedKey && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

/// Scope the objects which mixin with the [ScopedDisposableObjectMixin], all objects
/// will be disposed after [clear]
class ScopedObjects {
  @visibleForTesting
  // ignore: public_member_api_docs
  final Map<ScopedKey, ScopedDisposableObjectMixin?> pool = {};
  bool _isClearing = false;

  void _markDisposed(ScopedKey scopedKey) {
    remove(scopedKey);
  }

  /// Put an [ScopedDisposableObjectMixin] object if absent
  T putIfAbsent<T extends ScopedDisposableObjectMixin>(
      ScopedKey key, DisposableObjectProvider provider) {
    T? v = pool.putIfAbsent(key, () {
      final o = provider();
      o._setOwner(this);
      o._setScopedKey(key);
      return o;
    }) as T?;

    if (v == null) {
      final o = provider();
      o._setOwner(this);
      o._setScopedKey(key);
      v = o as T?;

      pool[key] = o;
    }

    return v!;
  }

  /// Remove the [ScopedDisposableObjectMixin] object by key
  T? remove<T extends ScopedDisposableObjectMixin>(ScopedKey key) {
    T? returnValue;
    final thePool = pool;
    if (_isClearing) {
      for (final k in thePool.keys) {
        if (k == key) {
          thePool[key] = null;
          returnValue = null;
        }
      }
    } else {
      returnValue = thePool.remove(key) as T?;
    }

    return returnValue;
  }

  /// Get the [ScopedDisposableObjectMixin] object by key
  T? get<T extends ScopedDisposableObjectMixin>(ScopedKey key) {
    final v = pool[key] as T?;
    _tryDefragmentPool();
    return v;
  }

  /// Get all the [ScopedKey]s
  Iterable<ScopedKey> get keys {
    final List<ScopedKey> nonNullKeys = [];
    final thePool = pool;
    thePool.forEach((key, value) {
      if (value != null) {
        nonNullKeys.add(key);
      }
    });

    return nonNullKeys;
  }

  /// Get all the [ScopedDisposableObjectMixin] objects
  Iterable<ScopedDisposableObjectMixin> get values {
    final List<ScopedDisposableObjectMixin> nonNullValues = [];
    final thePool = pool;
    for (final v in thePool.values) {
      if (v != null) {
        nonNullValues.add(v);
      }
    }
    return nonNullValues;
  }

  /// Clear all the [ScopedDisposableObjectMixin] objects, which will trigger the
  /// [DisposableObject.dispose]
  Future<void> clear() async {
    _isClearing = true;
    final values = pool.values;
    for (final v in values) {
      await v?._disposeOnParentClear();
    }

    pool.clear();
    _isClearing = false;
  }

  void _tryDefragmentPool() {
    if (_isClearing) {
      return;
    }

    final thePool = pool;
    thePool.removeWhere((key, value) => value == null);
  }
}
