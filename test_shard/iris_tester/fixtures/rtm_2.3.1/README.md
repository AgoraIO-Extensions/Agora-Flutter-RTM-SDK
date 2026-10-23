# RTM 2.3.1 native test fixtures

These are fake clients for native binding tests, not distributable SDKs.
The old 2.2.1 Debugger has a different C++ virtual interface and cannot safely
be injected into Iris built against 2.3.1 (`getHistory` shifts later methods).

Source: Iris fixture revision `9a6c550d3fc405d9846e45d2989c184e2bc0e806`,
based on production Iris revision `b55b8f5b17ce1381c4ae8f76b8a4030b39c6f3e0`.
The historical fixture generators are run against `rtm_2.3.1` headers and
formatted with clang-format; generated C++ is not hand-patched. Build the
standalone `debug/rtm` target following its README to reproduce the assets.
No production SDK target, release Job or CDN package was rebuilt/published.

`android.zip`: NDK 27.1.12297006, API 21, static C++ runtime; arm64-v8a,
armeabi-v7a and x86_64. `ios.zip`: iOS 12 minimum, device arm64 plus simulator
arm64/x86_64 XCFramework. Only six explicit test C functions are exported;
Native SDK factory/version functions and C++ implementation symbols are hidden.

The host CTest dynamically loads the actual fixture and checks version,
history/stream virtual dispatch, channel name and online-status callback data.
`GetRtmFixtureVersion` must return `rtm_2.3.1`. The installer checks archive
SHA-256 before extraction, and the Dart test adapter checks the ABI marker.
Full device/simulator CI is still required; these checks are not service QA.

The archives and unpacked libraries are excluded from Dart publication by
`.pubignore`. Production Native/Iris dependency versions remain unchanged.
