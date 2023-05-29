package io.agora.agorartm

import android.os.Handler
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelListener
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmMessage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMChannel(
    clientIndex: Long,
    channelId: String,
    private val messenger: BinaryMessenger,
    private val eventHandler: Handler
) : RtmChannelListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink?

    init {
        this.eventChannel =
            EventChannel(this.messenger, "io.agora.rtm.client${clientIndex}.channel${channelId}")
        this.eventChannel.setStreamHandler(this)
        this.eventSink = null
    }

    private fun runMainThread(f: () -> Unit) {
        eventHandler.post(f)
    }

    private fun sendEvent(eventName: String, params: HashMap<String, Any?>) {
        val map = params.toMutableMap()
        map["event"] = eventName
        runMainThread {
            this.eventSink?.success(map)
        }
    }

    override fun onListen(params: Any?, eventSink: EventChannel.EventSink) {
        this.eventSink = eventSink
    }

    override fun onCancel(params: Any?) {
        this.eventSink = null
    }

    override fun onMemberCountUpdated(memberCount: Int) {
        sendEvent("onMemberCountUpdated", hashMapOf("memberCount" to memberCount))
    }

    override fun onAttributesUpdated(attributeList: List<RtmChannelAttribute>?) {
        sendEvent(
            "onAttributesUpdated", hashMapOf(
                "attributeList" to attributeList?.toJson()
            )
        )
    }

    override fun onMessageReceived(message: RtmMessage, fromMember: RtmChannelMember) {
        sendEvent(
            "onMessageReceived", hashMapOf(
                "message" to message.toJson(),
                "fromMember" to fromMember.toJson(),
            )
        )
    }

    override fun onMemberJoined(member: RtmChannelMember) {
        sendEvent(
            "onMemberJoined", hashMapOf(
                "member" to member.toJson()
            )
        )
    }

    override fun onMemberLeft(member: RtmChannelMember) {
        sendEvent(
            "onMemberLeft", hashMapOf(
                "member" to member.toJson()
            )
        )
    }
}
