package io.agora.agorartm

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.agora.rtm.ChannelAttributeOptions
import io.agora.rtm.RtmAttribute
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmClient
import io.agora.rtm.SendMessageOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class AgoraRtmPlugin : FlutterPlugin, MethodCallHandler {
    private var registrar: Registrar? = null
    private var binding: FlutterPlugin.FlutterPluginBinding? = null
    private lateinit var applicationContext: Context
    private lateinit var methodChannel: MethodChannel

    private val handler: Handler = Handler(Looper.getMainLooper())
    private var nextClientIndex: Long = 0
    private var clients = HashMap<Long, RTMClient>()

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            AgoraRtmPlugin().apply {
                this.registrar = registrar
                initPlugin(registrar.context(), registrar.messenger())
            }
        }
    }

    private fun initPlugin(
        context: Context, binaryMessenger: BinaryMessenger
    ) {
        applicationContext = context.applicationContext
        methodChannel = MethodChannel(binaryMessenger, "io.agora.rtm")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.binding = binding
        initPlugin(binding.applicationContext, binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    private fun runMainThread(f: () -> Unit) {
        handler.post(f)
    }

    override fun onMethodCall(methodCall: MethodCall, result: Result) {
        val methodName = methodCall.method
        val callArguments = methodCall.arguments as? Map<*, *>
        val caller = callArguments?.get("caller") as? String
        val arguments = callArguments?.get("arguments") as? Map<*, *>
        when (caller) {
            "AgoraRtmClient#static" -> {
                handleStaticMethod(methodName, arguments, result)
            }

            "AgoraRtmClient" -> {
                handleClientMethod(methodName, arguments, result)
            }

            "AgoraRtmChannel" -> {
                handleChannelMethod(methodName, arguments, result)
            }

            "AgoraRtmCallManager" -> {
                handleCallManagerMethod(methodName, arguments, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleCallManagerMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        val clientIndex = (params?.get("clientIndex") as? Int)?.toLong()
        val agoraClient = clients[clientIndex]
        if (agoraClient == null) {
            runMainThread {
                result.success(hashMapOf("errorCode" to -1))
            }
            return
        }

        val args = params?.get("args") as? Map<*, *>
        when (methodName) {
            "sendLocalInvitation" -> {
                val calleeId = args?.get("calleeId") as? String
                val content = args?.get("content") as? String
                val channelId = args?.get("channelId") as? String

                val localInvitation =
                    agoraClient.call.manager.createLocalInvitation(calleeId).apply {
                        this.content = content
                        this.channelId = channelId
                    }

                agoraClient.call.manager.sendLocalInvitation(localInvitation,
                    object : Callback<Void>(result) {
                        override fun toJson(responseInfo: Void): Any {
                            agoraClient.call.localInvitations[localInvitation.calleeId] =
                                localInvitation
                            return Unit
                        }
                    })
            }

            "cancelLocalInvitation" -> {
                val calleeId = args?.get("calleeId") as? String
                val content = args?.get("content") as? String
                val channelId = args?.get("channelId") as? String

                val localInvitation = agoraClient.call.localInvitations[calleeId]?.apply {
                    this.content = content
                    this.channelId = channelId
                }

                if (localInvitation == null) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }

                agoraClient.call.manager.cancelLocalInvitation(localInvitation,
                    object : Callback<Void>(result) {
                        override fun toJson(responseInfo: Void): Any {
                            agoraClient.call.localInvitations.remove(localInvitation.calleeId)
                            return Unit
                        }
                    })
            }

            "acceptRemoteInvitation" -> {
                val response = args?.get("response") as? String
                val callerId = args?.get("callerId") as? String
                val remoteInvitation = agoraClient.call.remoteInvitations[callerId]?.apply {
                    this.response = response
                }

                if (remoteInvitation == null) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }

                agoraClient.call.manager.acceptRemoteInvitation(remoteInvitation,
                    object : Callback<Void>(result) {
                        override fun toJson(responseInfo: Void): Any {
                            agoraClient.call.remoteInvitations.remove(remoteInvitation.callerId)
                            return Unit
                        }
                    })
            }

            "refuseRemoteInvitation" -> {
                val response = args?.get("response") as? String
                val callerId = args?.get("callerId") as? String
                val remoteInvitation = agoraClient.call.remoteInvitations[callerId]?.apply {
                    this.response = response
                }

                if (remoteInvitation == null) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }

                agoraClient.call.manager.refuseRemoteInvitation(remoteInvitation,
                    object : Callback<Void>(result) {
                        override fun toJson(responseInfo: Void): Any {
                            agoraClient.call.remoteInvitations.remove(remoteInvitation.callerId)
                            return Unit
                        }
                    })
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleStaticMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        when (methodName) {
            "createInstance" -> {
                val appId = params?.get("appId") as? String

                if (appId == null) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }

                while (null != clients[nextClientIndex]) {
                    nextClientIndex++
                }

                val rtmClient = RTMClient(
                    applicationContext,
                    appId,
                    nextClientIndex,
                    registrar?.messenger() ?: binding!!.binaryMessenger,
                    handler
                )
                result.success(
                    hashMapOf(
                        "errorCode" to 0,
                        "result" to nextClientIndex,
                    )
                )
                clients[nextClientIndex] = rtmClient
                nextClientIndex++
            }

            "getSdkVersion" -> {
                result.success(
                    hashMapOf(
                        "errorCode" to 0, "result" to RtmClient.getSdkVersion()
                    )
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleClientMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        val clientIndex = (params?.get("clientIndex") as? Int)?.toLong()
        val agoraClient = clients[clientIndex]
        if (agoraClient == null) {
            runMainThread {
                result.success(hashMapOf("errorCode" to -1))
            }
            return
        }

        val client = agoraClient.client
        val args = params?.get("args") as? Map<*, *>
        when (methodName) {
            "release" -> {
                agoraClient.channels.forEach {
                    val pair = it.toPair()
                    pair.second.release()
                }
                agoraClient.channels.clear()
                clients.remove(clientIndex)
                runMainThread {
                    result.success(hashMapOf("errorCode" to 0))
                }
            }

            "login" -> {
                val token = args?.get("token") as? String
                val userId = args?.get("userId") as? String
                client?.login(token, userId, object : Callback<Void>(result) {})
            }

            "logout" -> {
                client?.logout(object : Callback<Void>(result) {})
            }

            "renewToken" -> {
                val token = args?.get("token") as? String
                client?.renewToken(token, object : Callback<Void>(result) {})
            }

            "queryPeersOnlineStatus" -> {
                val peerIds = (args?.get("peerIds") as? ArrayList<*>)?.toSet()
                client?.queryPeersOnlineStatus(peerIds,
                    object : Callback<Map<String, Boolean>>(result) {
                        override fun toJson(responseInfo: Map<String, Boolean>): Any {
                            return responseInfo
                        }
                    })
            }

            "sendMessageToPeer" -> {
                val peerId = args?.get("peerId") as? String
                val text = args?.get("message") as? String
                val message = client?.createMessage(text)
                val options = SendMessageOptions()
                client?.sendMessageToPeer(peerId,
                    message,
                    options,
                    object : Callback<Void>(result) {})
            }

            "setLocalUserAttributes" -> {
                val attributes = args?.get("attributes") as? List<*>
                val localUserAttributes = ArrayList<RtmAttribute>()
                attributes?.forEach {
                    (it as? Map<*, *>)?.let {
                        localUserAttributes.add(RtmAttribute().apply {
                            key = it["key"] as String
                            value = it["value"] as String
                        })
                    }
                }
                client?.setLocalUserAttributes(localUserAttributes,
                    object : Callback<Void>(result) {})
            }

            "addOrUpdateLocalUserAttributes" -> {
                val attributes = args?.get("attributes") as? List<*>
                val localUserAttributes = ArrayList<RtmAttribute>()
                attributes?.forEach {
                    (it as? Map<*, *>)?.let {
                        localUserAttributes.add(RtmAttribute().apply {
                            key = it["key"] as String
                            value = it["value"] as String
                        })
                    }
                }
                client?.addOrUpdateLocalUserAttributes(
                    localUserAttributes,
                    object : Callback<Void>(result) {})
            }

            "deleteLocalUserAttributesByKeys" -> {
                val keys = args?.get("keys") as? List<*>
                client?.deleteLocalUserAttributesByKeys(keys, object : Callback<Void>(result) {})
            }

            "clearLocalUserAttributes" -> {
                client?.clearLocalUserAttributes(object : Callback<Void>(result) {})
            }

            "getUserAttributes" -> {
                val userId = args?.get("userId") as? String
                client?.getUserAttributes(userId, object : Callback<List<RtmAttribute>>(result) {
                    override fun toJson(responseInfo: List<RtmAttribute>): Any {
                        return responseInfo.toJson()
                    }
                })
            }

            "getUserAttributesByKeys" -> {
                val userId = args?.get("userId") as? String
                val keys = args?.get("keys") as? List<*>
                client?.getUserAttributesByKeys(userId, keys,
                    object : Callback<List<RtmAttribute>>(result) {
                        override fun toJson(responseInfo: List<RtmAttribute>): Any {
                            return responseInfo.toJson()
                        }
                    }
                )
            }

            "setChannelAttributes" -> {
                val channelId = args?.get("channelId") as? String
                val enableNotificationToChannelMembers =
                    args?.get("enableNotificationToChannelMembers") as? Boolean
                val attributes = args?.get("attributes") as? List<*>
                val channelAttributes = ArrayList<RtmChannelAttribute>()
                attributes?.forEach {
                    (it as? Map<*, *>)?.let {
                        channelAttributes.add(RtmChannelAttribute().apply {
                            key = it["key"] as String
                            value = it["value"] as String
                        })
                    }
                }
                client?.setChannelAttributes(channelId, channelAttributes,
                    ChannelAttributeOptions(enableNotificationToChannelMembers),
                    object : Callback<Void>(result) {})
            }

            "addOrUpdateChannelAttributes" -> {
                val channelId = args?.get("channelId") as? String
                val enableNotificationToChannelMembers =
                    args?.get("enableNotificationToChannelMembers") as? Boolean
                val attributes = args?.get("attributes") as? List<*>
                val channelAttributes = ArrayList<RtmChannelAttribute>()
                attributes?.forEach {
                    (it as? Map<*, *>)?.let {
                        channelAttributes.add(RtmChannelAttribute().apply {
                            key = it["key"] as String
                            value = it["value"] as String
                        })
                    }
                }
                client?.addOrUpdateChannelAttributes(channelId, channelAttributes,
                    ChannelAttributeOptions(enableNotificationToChannelMembers),
                    object : Callback<Void>(result) {})
            }

            "deleteChannelAttributesByKeys" -> {
                val channelId = args?.get("channelId") as? String
                val enableNotificationToChannelMembers =
                    args?.get("enableNotificationToChannelMembers") as? Boolean
                val keys = args?.get("keys") as? List<*>
                client?.deleteChannelAttributesByKeys(channelId, keys,
                    ChannelAttributeOptions(enableNotificationToChannelMembers),
                    object : Callback<Void>(result) {})
            }

            "clearChannelAttributes" -> {
                val channelId = args?.get("channelId") as? String
                val enableNotificationToChannelMembers =
                    args?.get("enableNotificationToChannelMembers") as? Boolean
                client?.clearChannelAttributes(channelId,
                    ChannelAttributeOptions(enableNotificationToChannelMembers),
                    object : Callback<Void>(result) {})
            }

            "getChannelAttributes" -> {
                val channelId = args?.get("channelId") as? String
                client?.getChannelAttributes(channelId,
                    object : Callback<List<RtmChannelAttribute>>(result) {
                        override fun toJson(responseInfo: List<RtmChannelAttribute>): Any {
                            return responseInfo.toJson()
                        }
                    })
            }

            "getChannelAttributesByKeys" -> {
                val channelId = args?.get("channelId") as? String
                val keys = args?.get("keys") as? List<*>
                client?.getChannelAttributesByKeys(channelId, keys,
                    object : Callback<List<RtmChannelAttribute>>(result) {
                        override fun toJson(responseInfo: List<RtmChannelAttribute>): Any {
                            return responseInfo.toJson()
                        }
                    }
                )
            }

            "createChannel" -> {
                val channelId = args?.get("channelId") as? String
                val agoraRtmChannel = RTMChannel(
                    clientIndex,
                    channelId,
                    registrar?.messenger() ?: binding!!.binaryMessenger,
                    handler
                )
                val channel = client?.createChannel(channelId, agoraRtmChannel)
                if (null == channel) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }
                agoraClient.channels[channelId] = channel
                runMainThread {
                    result.success(hashMapOf("errorCode" to 0))
                }
            }

            "releaseChannel" -> {
                val channelId = args?.get("channelId") as? String
                val rtmChannel = agoraClient.channels[channelId]
                if (null == rtmChannel) {
                    runMainThread {
                        result.success(hashMapOf("errorCode" to -1))
                    }
                    return
                }
                rtmChannel.release()
                agoraClient.channels.remove(channelId)
                runMainThread {
                    result.success(hashMapOf("errorCode" to 0))
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleChannelMethod(
        methodName: String?, params: Map<*, *>?, result: Result
    ) {
        val clientIndex = (params?.get("clientIndex") as? Int)?.toLong()
        val agoraClient = clients[clientIndex]
        if (null == agoraClient) {
            runMainThread {
                result.success(hashMapOf("errorCode" to -1))
            }
            return
        }

        val client = agoraClient.client
        if (null == client) {
            runMainThread {
                result.success(hashMapOf("errorCode" to -1))
            }
            return
        }

        val channelId = params?.get("channelId") as? String
        val rtmChannel = agoraClient.channels[channelId]
        if (null == rtmChannel) {
            runMainThread {
                result.success(hashMapOf("errorCode" to -1))
            }
            return
        }

        val args = params?.get("args") as? Map<*, *>
        when (methodName) {
            "join" -> {
                rtmChannel.join(object : Callback<Void>(result) {})
            }

            "sendMessage" -> {
                val message = client.createMessage().apply {
                    text = args?.get("message") as? String
                }
                val options = SendMessageOptions()
                rtmChannel.sendMessage(message, options, object : Callback<Void>(result) {})
            }

            "leave" -> {
                rtmChannel.leave(object : Callback<Void>(result) {})
            }

            "getMembers" -> {
                rtmChannel.getMembers(object : Callback<List<RtmChannelMember>>(result) {
                    override fun toJson(responseInfo: List<RtmChannelMember>): Any {
                        return responseInfo.toJson()
                    }
                })
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
