package io.agora.agorartm

import io.agora.rtm.ErrorInfo
import io.agora.rtm.ResultCallback
import io.flutter.plugin.common.MethodChannel.Result

abstract class Callback<T>(private val result: Result) : ResultCallback<T> {
    final override fun onSuccess(responseInfo: T) {
        result.success(
            hashMapOf(
                "errorCode" to 0, "result" to toJson(responseInfo)
            )
        )
    }

    open fun toJson(responseInfo: T): Any {
        return responseInfo as Any
    }

    final override fun onFailure(errorInfo: ErrorInfo?) {
        result.success(errorInfo?.toJson())
    }
}