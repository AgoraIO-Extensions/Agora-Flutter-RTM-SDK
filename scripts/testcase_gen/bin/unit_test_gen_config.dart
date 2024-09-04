import 'package:paraphrase/paraphrase.dart';
import 'package:testcase_gen/default_generator.dart';
import 'package:testcase_gen/templated_generator.dart';

List<TemplatedTestCase> createUnitTestCases(String outputDir) {
  List<TemplatedTestCase> templatedTestCases = [
    CustomTemplatedTestCase(
      className: 'RtmClient',
      package: Uri.tryParse('package:agora_rtm/src/agora_rtm_client.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/agora_rtm_client_impl_override.dart'
    as agora_rtm_client_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
test('{{TEST_CASE_NAME}}', () async {
    final mockRtmClientNativeBinding = MockRtmClientImplOverride();
    final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
    final (_, rtmClient) = await agora_rtm_client_impl.RtmClientImplOverride.create(
      'app_id',
      'user_id',
      rtmClientNativeBinding: mockRtmClientNativeBinding,
      rtmResultHandlerImpl: mockRtmResultHandlerImpl,
    );

    {{TEST_CASE_BODY}}

    await rtmClient.release();
  },
);
''',
      methodInvokeObjectName: 'rtmClient',
      outputDir: outputDir,
      skipMemberFunctions: [
        'addListener',
        'removeListener',
        'release',
      ],
      outputFileSuffixName: 'unit_test',
      customMethodCodeGenerator: _mockUnitTestCodeGenerator,
      extraArgs: {
        'mockNativeBindingClass': {
          'name': 'RtmClient',
          'callerName': 'mockRtmClientNativeBinding',
          'package': Uri.tryParse(
              'package:agora_rtm/src/bindings/gen/agora_rtm_client.dart'),
        }
      },
    ),
    CustomTemplatedTestCase(
      className: 'RtmLock',
      package: Uri.tryParse('package:agora_rtm/src/agora_rtm_lock.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/gen/agora_rtm_lock_impl.dart'
    as agora_rtm_lock_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
test('{{TEST_CASE_NAME}}', () async {
    final mockRtmLockNativeBinding = MockRtmLockImpl();
    final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
    RtmLock rtmLock = agora_rtm_lock_impl.RtmLockImpl(
      mockRtmLockNativeBinding,
      mockRtmResultHandlerImpl,
    );

    {{TEST_CASE_BODY}}
  },
);
''',
      methodInvokeObjectName: 'rtmLock',
      outputDir: outputDir,
      skipMemberFunctions: [
        'addListener',
        'removeListener',
        'release',
      ],
      outputFileSuffixName: 'unit_test',
      customMethodCodeGenerator: _mockUnitTestCodeGenerator,
      extraArgs: {
        'mockNativeBindingClass': {
          'name': 'RtmLock',
          'callerName': 'mockRtmLockNativeBinding',
          'package': Uri.tryParse(
              'package:agora_rtm/src/bindings/gen/agora_rtm_lock.dart'),
        }
      },
    ),
    CustomTemplatedTestCase(
      className: 'RtmPresence',
      package: Uri.tryParse('package:agora_rtm/src/agora_rtm_presence.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/gen/agora_rtm_presence_impl.dart'
    as rtm_presence_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
test('{{TEST_CASE_NAME}}', () async {
    final mockRtmPresenceNativeBinding = MockRtmPresenceImpl();
    final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
    RtmPresence rtmPresence = rtm_presence_impl.RtmPresenceImpl(
      mockRtmPresenceNativeBinding,
      mockRtmResultHandlerImpl,
    );

    {{TEST_CASE_BODY}}
  },
);
''',
      methodInvokeObjectName: 'rtmPresence',
      outputDir: outputDir,
      skipMemberFunctions: [
        'setState',
      ],
      outputFileSuffixName: 'unit_test',
      customMethodCodeGenerator: _mockUnitTestCodeGenerator,
      extraArgs: {
        'mockNativeBindingClass': {
          'name': 'RtmPresence',
          'callerName': 'mockRtmPresenceNativeBinding',
          'package': Uri.tryParse(
              'package:agora_rtm/src/bindings/gen/agora_rtm_presence.dart'),
        }
      },
    ),
    CustomTemplatedTestCase(
      className: 'RtmStorage',
      package: Uri.tryParse('package:agora_rtm/src/agora_rtm_storage.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/gen/agora_rtm_storage_impl.dart'
    as rtm_storage_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
test('{{TEST_CASE_NAME}}', () async {
    final mockRtmStorageNativeBinding = MockRtmStorageImpl();
    final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
    RtmStorage rtmStorage = rtm_storage_impl.RtmStorageImpl(
      mockRtmStorageNativeBinding,
      mockRtmResultHandlerImpl,
    );

    {{TEST_CASE_BODY}}
  },
);
''',
      methodInvokeObjectName: 'rtmStorage',
      outputDir: outputDir,
      skipMemberFunctions: [
        'addListener',
        'removeListener',
        'release',
      ],
      outputFileSuffixName: 'unit_test',
      customMethodCodeGenerator: _mockUnitTestCodeGenerator,
      extraArgs: {
        'mockNativeBindingClass': {
          'name': 'RtmStorage',
          'callerName': 'mockRtmStorageNativeBinding',
          'package': Uri.tryParse(
              'package:agora_rtm/src/bindings/gen/agora_rtm_storage.dart'),
        }
      },
    ),
    CustomTemplatedTestCase(
      className: 'StreamChannel',
      package: Uri.tryParse('package:agora_rtm/src/agora_stream_channel.dart'),
      testCaseFileTemplate: '''
$defaultHeader

import 'package:agora_rtm/agora_rtm.dart';
import 'package:agora_rtm/src/impl/gen/agora_stream_channel_impl.dart'
    as stream_channel_impl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import '../all_mocks.mocks.dart';

void testCases() {

  {{TEST_CASES_CONTENT}}
}
''',
      testCaseTemplate: '''
test('{{TEST_CASE_NAME}}', () async {
    final mockStreamChannelNativeBinding = MockStreamChannelImpl();
    final mockRtmResultHandlerImpl = MockRtmResultHandlerImpl();
    StreamChannel streamChannel = stream_channel_impl.StreamChannelImpl(
      mockStreamChannelNativeBinding,
      mockRtmResultHandlerImpl,
    );

    {{TEST_CASE_BODY}}
  },
);
''',
      methodInvokeObjectName: 'streamChannel',
      outputDir: outputDir,
      skipMemberFunctions: [],
      outputFileSuffixName: 'unit_test',
      customMethodCodeGenerator: _mockUnitTestCodeGenerator,
      extraArgs: {
        'mockNativeBindingClass': {
          'name': 'StreamChannel',
          'callerName': 'mockStreamChannelNativeBinding',
          'package': Uri.tryParse(
              'package:agora_rtm/src/bindings/gen/agora_stream_channel.dart'),
        }
      },
    ),
  ];
  return templatedTestCases;
}

String _mockUnitTestCodeGenerator(
    TemplatedGenerator templatedGenerator,
    ParseResult parseResult,
    Clazz clazz,
    Method method,
    CustomTemplatedTestCase templated) {
  void buildParameterInitList(StringBuffer initializerBuilder, Method method) {
    for (final parameter in method.parameters) {
      if (parameter.type.type == 'Function') {
        continue;
      }
      if (parameter.isPrimitiveType) {
        final parameterType = templatedGenerator.getParamType(parameter);

        if (parameterType == 'Uint8List') {
          initializerBuilder.writeln(
              '${templatedGenerator.getParamType(parameter)} ${parameter.name} = ${templatedGenerator.defualtValueOfType(parameter.type)};');
        } else {
          if (parameterType.startsWith('List') &&
              parameter.type.typeArguments.isNotEmpty) {
            final listBuilderBlock = templatedGenerator
                .createListBuilderBlockForList(parseResult, parameter);
            initializerBuilder.writeln(listBuilderBlock);
          } else {
            initializerBuilder.writeln(
                '${templatedGenerator.getParamType(parameter)} ${parameter.name} = ${templatedGenerator.defualtValueOfType(parameter.type)};');
          }
        }
      } else {
        templatedGenerator.createConstructorInitializerForMethodParameter(
            parseResult, null, parameter, initializerBuilder);
      }
    }
  }

  StringBuffer initializerBuilder = StringBuffer();
  String fakeParameterName = '';
  String mockReturnValueParamName = '';
  String mockResultHandlerReturnValue = '';
  String expectedResultHandlerReturnValue = '';
  bool shouldMockResultHandler = false;
  final fakeParameter = Parameter();
  bool shouldCheckReturnType = false;
  if (method.returnType.typeArguments.isNotEmpty) {
    String typeArgument = '';
    bool isDartRecords = false;
    if (method.returnType.typeArguments.isNotEmpty) {
      final typeArgumentType = method.returnType.typeArguments[0];
      if (typeArgumentType.positionalFields.length > 1) {
        typeArgument = typeArgumentType.positionalFields[1].type;
        isDartRecords = true;
      }
    }

    shouldMockResultHandler = parseResult.hasClass(typeArgument);

    if (shouldMockResultHandler) {
      shouldCheckReturnType = true;

      if (isDartRecords) {
        initializerBuilder.writeln(
            'const rtmStatus = RtmStatus.success(operation: \'${method.name}\');');

        final resultClassType =
            method.returnType.typeArguments[0].positionalFields[1];

        final fakeParameterName = 'the${resultClassType.type}';
        final fakeParameter = Parameter()
          ..type = method.returnType.typeArguments[0].positionalFields[1]
          ..name = fakeParameterName;

        templatedGenerator.createConstructorInitializerForMethodParameter(
            parseResult, null, fakeParameter, initializerBuilder);

        initializerBuilder.writeln(
            'final mockResultHandlerReturnValue = ($fakeParameterName, RtmErrorCode.ok);');
        mockResultHandlerReturnValue = 'mockResultHandlerReturnValue';

        initializerBuilder.writeln(
            'final expectedResultHandlerReturnValue = (rtmStatus, $fakeParameterName);');
        expectedResultHandlerReturnValue = 'expectedResultHandlerReturnValue';

        mockReturnValueParamName = 'mockRequestId';
        initializerBuilder.writeln('int $mockReturnValueParamName = 1;');
      } else {
        fakeParameterName =
            '${typeArgument[0].toLowerCase()}${typeArgument.substring(1)}';
        fakeParameter
          ..type = method.returnType.typeArguments[0]
          ..name = fakeParameterName;
        mockResultHandlerReturnValue = fakeParameterName;

        mockReturnValueParamName = 'mockRequestId';
        initializerBuilder.writeln('int $mockReturnValueParamName = 1;');

        templatedGenerator.createConstructorInitializerForMethodParameter(
            parseResult, null, fakeParameter, initializerBuilder);
      }
    } else {
      if (typeArgument != 'void') {
        Type tmpType = method.returnType.typeArguments[0];
        if (method.returnType.typeArguments[0].positionalFields.length > 1) {
          tmpType = method.returnType.typeArguments[0].positionalFields[1];
          mockReturnValueParamName = 'the$typeArgument';
        }

        fakeParameter
          ..type = tmpType
          ..name = mockReturnValueParamName;
        if (fakeParameter.type.isPrimitiveType) {
          initializerBuilder.writeln(
              '${templatedGenerator.getParamType(fakeParameter)} $mockReturnValueParamName = ${templatedGenerator.defualtValueOfType(fakeParameter.type)};');
        }
      }
    }
  }

  final mockNativeBindingClassMap = Map<String, Object>.from(
      templated.extraArgs['mockNativeBindingClass'] as Map);
  final mockNativeBindingClassName =
      mockNativeBindingClassMap['name'] as String;
  final mockNativeBindingClassCallerName =
      mockNativeBindingClassMap['callerName'] as String;
  final mockNativeBindingClassPackage =
      mockNativeBindingClassMap['package'] as Uri;

  final mockNativeBindingClass = templatedGenerator.getClazz(
      parseResult, mockNativeBindingClassName, mockNativeBindingClassPackage);

  final mockMethod = mockNativeBindingClass.methods
      .firstWhere((element) => element.name == method.name);

  final mockNativeBindingCall = StringBuffer();
  mockNativeBindingCall.writeln('{');
  buildParameterInitList(mockNativeBindingCall, mockMethod);
  final parameterListBlockBuilder = StringBuffer();
  for (final parameter in mockMethod.parameters) {
    String paramValue = parameter.name;
    if (!parameter.type.isPrimitiveType) {}

    final parameterTypeClazzes = parseResult.getClazz(parameter.type.type);
    if (parameterTypeClazzes.isNotEmpty) {
      final cls = parameterTypeClazzes[0];
      paramValue =
          'argThat(isA<${cls.name}>()${parameter.isNamed ? ', named: \'$paramValue\',' : ''})';
    } else {
      final paramType = templatedGenerator.getParamType(parameter);
      if (paramType.startsWith('List') || paramType.startsWith('Map')) {
        paramValue =
            'argThat(isA<${templatedGenerator.getParamType(parameter)}>()${parameter.isNamed ? ', named: \'$paramValue\',' : ''})';
      }
    }

    if (parameter.isNamed) {
      parameterListBlockBuilder.write('${parameter.name}:$paramValue,');
    } else {
      parameterListBlockBuilder.write('$paramValue, ');
    }
  }
  if (mockReturnValueParamName.isNotEmpty) {
    mockNativeBindingCall.writeln(
        'when($mockNativeBindingClassCallerName.${mockMethod.name}(${parameterListBlockBuilder.toString()})).thenAnswer((_) async => $mockReturnValueParamName);');
  }

  if (shouldMockResultHandler) {
    mockNativeBindingCall.writeln(
        'when(mockRtmResultHandlerImpl.request($mockReturnValueParamName)).thenAnswer((_) async => $mockResultHandlerReturnValue);');
  }

  mockNativeBindingCall.writeln('}');
  initializerBuilder.writeln(mockNativeBindingCall.toString());

  buildParameterInitList(initializerBuilder, method);

  StringBuffer methodCallBuilder = StringBuffer();

  if (shouldCheckReturnType) {
    methodCallBuilder.write('final ret = ');
  }

  bool isFuture = method.returnType.type == 'Future';
  methodCallBuilder.write(
      '${isFuture ? 'await ' : ''}${templated.methodInvokeObjectName}.${method.name}(');
  for (final parameter in method.parameters) {
    if (parameter.isNamed) {
      methodCallBuilder.write('${parameter.name}:${parameter.name},');
    } else {
      methodCallBuilder.write('${parameter.name}, ');
    }
  }
  methodCallBuilder.write(');');
  if (shouldCheckReturnType) {
    if (shouldMockResultHandler) {
      methodCallBuilder
          .write('expect(ret, $expectedResultHandlerReturnValue);');
    } else {
      methodCallBuilder.write('expect(ret, $mockReturnValueParamName);');
    }
  }
  initializerBuilder.writeln(methodCallBuilder.toString());

  return initializerBuilder.toString();
}
