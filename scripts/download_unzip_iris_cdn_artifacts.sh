#!/usr/bin/env bash

set -e
set -x

CDN_URL=$1
PLATFORM=$2

MY_PATH=$(dirname "$0")

ARTIFACTS_PATH="${MY_PATH}/../artifacts"
mkdir -p ${ARTIFACTS_PATH}

IRIS_TESTER_PATH=${MY_PATH}/../test_shard/iris_tester

DOWNLOAD_NAME=${CDN_URL##*/}

DOWNLOAD_BASE_NAME=${DOWNLOAD_NAME/.zip/""}

curl -L "${CDN_URL}" > ${ARTIFACTS_PATH}/${DOWNLOAD_NAME}

VERSION="$(cut -d'_' -f2 <<<"${DOWNLOAD_NAME}")"

pushd ${ARTIFACTS_PATH}
    unzip ${DOWNLOAD_NAME} -d ${DOWNLOAD_BASE_NAME}
popd

UNZIP_PATH="${ARTIFACTS_PATH}/${DOWNLOAD_BASE_NAME}/iris_${VERSION}_RTM_${PLATFORM}"

if [[ ${PLATFORM} == "Android" ]];then
    ABIS="arm64-v8a armeabi-v7a x86_64"
    for ABI in ${ABIS};
    do
        if [[ ! -d "${IRIS_TESTER_PATH}/android/libs/${ABI}" ]]; then
            mkdir -p "${IRIS_TESTER_PATH}/android/libs/${ABI}"
        fi

        cp -RP "${UNZIP_PATH}/Debugger/ALL_ARCHITECTURE/${ABI}/libIrisDebugger.so" "${IRIS_TESTER_PATH}/android/libs/${ABI}/libIrisDebugger.so"

        ls ${IRIS_TESTER_PATH}/android/libs/${ABI}/
    done;

    
fi

if [[ ${PLATFORM} == "MAC" || ${PLATFORM} == "macOS" ]];then
    iris_debugger_framework=$(find "${UNZIP_PATH}" -name "IrisDebugger.framework" -type d | head -n 1)

    if [[ -z "${iris_debugger_framework}" ]]; then
        echo "IrisDebugger.framework not found under ${UNZIP_PATH}"
        find "${UNZIP_PATH}" -maxdepth 5 -type d -name "IrisDebugger.framework" -print
        exit 1
    fi

    cp -RP "${iris_debugger_framework}" "${IRIS_TESTER_PATH}/macos/"
fi

if [[ ${PLATFORM} == "iOS" ]];then
    cp -RP "${UNZIP_PATH}/Debugger/ALL_ARCHITECTURE/IrisDebugger.xcframework" "${IRIS_TESTER_PATH}/ios/"
fi

if [[ ${PLATFORM} == "Windows" ]];then
    iris_debugger_dll=$(find "${UNZIP_PATH}" -name "IrisDebugger.dll" | head -n 1)
    iris_debugger_lib=$(find "${UNZIP_PATH}" -name "IrisDebugger.lib" | head -n 1)

    if [[ -z "${iris_debugger_dll}" || -z "${iris_debugger_lib}" ]]; then
        echo "IrisDebugger Windows binaries not found under ${UNZIP_PATH}"
        find "${UNZIP_PATH}" -maxdepth 5 -type f \( -name "*.dll" -o -name "*.lib" \) -print
        exit 1
    fi

    cp -RP "${iris_debugger_dll}" "${IRIS_TESTER_PATH}/windows/IrisDebugger.dll"
    cp -RP "${iris_debugger_lib}" "${IRIS_TESTER_PATH}/windows/IrisDebugger.lib"
fi

# pushd ${UNZIP_PATH}





# popd
