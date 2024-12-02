import 'package:agora_rtm/src/method_channel/internal/platform/iris_method_channel_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/platform_bindings_delegate_interface.dart';
import 'package:agora_rtm/src/method_channel/internal/platform/web/iris_method_channel_internal_web.dart';

/// Create the [IrisMethodChannelInternal] for web
IrisMethodChannelInternal createIrisMethodChannelInternal(
        PlatformBindingsProvider provider) =>
    IrisMethodChannelInternalWeb(provider);
