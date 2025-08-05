#!/usr/bin/env bash
set -e
set -x

NEW_VERSION=$1
MY_PATH=$(realpath $(dirname "$0"))
PROJECT_ROOT=$(realpath ${MY_PATH}/../..)

TERRA_MAIN_FILE=${PROJECT_ROOT}/scripts/terra/bindings_api_config.yaml

echo "============= Build Script Debug Info Start ============="
echo "Current working directory: $(pwd)"
echo "Script path: ${MY_PATH}"
echo "Project root: ${PROJECT_ROOT}"
echo "Terra config file: ${TERRA_MAIN_FILE}"
echo "New version requested: ${NEW_VERSION}"

# 显示当前配置文件中的版本
echo "Current version in config file:"
grep -n "rtm_[0-9]\+\.[0-9]\+\(\.[0-9]\+\)*" ${TERRA_MAIN_FILE} || echo "No version found"

if [ -n "$NEW_VERSION" ]; then
  echo "Updating version to ${NEW_VERSION}..."
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
  else
    sed -i -E "s/rtm_[0-9]+\.[0-9]+(\.[0-9]+)*/${NEW_VERSION}/g" $TERRA_MAIN_FILE
  fi
  
  echo "Version after update:"
  grep -n "rtm_[0-9]\+\.[0-9]\+\(\.[0-9]\+\)*" ${TERRA_MAIN_FILE} || echo "No version found"
fi

# 检查头文件目录
HEADER_DIR="@agoraio-extensions/terra_shared_configs:headers/${NEW_VERSION}/include"
echo "Looking for header files in: ${HEADER_DIR}"

echo "Running prepare script..."
bash ${MY_PATH}/prepare.sh

pushd ${MY_PATH}

echo "Running Terra for bindings generation..."
npm exec terra -- run \
    --config ${TERRA_MAIN_FILE}  \
    --output-dir=${PROJECT_ROOT}

echo "Running Terra for API export generation..."
npm exec terra -- run \
    --config ${PROJECT_ROOT}/scripts/terra/export_api_config.yaml  \
    --output-dir=${PROJECT_ROOT}

popd

pushd ${PROJECT_ROOT}

# 检查生成的文件
echo "Checking generated files..."
echo "Looking for GetHistoryMessagesOptions and HistoryMessage in generated files..."
find . -type f -name "*.dart" -exec grep -l "GetHistoryMessagesOptions\|HistoryMessage" {} \;

echo "Formatting Dart code..."
dart format .

echo "============= Build Script Debug Info End ============="

popd