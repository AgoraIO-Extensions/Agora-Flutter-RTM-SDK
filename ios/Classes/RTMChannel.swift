//
//  RTMChannel.swift
//  agora_rtm
//
//  Created by LXH on 2023/5/31.
//

import Foundation
import Flutter
import AgoraRtmKit

class RTMChannel: NSObject, FlutterStreamHandler, AgoraRtmChannelDelegate {
    var eventChannel: FlutterEventChannel
    var eventSink: FlutterEventSink?
    
    init(_ clientIndex: Int, _ channelId: String, _ messenger: FlutterBinaryMessenger) {
        eventChannel = FlutterEventChannel(name: "io.agora.rtm.client\(clientIndex).channel\(channelId)", binaryMessenger: messenger)
        super.init()
        eventChannel.setStreamHandler(self)
    }
    
    func sendEvent(eventName: String, params: Dictionary<String, Any?>) {
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
    
    func channel(_ channel: AgoraRtmChannel, memberCount count: Int32) {
        sendEvent(eventName: "onMemberCountUpdated", params: [
            "memberCount": count,
        ])
    }
    
    func channel(_ channel: AgoraRtmChannel, attributeUpdate attributes: [AgoraRtmChannelAttribute]) {
        sendEvent(eventName: "onAttributesUpdated", params: [
            "attributeList": attributes.map { $0.toJson() },
        ])
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        sendEvent(eventName: "onMessageReceived", params: [
            "message": message.toJson(),
            "fromMember": member.toJson(),
        ])
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        sendEvent(eventName: "onMemberJoined", params: [
            "member": member.toJson(),
        ])
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        sendEvent(eventName: "onMemberLeft", params: [
            "member": member.toJson(),
        ])
    }
}
