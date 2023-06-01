package io.agora.agorartm

import android.content.Context
import android.os.Handler
import io.agora.rtm.RtmChannel
import io.agora.rtm.RtmClient
import io.agora.rtm.RtmClientListener
import io.agora.rtm.RtmMessage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMClient(
    context: Context,
    appId: String?,
    clientIndex: Long,
    messenger: BinaryMessenger,
    private val handler: Handler
) : RtmClientListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel =
        EventChannel(messenger, "io.agora.rtm.client${clientIndex}")
    private var eventSink: EventChannel.EventSink? = null

    val client: RtmClient?
    val call: RTMCallManager
    val channels: HashMap<String?, RtmChannel> = HashMap()

    init {
        this.eventChannel.setStreamHandler(this)

        this.client = RtmClient.createInstance(context, appId, this)
        this.call = RTMCallManager(client, clientIndex, messenger, handler)
    }

    private fun sendEvent(eventName: String, params: HashMap<Any, Any>) {
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

    override fun onConnectionStateChanged(state: Int, reason: Int) {
        sendEvent(
            "onConnectionStateChanged", hashMapOf(
                "state" to state,
                "reason" to reason,
            )
        )
    }

    override fun onMessageReceived(message: RtmMessage, peerId: String) {
        sendEvent(
            "onMessageReceived", hashMapOf(
                "message" to message.toJson(),
                "peerId" to peerId,
            )
        )
    }

    override fun onTokenExpired() {
        sendEvent("onTokenExpired", hashMapOf())
    }

    override fun onTokenPrivilegeWillExpire() {
        sendEvent("onTokenPrivilegeWillExpire", hashMapOf())
    }

    override fun onPeersOnlineStatusChanged(peersStatus: Map<String, Int>) {
        sendEvent(
            "onPeersOnlineStatusChanged", hashMapOf(
                "peersStatus" to peersStatus
            )
        )
    }
}
