import 'package:agora_rtm/src/method_channel/internal/platform/io/iris_method_channel_internal_io.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/iris_method_channel_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/platform_bindings_delegate_interface.dart';

/// Create the [IrisMethodChannelInternal] for `dart:io`
IrisMethodChannelInternal createIrisMethodChannelInternal(
        PlatformBindingsProvider provider) =>
    IrisMethodChannelInternalIO(provider);
