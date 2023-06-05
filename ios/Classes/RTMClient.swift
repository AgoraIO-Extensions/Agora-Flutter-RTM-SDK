//
//  RTMClient.swift
//  agora_rtm
//
//  Created by LXH on 2023/5/31.
//

import Foundation
import Flutter
import AgoraRtmKit

class RTMClient: NSObject, FlutterStreamHandler, AgoraRtmDelegate {
    var eventChannel: FlutterEventChannel?
    var eventSink: FlutterEventSink?
    
    var client: AgoraRtmKit?
    var call: RTMCallManager?
    var channels: [String: AgoraRtmChannel] = [:]
    
    init(_ appId: String?, _ clientIndex: Int, _ messenger: FlutterBinaryMessenger) throws {
        super.init()
        self.eventChannel = FlutterEventChannel(name: "io.agora.rtm.client\(clientIndex)", binaryMessenger: messenger)
        self.eventChannel?.setStreamHandler(self)
        
        guard let client = AgoraRtmKit(appId: appId ?? "", delegate: self) else {
            throw NSError(domain: "", code: AgoraRtmLoginErrorCode.invalidAppId.rawValue)
        }
        self.client = client
        self.call = RTMCallManager(client, clientIndex, messenger)
    }
    
    deinit {
        channels.forEach { client?.destroyChannel(withId: $0.key) }
        channels.removeAll()
        eventChannel = nil
        client = nil
        call = nil
    }
    
    func sendEvent(eventName: String, params: [String: Any]) {
        let event: [String: Any?] = [
            "event": eventName,
            "data": params,
        ]
        
        eventSink?(event)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        sendEvent(eventName: "onConnectionStateChanged", params: ["state": state.rawValue, "reason": reason.rawValue])
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        sendEvent(eventName: "onMessageReceived", params: ["message": message.toJson(), "peerId": peerId])
    }
    
    func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus]) {
        sendEvent(eventName: "onPeersOnlineStatusChanged", params: ["peersStatus": onlineStatus.reduce(into: [String: Int]()) {
            $0[$1.peerId] = $1.state.rawValue
        }])
    }
    
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        sendEvent(eventName: "onTokenExpired", params: [:])
    }
    
    func rtmKitTokenPrivilegeWillExpire(_ kit: AgoraRtmKit) {
        sendEvent(eventName: "onTokenPrivilegeWillExpire", params: [:])
    }
}
