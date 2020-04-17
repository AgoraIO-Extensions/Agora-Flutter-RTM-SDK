package io.agora.agorartm

import android.content.Context
import android.os.Handler
import io.agora.rtm.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class RTMClient : RtmClientListener, EventChannel.StreamHandler, RtmCallEventListener {

    val messenger: BinaryMessenger
    val eventChannel: EventChannel
    val appId: String
    val clientIndex: Long
    val client: RtmClient
    val callKit: RtmCallManager
    val eventHandler: Handler

    var channels: HashMap<String, RtmChannel>
    var eventSink: EventChannel.EventSink?
    var remoteInvitations: MutableMap<String, RemoteInvitation>
    var localInvitations: MutableMap<String, LocalInvitation>


    constructor(context: Context, appId: String, clientIndex: Long, messenger: BinaryMessenger, eventHandler: Handler) {
        this.appId = appId
        this.clientIndex = clientIndex
        this.messenger = messenger
        this.client = RtmClient.createInstance(context, this.appId, this)
        this.channels = HashMap<String, RtmChannel>()
        this.remoteInvitations = HashMap<String, RemoteInvitation>()
        this.localInvitations = HashMap<String, LocalInvitation>()
        this.eventChannel = EventChannel(this.messenger, "io.agora.rtm.client${clientIndex}")
        this.eventChannel.setStreamHandler(this)
        this.eventSink = null

        this.callKit = client.getRtmCallManager()
        this.callKit.setEventListener(this)
        this.eventHandler = eventHandler
    }

    private fun runMainThread(f: () -> Unit) {
        eventHandler.post(f)
    }


    private fun sendClientEvent(eventName: String, params: HashMap<Any, Any>) {
        var map = params.toMutableMap()
        map["event"] = eventName
        runMainThread {
            this.eventSink?.success(map)
        }
    }


    override
    fun onLocalInvitationReceivedByPeer(localInvitation: LocalInvitation) {
        localInvitations[localInvitation.calleeId] = localInvitation
        sendClientEvent("onLocalInvitationReceivedByPeer", hashMapOf(
                "localInvitation" to hashMapOf(
                        "calleeId" to localInvitation.calleeId,
                        "content" to localInvitation.content,
                        "channelId" to localInvitation.channelId,
                        "state" to localInvitation.state,
                        "response" to localInvitation.response
                )
        ))
    }

    override
    fun onLocalInvitationAccepted(localInvitation: LocalInvitation, response: String) {
        sendClientEvent("onLocalInvitationAccepted", hashMapOf(
                "localInvitation" to hashMapOf(
                        "calleeId" to localInvitation.calleeId,
                        "content" to localInvitation.content,
                        "channelId" to localInvitation.channelId,
                        "state" to localInvitation.state,
                        "response" to localInvitation.response
                )
        ))
    }

    override
    fun onLocalInvitationRefused(localInvitation: LocalInvitation, response: String) {
        sendClientEvent("onLocalInvitationRefused", hashMapOf(
                "localInvitation" to hashMapOf(
                        "calleeId" to localInvitation.calleeId,
                        "content" to localInvitation.content,
                        "channelId" to localInvitation.channelId,
                        "state" to localInvitation.state,
                        "response" to localInvitation.response
                )
        ))
    }

    override
    fun onLocalInvitationCanceled(localInvitation: LocalInvitation) {
        sendClientEvent("onLocalInvitationCanceled", hashMapOf(
                "localInvitation" to hashMapOf(
                        "calleeId" to localInvitation.calleeId,
                        "content" to localInvitation.content,
                        "channelId" to localInvitation.channelId,
                        "state" to localInvitation.state,
                        "response" to localInvitation.response
                )
        ))
    }

    override
    fun onLocalInvitationFailure(localInvitation: LocalInvitation, errorCode: Int) {
        sendClientEvent("onLocalInvitationFailure", hashMapOf(
                "errorCode" to errorCode,
                "localInvitation" to hashMapOf(
                        "calleeId" to localInvitation.calleeId,
                        "content" to localInvitation.content,
                        "channelId" to localInvitation.channelId,
                        "state" to localInvitation.state,
                        "response" to localInvitation.response
                )
        ))
    }

    override
    fun onRemoteInvitationReceived(remoteInvitation: RemoteInvitation) {
        remoteInvitations[remoteInvitation.callerId] = remoteInvitation
        sendClientEvent("onRemoteInvitationReceivedByPeer", hashMapOf(
                "remoteInvitation" to hashMapOf(
                        "callerId" to remoteInvitation.callerId,
                        "content" to remoteInvitation.content,
                        "channelId" to remoteInvitation.channelId,
                        "state" to remoteInvitation.state,
                        "response" to remoteInvitation.response
                )
        ))
    }

    override
    fun onRemoteInvitationAccepted(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.callerId)
        sendClientEvent("onRemoteInvitationAccepted", hashMapOf(
                "remoteInvitation" to hashMapOf(
                        "callerId" to remoteInvitation.callerId,
                        "content" to remoteInvitation.content,
                        "channelId" to remoteInvitation.channelId,
                        "state" to remoteInvitation.state,
                        "response" to remoteInvitation.response
                )
        ))
    }

    override
    fun onRemoteInvitationRefused(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.callerId)
        sendClientEvent("onRemoteInvitationRefused", hashMapOf(
                "remoteInvitation" to hashMapOf(
                        "callerId" to remoteInvitation.callerId,
                        "content" to remoteInvitation.content,
                        "channelId" to remoteInvitation.channelId,
                        "state" to remoteInvitation.state,
                        "response" to remoteInvitation.response
                )
        ))
    }

    override
    fun onRemoteInvitationCanceled(remoteInvitation: RemoteInvitation) {
        remoteInvitations.remove(remoteInvitation.callerId)
        sendClientEvent("onRemoteInvitationCanceled", hashMapOf(
                "remoteInvitation" to hashMapOf(
                        "callerId" to remoteInvitation.callerId,
                        "content" to remoteInvitation.content,
                        "channelId" to remoteInvitation.channelId,
                        "state" to remoteInvitation.state,
                        "response" to remoteInvitation.response
                )
        ))
    }

    override
    fun onRemoteInvitationFailure(remoteInvitation: RemoteInvitation, errorCode: Int) {
        remoteInvitations.remove(remoteInvitation.callerId)
        sendClientEvent("onRemoteInvitationFailure", hashMapOf(
                "errorCode" to errorCode,
                "remoteInvitation" to hashMapOf(
                        "callerId" to remoteInvitation.callerId,
                        "content" to remoteInvitation.content,
                        "channelId" to remoteInvitation.channelId,
                        "state" to remoteInvitation.state,
                        "response" to remoteInvitation.response
                )
        ))
    }

    override
    fun onConnectionStateChanged(state: Int, reason: Int) {
        sendClientEvent("onConnectionStateChanged", hashMapOf("state" to state, "reason" to reason))
    }

    override
    fun onMessageReceived(message: RtmMessage, peerId: String) {
        sendClientEvent("onMessageReceived", hashMapOf("peerId" to peerId,
                "message" to hashMapOf(
                        "text" to message.text,
                        "offline" to message.isOfflineMessage,
                        "ts" to message.serverReceivedTs
                )))
    }

    override
    fun onTokenExpired() {
        sendClientEvent("onTokenExpired", hashMapOf())
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
    fun onPeersOnlineStatusChanged(p0: MutableMap<String, Int>) {

    }
}