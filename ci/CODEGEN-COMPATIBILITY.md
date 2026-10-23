# RTM code generation compatibility

The generator uses Flutter 3.19.6. Its `flutter_test` pins `meta` 1.11.0 and
its Dart SDK resolves `async` 2.11.0. The package lower bounds must permit
these versions; newer compatible versions remain available on newer SDKs.
The declared minimum Flutter 3.10.0 additionally pins `meta` 1.9.1, so the
constraint must permit that version too. Keep both existing CI matrix versions.
Do not use dependency overrides or disable generation to hide solver failures.

Terra uses the exact Yarn version declared in `scripts/terra/package.json`.
Its checked-in Yarn configuration permits only the two existing Agora Git
dependencies. Do not upgrade to moving Berry during every generation or
disable repository approval checks.

RTM 2.3.1 splits configuration and callback declarations across headers.
Render public exports from the actual header set, export callback interfaces,
and include the separate callback/payload files in test generation. Do not
hand-edit generated bindings. The old callback wrapper path forwards to the
new generated file, replacing stale generated code when upgrading headers.

The `Check codegen compatibility` PR workflow generates real 2.3.1 bindings
and test sources, then analyzes the SDK and runs its unit tests. It has read-only repository access
and creates no commit, PR, tag, package release, or test notification.

Local verification with Flutter 3.19.6:

```sh
flutter pub get
corepack enable
bash scripts/code_gen.sh rtm_2.3.1
flutter analyze lib --no-pub --no-fatal-infos --no-fatal-warnings
cd test_shard/integration_test_app
flutter test --no-pub
```

Generation modifies generated files in the checkout; use a disposable
worktree. Existing lint information is allowed, while analyzer errors still
fail the check. Generation and analysis do not establish device or QA success.

The internal PR workflow must be checked at job level: a queued matrix child
can leave the workflow summary `queued` even after other children fail.
Native/Iris dev.4 Android coordinates are served by
`https://download.agora.io/maven`, not Maven Central. The plugin registers this
repository for its two dependency groups.

Windows builds use `windows-2022`. iOS simulator tests use `macos-15` with
Xcode 16.4 and an iPhone 16; `macos-latest` can change both architecture and
installed simulator models. The explicit Xcode 15 regression check remains
on `macos-14` with Xcode 15.4, rather than pretending a newer Xcode tests it.
GitHub schedules macOS 14 retirement for November 2, 2026; that legacy check
will need an explicitly provisioned runner to retain Xcode 15 coverage then.

IrisDebugger is a test-only fake client, not a Native/Iris SDK dependency.
The published dev.4 Standalone archives contain no Debugger. Current tests use
the checksum-pinned `test_shard/iris_tester/fixtures/rtm_2.3.1` assets: the old
2.2.1 fake client lacks `getHistory`, shifting the virtual calls in 2.3.1.
The installer verifies archive hashes and the Dart adapter verifies the fixture
ABI marker. The test framework is explicitly linked on iOS for FFI lookup.
The fixture source has a standalone build and host ABI/event CTest; its six
exports cannot interpose Native SDK factory/version calls. These are test
assets, excluded from Dart publication, not service/device QA evidence.

Event test generation must initialize the client with the event handler supplied
by each test. A fresh default result handler discards that callback and makes
the generated completion check hang even when native event dispatch succeeds.

RTM 2.3.1-dev.4 bundles Android AOSL 1.3.5. Both example/test apps must
request that version rather than 1.2.13: the latter lacks
`aosl_ref_magic_hold_args`, so APK builds pass but loading RTM fails at runtime.
The Maven 1.3.5 and Native RTM bundled x86_64 libraries have identical SHA-256.
On iOS, keep the new RTM AOSL and remove only the duplicate AgoraInfra copy
from the generated Pods sandbox. Deleting RTM's copy can leave the simulator
linker without AOSL. Both apps share the same selection helper; its regression
check covers repeated installation and an absent RTM provider.
