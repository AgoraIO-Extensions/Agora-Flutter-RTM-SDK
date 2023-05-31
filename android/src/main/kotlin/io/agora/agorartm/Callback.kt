package io.agora.agorartm

import android.os.Handler
import io.agora.rtm.ErrorInfo
import io.agora.rtm.ResultCallback
import io.flutter.plugin.common.MethodChannel.Result

abstract class Callback<T>(
    private val result: Result,
    private val handler: Handler,
) : ResultCallback<T> {
    final override fun onSuccess(responseInfo: T?) {
        val response = responseInfo?.let { toJson(it) }
        handler.post {
            result.success(
                hashMapOf(
                    "errorCode" to 0,
                    "result" to response,
                )
            )
        }
    }

    open fun toJson(responseInfo: T): Any? {
        return responseInfo
    }

    final override fun onFailure(errorInfo: ErrorInfo?) {
        handler.post {
            result.success(errorInfo?.toJson())
        }
    }
}
