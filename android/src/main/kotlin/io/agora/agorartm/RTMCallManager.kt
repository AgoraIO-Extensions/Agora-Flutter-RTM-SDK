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
    client: RtmClient,
    clientIndex: Long,
    messenger: BinaryMessenger,
    private val handler: Handler
) : RtmCallEventListener, EventChannel.StreamHandler {
    private val eventChannel: EventChannel =
        EventChannel(messenger, "io.agora.rtm.client${clientIndex}.call_manager")
    private var eventSink: EventChannel.EventSink? = null

    val manager: RtmCallManager
    val remoteInvitations: MutableMap<Int?, RemoteInvitation> = HashMap()
    val localInvitations: MutableMap<Int?, LocalInvitation> = HashMap()

    init {
        this.eventChannel.setStreamHandler(this)

        manager = client.rtmCallManager
        manager.setEventListener(this)
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
        localInvitations.remove(localInvitation.hashCode())
        sendEvent(
            "onLocalInvitationAccepted", hashMapOf(
                "localInvitation" to localInvitation.toJson(),
                "response" to response,
            )
        )
    }

    override
    fun onLocalInvitationRefused(localInvitation: LocalInvitation, response: String) {
        localInvitations.remove(localInvitation.hashCode())
        sendEvent(
            "onLocalInvitationRefused", hashMapOf(
                "localInvitation" to localInvitation.toJson(),
                "response" to response,
            )
        )
    }

    override
    fun onLocalInvitationCanceled(localInvitation: LocalInvitation) {
        localInvitations.remove(localInvitation.hashCode())
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
        sendEvent(
            "onRemoteInvitationFailure", hashMapOf(
                "remoteInvitation" to remoteInvitation.toJson(),
                "errorCode" to errorCode,
            )
        )
    }
}
