import 'dart:async';

import 'package:flutter/services.dart';

import 'agora_rtm_plugin.dart';
import 'utils.dart';

class AgoraRtmCallManagerException implements Exception {
  final String reason;
  final int code;

  AgoraRtmCallManagerException(this.reason, this.code) : super();
}

class AgoraRtmCallManager {
  /// Occurs when you receive error events.
  void Function(dynamic error)? onError;

  /// Callback to the caller: occurs when the caller receives the call invitation.
  void Function(LocalInvitation localInvitation)?
      onLocalInvitationReceivedByPeer;

  /// Callback to the caller: occurs when the caller accepts the call invitation.
  void Function(LocalInvitation localInvitation, String response)?
      onLocalInvitationAccepted;

  /// Callback to the caller: occurs when the caller declines the call invitation.
  void Function(LocalInvitation localInvitation, String response)?
      onLocalInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  void Function(LocalInvitation localInvitation)? onLocalInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  void Function(LocalInvitation localInvitation, int errorCode)?
      onLocalInvitationFailure;

  /// Callback to the caller: occurs when the callee receives the call invitation.
  void Function(RemoteInvitation remoteInvitation)? onRemoteInvitationReceived;

  /// Callback to the caller: occurs when the callee accepts the call invitation.
  void Function(RemoteInvitation remoteInvitation)? onRemoteInvitationAccepted;

  /// Callback to the caller: occurs when the callee declines the call invitation.
  void Function(RemoteInvitation remoteInvitation)? onRemoteInvitationRefused;

  /// Callback to the caller: occurs when the caller cancels a call invitation.
  void Function(RemoteInvitation remoteInvitation)? onRemoteInvitationCanceled;

  /// Callback to the caller: occurs when the life cycle of the outgoing call invitation ends in failure.
  void Function(RemoteInvitation remoteInvitation, int errorCode)?
      onRemoteInvitationFailure;

  final int _clientIndex;

  StreamSubscription<dynamic>? _eventSubscription;

  EventChannel _addEventChannel() {
    return EventChannel('io.agora.rtm.client$_clientIndex.call_manager');
  }

  AgoraRtmCallManager(this._clientIndex) {
    _eventSubscription =
        _addEventChannel().receiveBroadcastStream().listen((dynamic event) {
      final map = Map.from(event['data']);
      switch (event['event']) {
        case 'onLocalInvitationReceivedByPeer':
          onLocalInvitationReceivedByPeer
              ?.call(LocalInvitation.fromJson(map['localInvitation']));
          break;
        case 'onLocalInvitationAccepted':
          onLocalInvitationAccepted?.call(
              LocalInvitation.fromJson(map['localInvitation']),
              map['response']);
          break;
        case 'onLocalInvitationRefused':
          onLocalInvitationRefused?.call(
              LocalInvitation.fromJson(map['localInvitation']),
              map['response']);
          break;
        case 'onLocalInvitationCanceled':
          onLocalInvitationCanceled
              ?.call(LocalInvitation.fromJson(map['localInvitation']));
          break;
        case 'onLocalInvitationFailure':
          onLocalInvitationFailure?.call(
              LocalInvitation.fromJson(map['localInvitation']),
              map['errorCode']);
          break;
        case 'onRemoteInvitationReceived':
          onRemoteInvitationReceived
              ?.call(RemoteInvitation.fromJson(map['remoteInvitation']));
          break;
        case 'onRemoteInvitationAccepted':
          onRemoteInvitationAccepted
              ?.call(RemoteInvitation.fromJson(map['remoteInvitation']));
          break;
        case 'onRemoteInvitationRefused':
          onRemoteInvitationRefused
              ?.call(RemoteInvitation.fromJson(map['remoteInvitation']));
          break;
        case 'onRemoteInvitationCanceled':
          onRemoteInvitationCanceled
              ?.call(RemoteInvitation.fromJson(map['remoteInvitation']));
          break;
        case 'onRemoteInvitationFailure':
          onRemoteInvitationFailure?.call(
              RemoteInvitation.fromJson(map['remoteInvitation']),
              map['errorCode']);
          break;
      }
    }, onError: onError);
  }

  Future<dynamic> _callNative(String methodName, dynamic arguments) {
    return AgoraRtmPlugin.callMethodForCallManager(
        methodName, {'clientIndex': _clientIndex, 'args': arguments});
  }

  Future<LocalInvitation> createLocalInvitation(String calleeId) async {
    return LocalInvitation.fromJson(
        await _callNative("createLocalInvitation", {'calleeId': calleeId}));
  }

  /// Allows the caller to send a call invitation to the callee.
  Future<void> sendLocalInvitation(LocalInvitation localInvitation) {
    return _callNative(
        "sendLocalInvitation", {'localInvitation': localInvitation.toJson()});
  }

  /// Allows the callee to accept a call invitation.
  Future<void> acceptRemoteInvitation(RemoteInvitation remoteInvitation) {
    return _callNative("acceptRemoteInvitation",
        {'remoteInvitation': remoteInvitation.toJson()});
  }

  /// Allows the callee to decline a call invitation.
  Future<void> refuseRemoteInvitation(RemoteInvitation remoteInvitation) {
    return _callNative("refuseRemoteInvitation",
        {'remoteInvitation': remoteInvitation.toJson()});
  }

  /// Allows the caller to cancel a call invitation.
  Future<void> cancelLocalInvitation(LocalInvitation localInvitation) {
    return _callNative(
        "cancelLocalInvitation", {'localInvitation': localInvitation.toJson()});
  }

  Future<void> release() async {
    await _eventSubscription
        ?.cancel()
        .then((value) => _eventSubscription = null);
  }
}
