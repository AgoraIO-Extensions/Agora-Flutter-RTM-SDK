import 'package:mockito/annotations.dart';

import 'package:agora_rtm/src/bindings/agora_rtm_client_impl_override.dart'
    as rtm_client_impl_native_binding;

import 'package:agora_rtm/src/bindings/gen/agora_rtm_lock_impl.dart'
    as rtm_lock_impl_native_binding;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_presence_impl.dart'
    as rtm_presence_impl_native_binding;
import 'package:agora_rtm/src/bindings/gen/agora_rtm_storage_impl.dart'
    as rtm_storage_impl_native_binding;
import 'package:agora_rtm/src/bindings/gen/agora_stream_channel_impl.dart'
    as stream_channel_impl_native_binding;

import 'package:agora_rtm/src/impl/rtm_result_handler_impl.dart';

@GenerateNiceMocks([
  MockSpec<rtm_client_impl_native_binding.RtmClientImplOverride>(),
  MockSpec<rtm_lock_impl_native_binding.RtmLockImpl>(),
  MockSpec<rtm_presence_impl_native_binding.RtmPresenceImpl>(),
  MockSpec<rtm_storage_impl_native_binding.RtmStorageImpl>(),
  MockSpec<stream_channel_impl_native_binding.StreamChannelImpl>(),
  // RtmResultHandlerImpl
  MockSpec<RtmResultHandlerImpl>(),
])
// ignore: unused_import
import 'all_mocks.mocks.dart';
