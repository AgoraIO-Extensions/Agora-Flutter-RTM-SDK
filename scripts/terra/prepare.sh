#!/usr/bin/env bash
set -e
set -x

MY_PATH=$(realpath $(dirname "$0"))

pushd ${MY_PATH}

rm -rf .yarnrc.yml
rm -rf yarn.lock

echo "nodeLinker: node-modules" >> .yarnrc.yml
echo "enableImmutableInstalls: false" >> .yarnrc.yml
# Use the packageManager version declared in package.json, not moving Berry.
corepack yarn install

popd
