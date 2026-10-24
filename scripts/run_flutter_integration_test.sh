#!/usr/bin/env bash
set -euo pipefail

MY_PATH=$(cd "$(dirname "$0")" && pwd)
PLATFORM=${1:?Expected android or ios}

report_native_crash() {
    status=$?
    if [[ ${status} -ne 0 && ${PLATFORM} == "android" ]] && command -v adb >/dev/null; then
        adb logcat -b crash -d -t 150 2>/dev/null |
            sed -E '/credential|token|secret|password|cookie|crumb|webhook|curl|[Ee][Nn][Vv]/Id' || true
    fi
    exit "${status}"
}
trap report_native_crash EXIT

case "${PLATFORM}" in
    android|ios) ;;
    *) echo 'Expected android or ios integration platform' >&2; exit 2 ;;
esac

pushd "${MY_PATH}/../test_shard/integration_test_app"
flutter pub get --verbose
flutter test --verbose
flutter test integration_test/integration_test.dart --reporter expanded --verbose
popd
