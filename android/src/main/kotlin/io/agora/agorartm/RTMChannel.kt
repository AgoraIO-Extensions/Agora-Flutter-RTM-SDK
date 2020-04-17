package io.agora.agorartm

import android.os.Handler
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelListener
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmMessage
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

    override fun onAttributesUpdated(attributes: MutableList<RtmChannelAttribute>?) {
        var attributeList = ArrayList<Map<String, Any>>()
        for(attribute in attributes.orEmpty()){
            attributeList.add(hashMapOf(
                    "key" to attribute.key,
                    "value" to attribute.value,
                    "userId" to attribute.getLastUpdateUserId(),
                    "updateTs" to attribute.getLastUpdateTs()
            ))
        }
        sendChannelEvent("onAttributesUpdated", hashMapOf(
                "attributes" to attributeList
        ))
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

    override fun onMemberCountUpdated(count: Int) {
        sendChannelEvent("onMemberCountUpdated", hashMapOf("count" to count))
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