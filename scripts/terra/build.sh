#!/usr/bin/env bash
set -e
set -x

NEW_VERSION=$1
MY_PATH=$(realpath $(dirname "$0"))
PROJECT_ROOT=$(realpath ${MY_PATH}/../..)

TERRA_MAIN_FILE=${PROJECT_ROOT}/scripts/terra/bindings_api_config.yaml
TERRA_EXPORT_FILE=${PROJECT_ROOT}/scripts/terra/export_api_config.yaml

if [ -n "$NEW_VERSION" ]; then
  echo "Updating version to ${NEW_VERSION}..."
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
    sed -i '' -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_EXPORT_FILE
  else
    sed -i -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
    sed -i -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_EXPORT_FILE
  fi
  
  echo "Version after update:"
  grep -n "rtm_[0-9]\+\.[0-9]\+\(\.[0-9]\+\)*" ${TERRA_MAIN_FILE} || echo "No version found"
fi

echo "Running prepare script..."
bash ${MY_PATH}/prepare.sh

pushd ${MY_PATH}

echo "Running Terra for bindings generation..."
npm exec terra -- run \
    --config ${TERRA_MAIN_FILE}  \
    --output-dir=${PROJECT_ROOT}

echo "Running Terra for API export generation..."
npm exec terra -- run \
    --config ${TERRA_EXPORT_FILE}  \
    --output-dir=${PROJECT_ROOT}

popd

pushd ${PROJECT_ROOT}

echo "Formatting Dart code..."
dart format .

popd