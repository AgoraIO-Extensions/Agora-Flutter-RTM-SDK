# RTM 2.3.1 Dart semantic layer

The public Flutter API is not a direct C++ binding. The custom Terra
`export_api_renderer.ts` and `dart_project_marker_parser.config.ts` generate
the semantic interfaces, option flattening, result objects and async wrappers.
The files outside `impl/gen` and `bindings/gen` own initialization, listeners,
transport overrides, error/status conversion and scoped stream objects.

Audited against dependency PR #246 (`d2736343eee417dd7fcd35ba34a9cba993b01e22`):

| Surface | Semantic adaptation |
| --- | --- |
| `getUserOnlineStatus` | Public `Future<(RtmStatus, GetUserOnlineStatusResult?)>`; real callback decoder routes request ID and `UserOnlineStatus` through `RtmResultHandlerImpl` |
| Native failures | Immediate exceptions become `(error status, null)`; callback errors retain their result payload and native error code/reason |
| Callback timing | Results arriving before or after Future registration are matched by request ID |
| Token events | Native payload reaches the listener with `reason` and nested `affectedResources.messageChannels`; listener removal stops delivery |
| Configuration and payload split | `RtmConfig` now lives in base; events live in the event-handler file; public barrel and handwritten imports resolve these types |
| Existing semantic conversions | Map/StateItem, option flattening, area/service bitmasks, stream scoping and UTF-8 buffer conversion remain in the existing renderer/overrides |
| Native child factories | History, lock, presence and storage bindings are constructed locally on the existing Iris transport; C++ interface pointers are not cast from JSON factory results |

Found and fixed a handwritten-layer inconsistency: stream text/binary publish
overrides did not catch `AgoraRtmException`, unlike generated semantic methods.
Both now return an error `RtmStatus` and null result using the shared converter.
Other exception types still propagate.

The handwritten native client adapter also supplies the four child factories.
In particular, raw `RtmClient_getHistory` is not a registered pointer-marshalling
API in the published Iris build; history operations resolve their native child
from the client internally. The regression verifies shared transport and no
factory RPC, rather than accepting an unregistered-API error in tests.

`rtm231_semantic_test.dart` uses the real native bindings, event JSON decoder,
result handler and semantic implementation; only the native transport is fake.
It supplements generated tests that mock the result handler. The codegen CI
also runs when handwritten test files change.

Run from `test_shard/integration_test_app`: `flutter test --no-pub`.
These are Dart contract checks, not Android/iOS device login, message delivery,
reconnection or QA acceptance evidence. Normal PR CI/review and candidate
builds remain required before release.
