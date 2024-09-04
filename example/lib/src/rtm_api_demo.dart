import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtm_example/src/internal/internal_config.dart' as config;

import 'log_sink.dart';

class RtmApiDemo extends StatefulWidget {
  const RtmApiDemo({super.key});

  @override
  State<RtmApiDemo> createState() => _RtmApiDemoState();
}

class _RtmApiDemoState extends State<RtmApiDemo> {
  late TextEditingController _userIdController;
  late TextEditingController _channelNameController;

  bool _isSubscribeWithMessage = true;
  bool _isSubscribeWithMetadata = false;
  bool _isSubscribeWithPresence = true;
  bool _isSubscribeWithLock = false;
  bool _isSubscribeBeQuiet = false;

  bool _isSetChannelMetadataRecordTs = false;
  bool _isSetChannelMetadataRecordUserId = false;
  late TextEditingController _setChannelMetadataLockNameController;
  late TextEditingController _setChannelMetadataRevisionController;
  late TextEditingController _setChannelMetadataMajorRevisionController;

  bool _isWhoNowIncludeUserId = true;
  bool _isWhoNowIncludeState = false;
  late TextEditingController _isWhoNowPageController;

  late TextEditingController _rtmClientMessageController;
  late TextEditingController _rtmClientPublishCustomTypeController;

  late KeyValueInputGroupWidgetController _keyValueInputGroupWidgetController;

  RtmChannelType _rtmChannelType = RtmChannelType.message;

  late RtmClient _rtmClient;

  @override
  void initState() {
    super.initState();

    _userIdController = TextEditingController();
    _channelNameController = TextEditingController(text: config.channelId);
    _rtmClientMessageController = TextEditingController();
    _setChannelMetadataLockNameController = TextEditingController();
    _setChannelMetadataRevisionController = TextEditingController();
    _setChannelMetadataMajorRevisionController = TextEditingController();
    _isWhoNowPageController = TextEditingController();
    _rtmClientPublishCustomTypeController = TextEditingController();
    _keyValueInputGroupWidgetController = KeyValueInputGroupWidgetController();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _channelNameController.dispose();
    _rtmClientMessageController.dispose();
    _setChannelMetadataLockNameController.dispose();
    _setChannelMetadataRevisionController.dispose();
    _setChannelMetadataMajorRevisionController.dispose();
    _isWhoNowPageController.dispose();
    _rtmClientPublishCustomTypeController.dispose();
    _keyValueInputGroupWidgetController.dispose();
    super.dispose();
  }

  Widget _textField(TextEditingController controller, String hintText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _button(String text, Future<void> Function() call) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          child: Text(text),
          onPressed: () {
            _logCall(text, call);
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _switch(String title, bool value, ValueChanged<bool> callback) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$title: '),
          Switch(
            value: value,
            onChanged: callback,
          )
        ]);
  }

  Widget _card(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _textField(_userIdController, 'Input user id'),
            _button('create RTM', () async {
              final (status, client) =
                  await RTM(config.appId, _userIdController.text);
              if (status.error) {
                logSink.log(
                    '[error] errorCode: ${status.errorCode}, operation: ${status.operation}, reason: ${status.reason}');
                return;
              }
              _rtmClient = client;

              logSink.log('create RTM success.');
              _rtmClient.addListener(
                linkState: (event) {
                  logSink.log('[linkState] ${event.toJson()}');
                },
                message: (event) {
                  logSink.log('[message] event: ${event.toJson()}');
                },
                presence: (event) {
                  logSink.log('[presence] event: ${event.toJson()}');
                },
                topic: (event) {
                  logSink.log('[topic] event: ${event.toJson()}');
                },
                lock: (event) {
                  logSink.log('[lock] event: ${event.toJson()}');
                },
                storage: (event) {
                  logSink.log('[storage] event: ${event.toJson()}');
                },
                token: (channelName) {
                  logSink.log('[token] channelName: $channelName');
                },
              );
              await _rtmClient.setParameters('{"rtm.log_filter":2063}');
            }),
            _textField(_channelNameController, 'Input channel name'),
            _button('RtmClient.login', () async {
              final (status, _) = await _rtmClient.login(config.token);
              logSink.log('[LoginResult] errorCode: ${status.errorCode}');
            }),
            _button('RtmClient.logout', () async {
              final (status, _) = await _rtmClient.logout();
              logSink.log('[LogoutResult] errorCode: ${status.errorCode}');
            }),
            const Text('RtmChannelType: '),
            DropdownButton<RtmChannelType>(
              items: RtmChannelType.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.toString().split('.')[1],
                        ),
                      ))
                  .toList(),
              value: _rtmChannelType,
              onChanged: (v) {
                setState(() {
                  _rtmChannelType = v!;
                });
              },
            ),
            _card(
              [
                Wrap(
                  children: [
                    _switch('withMessage', _isSubscribeWithMessage, (v) {
                      setState(() {
                        _isSubscribeWithMessage = v;
                      });
                    }),
                    _switch('withMetadata', _isSubscribeWithMetadata, (v) {
                      setState(() {
                        _isSubscribeWithMetadata = v;
                      });
                    }),
                    _switch('withPresence', _isSubscribeWithPresence, (v) {
                      setState(() {
                        _isSubscribeWithPresence = v;
                      });
                    }),
                    _switch('withLock', _isSubscribeWithLock, (v) {
                      setState(() {
                        _isSubscribeWithLock = v;
                      });
                    }),
                    _switch('beQuiet', _isSubscribeBeQuiet, (v) {
                      setState(() {
                        _isSubscribeBeQuiet = v;
                      });
                    }),
                  ],
                ),
                _button('RtmClient.subscribe', () async {
                  final (status, _) = await _rtmClient.subscribe(
                    _channelNameController.text,
                    withMessage: _isSubscribeWithMessage,
                    withMetadata: _isSubscribeWithMetadata,
                    withPresence: _isSubscribeWithPresence,
                    withLock: _isSubscribeWithLock,
                    beQuiet: _isSubscribeBeQuiet,
                  );

                  logSink
                      .log('[SubscribeResult] errorCode: ${status.errorCode}');
                }),
                _button('RtmClient.unsubscribe', () async {
                  final (status, result) =
                      await _rtmClient.unsubscribe(_channelNameController.text);

                  logSink.log(
                      '[UnsubscribeResult] channelName: ${result?.channelName}, errorCode: ${status.errorCode}');
                }),
              ],
            ),
            _card(
              [
                Wrap(
                  children: [
                    _switch('recordTs', _isSetChannelMetadataRecordTs, (v) {
                      setState(() {
                        _isSetChannelMetadataRecordTs = v;
                      });
                    }),
                    _switch('recordUserId', _isSetChannelMetadataRecordUserId,
                        (v) {
                      setState(() {
                        _isSetChannelMetadataRecordUserId = v;
                      });
                    }),
                  ],
                ),
                KeyValueInputGroupWidget(
                    controller: _keyValueInputGroupWidgetController),
                _textField(
                    _setChannelMetadataLockNameController, 'Input lock name'),
                _textField(_setChannelMetadataMajorRevisionController,
                    'Input majorRevision'),
                _textField(
                    _setChannelMetadataRevisionController, 'Input revision'),
                _button('RtmStorage.setChannelMetadata', () async {
                  final storage = _rtmClient.getStorage();
                  final (status, result) = await storage.setChannelMetadata(
                    _channelNameController.text,
                    _rtmChannelType,
                    _keyValueInputGroupWidgetController.keyValuePairs
                        .map((e) => MetadataItem(
                              key: e.key,
                              value: e.value,
                            ))
                        .toList(),
                    recordTs: _isSetChannelMetadataRecordTs,
                    recordUserId: _isSetChannelMetadataRecordUserId,
                    lockName: _setChannelMetadataLockNameController.text,
                  );

                  logSink.log(
                      '[SetChannelMetadataResult] channelName: ${result?.channelName}, channelType: ${result?.channelType}, errorCode: ${status.errorCode}');
                }),
                _button('RtmStorage.updateChannelMetadata', () async {
                  final storage = _rtmClient.getStorage();

                  final (status, result) = await storage.updateChannelMetadata(
                    _channelNameController.text,
                    _rtmChannelType,
                    _keyValueInputGroupWidgetController.keyValuePairs
                        .map((e) => MetadataItem(
                            key: e.key,
                            value: e.value,
                            revision: int.tryParse(
                                    _setChannelMetadataRevisionController
                                        .text) ??
                                0))
                        .toList(),
                    recordTs: _isSetChannelMetadataRecordTs,
                    recordUserId: _isSetChannelMetadataRecordUserId,
                    lockName: _setChannelMetadataLockNameController.text,
                  );

                  logSink.log(
                      '[UpdateChannelMetadataResult] channelName: ${result?.channelName}, channelType: ${result?.channelType}, errorCode: ${status.errorCode}');
                }),
                _button('RtmStorage.removeChannelMetadata', () async {
                  final storage = _rtmClient.getStorage();

                  final (status, result) = await storage.removeChannelMetadata(
                    _channelNameController.text,
                    _rtmChannelType,
                    metadata: _keyValueInputGroupWidgetController.keyValuePairs
                        .map((e) => MetadataItem(
                              key: e.key,
                              value: e.value,
                            ))
                        .toList(),
                    lockName: _setChannelMetadataLockNameController.text,
                  );

                  logSink.log(
                      '[RemoveChannelMetadataResult] channelName: ${result?.channelName}, channelType: ${result?.channelType}, errorCode: ${status.errorCode}');
                }),
                _button('RtmStorage.getChannelMetadata', () async {
                  final storage = _rtmClient.getStorage();
                  final (status, result) = await storage.getChannelMetadata(
                      _channelNameController.text, _rtmChannelType);

                  logSink.log(
                      '[GetChannelMetadataResult] channelName: ${result?.channelName}, channelType: ${result?.channelType}, data: ${result?.data.toJson()} errorCode: ${status.errorCode}');
                }),
              ],
            ),
            _card(
              [
                Wrap(
                  children: [
                    _switch('includeState', _isWhoNowIncludeState, (v) {
                      setState(() {
                        _isWhoNowIncludeState = v;
                      });
                    }),
                    _switch('includeUserId', _isWhoNowIncludeUserId, (v) {
                      setState(() {
                        _isWhoNowIncludeUserId = v;
                      });
                    }),
                  ],
                ),
                _textField(_isWhoNowPageController, 'Input page'),
                _button('RtmPresence.whoNow', () async {
                  final presence = _rtmClient.getPresence();
                  final (status, result) = await presence.whoNow(
                    _channelNameController.text,
                    _rtmChannelType,
                    includeState: _isWhoNowIncludeState,
                    includeUserId: _isWhoNowIncludeUserId,
                    page: _isWhoNowPageController.text,
                  );

                  logSink.log(
                      '[WhoNowResult] userStateList: [${(result?.userStateList ?? []).map((e) => e.toJson())}], nextPage: ${result?.nextPage}, errorCode: ${status.errorCode}');
                }),
              ],
            ),
            _card(
              [
                _textField(_rtmClientMessageController, 'Input message'),
                _textField(
                    _rtmClientPublishCustomTypeController, 'Input customType'),
                _button('RtmClient.publish', () async {
                  final (status, _) = await _rtmClient.publish(
                      _channelNameController.text,
                      _rtmClientMessageController.text,
                      channelType: _rtmChannelType,
                      customType: _rtmClientPublishCustomTypeController.text);

                  logSink.log('[PublishResult] errorCode: ${status.errorCode}');
                }),
                _button('RtmClient.publishBinaryMessage', () async {
                  final (status, _) = await _rtmClient.publishBinaryMessage(
                      _channelNameController.text,
                      Uint8List.fromList(
                          utf8.encode(_rtmClientMessageController.text)),
                      channelType: _rtmChannelType,
                      customType: _rtmClientPublishCustomTypeController.text);

                  logSink.log('[PublishResult] errorCode: ${status.errorCode}');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _logCall(String func, Future<void> Function() call) async {
  void log_(String log) {
    debugPrint(log);
    logSink.log(log);
  }

  log_(func);
  try {
    await call();
  } catch (e) {
    final log = '[$func] error:\n $e';
    log_(log);
  }
}

class KeyValueInputGroupWidgetPair {
  KeyValueInputGroupWidgetPair(this.key, this.value);
  final String key;
  final String value;
}

class KeyValueInputGroupWidgetController {
  final List<_Holder> _holders = [];

  List<KeyValueInputGroupWidgetPair> get keyValuePairs =>
      UnmodifiableListView(_holders.map((e) => KeyValueInputGroupWidgetPair(
          e.keyController.text, e.valueController.text)));

  void dispose() {
    for (final holder in _holders) {
      holder.keyController.dispose();
      holder.valueController.dispose();
    }

    _holders.clear();
  }
}

class KeyValueInputGroupWidget extends StatefulWidget {
  const KeyValueInputGroupWidget({super.key, required this.controller});

  final KeyValueInputGroupWidgetController controller;

  @override
  State<KeyValueInputGroupWidget> createState() =>
      _KeyValueInputGroupWidgetState();
}

class _KeyValueInputGroupWidgetState extends State<KeyValueInputGroupWidget> {
  Widget _keyValuePairInputs(_Holder holder) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.controller._holders.removeWhere((e) => e.id == holder.id);
            });
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Expanded(
          child: TextField(
            controller: holder.keyController,
            decoration: const InputDecoration(hintText: 'Input key'),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: holder.valueController,
            decoration: const InputDecoration(hintText: 'Input value'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...(widget.controller._holders.map((e) {
          return _keyValuePairInputs(e);
        }).toList()),
        ElevatedButton(
            onPressed: () {
              setState(() {
                widget.controller._holders.add(_Holder(
                    widget.controller._holders.length + 1,
                    TextEditingController(),
                    TextEditingController()));
              });
            },
            child: const Text('Add key/value')),
      ],
    );
  }
}

class _Holder {
  _Holder(this.id, this.keyController, this.valueController);
  final int id;
  final TextEditingController keyController;
  final TextEditingController valueController;
}
