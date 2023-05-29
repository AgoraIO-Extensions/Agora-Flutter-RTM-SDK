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
    private val appId: String,
    clientIndex: Long,
    private val messenger: BinaryMessenger,
    private val eventHandler: Handler
) : RtmClientListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink?

    val client: RtmClient?
    val call: RTMCallManager
    val channels: HashMap<String, RtmChannel> = HashMap()

    init {
        this.eventChannel = EventChannel(this.messenger, "io.agora.rtm.client${clientIndex}")
        this.eventChannel.setStreamHandler(this)
        this.eventSink = null

        this.client = RtmClient.createInstance(context, this.appId, this)
        this.call = RTMCallManager(clientIndex, client, messenger, eventHandler)
    }

    private fun runMainThread(f: () -> Unit) {
        eventHandler.post(f)
    }

    private fun sendEvent(eventName: String, params: HashMap<Any, Any>) {
        val map = params.toMutableMap()
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

    override
    fun onConnectionStateChanged(state: Int, reason: Int) {
        sendEvent("onConnectionStateChanged", hashMapOf("state" to state, "reason" to reason))
    }

    override
    fun onMessageReceived(message: RtmMessage, peerId: String) {
        sendEvent(
            "onMessageReceived", hashMapOf(
                "peerId" to peerId,
                "message" to hashMapOf(
                    "text" to message.text,
                    "offline" to message.isOfflineMessage,
                    "ts" to message.serverReceivedTs
                )
            )
        )
    }

    override
    fun onTokenExpired() {
        sendEvent("onTokenExpired", hashMapOf())
    }

    override fun onTokenPrivilegeWillExpire() {
        sendEvent("onTokenPrivilegeWillExpire", hashMapOf())
    }

    override
    fun onPeersOnlineStatusChanged(p0: MutableMap<String, Int>) {

    }
}
