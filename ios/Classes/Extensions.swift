import AgoraRtmKit
import Flutter

extension AgoraRtmMessage {
    func toJson() -> [String: Any?] {
        switch(self){
        case let self as AgoraRtmRawMessage: return [
            "text": text,
            "rawMessage": FlutterStandardTypedData(bytes: self.rawData),
            "messageType": type.rawValue,
            "serverReceivedTs": serverReceivedTs,
            "isOfflineMessage": isOfflineMessage,
        ]
        default: return [
            "text": text,
            "messageType": type.rawValue,
            "serverReceivedTs": serverReceivedTs,
            "isOfflineMessage": isOfflineMessage,
        ]
        }
    }
}

extension AgoraRtmMember {
    func toJson() -> [String: Any?] {
        return [
            "userId": userId,
            "channelId": channelId,
        ]
    }
}

extension AgoraRtmAttribute {
    func toJson() -> [String: Any?] {
        return [
            "key": key,
            "value": value,
        ]
    }
}

extension AgoraRtmChannelAttribute {
    func toJson() -> [String: Any?] {
        return [
            "key": key,
            "value": value,
            "lastUpdateUserId": lastUpdateUserId,
            "lastUpdateTs": lastUpdateTs,
        ]
    }
}

extension AgoraRtmLocalInvitation {
    func toJson() -> [String: Any?] {
        return [
            "calleeId": calleeId,
            "content": content,
            "channelId": channelId,
            "response": response,
            "state": state.rawValue,
            "hashCode": hash,
        ]
    }
}

extension AgoraRtmRemoteInvitation {
    func toJson() -> [String: Any?] {
        return [
            "callerId": callerId,
            "content": content,
            "channelId": channelId,
            "response": response,
            "state": state.rawValue,
            "hashCode": hash,
        ]
    }
}

extension AgoraRtmChannelAttributeOptions{
    func toJson() -> [String: Any?] {
        return [
            "enableNotificationToChannelMembers": enableNotificationToChannelMembers,
        ]
    }
}

extension AgoraRtmSendMessageOptions {
    func toJson() -> [String: Any?] {
        return [:]
    }
}

extension AgoraRtmChannelMemberCount {
    func toJson() -> [String: Any?] {
        return [
            "channelId": channelId,
            "memberCount": count,
        ]
    }
}

extension Dictionary where Key == String {
    func toRtmMessage() -> AgoraRtmMessage {
        let text = self["text"] as? String
        if let rawMessage = self["rawMessage"] as? FlutterStandardTypedData {
            return AgoraRtmRawMessage(rawData: rawMessage.data, description: text!)
        } else {
            return AgoraRtmMessage(text: text!)
        }
    }
    
    func toRtmAttribute() -> AgoraRtmAttribute {
        let rtmAttribute = AgoraRtmAttribute()
        rtmAttribute.key = self["key"] as! String
        rtmAttribute.value = self["value"] as! String
        return rtmAttribute
    }
    
    func toRtmChannelAttribute() -> AgoraRtmChannelAttribute {
        let rtmAttribute = AgoraRtmChannelAttribute()
        rtmAttribute.key = self["key"] as! String
        rtmAttribute.value = self["value"] as! String
        return rtmAttribute
    }
    
    func toLocalInvitation(_ callManager: RTMCallManager) -> AgoraRtmLocalInvitation? {
        if let hashCode = self["hashCode"] as? Int, let localInvitation = callManager.localInvitations[hashCode] {
            localInvitation.content = self["content"] as? String
            localInvitation.channelId = self["channelId"] as? String
            return localInvitation
        }
        if let calleeId = self["calleeId"] as? String {
            let localInvitation = AgoraRtmLocalInvitation(calleeId: calleeId)
            localInvitation.content = self["content"] as? String
            localInvitation.channelId = self["channelId"] as? String
            return localInvitation
        }
        return nil
    }
    
    func toRemoteInvitation(_ callManager: RTMCallManager) -> AgoraRtmRemoteInvitation? {
        if let hashCode = self["hashCode"] as? Int, let remoteInvitation = callManager.remoteInvitations[hashCode] {
            remoteInvitation.response = self["response"] as? String
            return remoteInvitation
        }
        return nil
    }
    
    func toChannelAttributeOptions() -> AgoraRtmChannelAttributeOptions {
        let channelAttributeOptions = AgoraRtmChannelAttributeOptions()
        channelAttributeOptions.enableNotificationToChannelMembers = self["enableNotificationToChannelMembers"] as! Bool
        return channelAttributeOptions
    }
    
    func toSendMessageOptions() -> AgoraRtmSendMessageOptions {
        return AgoraRtmSendMessageOptions()
    }

    func toRtmServiceContext() -> AgoraRtmServiceContext {
        let context = AgoraRtmServiceContext()
        context.areaCode = AgoraRtmAreaCode(rawValue: self["areaCode"] as! UInt)
        context.proxyType = AgoraRtmCloudProxyType(rawValue: self["proxyType"] as! UInt)
        return context
    }
}

extension Array {
    func toRtmAttributeList() -> [AgoraRtmAttribute] {
        return self.map { ($0 as? [String: Any?] ?? [:]).toRtmAttribute() }
    }
    
    func toRtmChannelAttributeList() -> [AgoraRtmChannelAttribute] {
        return self.map { ($0 as? [String: Any?] ?? [:]).toRtmChannelAttribute() }
    }
    
    func toStringList() -> [String] {
        return self.map { $0 as! String }
    }
    
    func toJson() -> [[String: Any?]] {
        return self.map {
            switch $0 {
            case let it as AgoraRtmAttribute: return it.toJson()
            case let it as AgoraRtmChannelAttribute: return it.toJson()
            case let it as AgoraRtmMember: return it.toJson()
            case let it as AgoraRtmChannelMemberCount: return it.toJson()
            default: return [:]
            }
        }
    }
}
