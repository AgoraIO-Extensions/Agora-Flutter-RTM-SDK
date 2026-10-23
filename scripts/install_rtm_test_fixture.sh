#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TESTER_DIR="${SCRIPT_DIR}/../test_shard/iris_tester"
FIXTURE_DIR="${TESTER_DIR}/fixtures/rtm_2.3.1"
case "${1:-}" in
  android|ios) platform="$1" ;;
  *) echo 'Expected android or ios test fixture' >&2; exit 2 ;;
esac

cd "${FIXTURE_DIR}"
shasum -a 256 -c "${platform}.sha256"
unzip -oq "${platform}.zip" -d "${TESTER_DIR}"
