set -e

# Legacy fixture coordinates for historical reproductions only. Current RTM
# tests use install_rtm_test_fixture.sh and the checksum-pinned 2.3.1 fixtures.
export IRIS_CDN_URL_ANDROID="https://download.agora.io/sdk/release/iris_2.2.1-build.1_RTM_Android_Video_20240816_0317_599.zip"
export IRIS_CDN_URL_IOS="https://download.agora.io/sdk/release/iris_2.2.1-build.1_RTM_iOS_Video_20240816_0319_488.zip"
