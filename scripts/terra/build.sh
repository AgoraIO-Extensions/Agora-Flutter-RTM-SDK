#!/usr/bin/env bash
set -e
set -x

NEW_VERSION=$1
MY_PATH=$(realpath $(dirname "$0"))
PROJECT_ROOT=$(realpath ${MY_PATH}/../..)

TERRA_MAIN_FILE=${PROJECT_ROOT}/scripts/terra/bindings_api_config.yaml

if [ -n "$NEW_VERSION" ]; then
  # Check the operating system type
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' -E "s/rtc_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
  else
    # Linux and other Unix-like systems
    sed -i -E "s/rtc_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
  fi
  echo "Updated version to ${NEW_VERSION} in $TERRA_MAIN_FILE"
fi

bash ${MY_PATH}/prepare.sh

pushd ${MY_PATH}

npm exec terra -- run \
    --config ${TERRA_MAIN_FILE}  \
    --output-dir=${PROJECT_ROOT}

npm exec terra -- run \
    --config ${PROJECT_ROOT}/scripts/terra/export_api_config.yaml  \
    --output-dir=${PROJECT_ROOT}

popd

pushd ${PROJECT_ROOT}

dart format .

popd