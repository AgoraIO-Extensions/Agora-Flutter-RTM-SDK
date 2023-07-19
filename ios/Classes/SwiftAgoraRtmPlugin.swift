//
//  AgoraRtmPlugin.swift
//  agora_rtm
//
//  Created by LXH on 2023/5/31.
//

import Foundation
import Flutter
import AgoraRtmKit

public class SwiftAgoraRtmPlugin: NSObject, FlutterPlugin {
    var registrar: FlutterPluginRegistrar!
    var methodChannel: FlutterMethodChannel!
    
    var nextClientIndex: Int = 0
    var clients: [Int: RTMClient] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "io.agora.rtm", binaryMessenger: registrar.messenger())
        let instance = SwiftAgoraRtmPlugin()
        instance.methodChannel = channel
        instance.registrar = registrar
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodChannel.setMethodCallHandler(nil)
        clients.removeAll()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodName = call.method
        guard let callArguments = call.arguments as? [String: Any] else {
            result(FlutterError(code: "InvalidArguments", message: "Invalid arguments", details: nil))
            return
        }
        let caller = callArguments["caller"] as? String
        let arguments = callArguments["arguments"] as? [String: Any]
        if caller == "AgoraRtmClient#static" {
            handleStaticMethod(methodName, arguments, result)
        } else if caller == "AgoraRtmClient" {
            handleClientMethod(methodName, arguments, result)
        } else if caller == "AgoraRtmChannel" {
            handleChannelMethod(methodName, arguments, result)
        } else if caller == "AgoraRtmCallManager" {
            handleCallManagerMethod(methodName, arguments, result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func handleCallManagerMethod(_ methodName: String?, _ params: [String: Any?]?, _ result: @escaping FlutterResult) {
        if let clientIndex = params?["clientIndex"] as? Int, let agoraClient = clients[clientIndex], let callManager = agoraClient.call?.manager {
            let args = params?["args"] as? [String: Any?]
            switch methodName {
            case "createLocalInvitation":
                let calleeId = args?["calleeId"] as? String
                let localInvitation = AgoraRtmLocalInvitation(calleeId: calleeId!)
                agoraClient.call!.localInvitations[localInvitation.hash] = localInvitation
                result(["errorCode": 0, "result": localInvitation.toJson()])
            case "sendLocalInvitation":
                let localInvitation = (args?["localInvitation"] as? [String: Any?])?.toLocalInvitation(agoraClient.call!)
                callManager.send(localInvitation!) {
                    result(["errorCode": $0.rawValue])
                }
            case "acceptRemoteInvitation":
                let remoteInvitation = (args?["remoteInvitation"] as? [String: Any?])?.toRemoteInvitation(agoraClient.call!)
                callManager.accept(remoteInvitation!) {
                    agoraClient.call!.remoteInvitations.removeValue(forKey: remoteInvitation!.hash)
                    result(["errorCode": $0.rawValue])
                }
            case "refuseRemoteInvitation":
                let remoteInvitation = (args?["remoteInvitation"] as? [String: Any?])?.toRemoteInvitation(agoraClient.call!)
                callManager.refuse(remoteInvitation!) {
                    agoraClient.call!.remoteInvitations.removeValue(forKey: remoteInvitation!.hash)
                    result(["errorCode": $0.rawValue])
                }
            case "cancelLocalInvitation":
                let localInvitation = (args?["localInvitation"] as? [String: Any?])?.toLocalInvitation(agoraClient.call!)
                callManager.cancel(localInvitation!) {
                    agoraClient.call!.localInvitations.removeValue(forKey: localInvitation!.hash)
                    result(["errorCode": $0.rawValue])
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func handleStaticMethod(_ methodName: String?, _ params: [String: Any?]?, _ result: @escaping FlutterResult) {
        switch methodName {
        case "createInstance":
            while (clients[nextClientIndex] != nil) {
                nextClientIndex += 1
            }
            let appId = params?["appId"] as? String
            do {
                let agoraClient = try RTMClient(appId, nextClientIndex, registrar.messenger())
                result(["errorCode": 0, "result": nextClientIndex])
                clients[nextClientIndex] = agoraClient
                nextClientIndex += 1
            } catch let error as NSError {
                result(["errorCode": error.code])
            }
        case "getSdkVersion":
            result(["errorCode": 0, "result": AgoraRtmKit.getSDKVersion()])
        case "setRtmServiceContext":
            let context = params?["context"] as? [String: Any?] ?? [:]
            result(["errorCode": AgoraRtmKit.setRtmServiceContext(context.toRtmServiceContext())])
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func handleClientMethod(_ methodName: String?, _ params: [String: Any?]?, _ result: @escaping FlutterResult) {
        if let clientIndex = params?["clientIndex"] as? Int, let agoraClient = clients[clientIndex], let client = agoraClient.client {
            let args = params?["args"] as? [String: Any?]
            switch methodName {
            case "release":
                clients.removeValue(forKey: clientIndex)
                result(["errorCode": 0])
            case "login":
                let token = args?["token"] as? String
                let userId = args?["userId"] as? String
                client.login(byToken: token, user: userId!) {
                    result(["errorCode": $0.rawValue])
                }
            case "logout":
                client.logout {
                    result(["errorCode": $0.rawValue])
                }
            case "sendMessageToPeer":
                let peerId = args?["peerId"] as? String
                let message = args?["message"] as? [String: Any?] ?? [:]
                let options = args?["options"] as? [String: Any?] ?? [:]
                client.send(message.toRtmMessage(), toPeer: peerId!, sendMessageOptions: options.toSendMessageOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "createChannel":
                let channelId = args?["channelId"] as? String
                let agoraRtmChannel = RTMChannel(clientIndex, channelId!, registrar.messenger())
                let channel = client.createChannel(withId: channelId!, delegate: agoraRtmChannel)
                agoraClient.channels[channelId!] = channel
                result(["errorCode": 0])
            case "queryPeersOnlineStatus":
                let peerIds = args?["peerIds"] as? [String]
                client.queryPeersOnlineStatus(peerIds!) {
                    result(["errorCode": $1.rawValue, "result": $0?.reduce(into: [String: Int]()) {
                        $0[$1.peerId] = $1.state.rawValue
                    }])
                }
            case "subscribePeersOnlineStatus":
                let peerIds = args?["peerIds"] as? [String]
                client.subscribePeersOnlineStatus(peerIds!) {
                    result(["errorCode": $0.rawValue])
                }
            case "unsubscribePeersOnlineStatus":
                let peerIds = args?["peerIds"] as? [String]
                client.unsubscribePeersOnlineStatus(peerIds!) {
                    result(["errorCode": $0.rawValue])
                }
            case "queryPeersBySubscriptionOption":
                let option = args?["option"] as? Int
                client.queryPeers(bySubscriptionOption: AgoraRtmPeerSubscriptionOptions(rawValue: option!)!) {
                    result(["errorCode": $1.rawValue, "result": $0])
                }
            case "renewToken":
                let token = args?["token"] as? String
                client.renewToken(token!) {
                    result(["errorCode": $1.rawValue, "result": $0])
                }
            case "setLocalUserAttributes":
                let attributes = args?["attributes"] as? [[String: Any?]] ?? []
                client.setLocalUserAttributes(attributes.toRtmAttributeList()) {
                    result(["errorCode": $0.rawValue])
                }
            case "addOrUpdateLocalUserAttributes":
                let attributes = args?["attributes"] as? [[String: Any?]] ?? []
                client.addOrUpdateLocalUserAttributes(attributes.toRtmAttributeList()) {
                    result(["errorCode": $0.rawValue])
                }
            case "deleteLocalUserAttributesByKeys":
                let keys = args?["keys"] as? [String]
                client.deleteLocalUserAttributes(byKeys: keys!) {
                    result(["errorCode": $0.rawValue])
                }
            case "clearLocalUserAttributes":
                client.clearLocalUserAttributes {
                    result(["errorCode": $0.rawValue])
                }
            case "getUserAttributes":
                let userId = args?["userId"] as? String
                client.getUserAllAttributes(userId!) {
                    result(["errorCode": $2.rawValue, "result": $0?.toJson(), "userId": $1])
                }
            case "getUserAttributesByKeys":
                let userId = args?["userId"] as? String
                let keys = args?["keys"] as? [String]
                client.getUserAttributes(userId!, byKeys: keys!) {
                    result(["errorCode": $2.rawValue, "result": $0?.toJson(), "userId": $1])
                }
            case "setChannelAttributes":
                let channelId = args?["channelId"] as? String
                let attributes = args?["attributes"] as? [[String: Any?]] ?? []
                let options = args?["options"] as? [String: Any?] ?? [:]
                client.setChannel(channelId!, attributes: attributes.toRtmChannelAttributeList(), options: options.toChannelAttributeOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "addOrUpdateChannelAttributes":
                let channelId = args?["channelId"] as? String
                let attributes = args?["attributes"] as? [[String: Any?]] ?? []
                let options = args?["options"] as? [String: Any?] ?? [:]
                client.addOrUpdateChannel(channelId!, attributes: attributes.toRtmChannelAttributeList(), options: options.toChannelAttributeOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "deleteChannelAttributesByKeys":
                let channelId = args?["channelId"] as? String
                let keys = args?["keys"] as? [String]
                let options = args?["options"] as? [String: Any?] ?? [:]
                client.deleteChannel(channelId!, attributesByKeys: keys!, options: options.toChannelAttributeOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "clearChannelAttributes":
                let channelId = args?["channelId"] as? String
                let options = args?["options"] as? [String: Any?] ?? [:]
                client.clearChannel(channelId!, options: options.toChannelAttributeOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "getChannelAttributes":
                let channelId = args?["channelId"] as? String
                client.getChannelAllAttributes(channelId!) {
                    result(["errorCode": $1.rawValue, "result": $0?.toJson()])
                }
            case "getChannelAttributesByKeys":
                let channelId = args?["channelId"] as? String
                let keys = args?["keys"] as? [String]
                client.getChannelAttributes(channelId!, byKeys: keys!) {
                    result(["errorCode": $1.rawValue, "result": $0?.toJson()])
                }
            case "getChannelMemberCount":
                let channelIds = args?["channelIds"] as? [String]
                client.getChannelMemberCount(channelIds!) {
                    result(["errorCode": $1.rawValue, "result": $0?.toJson()])
                }
            case "setParameters":
                let parameters = args?["parameters"] as? String
                let errorCode = client.setParameters(parameters!)
                result(["errorCode": errorCode])
            case "setLogFile":
                let filePath = args?["filePath"] as? String
                let errorCode = client.setLogFile(filePath!)
                result(["errorCode": errorCode])
            case "setLogFilter":
                let filter = args?["filter"] as? Int
                let errorCode = client.setLogFilters(AgoraRtmLogFilter(rawValue: filter!)!)
                result(["errorCode": errorCode])
            case "setLogFileSize":
                let fileSizeInKBytes = args?["fileSizeInKBytes"] as? Int32
                let errorCode = client.setLogFileSize(fileSizeInKBytes!)
                result(["errorCode": errorCode])
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func handleChannelMethod(_ methodName: String?, _ params: [String: Any?]?, _ result: @escaping FlutterResult) {
        if let clientIndex = params?["clientIndex"] as? Int, let channelId = params?["channelId"] as? String, let agoraClient = clients[clientIndex], let channel = agoraClient.channels[channelId] {
            let args = params?["args"] as? [String: Any?]
            switch methodName {
            case "join":
                channel.join {
                    result(["errorCode": $0.rawValue])
                }
            case "leave":
                channel.leave {
                    result(["errorCode": $0.rawValue])
                }
            case "sendMessage":
                let message = args?["message"] as? [String: Any?] ?? [:]
                let options = args?["options"] as? [String: Any?] ?? [:]
                channel.send(message.toRtmMessage(), sendMessageOptions: options.toSendMessageOptions()) {
                    result(["errorCode": $0.rawValue])
                }
            case "getMembers":
                channel.getMembersWithCompletion() {
                    result(["errorCode": $1.rawValue, "result": $0?.toJson()])
                }
            case "release":
                if let errorCode = agoraClient.client?.destroyChannel(withId: channelId) {
                    agoraClient.channels.removeValue(forKey: channelId)
                    if errorCode {
                        result(["errorCode": 0])
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
