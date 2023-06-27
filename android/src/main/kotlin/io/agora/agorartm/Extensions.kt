package io.agora.agorartm

import io.agora.rtm.ChannelAttributeOptions
import io.agora.rtm.ErrorInfo
import io.agora.rtm.LocalInvitation
import io.agora.rtm.RemoteInvitation
import io.agora.rtm.RtmAttribute
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmChannelMemberCount
import io.agora.rtm.RtmClient
import io.agora.rtm.RtmMessage
import io.agora.rtm.RtmServiceContext
import io.agora.rtm.SendMessageOptions

fun RtmMessage.toJson(): Map<String, Any?> {
    return hashMapOf(
        "text" to text,
        "rawMessage" to rawMessage,
        "messageType" to messageType,
        "serverReceivedTs" to serverReceivedTs,
        "isOfflineMessage" to isOfflineMessage,
    )
}

fun Map<*, *>.toRtmMessage(client: RtmClient?): RtmMessage? {
    val text = this["text"] as? String
    return (this["rawMessage"] as? ByteArray)?.let {
        client?.createMessage(it, text)
    } ?: let { client?.createMessage(text) }
}

fun RtmChannelMember.toJson(): Map<String, Any?> {
    return hashMapOf(
        "userId" to userId,
        "channelId" to channelId,
    )
}

fun RtmAttribute.toJson(): Map<String, Any?> {
    return hashMapOf(
        "key" to key,
        "value" to value,
    )
}

fun Map<*, *>.toRtmAttribute(): RtmAttribute {
    return RtmAttribute().apply {
        key = this@toRtmAttribute["key"] as? String
        value = this@toRtmAttribute["value"] as? String
    }
}

fun List<*>.toRtmAttributeList(): List<RtmAttribute?> {
    return this.map { (it as? Map<*, *>)?.toRtmAttribute() }
}

fun RtmChannelAttribute.toJson(): Map<String, Any?> {
    return hashMapOf(
        "key" to key,
        "value" to value,
        "lastUpdateUserId" to lastUpdateUserId,
        "lastUpdateTs" to lastUpdateTs,
    )
}

fun Map<*, *>.toRtmChannelAttribute(): RtmChannelAttribute {
    return RtmChannelAttribute().apply {
        key = this@toRtmChannelAttribute["key"] as? String
        value = this@toRtmChannelAttribute["value"] as? String
    }
}

fun List<*>.toRtmChannelAttributeList(): List<RtmChannelAttribute?> {
    return this.map { (it as? Map<*, *>)?.toRtmChannelAttribute() }
}

fun LocalInvitation.toJson(): Map<String, Any?> {
    return hashMapOf(
        "calleeId" to calleeId,
        "content" to content,
        "channelId" to channelId,
        "response" to response,
        "state" to state,
        "hashCode" to hashCode(),
    )
}

fun Map<*, *>.toLocalInvitation(callManager: RTMCallManager): LocalInvitation {
    val hashCode = this["hashCode"] as? Int
    return hashCode?.let {
        callManager.localInvitations[it]?.apply {
            content = this@toLocalInvitation["content"] as? String
            channelId = this@toLocalInvitation["channelId"] as? String
        }
    } ?: let {
        val calleeId = it["calleeId"] as? String
        callManager.manager.createLocalInvitation(calleeId).apply {
            content = it["content"] as? String
            channelId = it["channelId"] as? String
        }
    }
}

fun RemoteInvitation.toJson(): Map<String, Any?> {
    return hashMapOf(
        "callerId" to callerId,
        "content" to content,
        "channelId" to channelId,
        "response" to response,
        "state" to state,
        "hashCode" to hashCode(),
    )
}

fun Map<*, *>.toRemoteInvitation(callManager: RTMCallManager): RemoteInvitation? {
    val hashCode = this["hashCode"] as? Int
    return callManager.remoteInvitations[hashCode]?.apply {
        response = this@toRemoteInvitation["response"] as? String
    }
}

fun ChannelAttributeOptions.toJson(): Map<String, Any?> {
    return hashMapOf(
        "enableNotificationToChannelMembers" to enableNotificationToChannelMembers,
    )
}

fun Map<*, *>.toChannelAttributeOptions(): ChannelAttributeOptions {
    return ChannelAttributeOptions().apply {
        enableNotificationToChannelMembers =
            this@toChannelAttributeOptions["enableNotificationToChannelMembers"] as Boolean
    }
}

fun SendMessageOptions.toJson(): Map<String, Any?> {
    return hashMapOf(
    )
}

fun Map<*, *>.toSendMessageOptions(): SendMessageOptions {
    return SendMessageOptions()
}

fun RtmChannelMemberCount.toJson(): Map<String, Any?> {
    return hashMapOf(
        "channelId" to channelID,
        "memberCount" to memberCount,
    )
}

fun ErrorInfo.toJson(): Map<String, Any?> {
    return hashMapOf(
        "errorCode" to errorCode,
        "errorDescription" to errorDescription,
    )
}

fun Map<*, *>.toRtmServiceContext(): RtmServiceContext {
    return RtmServiceContext().apply {
        areaCode = this@toRtmServiceContext["areaCode"] as Int
        proxyType = this@toRtmServiceContext["proxyType"] as Int
    }
}

fun List<*>.toStringSet(): Set<String> {
    return toStringList().toSet()
}

fun List<*>.toStringList(): List<String> {
    return this.map { it as String }
}

fun List<*>.toJson(): List<Map<String, Any?>> {
    return this.map {
        when (it) {
            is RtmAttribute -> it.toJson()
            is RtmChannelAttribute -> it.toJson()
            is RtmChannelMember -> it.toJson()
            is RtmChannelMemberCount -> it.toJson()
            else -> emptyMap()
        }
    }
}
