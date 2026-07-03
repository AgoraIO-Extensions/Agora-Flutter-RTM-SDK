#include "include/agora_rtm/agora_rtm_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "agora_rtm_plugin.h"

void AgoraRtmPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  agora_rtm::AgoraRtmPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
