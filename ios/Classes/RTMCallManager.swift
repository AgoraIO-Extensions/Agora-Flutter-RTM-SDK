//
//  RTMCallManager.swift
//  agora_rtm
//
//  Created by LXH on 2023/5/31.
//

import Foundation
import AgoraRtmKit
import Flutter

class RTMCallManager: NSObject, AgoraRtmCallDelegate, FlutterStreamHandler {
    var eventChannel: FlutterEventChannel?
    var eventSink: FlutterEventSink?
    
    var client: AgoraRtmKit?
    var remoteInvitations: [Int: AgoraRtmRemoteInvitation] = [:]
    var localInvitations: [Int: AgoraRtmLocalInvitation] = [:]
    var manager: AgoraRtmCallKit? {
        get {
            return client?.getRtmCall()
        }
    }
    
    init(_ client: AgoraRtmKit, _ clientIndex: Int, _ messenger: FlutterBinaryMessenger) {
        eventChannel = FlutterEventChannel(
            name: "io.agora.rtm.client\(clientIndex).call_manager",
            binaryMessenger: messenger
        )
        self.client = client
        super.init()
        eventChannel?.setStreamHandler(self)
        self.manager?.callDelegate = self
    }
    
    deinit {
        remoteInvitations.removeAll()
        localInvitations.removeAll()
        eventChannel = nil
        client = nil
    }
    
    private func sendEvent(eventName: String, params: [String: Any?]) {
        let event: [String: Any?] = [
            "event": eventName,
            "data": params,
        ]
        
        eventSink?(event)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationReceivedByPeer localInvitation: AgoraRtmLocalInvitation) {
        localInvitations[localInvitation.hash] = localInvitation
        sendEvent(eventName: "onLocalInvitationReceivedByPeer", params: [
            "localInvitation": localInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationAccepted localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        localInvitations.removeValue(forKey: localInvitation.hash)
        sendEvent(eventName: "onLocalInvitationAccepted", params: [
            "localInvitation": localInvitation.toJson(),
            "response": response,
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationRefused localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        localInvitations.removeValue(forKey: localInvitation.hash)
        sendEvent(eventName: "onLocalInvitationRefused", params: [
            "localInvitation": localInvitation.toJson(),
            "response": response,
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationCanceled localInvitation: AgoraRtmLocalInvitation) {
        localInvitations.removeValue(forKey: localInvitation.hash)
        sendEvent(eventName: "onLocalInvitationCanceled", params: [
            "localInvitation": localInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationFailure localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        sendEvent(eventName: "onLocalInvitationFailure", params: [
            "localInvitation": localInvitation.toJson(),
            "errorCode": errorCode.rawValue,
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationReceived remoteInvitation: AgoraRtmRemoteInvitation) {
        remoteInvitations[remoteInvitation.hash] = remoteInvitation
        sendEvent(eventName: "onRemoteInvitationReceived", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationAccepted remoteInvitation: AgoraRtmRemoteInvitation) {
        remoteInvitations.removeValue(forKey: remoteInvitation.hash)
        sendEvent(eventName: "onRemoteInvitationAccepted", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationRefused remoteInvitation: AgoraRtmRemoteInvitation) {
        remoteInvitations.removeValue(forKey: remoteInvitation.hash)
        sendEvent(eventName: "onRemoteInvitationRefused", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationCanceled remoteInvitation: AgoraRtmRemoteInvitation) {
        remoteInvitations.removeValue(forKey: remoteInvitation.hash)
        sendEvent(eventName: "onRemoteInvitationCanceled", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationFailure remoteInvitation: AgoraRtmRemoteInvitation, errorCode: AgoraRtmRemoteInvitationErrorCode) {
        sendEvent(eventName: "onRemoteInvitationFailure", params: [
            "remoteInvitation": remoteInvitation.toJson(),
            "errorCode": errorCode.rawValue,
        ])
    }
}
