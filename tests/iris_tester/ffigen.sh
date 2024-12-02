

#!/usr/bin/env bash

set -e
set -x

MY_PATH=$(dirname "$0")
IRIS_PATH=$1

pushd ${MY_PATH}

mkdir -p ${MY_PATH}/ffigen_include

cp -RP ${IRIS_PATH}/src/rtm/include/* ${MY_PATH}/ffigen_include/
cp -RP ${IRIS_PATH}/debug/rtm/*.h ${MY_PATH}/ffigen_include/
cp -RP ${IRIS_PATH}/common/public/*.h ${MY_PATH}/ffigen_include/
cp -RP ${IRIS_PATH}/debug/rtm/iris_debug_rtm.h ${MY_PATH}/ffigen_include/iris_debug_rtm.h

flutter pub run ffigen --config ${MY_PATH}/ffigen_config.yaml

rm -rf ${MY_PATH}/ffigen_include

popd