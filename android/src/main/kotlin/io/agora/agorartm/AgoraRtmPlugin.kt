package io.agora.agorartm

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.agora.rtm.ErrorInfo
import io.agora.rtm.LocalInvitation
import io.agora.rtm.PeerOnlineState
import io.agora.rtm.RtmAttribute
import io.agora.rtm.RtmChannelAttribute
import io.agora.rtm.RtmChannelMember
import io.agora.rtm.RtmChannelMemberCount
import io.agora.rtm.RtmClient
import io.agora.rtm.RtmStatusCode.JoinChannelError.JOIN_CHANNEL_ERR_NOT_INITIALIZED
import io.agora.rtm.RtmStatusCode.LoginError.LOGIN_ERR_NOT_INITIALIZED
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
        agoraClient?.call?.manager?.let { callManager ->
            val args = params?.get("args") as? Map<*, *>
            when (methodName) {
                "createLocalInvitation" -> {
                    val calleeId = args?.get("calleeId") as? String
                    val localInvitation = callManager.createLocalInvitation(calleeId)
                    object : Callback<LocalInvitation>(result, handler) {
                        override fun toJson(responseInfo: LocalInvitation): Any {
                            agoraClient.call.localInvitations[responseInfo.hashCode()] =
                                responseInfo
                            return responseInfo.toJson()
                        }
                    }.onSuccess(localInvitation)
                }

                "sendLocalInvitation" -> {
                    val localInvitation =
                        (args?.get("localInvitation") as? Map<*, *>)?.toLocalInvitation(agoraClient.call)
                    callManager.sendLocalInvitation(
                        localInvitation,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "acceptRemoteInvitation" -> {
                    val remoteInvitation =
                        (args?.get("remoteInvitation") as? Map<*, *>)?.toRemoteInvitation(
                            agoraClient.call
                        )
                    callManager.acceptRemoteInvitation(
                        remoteInvitation,
                        object : Callback<Void>(result, handler) {
                            override fun toJson(responseInfo: Void): Any? {
                                agoraClient.call.remoteInvitations.remove(remoteInvitation.hashCode())
                                return null
                            }
                        },
                    )
                }

                "refuseRemoteInvitation" -> {
                    val remoteInvitation =
                        (args?.get("remoteInvitation") as? Map<*, *>)?.toRemoteInvitation(
                            agoraClient.call
                        )
                    callManager.refuseRemoteInvitation(
                        remoteInvitation,
                        object : Callback<Void>(result, handler) {
                            override fun toJson(responseInfo: Void): Any? {
                                agoraClient.call.remoteInvitations.remove(remoteInvitation.hashCode())
                                return null
                            }
                        },
                    )
                }

                "cancelLocalInvitation" -> {
                    val localInvitation =
                        (args?.get("localInvitation") as? Map<*, *>)?.toLocalInvitation(agoraClient.call)
                    callManager.cancelLocalInvitation(
                        localInvitation,
                        object : Callback<Void>(result, handler) {
                            override fun toJson(responseInfo: Void): Any? {
                                agoraClient.call.localInvitations.remove(localInvitation.hashCode())
                                return null
                            }
                        },
                    )
                }

                else -> {
                    result.notImplemented()
                }
            }
        } ?: run {
            object : Callback<Void>(result, handler) {}.onFailure(
                ErrorInfo(
                    LOGIN_ERR_NOT_INITIALIZED
                )
            )
        }
    }

    private fun handleStaticMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        when (methodName) {
            "createInstance" -> {
                while (clients[nextClientIndex] != null) {
                    nextClientIndex++
                }
                val appId = params?.get("appId") as? String
                val rtmClient = RTMClient(
                    applicationContext,
                    appId,
                    nextClientIndex,
                    registrar?.messenger() ?: binding!!.binaryMessenger,
                    handler
                )
                object : Callback<Long>(result, handler) {}.onSuccess(nextClientIndex)
                clients[nextClientIndex] = rtmClient
                nextClientIndex++
            }

            "getSdkVersion" -> {
                object : Callback<String>(result, handler) {}.onSuccess(RtmClient.getSdkVersion())
            }

            "setRtmServiceContext" -> {
                val context = (params?.get("context") as? Map<*, *>)?.toRtmServiceContext()
                val ret = RtmClient.setRtmServiceContext(context)
                if (ret.swigValue() == 0) {
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                } else {
                    object : Callback<Void>(result, handler) {}.onFailure(
                        ErrorInfo(
                            ret.swigValue(),
                            ret.toString(),
                        )
                    )
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleClientMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        val clientIndex = (params?.get("clientIndex") as? Int)?.toLong()
        val agoraClient = clients[clientIndex]
        agoraClient?.client?.let { client ->
            val args = params?.get("args") as? Map<*, *>
            when (methodName) {
                "release" -> {
                    agoraClient.channels.values.forEach { it.release() }
                    agoraClient.channels.clear()
                    clients.remove(clientIndex)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                "login" -> {
                    val token = args?.get("token") as? String
                    val userId = args?.get("userId") as? String
                    client.login(token, userId, object : Callback<Void>(result, handler) {})
                }

                "logout" -> {
                    client.logout(object : Callback<Void>(result, handler) {})
                }

                "sendMessageToPeer" -> {
                    val peerId = args?.get("peerId") as? String
                    val message = (args?.get("message") as? Map<*, *>)?.toRtmMessage(client)
                    val options = (args?.get("options") as? Map<*, *>)?.toSendMessageOptions()
                    client.sendMessageToPeer(
                        peerId,
                        message,
                        options,
                        object : Callback<Void>(result, handler) {},
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
                    client.createChannel(channelId, agoraRtmChannel)?.let {
                        agoraClient.channels[channelId] = it
                        object : Callback<Void>(result, handler) {}.onSuccess(null)
                    } ?: let {
                        object : Callback<Void>(result, handler) {}.onFailure(
                            ErrorInfo(
                                JOIN_CHANNEL_ERR_NOT_INITIALIZED
                            )
                        )
                    }
                }

                "queryPeersOnlineStatus" -> {
                    val peerIds = (args?.get("peerIds") as? ArrayList<*>)?.toStringSet()
                    client.queryPeersOnlineStatus(
                        peerIds,
                        object : Callback<Map<String, Boolean>>(result, handler) {
                            override fun toJson(responseInfo: Map<String, Boolean>): Any {
                                return responseInfo.entries.associate {
                                    it.key to if (it.value) PeerOnlineState.ONLINE else PeerOnlineState.OFFLINE
                                }
                            }
                        },
                    )
                }

                "subscribePeersOnlineStatus" -> {
                    val peerIds = (args?.get("peerIds") as? ArrayList<*>)?.toStringSet()
                    client.subscribePeersOnlineStatus(
                        peerIds,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "unsubscribePeersOnlineStatus" -> {
                    val peerIds = (args?.get("peerIds") as? ArrayList<*>)?.toStringSet()
                    client.unsubscribePeersOnlineStatus(
                        peerIds,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "queryPeersBySubscriptionOption" -> {
                    val option = args?.get("option") as? Int
                    client.queryPeersBySubscriptionOption(
                        option,
                        object : Callback<Set<String>>(result, handler) {
                            override fun toJson(responseInfo: Set<String>): Any {
                                return responseInfo.toList()
                            }
                        },
                    )
                }

                "renewToken" -> {
                    val token = args?.get("token") as? String
                    client.renewToken(token, object : Callback<Void>(result, handler) {})
                }

                "setLocalUserAttributes" -> {
                    val attributes = (args?.get("attributes") as? List<*>)?.toRtmAttributeList()
                    client.setLocalUserAttributes(
                        attributes,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "addOrUpdateLocalUserAttributes" -> {
                    val attributes = (args?.get("attributes") as? List<*>)?.toRtmAttributeList()
                    client.addOrUpdateLocalUserAttributes(
                        attributes,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "deleteLocalUserAttributesByKeys" -> {
                    val attributeKeys = (args?.get("attributeKeys") as? List<*>)?.toStringList()
                    client.deleteLocalUserAttributesByKeys(
                        attributeKeys,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "clearLocalUserAttributes" -> {
                    client.clearLocalUserAttributes(object : Callback<Void>(result, handler) {})
                }

                "getUserAttributes" -> {
                    val userId = args?.get("userId") as? String
                    client.getUserAttributes(
                        userId,
                        object : Callback<List<RtmAttribute>>(result, handler) {
                            override fun toJson(responseInfo: List<RtmAttribute>): Any {
                                return responseInfo.toJson()
                            }
                        },
                    )
                }

                "getUserAttributesByKeys" -> {
                    val userId = args?.get("userId") as? String
                    val attributeKeys = (args?.get("attributeKeys") as? List<*>)?.toStringList()
                    client.getUserAttributesByKeys(
                        userId,
                        attributeKeys,
                        object : Callback<List<RtmAttribute>>(result, handler) {
                            override fun toJson(responseInfo: List<RtmAttribute>): Any {
                                return responseInfo.toJson()
                            }
                        },
                    )
                }

                "setChannelAttributes" -> {
                    val channelId = args?.get("channelId") as? String
                    val attributes =
                        (args?.get("attributes") as? List<*>)?.toRtmChannelAttributeList()
                    val option = (args?.get("option") as? Map<*, *>)?.toChannelAttributeOptions()
                    client.setChannelAttributes(
                        channelId,
                        attributes,
                        option,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "addOrUpdateChannelAttributes" -> {
                    val channelId = args?.get("channelId") as? String
                    val attributes =
                        (args?.get("attributes") as? List<*>)?.toRtmChannelAttributeList()
                    val option = (args?.get("option") as? Map<*, *>)?.toChannelAttributeOptions()
                    client.addOrUpdateChannelAttributes(
                        channelId,
                        attributes,
                        option,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "deleteChannelAttributesByKeys" -> {
                    val channelId = args?.get("channelId") as? String
                    val attributeKeys = (args?.get("attributeKeys") as? List<*>)?.toStringList()
                    val option = (args?.get("option") as? Map<*, *>)?.toChannelAttributeOptions()
                    client.deleteChannelAttributesByKeys(
                        channelId,
                        attributeKeys,
                        option,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "clearChannelAttributes" -> {
                    val channelId = args?.get("channelId") as? String
                    val option = (args?.get("option") as? Map<*, *>)?.toChannelAttributeOptions()
                    client.clearChannelAttributes(
                        channelId,
                        option,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "getChannelAttributes" -> {
                    val channelId = args?.get("channelId") as? String
                    client.getChannelAttributes(
                        channelId,
                        object : Callback<List<RtmChannelAttribute>>(result, handler) {
                            override fun toJson(responseInfo: List<RtmChannelAttribute>): Any {
                                return responseInfo.toJson()
                            }
                        },
                    )
                }

                "getChannelAttributesByKeys" -> {
                    val channelId = args?.get("channelId") as? String
                    val attributeKeys = (args?.get("attributeKeys") as? List<*>)?.toStringList()
                    client.getChannelAttributesByKeys(
                        channelId,
                        attributeKeys,
                        object : Callback<List<RtmChannelAttribute>>(result, handler) {
                            override fun toJson(responseInfo: List<RtmChannelAttribute>): Any {
                                return responseInfo.toJson()
                            }
                        },
                    )
                }

                "getChannelMemberCount" -> {
                    val channelIds = (args?.get("channelIds") as? List<*>)?.toStringList()
                    client.getChannelMemberCount(
                        channelIds,
                        object : Callback<List<RtmChannelMemberCount>>(result, handler) {
                            override fun toJson(responseInfo: List<RtmChannelMemberCount>): Any {
                                return responseInfo.toJson()
                            }
                        },
                    )
                }

                "setParameters" -> {
                    val parameters = args?.get("parameters") as? String
                    client.setParameters(parameters)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                "setLogFile" -> {
                    val filePath = args?.get("filePath") as? String
                    client.setLogFile(filePath)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                "setLogFilter" -> {
                    val filter = args?.get("filter") as? Int
                    client.setLogFilter(filter!!)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                "setLogFileSize" -> {
                    val fileSizeInKBytes = args?.get("fileSizeInKBytes") as? Int
                    client.setLogFileSize(fileSizeInKBytes!!)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        } ?: run {
            object : Callback<Void>(result, handler) {}.onFailure(
                ErrorInfo(
                    LOGIN_ERR_NOT_INITIALIZED
                )
            )
        }
    }

    private fun handleChannelMethod(methodName: String?, params: Map<*, *>?, result: Result) {
        val clientIndex = (params?.get("clientIndex") as? Int)?.toLong()
        val channelId = params?.get("channelId") as? String
        val agoraClient = clients[clientIndex]
        agoraClient?.channels?.get(channelId)?.let { channel ->
            val args = params?.get("args") as? Map<*, *>
            when (methodName) {
                "join" -> {
                    channel.join(object : Callback<Void>(result, handler) {})
                }

                "leave" -> {
                    channel.leave(object : Callback<Void>(result, handler) {})
                }

                "sendMessage" -> {
                    val message =
                        (args?.get("message") as? Map<*, *>)?.toRtmMessage(agoraClient.client)
                    val options = (args?.get("options") as? Map<*, *>)?.toSendMessageOptions()
                    channel.sendMessage(
                        message,
                        options,
                        object : Callback<Void>(result, handler) {},
                    )
                }

                "getMembers" -> {
                    channel.getMembers(object : Callback<List<RtmChannelMember>>(result, handler) {
                        override fun toJson(responseInfo: List<RtmChannelMember>): Any {
                            return responseInfo.toJson()
                        }
                    })
                }

                "release" -> {
                    channel.release()
                    agoraClient.channels.remove(channelId)
                    object : Callback<Void>(result, handler) {}.onSuccess(null)
                }

                else -> {
                    result.notImplemented()
                }
            }
        } ?: run {
            object : Callback<Void>(result, handler) {}.onFailure(
                ErrorInfo(
                    JOIN_CHANNEL_ERR_NOT_INITIALIZED
                )
            )
        }
    }
}
