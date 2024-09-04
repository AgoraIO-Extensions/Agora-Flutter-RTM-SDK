#!/usr/bin/env bash

set -e
set -x

# Usage:
# bash scripts/build-iris.sh <iris-project-path> <build-type> <native-sdk-unzip-path> <platform>

IRIS_PROJECT_PATH=$1
BUILD_TYPE=$2 # Debug|Release
NATIVE_SDK_PATH_NAME=$3 # Agora_Native_SDK_for_Android_MINI_RTM
AGORA_FLUTTER_PROJECT_PATH=$(pwd)
SCRIPTS_PATH=$(dirname "$0")
ABIS="arm64-v8a armeabi-v7a x86_64"
IRIS_TYPE="RTM" # DCG|RTM
PLATFORM=$4 # android/ios/macos/windows/web

build_android() {
    
    bash $IRIS_PROJECT_PATH/ci/build-android.sh buildALL $BUILD_TYPE Video $IRIS_TYPE

    IRIS_OUTPUT=${IRIS_PROJECT_PATH}/build/android/$IRIS_TYPE/ALL_ARCHITECTURE/output/$BUILD_TYPE

    for ABI in ${ABIS};
    do
        echo "Copying ${IRIS_OUTPUT}/$ABI/libAgoraRtmWrapper.so to $AGORA_FLUTTER_PROJECT_PATH/android/libs/$ABI/libAgoraRtmWrapper.so"
        mkdir -p "$AGORA_FLUTTER_PROJECT_PATH/android/libs/$ABI/"

        cp -RP "${IRIS_OUTPUT}/$ABI/libAgoraRtmWrapper.so" \
            "$AGORA_FLUTTER_PROJECT_PATH/android/libs/$ABI/libAgoraRtmWrapper.so" 
        
        cp -RP "${IRIS_OUTPUT}/$ABI/libIrisDebugger.so" "$AGORA_FLUTTER_PROJECT_PATH/test_shard/iris_tester/android/libs/$ABI/libIrisDebugger.so"

    done;

    echo "Copying ${IRIS_OUTPUT}/AgoraRtmWrapper.jar to $AGORA_FLUTTER_PROJECT_PATH/android/libs/AgoraRtmWrapper.jar"
    cp -r "${IRIS_OUTPUT}/AgoraRtmWrapper.jar" "$AGORA_FLUTTER_PROJECT_PATH/android/libs/AgoraRtmWrapper.jar"

    for ABI in ${ABIS};
    do
        echo "Copying $IRIS_PROJECT_PATH/third_party/agora/rtm/libs/$NATIVE_SDK_PATH_NAME/rtm/sdk/$ABI/ to $AGORA_FLUTTER_PROJECT_PATH/android/libs/$ABI/"
        cp -r "$IRIS_PROJECT_PATH/third_party/agora/rtm/libs/$NATIVE_SDK_PATH_NAME/rtm/sdk/$ABI/" \
            "$AGORA_FLUTTER_PROJECT_PATH/android/libs/$ABI/" 
    done;

    echo "Copying $IRIS_PROJECT_PATH/third_party/agora/rtm/libs/${NATIVE_SDK_PATH_NAME}/rtm/sdk/agora-rtm-sdk.jar to $AGORA_FLUTTER_PROJECT_PATH/android/libs/libs/agora-rtm-sdk.jar"
    cp -r "$IRIS_PROJECT_PATH/third_party/agora/rtm/libs/${NATIVE_SDK_PATH_NAME}/rtm/sdk/agora-rtm-sdk.jar" "$AGORA_FLUTTER_PROJECT_PATH/android/libs/agora-rtm-sdk.jar"
}

build_mac() {
    bash $IRIS_PROJECT_PATH/ci/build-mac.sh buildALL $BUILD_TYPE Video $IRIS_TYPE
}

if [[ $PLATFORM == "android" ]]; then
    build_android
elif [[ $PLATFORM == "macos" ]]; then
    build_mac
else
    echo "Not implemented"
fi
