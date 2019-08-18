package io.agora.agorartm

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.agora.agora_rtm.RTMChannel
import io.agora.agora_rtm.RTMClient
import io.agora.rtm.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

class AgoraRtmPlugin: MethodCallHandler {
  private val registrar: Registrar
  private val methodChannel: MethodChannel
  private val eventHandler: Handler
  private var nextClientIndex: Long = 0
  private var clients = HashMap<Long, RTMClient>()

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "io.agora.rtm")
      val plugin = AgoraRtmPlugin(registrar, channel)
      channel.setMethodCallHandler(plugin)
    }
  }

  constructor(registrar: Registrar, channel: MethodChannel) {
    this.registrar = registrar
    this.methodChannel = channel
    this.eventHandler = Handler(Looper.getMainLooper())
  }

  private fun getActiveContext(): Context {
    return when {
      (registrar.activity() == null) -> registrar.context()
      else -> registrar.activity()
    }
  }

  private fun runMainThread(f: () -> Unit) {
    eventHandler.post(f)
  }

  override fun onMethodCall(methodCall: MethodCall, result: Result) {
    val methodName: String? = when {
      methodCall.method is String -> methodCall.method as String
      else -> null
    }
    val callArguments: Map<String, Any>? = when {
      methodCall.arguments is Map<*, *> -> methodCall.arguments as Map<String, Any>
      else -> null
    }
    val call: String? = when {
      callArguments!!.get("call") is String -> callArguments!!.get("call") as String
      else -> null
    }

    var params: Map<String, Any> = callArguments["params"] as Map<String, Any>

    when (call) {
      "static" -> {
        handleStaticMethod(methodName, params, result)
      }
      "AgoraRtmClient" -> {
        handleClientMethod(methodName, params, result)
      }
      "AgoraRtmChannel" -> {
        handleChannelMethod(methodName, params, result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun handleStaticMethod(methodName: String?, params: Map<String, Any>, result: MethodChannel.Result) {
    when (methodName) {
      "createInstance" -> {
        val appId: String = params["appId"] as String
        val rtmClient = RTMClient(getActiveContext(), appId, nextClientIndex, registrar.messenger(), eventHandler)
        result.success(hashMapOf(
                "errorCode" to 0,
                "index" to nextClientIndex
        ))
        clients[nextClientIndex] = rtmClient
        nextClientIndex++
      }
      "getSdkVersion" -> {
        result.success(hashMapOf(
                "errorCode" to 0,
                "version" to RtmClient.getSdkVersion()
        ))
      }
      else -> {
        result.notImplemented();
      }
    }
  }

  private fun handleClientMethod(methodName: String?, params: Map<String, Any>, result: Result) {

    val clientIndex = (params["clientIndex"] as Int).toLong()
    var args: Map<String, Any>? = when {
      (params?.get("args") is Map<*,*>) -> (params["args"] as Map<String, Any>)
      else -> null
    }
    val agoraClient = clients[clientIndex] as RTMClient
    if (null == agoraClient) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }
    var client = when {
      agoraClient!!.client != null -> agoraClient!!.client
      else -> {
        runMainThread { result.success(hashMapOf("errorCode" to -1)) }
        return
      }
    }

    when (methodName) {
      "destroy" -> {
        agoraClient.channels.forEach{
          val pair = it.toPair()
          pair.second.release()
        }
        agoraClient.channels.clear()
        clients.remove(clientIndex)
        result.success(hashMapOf("errorCode" to 0))
      }
      "login" -> {
        var token = args?.get("token")

        token = when {
          (token is String) -> token as String
          else -> null
        }

        var userId = args?.get("userId")

        userId = when {
          (userId is String) -> userId as String
          else -> null
        }

        client.login(
                token,
                userId,
                object: ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to 0))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "logout" -> {
        client.logout(
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to 0))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "renewToken" -> {
        var token = args?.get("token")

        token = when {
          (token is String) -> token as String
          else -> null
        }

        client.renewToken(
                token,
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to 0))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "queryPeersOnlineStatus" -> {
        var peerIds: Set<String>? = (args?.get("peerIds") as ArrayList<String>).toSet()

        client.queryPeersOnlineStatus(peerIds,
          object : ResultCallback<MutableMap<String, Boolean>> {
            override fun onSuccess(resp: MutableMap<String, Boolean>) {
              runMainThread {
                result.success(hashMapOf(
                        "errorCode" to 0,
                        "results" to resp
                ))
              }
            }
            override fun onFailure(code: ErrorInfo) {
              runMainThread {
                result.success(hashMapOf("errorCode" to code.getErrorCode()))
              }
            }
          }
        )
      }
      "sendMessageToPeer" -> {
        var peerId: String? = args?.get("peerId") as String
        var text = args?.get("message") as String
        val message = client.createMessage()
        message.text = text
        client.sendMessageToPeer(peerId,
                message,
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "setLocalUserAttributes" -> {
        val attributes: List<Map<String, String>>? = args?.get("attributes") as List<Map<String, String>>
        var localUserAttributes = ArrayList<RtmAttribute>()
        attributes!!.forEach {
          var rtmAttribute = RtmAttribute()
          rtmAttribute.key = it["key"]
          rtmAttribute.value = it["value"]
          localUserAttributes.add(rtmAttribute)
        }
        client.setLocalUserAttributes(localUserAttributes,
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "addOrUpdateLocalUserAttributes" -> {
        val attributes: List<Map<String, String>>? = args?.get("attributes") as List<Map<String, String>>
        var localUserAttributes = ArrayList<RtmAttribute>()
        attributes!!.forEach {
          var rtmAttribute = RtmAttribute()
          rtmAttribute.key = it["key"]
          rtmAttribute.value = it["value"]
          localUserAttributes.add(rtmAttribute)
        }
        client.addOrUpdateLocalUserAttributes(localUserAttributes,
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "deleteLocalUserAttributesByKeys" -> {
        val keys: List<String>? = args?.get("keys") as List<String>
        client.deleteLocalUserAttributesByKeys(keys,
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "clearLocalUserAttributes" -> {
        client.clearLocalUserAttributes(
                object : ResultCallback<Void> {
                  override fun onSuccess(resp: Void?) {
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                }
        )
      }
      "getUserAttributes" -> {
        val userId: String? = args?.get("userId") as String
        client.getUserAttributes(userId,
          object : ResultCallback<List<RtmAttribute>> {
            override fun onSuccess(resp: List<RtmAttribute>) {
              var attributes: MutableMap<String, String> = HashMap<String, String>()
              resp.map {
                attributes[it.key] = it.value
              }
              runMainThread {
                result.success(hashMapOf(
                        "errorCode" to 0,
                        "attributes" to attributes
                ))
              }
            }
            override fun onFailure(code: ErrorInfo) {
              runMainThread {
                result.success(hashMapOf("errorCode" to code.getErrorCode()))
              }
            }
          })
      }
      "getUserAttributesByKeys" -> {
        val userId: String? = args?.get("userId") as String
        var keys: List<String>? = args?.get("keys") as List<String>
        client.getUserAttributesByKeys(userId,
                keys,
                object : ResultCallback<List<RtmAttribute>> {
                  override fun onSuccess(resp: List<RtmAttribute>) {
                    var attributes: MutableMap<String, String> = HashMap<String, String>()
                    resp.map {
                      attributes[it.key] = it.value
                    }
                    runMainThread {
                      result.success(hashMapOf(
                              "errorCode" to 0,
                              "attributes" to attributes
                      ))
                    }
                  }
                  override fun onFailure(code: ErrorInfo) {
                    runMainThread {
                      result.success(hashMapOf("errorCode" to code.getErrorCode()))
                    }
                  }
                })
      }
      "sendLocalInvitation" -> {
        val calleeId = args?.get("calleeId") as String
        val content = args?.get("content") as String
        val channelId = args?.get("channelId") as String
        val localInvitation = agoraClient.callKit.createLocalInvitation(calleeId)
        localInvitation.content = content
        localInvitation.channelId = channelId
        agoraClient.callKit.sendLocalInvitation(localInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "cancelLocalInvitation" -> {
        val calleeId = args?.get("calleeId") as String
        val content = args?.get("content") as String
        val channelId = args?.get("channelId") as String
        val localInvitation = agoraClient.callKit.createLocalInvitation(calleeId)
        localInvitation.content = content
        localInvitation.channelId = channelId
        agoraClient.callKit.cancelLocalInvitation(localInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "acceptRemoteInvitation" -> {
        val response = args?.get("response") as String
        val callerId = args?.get("callerId") as String
        var remoteInvitation = agoraClient.remoteInvitations[callerId]
        if (null == remoteInvitation) {
          runMainThread {
            result.success(hashMapOf(
                    "errorCode" to -1
            ))
          }
          return
        }
        remoteInvitation!!.response = response
        agoraClient.callKit.acceptRemoteInvitation(remoteInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "refuseRemoteInvitation" -> {
        val response = args?.get("response") as String
        val callerId = args?.get("callerId") as String
        var remoteInvitation = agoraClient.remoteInvitations[callerId]
        if (null == remoteInvitation) {
          runMainThread {
            result.success(hashMapOf(
                    "errorCode" to -1
            ))
          }
          return
        }
        remoteInvitation!!.response = response
        agoraClient.callKit.refuseRemoteInvitation(remoteInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "createChannel" -> {
        val channelId = args?.get("channelId") as String
        val agoraRtmChannel = RTMChannel(clientIndex, channelId, registrar.messenger(), eventHandler)
        val channel: RtmChannel? = client.createChannel(channelId, agoraRtmChannel)
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
        val channelId = args?.get("channelId") as String
        val rtmChannel = agoraClient.channels[channelId]
        if (null == rtmChannel) {
          runMainThread {
            result.success(hashMapOf("errorCode" to -1))
          }
          return
        }
        rtmChannel!!.release()
        agoraClient.channels.remove(channelId)
        runMainThread {
          result.success(hashMapOf("errorCode" to 0))
        }
      }
      else -> {
        result.notImplemented();
      }
    }
  }

  private fun handleChannelMethod(methodName: String?, params: Map<String, Any>, result: MethodChannel.Result) {

    val _clientIndex = (params["clientIndex"] as Int).toLong()
    val _channelId = params["channelId"] as String
    var args: Map<String, Any>? = when {
      (params?.get("args") is Map<*,*>) -> params["args"] as Map<String, Any>
      else -> null
    }

    val agoraClient: RTMClient? = clients[_clientIndex]

    if (null == agoraClient) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }

    val client: RtmClient? = agoraClient?.client

    if (null == client) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }

    val rtmChannel = agoraClient?.channels[_channelId]

    if (null == rtmChannel) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }


    when (methodName) {
      "join" -> {
        rtmChannel!!.join(object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "sendMessage" -> {
        val message = client.createMessage()
        message.text = args?.get("message") as String
        rtmChannel!!.sendMessage(message, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "leave" -> {
        rtmChannel!!.leave(object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      "getMembers" -> {
        rtmChannel!!.getMembers(object : ResultCallback<List<RtmChannelMember>> {
          override fun onSuccess(resp: List<RtmChannelMember>) {
            val membersList = ArrayList<Map<String, String>>()
            if (null != resp) {
              for (member in resp) {
                membersList.add(hashMapOf("userId" to member.userId, "channelId" to member.channelId))
              }
            }
            runMainThread {
              result.success(hashMapOf(
                      "errorCode" to 0,
                      "members" to membersList
              ))
            }
          }
          override fun onFailure(code: ErrorInfo) {
            runMainThread {
              result.success(hashMapOf("errorCode" to code.getErrorCode()))
            }
          }
        })
      }
      else -> {
        result.notImplemented();
      }
    }
  }
}