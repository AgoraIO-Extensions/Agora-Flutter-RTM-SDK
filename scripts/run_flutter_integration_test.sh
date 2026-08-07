#!/usr/bin/env bash

set -e
set -x

if [[ "$(uname -s)" == "Darwin" ]]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
fi

MY_PATH=$(realpath $(dirname "$0"))
PROJECT_ROOT=$(realpath ${MY_PATH}/..)
PLATFORM=$1 # android/ios/macos/windows/web

if [[ ${PLATFORM} == "web" ]];then
    pushd ${PROJECT_ROOT}/test_shard/fake_test_app

    IRIS_WEB_VERSION_PATH=${PROJECT_ROOT}/scripts/iris_web_version.js
    rm -rf web/iris_web_version.js
    cp -RP ${IRIS_WEB_VERSION_PATH} web/

    echo "Run integration test on web"
    echo "If you want to run integration test on your local machine, please follow the https://docs.flutter.dev/testing/integration-tests#test-in-a-web-browser to setup first."

    flutter packages get

    for filename in integration_test/*.dart; do
        if [[ "$filename" == *.generated.dart  ]]; then
            continue
        fi

        flutter drive \
            --verbose-system-logs \
            -d web-server \
            --driver=test_driver/integration_test.dart \
            --target=${filename}
    done

    popd

elif [[ ${PLATFORM} == "android" || ${PLATFORM} == "ios" || ${PLATFORM} == "macos" || ${PLATFORM} == "windows" ]];then
    # NOTE: the `*_fake_test.dart` suites are intentionally not run here.
    # They drive the plugin against a fake native proc table exported by the
    # prebuilt libIrisDebugger.so / IrisDebugger.xcframework. That artifact is
    # pinned to iris 2.2.1 while the plugin now depends on iris 2.2.6.2, and the
    # proc table layout is version specific, so every call lands on the wrong
    # slot and returns a garbage error code. No RTM fake sources exist in this
    # repo (test_shard/iris_tester/cxx only contains RTC fakes), so the library
    # cannot be rebuilt to match. Because of that the debugger artifact is not
    # downloaded either.
    #
    # API level coverage lives in `flutter test` (test/) below; the on-device run
    # keeps the real end to end smoke test, which needs no fake native layer.

    pushd ${MY_PATH}/../test_shard/integration_test_app

    flutter packages get

    flutter test --verbose

    # Pick the device to run the on-device suite against. The mobile jobs export
    # FLUTTER_TEST_DEVICE (simulator udid / emulator serial). Desktop has exactly
    # one target, whose device id is the platform name itself, so default to that
    # instead of leaving `flutter test` to guess.
    device_args=()
    if [[ -n "${FLUTTER_TEST_DEVICE:-}" ]]; then
        device_args=(-d "${FLUTTER_TEST_DEVICE}")
    elif [[ ${PLATFORM} == "macos" || ${PLATFORM} == "windows" ]]; then
        device_args=(-d "${PLATFORM}")
    elif [[ ${PLATFORM} == "android" ]]; then
        # Without an explicit device the run ends in "No tests were found." and
        # exits 79 even though the test body passes, so resolve the emulator
        # serial from adb.
        android_device="$(adb devices | awk '/\tdevice$/ {print $1; exit}')"
        if [[ -n "${android_device}" ]]; then
            device_args=(-d "${android_device}")
        fi
    fi

    flutter test integration_test/integration_test.dart "${device_args[@]}" --verbose

    popd
else
    echo "Not implemented"
fi
