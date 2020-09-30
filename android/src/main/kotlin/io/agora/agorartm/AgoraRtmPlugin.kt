package io.agora.agorartm

import android.content.Context
import android.os.Handler
import android.os.Looper
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
      callArguments!!.get("call") is String -> callArguments.get("call") as String
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
        val appId: String? = when {
          params["appId"] is String -> params["appId"] as String
          else -> null
        }

        if (null == appId) {
          runMainThread {
            result.success(hashMapOf("errorCode" to -1))
          }
          return
        }

        while (null != clients[nextClientIndex]) {
          nextClientIndex++
        }

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
      (params.get("args") is Map<*,*>) -> (params["args"] as Map<String, Any>)
      else -> null
    }
    val agoraClient = when {
      clients[clientIndex] is RTMClient -> clients[clientIndex] as RTMClient
      else -> null
    }
    if (null == agoraClient) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }

    var client: RtmClient = agoraClient.client

    when (methodName) {
      "destroy" -> {
        agoraClient.channels.forEach{
          val pair = it.toPair()
          pair.second.release()
        }
        agoraClient.channels.clear()
        clients.remove(clientIndex)
        runMainThread {
          result.success(hashMapOf("errorCode" to 0))
        }
      }
      "setLog" -> {
        val relativePath = "/sdcard/${getActiveContext().packageName}"
        val size: Int = when {
          args?.get("size") is Int -> args.get("size") as Int
          else -> 524288
        }
        val path: String? = when {
          args?.get("path") is String -> "${relativePath}/${(args.get("path") as String)}"
          else -> null
        }

        val level: Int = when {
          args?.get("level") is Int -> args.get("level") as Int
          else -> 0
        }

        runMainThread {
          result.success(hashMapOf(
                  "errorCode" to 0,
                  "results" to hashMapOf(
                          "setLogFileSize" to client.setLogFileSize(size),
                          "setLogLevel" to client.setLogFilter(level),
                          "setLogFile" to client.setLogFile(path)
                  )
          ))
        }
      }
      "login" -> {
        var token = args?.get("token")

        token = when {
          (token is String) -> token
          else -> null
        }

        var userId = args?.get("userId")

        userId = when {
          (userId is String) -> userId
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
          (token is String) -> token
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
        var text = args.get("message") as String
        val message = client.createMessage()
        message.text = text
        val options = SendMessageOptions().apply {
          (args["historical"] as? Boolean)?.let {
            enableHistoricalMessaging = it
          }
          (args["offline"] as? Boolean)?.let {
            enableOfflineMessaging = it
          }
        }
        client.sendMessageToPeer(peerId,
                message,
                options,
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
        val userId: String? =  when {
          args?.get("userId") is String -> args.get("userId") as String
          else -> null
        }
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
        val userId: String? =  when {
          args?.get("userId") is String -> args.get("userId") as String
          else -> null
        }
        var keys: List<String>? = when {
          args?.get("keys") is List<*> -> args.get("keys") as List<String>
          else -> null
        }

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
      "setChannelAttributes" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        val enableNotificationToChannelMembers: Boolean =  when {
          args?.get("enableNotificationToChannelMembers") is Boolean -> args.get("enableNotificationToChannelMembers") as Boolean
          else -> false
        }
        val attributes: List<Map<String, String>>? = args?.get("attributes") as List<Map<String, String>>
        var channelAttributes = ArrayList<RtmChannelAttribute>()
        attributes!!.forEach {
          var rtmChannelAttribute = RtmChannelAttribute()
          rtmChannelAttribute.key = it["key"]
          rtmChannelAttribute.value = it["value"]
          channelAttributes.add(rtmChannelAttribute)
        }

        client.setChannelAttributes(channelId, channelAttributes,
                ChannelAttributeOptions(enableNotificationToChannelMembers),
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
      "addOrUpdateChannelAttributes" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        val enableNotificationToChannelMembers: Boolean =  when {
          args?.get("enableNotificationToChannelMembers") is Boolean -> args.get("enableNotificationToChannelMembers") as Boolean
          else -> false
        }
        val attributes: List<Map<String, String>>? = args?.get("attributes") as List<Map<String, String>>
        var channelAttributes = ArrayList<RtmChannelAttribute>()
        attributes!!.forEach {
          var rtmChannelAttribute = RtmChannelAttribute()
          rtmChannelAttribute.key = it["key"]
          rtmChannelAttribute.value = it["value"]
          channelAttributes.add(rtmChannelAttribute)
        }
        client.addOrUpdateChannelAttributes(channelId, channelAttributes,
                ChannelAttributeOptions(enableNotificationToChannelMembers),
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
      "deleteChannelAttributesByKeys" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        val enableNotificationToChannelMembers: Boolean =  when {
          args?.get("enableNotificationToChannelMembers") is Boolean -> args.get("enableNotificationToChannelMembers") as Boolean
          else -> false
        }
        val keys: List<String>? = args?.get("keys") as List<String>
        client.deleteChannelAttributesByKeys(channelId, keys,
                ChannelAttributeOptions(enableNotificationToChannelMembers),
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
      "clearChannelAttributes" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        val enableNotificationToChannelMembers: Boolean =  when {
          args?.get("enableNotificationToChannelMembers") is Boolean -> args.get("enableNotificationToChannelMembers") as Boolean
          else -> false
        }
        client.clearChannelAttributes(channelId,
                ChannelAttributeOptions(enableNotificationToChannelMembers),
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
      "getChannelAttributes" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        client.getChannelAttributes(channelId,
                object : ResultCallback<List<RtmChannelAttribute>> {
                  override fun onSuccess(resp: List<RtmChannelAttribute>) {
                    var attributes = ArrayList<Map<String, Any>>()
                    for(attribute in resp.orEmpty()){
                      attributes.add(hashMapOf(
                              "key" to attribute.key,
                              "value" to attribute.value,
                              "userId" to attribute.getLastUpdateUserId(),
                              "updateTs" to attribute.getLastUpdateTs()
                      ))
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
      "getChannelAttributesByKeys" -> {
        val channelId: String? =  when {
          args?.get("channelId") is String -> args.get("channelId") as String
          else -> null
        }
        var keys: List<String>? = when {
          args?.get("keys") is List<*> -> args.get("keys") as List<String>
          else -> null
        }

        client.getChannelAttributesByKeys(channelId,
                keys,
                object : ResultCallback<List<RtmChannelAttribute>> {
                  override fun onSuccess(resp: List<RtmChannelAttribute>) {
                    var attributes = ArrayList<Map<String, Any>>()
                    for(attribute in resp.orEmpty()){
                      attributes.add(hashMapOf(
                              "key" to attribute.key,
                              "value" to attribute.value,
                              "userId" to attribute.getLastUpdateUserId(),
                              "updateTs" to attribute.getLastUpdateTs()
                      ))
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
        val calleeId = when {
          args?.get("calleeId") is String -> args["calleeId"] as String
          else -> null
        }
        val content = when {
          args?.get("content") is String -> args["content"] as String
          else -> null
        }
        val channelId = when {
          args?.get("channelId") is String -> args["channelId"] as String
          else -> null
        }
        val localInvitation = agoraClient.callKit.createLocalInvitation(calleeId)
        if (null != content) {
          localInvitation.content = content
        }
        if (null != channelId) {
          localInvitation.channelId = channelId
        }
        agoraClient.callKit.sendLocalInvitation(localInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              agoraClient.localInvitations[localInvitation.calleeId] = localInvitation
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
        val calleeId = when {
          args?.get("calleeId") is String -> args["calleeId"] as String
          else -> null
        }
        val content = when {
          args?.get("content") is String -> args["content"] as String
          else -> null
        }
        val channelId = when {
          args?.get("channelId") is String -> args["channelId"] as String
          else -> null
        }
        val localInvitation = when {
          agoraClient.localInvitations[calleeId] is LocalInvitation -> agoraClient.localInvitations[calleeId]
          else -> null
        }

        if (null == localInvitation) {
          runMainThread {
            result.success(hashMapOf("errorCode" to -1))
          }
          return
        }

        if (null != content) {
          localInvitation.content = content
        }
        if (null != channelId) {
          localInvitation.channelId = channelId
        }
        agoraClient.callKit.cancelLocalInvitation(localInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              agoraClient.localInvitations.remove(localInvitation.calleeId)
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
        val response = when {
          args?.get("response") is String -> args.get("response") as String
          else -> null
        }

        val callerId = when {
          args?.get("callerId") is String -> args.get("callerId") as String
          else -> null
        }

        var remoteInvitation: RemoteInvitation? = when {
          agoraClient.remoteInvitations[callerId] is RemoteInvitation -> agoraClient.remoteInvitations[callerId]
          else -> null
        }

        if (null == remoteInvitation) {
          runMainThread {
            result.success(hashMapOf("errorCode" to -1))
          }
          return
        }

        if (null != response) {
            remoteInvitation.response = response
        }
        agoraClient.callKit.acceptRemoteInvitation(remoteInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              agoraClient.remoteInvitations.remove(remoteInvitation.callerId)
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
        val response = when {
          args?.get("response") is String -> args.get("response") as String
          else -> null
        }

        val callerId = when {
          args?.get("callerId") is String -> args.get("callerId") as String
          else -> null
        }

        var remoteInvitation: RemoteInvitation? = when {
          agoraClient.remoteInvitations[callerId] is RemoteInvitation -> agoraClient.remoteInvitations[callerId]
          else -> null
        }

        if (null == remoteInvitation) {
          runMainThread {
            result.success(hashMapOf("errorCode" to -1))
          }
          return
        }

        if (null != response) {
          remoteInvitation.response = response
        }

        agoraClient.callKit.refuseRemoteInvitation(remoteInvitation, object : ResultCallback<Void> {
          override fun onSuccess(resp: Void?) {
            runMainThread {
              agoraClient.remoteInvitations.remove(remoteInvitation.callerId)
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
        rtmChannel.release()
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
      (params.get("args") is Map<*,*>) -> params["args"] as Map<String, Any>
      else -> null
    }

    val agoraClient: RTMClient? = clients[_clientIndex]

    if (null == agoraClient) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }

    val client: RtmClient? = agoraClient.client

    if (null == client) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }

    val rtmChannel = agoraClient.channels[_channelId]

    if (null == rtmChannel) {
      runMainThread {
        result.success(hashMapOf("errorCode" to -1))
      }
      return
    }


    when (methodName) {
      "join" -> {
        rtmChannel.join(object : ResultCallback<Void> {
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
        val options = SendMessageOptions().apply {
          (args["historical"] as? Boolean)?.let {
            enableHistoricalMessaging = it
          }
          (args["offline"] as? Boolean)?.let {
            enableOfflineMessaging = it
          }
        }
        rtmChannel.sendMessage(message, options, object : ResultCallback<Void> {
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
        rtmChannel.leave(object : ResultCallback<Void> {
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
        rtmChannel.getMembers(object : ResultCallback<List<RtmChannelMember>> {
          override fun onSuccess(resp: List<RtmChannelMember>) {
            val membersList = ArrayList<Map<String, String>>()
            for (member in resp) {
              membersList.add(hashMapOf("userId" to member.userId, "channelId" to member.channelId))
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