# RTM code generation compatibility

The generator uses Flutter 3.19.6. Its `flutter_test` pins `meta` 1.11.0 and
its Dart SDK resolves `async` 2.11.0. The package lower bounds must permit
these versions; newer compatible versions remain available on newer SDKs.
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
