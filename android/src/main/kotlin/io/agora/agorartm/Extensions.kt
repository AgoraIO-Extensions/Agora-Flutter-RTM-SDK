package io.agora.agorartm

import io.agora.rtm.ChannelAttributeOptions
import io.agora.rtm.ErrorInfo
import io.agora.rtm.LocalInvitation
import io.agora.rtm.RemoteInvitation
import io.agora.rtm.RtmAttribute
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmChannelMemberCount
import io.agora.rtm.RtmMessage
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

fun RtmChannelMember.toJson(): Map<String, Any?> {
    return hashMapOf(
        "userId" to userId,
        "channelId" to channelId,
    )
}

fun List<RtmChannelMember>.toJson(): List<Map<String, Any?>> {
    return List(size) { this[it].toJson() }
}

fun RtmAttribute.toJson(): Map<String, Any?> {
    return hashMapOf(
        "key" to key,
        "value" to value,
    )
}

fun List<RtmAttribute>.toJson(): List<Map<String, Any?>> {
    return List(size) { this[it].toJson() }
}

fun RtmChannelAttribute.toJson(): Map<String, Any?> {
    return hashMapOf(
        "key" to key,
        "value" to value,
        "lastUpdateUserId" to lastUpdateUserId,
        "lastUpdateTs" to lastUpdateTs,
    )
}

fun List<RtmChannelAttribute>.toJson(): List<Map<String, Any?>> {
    return List(size) { this[it].toJson() }
}

fun LocalInvitation.toJson(): Map<String, Any?> {
    return hashMapOf(
        "calleeId" to calleeId,
        "content" to content,
        "channelId" to channelId,
        "response" to response,
        "state" to state,
    )
}

fun RemoteInvitation.toJson(): Map<String, Any?> {
    return hashMapOf(
        "calleeId" to callerId,
        "content" to content,
        "channelId" to channelId,
        "response" to response,
        "state" to state,
    )
}

fun ChannelAttributeOptions.toJson(): Map<String, Any?> {
    return hashMapOf(
        "enableNotificationToChannelMembers" to enableNotificationToChannelMembers,
    )
}

fun SendMessageOptions.toJson(): Map<String, Any?> {
    return hashMapOf(
    )
}

fun RtmChannelMemberCount.toJson(): Map<String, Any?> {
    return hashMapOf(
        "channelID" to channelID,
        "memberCount" to memberCount,
    )
}

fun ErrorInfo.toJson(): Map<String, Any?> {
    return hashMapOf(
        "errorCode" to errorCode,
        "errorDescription" to errorDescription,
    )
}
