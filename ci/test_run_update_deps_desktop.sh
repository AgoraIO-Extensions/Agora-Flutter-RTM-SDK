#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

cp -R "${REPO_ROOT}/ci" "${TMP_DIR}/ci"
cp -R "${REPO_ROOT}/ios" "${TMP_DIR}/ios"
cp -R "${REPO_ROOT}/android" "${TMP_DIR}/android"
cp -R "${REPO_ROOT}/macos" "${TMP_DIR}/macos"
cp -R "${REPO_ROOT}/windows" "${TMP_DIR}/windows"
mkdir -p "${TMP_DIR}/scripts"
cp "${REPO_ROOT}/scripts/artifacts_version.sh" "${TMP_DIR}/scripts/artifacts_version.sh"
cp "${REPO_ROOT}/scripts/artifacts_version.sh" "${TMP_DIR}/artifacts_version.before"

DEPENDENCIES_CONTENT='[
  {
    "platform": "macOS",
    "iris_cdn": ["https://example.com/iris_rtm_macos.zip"],
    "cdn": ["https://example.com/native_rtm_macos.zip"],
    "iris_cocoapods": ["pod '\''AgoraIrisRTM_macOS'\'', '\''9.9.9-test'\''"],
    "cocoapods": ["pod '\''AgoraRtm_OC_Special'\'', '\''9.9.9-test'\''"]
  },
  {
    "platform": "Windows",
    "iris_cdn": ["https://example.com/iris_rtm_windows_standalone.zip"],
    "cdn": ["https://example.com/native_rtm_windows.zip"],
    "iris_cocoapods": [],
    "cocoapods": []
  }
]'

pushd "${TMP_DIR}" >/dev/null
bash ci/run_update_deps.sh "${DEPENDENCIES_CONTENT}"

grep -q "s.dependency 'AgoraIrisRTM_macOS', '9.9.9-test'" macos/agora_rtm.podspec
grep -q "s.dependency 'AgoraRtm_OC_Special', '9.9.9-test'" macos/agora_rtm.podspec
grep -q 'set(IRIS_SDK_DOWNLOAD_URL "https://example.com/iris_rtm_windows_standalone.zip")' windows/cmake/DownloadSDK.cmake
grep -q 'set(NATIVE_SDK_DOWNLOAD_URL "https://example.com/native_rtm_windows.zip")' windows/cmake/DownloadSDK.cmake
cmp -s "${TMP_DIR}/artifacts_version.before" scripts/artifacts_version.sh
popd >/dev/null
