package io.agora.agora_rtm

import android.os.Handler
import io.agora.rtm.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMChannel : RtmChannelListener, EventChannel.StreamHandler {

    val messenger: BinaryMessenger
    val eventChannel: EventChannel
    val clientIndex: Long
    val eventHandler: Handler

    var eventSink: EventChannel.EventSink?


    constructor(clientIndex: Long, channelId: String, messenger: BinaryMessenger, eventHandler: Handler) {
        this.clientIndex = clientIndex
        this.messenger = messenger
        this.eventChannel = EventChannel(this.messenger, "io.agora.rtm.client${clientIndex}.channel${channelId}")
        this.eventChannel.setStreamHandler(this)
        this.eventSink = null
        this.eventHandler = eventHandler
    }

    private fun runMainThread(f: () -> Unit) {
        eventHandler.post(f)
    }

    override
    fun onMessageReceived(message: RtmMessage, member: RtmChannelMember) {
        sendChannelEvent("onMessageReceived", hashMapOf(
                "userId" to member.userId,
                "channelId" to member.channelId,
                "message" to hashMapOf(
                        "text" to message.text,
                        "offline" to message.isOfflineMessage,
                        "ts" to message.serverReceivedTs
                )
        ))
    }

    override
    fun onMemberJoined(member: RtmChannelMember) {
        sendChannelEvent("onMemberJoined", hashMapOf(
                "userId" to member.userId,
                "channelId" to member.channelId
        ))
    }

    override
    fun onMemberLeft(member: RtmChannelMember) {
        sendChannelEvent("onMemberLeft", hashMapOf(
                "userId" to member.userId,
                "channelId" to member.channelId
        ))
    }

    private fun sendChannelEvent(eventName: String, params: HashMap<Any, Any>) {
        var map = params.toMutableMap()
        map["event"] = eventName
        runMainThread {
            this.eventSink?.success(map)
        }
    }

    override
    fun onListen(params: Any?, eventSink: EventChannel.EventSink) {
        this.eventSink = eventSink
    }

    override
    fun onCancel(params: Any?) {
        this.eventSink = null
    }
}