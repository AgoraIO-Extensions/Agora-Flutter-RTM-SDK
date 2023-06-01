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
    
    var manager: AgoraRtmCallKit?
    var remoteInvitations: [Int: AgoraRtmRemoteInvitation] = [:]
    var localInvitations: [Int: AgoraRtmLocalInvitation] = [:]
    
    init(_ client: AgoraRtmKit, _ clientIndex: Int, _ messenger: FlutterBinaryMessenger) {
        eventChannel = FlutterEventChannel(
            name: "io.agora.rtm.client\(clientIndex).call_manager",
            binaryMessenger: messenger
        )
        manager = client.getRtmCall()
        super.init()
        eventChannel?.setStreamHandler(self)
        manager?.callDelegate = self
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
    
    func onLocalInvitationReceived(byPeer localInvitation: AgoraRtmLocalInvitation) {
        localInvitations[localInvitation.hash] = localInvitation
        sendEvent(eventName: "onLocalInvitationReceivedByPeer", params: [
            "localInvitation": localInvitation.toJson(),
        ])
    }
    
    func onLocalInvitationAccepted(_ localInvitation: AgoraRtmLocalInvitation, withResponse response: String) {
        sendEvent(eventName: "onLocalInvitationAccepted", params: [
            "localInvitation": localInvitation.toJson(),
            "response": response,
        ])
    }
    
    func onLocalInvitationRefused(_ localInvitation: AgoraRtmLocalInvitation, withResponse response: String) {
        sendEvent(eventName: "onLocalInvitationRefused", params: [
            "localInvitation": localInvitation.toJson(),
            "response": response,
        ])
    }
    
    func onLocalInvitationCanceled(_ localInvitation: AgoraRtmLocalInvitation) {
        sendEvent(eventName: "onLocalInvitationCanceled", params: [
            "localInvitation": localInvitation.toJson(),
        ])
    }
    
    func onLocalInvitationFailure(_ localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        sendEvent(eventName: "onLocalInvitationFailure", params: [
            "localInvitation": localInvitation.toJson(),
            "errorCode": errorCode.rawValue,
        ])
    }
    
    func onRemoteInvitationFailure(_ remoteInvitation: AgoraRtmRemoteInvitation, errorCode: AgoraRtmRemoteInvitationErrorCode) {
        sendEvent(eventName: "onRemoteInvitationFailure", params: [
            "remoteInvitation": remoteInvitation.toJson(),
            "errorCode": errorCode.rawValue,
        ])
    }
    
    func onRemoteInvitationReceived(_ remoteInvitation: AgoraRtmRemoteInvitation) {
        remoteInvitations[remoteInvitation.hash] = remoteInvitation
        sendEvent(eventName: "onRemoteInvitationReceived", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func onRemoteInvitationAccepted(_ remoteInvitation: AgoraRtmRemoteInvitation) {
        sendEvent(eventName: "onRemoteInvitationAccepted", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func onRemoteInvitationRefused(_ remoteInvitation: AgoraRtmRemoteInvitation) {
        sendEvent(eventName: "onRemoteInvitationRefused", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
    
    func onRemoteInvitationCanceled(_ remoteInvitation: AgoraRtmRemoteInvitation) {
        sendEvent(eventName: "onRemoteInvitationCanceled", params: [
            "remoteInvitation": remoteInvitation.toJson(),
        ])
    }
}
