/// Generated by terra, DO NOT MODIFY BY HAND.

#ifndef FAKE_IAUDIODEVICECOLLECTION_INTERNAL_H_
#define FAKE_IAUDIODEVICECOLLECTION_INTERNAL_H_

#include "IAudioDeviceManager.h"

namespace agora {
namespace rtc {
class FakeIAudioDeviceCollectionInternal
    : public agora::rtc::IAudioDeviceCollection {
  virtual int getCount() override { return 0; }

  virtual int getDevice(int index, char *deviceName, char *deviceId) override {
    return 0;
  }

  virtual int setDevice(const char *deviceId) override { return 0; }

  virtual int getDefaultDevice(char *deviceName, char *deviceId) override {
    return 0;
  }

  virtual int setApplicationVolume(int volume) override { return 0; }

  virtual int getApplicationVolume(int &volume) override { return 0; }

  virtual int setApplicationMute(bool mute) override { return 0; }

  virtual int isApplicationMute(bool &mute) override { return 0; }

  virtual void release() override {}
};

} // namespace rtc
} // namespace agora

#endif // FAKE_IAUDIODEVICECOLLECTION_INTERNAL_H_
