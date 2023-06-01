package io.agora.agorartm

import android.os.Handler
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelListener
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmMessage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMChannel(
    clientIndex: Long?,
    channelId: String?,
    messenger: BinaryMessenger,
    private val handler: Handler
) : RtmChannelListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel =
        EventChannel(messenger, "io.agora.rtm.client${clientIndex}.channel${channelId}")
    private var eventSink: EventChannel.EventSink? = null

    init {
        this.eventChannel.setStreamHandler(this)
    }

    private fun sendEvent(eventName: String, params: HashMap<String, Any?>) {
        handler.post {
            this.eventSink?.success(
                hashMapOf(
                    "event" to eventName,
                    "data" to params,
                )
            )
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
