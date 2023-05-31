package io.agora.agorartm

import android.os.Handler
import io.agora.rtm.LocalInvitation
import io.agora.rtm.RemoteInvitation
import io.agora.rtm.RtmCallEventListener
import io.agora.rtm.RtmCallManager
import io.agora.rtm.RtmClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMCallManager(
    clientIndex: Long,
    client: RtmClient,
    private val messenger: BinaryMessenger,
    private val eventHandler: Handler
) : RtmCallEventListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink?

    val manager: RtmCallManager
    val remoteInvitations: MutableMap<Int?, RemoteInvitation> = HashMap()
    val localInvitations: MutableMap<Int?, LocalInvitation> = HashMap()

    init {
        this.eventChannel =
            EventChannel(this.messenger, "io.agora.rtm.client${clientIndex}.call_manager")
        this.eventChannel.setStreamHandler(this)
        this.eventSink = null

        manager = client.rtmCallManager
        manager.setEventListener(this)
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

    override
    fun onLocalInvitationReceivedByPeer(localInvitation: LocalInvitation) {
        localInvitations[localInvitation.hashCode()] = localInvitation
        sendEvent(
            "onLocalInvitationReceivedByPeer", hashMapOf(
                "localInvitation" to localInvitation.toJson()
            )
        )
    }

    override
    fun onLocalInvitationAccepted(localInvitation: LocalInvitation, response: String) {
        sendEvent(
            "onLocalInvitationAccepted", hashMapOf(
                "localInvitation" to localInvitation.toJson(),
                "response" to response,
            )
        )
    }

    override
    fun onLocalInvitationRefused(localInvitation: LocalInvitation, response: String) {
        sendEvent(
            "onLocalInvitationRefused", hashMapOf(
                "localInvitation" to localInvitation.toJson(),
                "response" to response,
            )
        )
    }

    override
    fun onLocalInvitationCanceled(localInvitation: LocalInvitation) {
        sendEvent(
            "onLocalInvitationCanceled", hashMapOf(
                "localInvitation" to localInvitation.toJson()
            )
        )
    }

    override
    fun onLocalInvitationFailure(localInvitation: LocalInvitation, errorCode: Int) {
        sendEvent(
            "onLocalInvitationFailure", hashMapOf(
                "localInvitation" to localInvitation.toJson(),
                "errorCode" to errorCode,
            )
        )
    }

    override
    fun onRemoteInvitationReceived(remoteInvitation: RemoteInvitation) {
        remoteInvitations[remoteInvitation.hashCode()] = remoteInvitation
        sendEvent(
            "onRemoteInvitationReceived", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson()
            )
        )
    }

    override
    fun onRemoteInvitationAccepted(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.hashCode())
        sendEvent(
            "onRemoteInvitationAccepted", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson()
            )
        )
    }

    override
    fun onRemoteInvitationRefused(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.hashCode())
        sendEvent(
            "onRemoteInvitationRefused", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson()
            )
        )
    }

    override
    fun onRemoteInvitationCanceled(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.hashCode())
        sendEvent(
            "onRemoteInvitationCanceled", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson()
            )
        )
    }

    override
    fun onRemoteInvitationFailure(remoteInvitation: RemoteInvitation, errorCode: Int) {
        remoteInvitations.remove(remoteInvitation.hashCode())
        sendEvent(
            "onRemoteInvitationFailure", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson(),
                "errorCode" to errorCode,
            )
        )
    }
}
