#ifndef FLUTTER_PLUGIN_AGORA_RTM_PLUGIN_H_
#define FLUTTER_PLUGIN_AGORA_RTM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace agora_rtm {

class AgoraRtmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  AgoraRtmPlugin();

  virtual ~AgoraRtmPlugin();

  AgoraRtmPlugin(const AgoraRtmPlugin&) = delete;
  AgoraRtmPlugin& operator=(const AgoraRtmPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace agora_rtm

#endif  // FLUTTER_PLUGIN_AGORA_RTM_PLUGIN_H_
