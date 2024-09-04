import 'agora_rtm_client.dart';
import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart';

// ignore_for_file: non_constant_identifier_names,

/// Error codes and error messages.
class AgoraRtmException implements Exception {
  /// @nodoc
  AgoraRtmException({required this.code, this.message});

  /// The error code. See ErrorCodeType.
  final int code;

  /// The error message.
  final String? message;

  @override
  String toString() => 'AgoraRtmException($code, $message)';
}

class RtmStatus {
  const RtmStatus(
    this.error,
    this.errorCode,
    this.operation,
    this.reason,
  );

  const RtmStatus.error({
    required String errorCode,
    required String operation,
    required String reason,
  }) : this(true, errorCode, operation, reason);

  const RtmStatus.success({
    required String operation,
  }) : this(false, '0', operation, '');

  final bool error;

  final String errorCode;

  final String operation;

  final String reason;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is RtmStatus &&
        error == other.error &&
        errorCode == other.errorCode &&
        operation == other.operation &&
        reason == other.reason;
  }

  @override
  int get hashCode => Object.hash(error, errorCode, operation, reason);
}

Future<(RtmStatus, RtmClient)> RTM(
  String appId,
  String userId, {
  RtmConfig? config,
}) {
  return RtmClientImplOverride.create(appId, userId, config: config);
}
