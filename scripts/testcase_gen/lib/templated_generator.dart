import 'package:dart_style/dart_style.dart';
import 'package:paraphrase/paraphrase.dart';
import 'dart:io';

import 'package:testcase_gen/default_generator.dart';
import 'package:path/path.dart' as path;

import 'generator.dart';

abstract class TemplatedTestCase {
  TemplatedTestCase({
    required this.className,
    this.package,
    required this.testCaseFileTemplate,
    required this.testCaseTemplate,
    required this.outputDir,
    this.outputFileSuffixName = 'testcases',
    this.skipMemberFunctions = const [],
  });

  final String className;
  Uri? package;
  final String testCaseFileTemplate;
  final String testCaseTemplate;
  final String outputDir;
  final String outputFileSuffixName;
  final List<String> skipMemberFunctions;
}

class MethoCallTemplatedTestCase extends TemplatedTestCase {
  MethoCallTemplatedTestCase({
    required String className,
    Uri? package,
    required String testCaseFileTemplate,
    required String testCaseTemplate,
    required String outputDir,
    required this.methodInvokeObjectName,
    List<String> skipMemberFunctions = const [],
    required String outputFileSuffixName,
  }) : super(
          className: className,
          package: package,
          testCaseFileTemplate: testCaseFileTemplate,
          testCaseTemplate: testCaseTemplate,
          outputDir: outputDir,
          outputFileSuffixName: outputFileSuffixName,
          skipMemberFunctions: skipMemberFunctions,
        );

  final String methodInvokeObjectName;
}

class EventHandlerTemplatedTestCase extends TemplatedTestCase {
  EventHandlerTemplatedTestCase({
    required this.callerObjClassName,
    required String className,
    required String testCaseFileTemplate,
    required String testCaseTemplate,
    required String outputDir,
    required this.callerObjName,
    this.eventPrefixOverride,
    required this.registerFunctionName,
    required this.unregisterFunctionName,
    this.registerFunctionBlockBuilder,
    this.unregisterFunctionBlockBuilder,
    this.isUpperFirstCaseOfEventName = false,
    List<String> skipMemberFunctions = const [],
  }) : super(
          className: className,
          testCaseFileTemplate: testCaseFileTemplate,
          testCaseTemplate: testCaseTemplate,
          outputDir: outputDir,
          skipMemberFunctions: skipMemberFunctions,
        );

  final String callerObjClassName;
  final String callerObjName;
  final String? eventPrefixOverride;
  final String registerFunctionName;
  final String unregisterFunctionName;
  final String Function(String eventHandlerName)? registerFunctionBlockBuilder;
  final String Function(String eventHandlerName)?
      unregisterFunctionBlockBuilder;
  final bool isUpperFirstCaseOfEventName;
}

class CustomTemplatedTestCase extends MethoCallTemplatedTestCase {
  CustomTemplatedTestCase({
    required String className,
    Uri? package,
    required String testCaseFileTemplate,
    required String testCaseTemplate,
    required String outputDir,
    required String methodInvokeObjectName,
    List<String> skipMemberFunctions = const [],
    required String outputFileSuffixName,
    required this.customMethodCodeGenerator,
    this.extraArgs = const {},
  }) : super(
          className: className,
          package: package,
          testCaseFileTemplate: testCaseFileTemplate,
          testCaseTemplate: testCaseTemplate,
          outputDir: outputDir,
          outputFileSuffixName: outputFileSuffixName,
          skipMemberFunctions: skipMemberFunctions,
          methodInvokeObjectName: methodInvokeObjectName,
        );

  // final String methodInvokeObjectName;
  final String Function(
      TemplatedGenerator templatedGenerator,
      ParseResult parseResult,
      Clazz clazz,
      Method method,
      CustomTemplatedTestCase template) customMethodCodeGenerator;

  final Map<String, Object> extraArgs;
}

class TemplatedGenerator extends DefaultGenerator {
  const TemplatedGenerator(this.templatedTestCases);

  final List<TemplatedTestCase> templatedTestCases;

  Clazz getClazz(ParseResult parseResult, String className, Uri? package) {
    final classes = parseResult.getClazz(className);
    for (final cls in classes) {
      if (cls.name == className && cls.uri == package) {
        return cls;
      }
    }
    throw StateError('Can not find $className');
  }

  @override
  void generate(StringSink sink, ParseResult parseResult) {
    for (final templated in templatedTestCases) {
      String output = '';
      String outputFileName = '';
      if (templated is CustomTemplatedTestCase) {
        late Clazz clazz;
        try {
          clazz = getClazz(parseResult, templated.className, templated.package);
        } catch (e) {
          stderr.writeln('Can not find the className: ${templated.className}.');
          rethrow;
        }

        output = generateWithTemplate(
          parseResult: parseResult,
          clazz: clazz,
          testCaseTemplate: templated.testCaseTemplate,
          testCasesContentTemplate: templated.testCaseFileTemplate,
          methodInvokeObjectName: templated.methodInvokeObjectName,
          configs: const [],
          supportedPlatformsOverride: const [],
          skipMemberFunctions: templated.skipMemberFunctions,
          templated: templated,
          customMethodCodeGenerator: templated.customMethodCodeGenerator,
        );
        outputFileName =
            '${templated.className.toLowerCase()}_${templated.outputFileSuffixName}.generated.dart';
      } else if (templated is MethoCallTemplatedTestCase) {
        late Clazz clazz;
        try {
          clazz = getClazz(parseResult, templated.className, templated.package);
        } catch (e) {
          stderr.writeln('Can not find the className: ${templated.className}.');
          rethrow;
        }

        output = generateWithTemplate(
          parseResult: parseResult,
          clazz: clazz,
          testCaseTemplate: templated.testCaseTemplate,
          testCasesContentTemplate: templated.testCaseFileTemplate,
          methodInvokeObjectName: templated.methodInvokeObjectName,
          configs: const [],
          supportedPlatformsOverride: const [],
          skipMemberFunctions: templated.skipMemberFunctions,
          templated: templated,
        );
        outputFileName =
            '${templated.className.toLowerCase()}_${templated.outputFileSuffixName}.generated.dart';
      } else if (templated is EventHandlerTemplatedTestCase) {
        late Clazz templatedCallerObjClazz;
        late Clazz templatedClazz;
        try {
          templatedCallerObjClazz =
              parseResult.getClazz(templated.callerObjClassName)[0];
        } catch (e) {
          stderr.writeln(
              'Can not find the callerObjClassName: ${templated.callerObjClassName}, make sure the class name is correct.');
        }

        try {
          templatedClazz = parseResult.getClazz(templated.className)[0];
        } catch (e) {
          stderr.writeln(
              'Can not find the className: ${templated.className}, make sure the class name is correct.');
        }
        output = _generateEventHandlerCasesWithTemplate(
          parseResult: parseResult,
          callerObjClazz: templatedCallerObjClazz,
          eventHandlerClazz: templatedClazz,
          testCaseTemplate: templated.testCaseFileTemplate,
          testCasesContentTemplate: templated.testCaseTemplate,
          callerObjName: templated.callerObjName,
          eventPrefixOverride: templated.eventPrefixOverride,
          registerFunctionName: templated.registerFunctionName,
          unregisterFunctionName: templated.unregisterFunctionName,
          registerFunctionBlockBuilder: templated.registerFunctionBlockBuilder,
          unregisterFunctionBlockBuilder:
              templated.unregisterFunctionBlockBuilder,
          isUpperFirstCaseOfEventName: templated.isUpperFirstCaseOfEventName,
          skipMemberFunctions: templated.skipMemberFunctions,
        );
        outputFileName =
            '${templated.callerObjClassName.toLowerCase()}_${templated.className.toLowerCase()}_${templated.outputFileSuffixName}.generated.dart';
      }

      final fileSink = openSink(path.join(
        templated.outputDir,
        outputFileName,
      ));
      fileSink!.writeln(output);
      fileSink.flush();
    }
  }

  @override
  IOSink? shouldGenerate(ParseResult parseResult) {
    return null;
  }

  String _generateEventHandlerCasesWithTemplate({
    required ParseResult parseResult,
    required Clazz callerObjClazz,
    required Clazz eventHandlerClazz,
    required String testCaseTemplate,
    required String testCasesContentTemplate,
    String? eventPrefixOverride,
    required String callerObjName,
    required String registerFunctionName,
    required String unregisterFunctionName,
    String Function(String eventHandlerName)? registerFunctionBlockBuilder,
    String Function(String eventHandlerName)? unregisterFunctionBlockBuilder,
    required bool isUpperFirstCaseOfEventName,
    List<String> skipMemberFunctions = const [],
  }) {
    // final fields = clazz.fields;
    final eventHandlerName = 'the${eventHandlerClazz.name}';

    final testCases = <String>[];

    final registerFunctionImpl = registerFunctionBlockBuilder != null
        ? registerFunctionBlockBuilder(eventHandlerName)
        : _getMethodCallImpl(
            parseResult: parseResult,
            callerObjClazz: callerObjClazz,
            eventHandlerClazz: eventHandlerClazz,
            callerObjName: callerObjName,
            functionName: registerFunctionName,
            eventHandlerName: eventHandlerName,
          );
    final unregisterFunctionImpl = unregisterFunctionBlockBuilder != null
        ? unregisterFunctionBlockBuilder(eventHandlerName)
        : _getMethodCallImpl(
            parseResult: parseResult,
            callerObjClazz: callerObjClazz,
            eventHandlerClazz: eventHandlerClazz,
            callerObjName: callerObjName,
            functionName: unregisterFunctionName,
            eventHandlerName: eventHandlerName,
          );

    for (final field in eventHandlerClazz.fields) {
      StringBuffer bodyBuffer = StringBuffer();

      final functionParamsList = field.type.parameters
          .map((t) => '${t.type.type} ${t.name}')
          .join(', ');

      String eventName = field.name;

      if (skipMemberFunctions.contains(eventName)) {
        continue;
      }

      StringBuffer jsonBuffer = StringBuffer();
      StringBuffer pb = StringBuffer();
      _createParameterInitializedList(
          parseResult, pb, field.type.parameters, []);

      jsonBuffer.writeln('final eventJson = {');
      // for (final parameter in field.type.parameters) {
      //   if (parameter.isPrimitiveType) {
      //     final parameterType = getParamType(parameter);

      //     if (parameterType == 'Uint8List') {
      //       jsonBuffer
      //           .writeln('\'${parameter.name}\': ${parameter.name}.toList(),');
      //     } else {
      //       jsonBuffer.writeln('\'${parameter.name}\': ${parameter.name},');
      //     }
      //   } else {
      //     final bool isEnum = parseResult.hasEnum(parameter.type.type);
      //     if (isEnum) {
      //       jsonBuffer
      //           .writeln('\'${parameter.name}\': ${parameter.name}.value(),');
      //     } else {
      //       final parameterClass = parseResult.getClazz(parameter.type.type)[0];
      //       if (parameterClass.constructors.isEmpty) {
      //         continue;
      //       }
      //       jsonBuffer
      //           .writeln('\'${parameter.name}\': ${parameter.name}.toJson(),');
      //     }
      //   }
      // }
      jsonBuffer.writeln('};');

      final eventCompleterName = '${field.name}Completer';
      StringBuffer fireEventImplBuffer = StringBuffer();

      String fireEventSuffix = eventName;
      if (isUpperFirstCaseOfEventName) {
        fireEventSuffix =
            '${fireEventSuffix[0].toUpperCase()}${fireEventSuffix.substring(1)}';
      }

      final event = '${eventHandlerClazz.name}_$fireEventSuffix';
      fireEventImplBuffer.writeln('''
{
  ${pb.toString()}
  ${jsonBuffer.toString()}
  final eventIds = eventIdsMapping['$event'] ?? [];
  for (final event in eventIds) {
    final ret = irisTester().fireEvent(event, params: eventJson);
    // Delay 200 milliseconds to ensure the callback is called.
    await Future.delayed(const Duration(milliseconds: 200));
    // TODO(littlegnal): Most of callbacks on web are not implemented, we're temporarily skip these callbacks at this time.
    if (kIsWeb && ret) {
      if (!$eventCompleterName.isCompleted) {
        $eventCompleterName.complete(true);
      }
    }
  }
}
''');

      bodyBuffer.writeln('''
final $eventCompleterName = Completer<bool>();
final $eventHandlerName = ${eventHandlerClazz.name}(
  $eventName: ($functionParamsList) {
    $eventCompleterName.complete(true);
  },
);

$registerFunctionImpl

// Delay 500 milliseconds to ensure the $registerFunctionName call completed.
await Future.delayed(const Duration(milliseconds: 500));

${fireEventImplBuffer.toString()}

final eventCalled = await $eventCompleterName.future;
expect(eventCalled, isTrue);

{
  $unregisterFunctionImpl
}
// Delay 500 milliseconds to ensure the $unregisterFunctionName call completed.
await Future.delayed(const Duration(milliseconds: 500));
''');

      String testCase = testCasesContentTemplate.replaceAll(
          '{{TEST_CASE_NAME}}', '${eventHandlerClazz.name}.$eventName');
      testCase =
          testCase.replaceAll('{{TEST_CASE_BODY}}', bodyBuffer.toString());

      testCases.add(testCase);
    }

    final output = testCaseTemplate.replaceAll(
      '{{TEST_CASES_CONTENT}}',
      testCases.join('\n'),
    );

    return DartFormatter().format(output);
  }

  String _getMethodCallImpl({
    required ParseResult parseResult,
    required Clazz callerObjClazz,
    required Clazz eventHandlerClazz,
    required String callerObjName,
    required String functionName,
    required String eventHandlerName,
  }) {
    StringBuffer methodCallBuilder = StringBuffer();

    for (final method in callerObjClazz.methods) {
      final methodName = method.name;

      if (functionName == methodName) {
        StringBuffer pb = StringBuffer();

        _createParameterInitializedList(
            parseResult, pb, method.parameters, [eventHandlerClazz.name]);

        methodCallBuilder.writeln(pb.toString());
        bool isFuture = method.returnType.type == 'Future';
        methodCallBuilder
            .write('${isFuture ? 'await ' : ''}$callerObjName.$methodName(');
        for (final parameter in method.parameters) {
          final pn = parameter.type.type == eventHandlerClazz.name
              ? eventHandlerName
              : parameter.name;
          if (parameter.isNamed) {
            methodCallBuilder.write('${parameter.name}:$pn,');
          } else {
            methodCallBuilder.write('$pn, ');
          }
        }
        methodCallBuilder.write(');');

        break;
      }
    }

    return methodCallBuilder.toString();
  }

  String _createParameterInitializedList(
    ParseResult parseResult,
    StringBuffer pb,
    List<Parameter> parameters,
    List<String> skipTypes,
  ) {
    for (final parameter in parameters) {
      if (parameter.type.type == 'Function') {
        continue;
      }
      if (skipTypes.contains(parameter.type.type)) {
        continue;
      }

      if (parameter.isPrimitiveType) {
        final parameterType = getParamType(parameter);
        if (parameterType == 'Uint8List') {
          pb.writeln(
              '${getParamType(parameter)} ${parameter.name} = ${defualtValueOfType(parameter.type)};');
        } else {
          if (parameterType.startsWith('List') &&
              parameter.type.typeArguments.isNotEmpty) {
            final listBuilderBlock =
                createListBuilderBlockForList(parseResult, parameter);
            pb.writeln(listBuilderBlock);
          } else {
            pb.writeln(
                '${getParamType(parameter)} ${parameter.name} = ${defualtValueOfType(parameter.type)};');
          }
        }
      } else {
        createConstructorInitializerForMethodParameter(
            parseResult, null, parameter, pb);
      }
    }

    return pb.toString();
  }

  String generateWithTemplate({
    required ParseResult parseResult,
    required Clazz clazz,
    required String testCaseTemplate,
    required String testCasesContentTemplate,
    required String methodInvokeObjectName,
    required List<GeneratorConfig> configs,
    List<GeneratorConfigPlatform>? supportedPlatformsOverride,
    List<String> skipMemberFunctions = const [],
    required TemplatedTestCase templated,
    String Function(
            TemplatedGenerator templatedGenerator,
            ParseResult parseResult,
            Clazz clazz,
            Method method,
            CustomTemplatedTestCase template)?
        customMethodCodeGenerator,
  }) {
    final testCases = <String>[];
    for (final method in clazz.methods) {
      final methodName = method.name;

      if (skipMemberFunctions.contains(methodName)) {
        continue;
      }

      final config = getConfig(configs, methodName);
      if (config?.donotGenerate == true) continue;
      if (methodName.startsWith('_')) continue;
      if (methodName.startsWith('create')) continue;

      StringBuffer pb = StringBuffer();

      if (customMethodCodeGenerator != null) {
        final out = customMethodCodeGenerator(this, parseResult, clazz, method,
            templated as CustomTemplatedTestCase);
        pb.writeln(out);
      } else {
        for (final parameter in method.parameters) {
          if (parameter.type.type == 'Function') {
            continue;
          }
          if (parameter.isPrimitiveType) {
            final parameterType = getParamType(parameter);

            if (parameterType == 'Uint8List') {
              pb.writeln(
                  '${getParamType(parameter)} ${parameter.name} = ${defualtValueOfType(parameter.type)};');
            } else {
              if (parameterType.startsWith('List') &&
                  parameter.type.typeArguments.isNotEmpty) {
                final listBuilderBlock =
                    createListBuilderBlockForList(parseResult, parameter);
                pb.writeln(listBuilderBlock);
              } else {
                pb.writeln(
                    '${getParamType(parameter)} ${parameter.name} = ${defualtValueOfType(parameter.type)};');
              }
            }
          } else {
            createConstructorInitializerForMethodParameter(
                parseResult, null, parameter, pb);
          }
        }

        StringBuffer methodCallBuilder = StringBuffer();
        bool isFuture = method.returnType.type == 'Future';
        // methodCallBuilder.write('await screenShareHelper.$methodName(');
        methodCallBuilder.write(
            '${isFuture ? 'await ' : ''}$methodInvokeObjectName.$methodName(');
        for (final parameter in method.parameters) {
          if (parameter.isNamed) {
            methodCallBuilder.write('${parameter.name}:${parameter.name},');
          } else {
            methodCallBuilder.write('${parameter.name}, ');
          }
        }
        methodCallBuilder.write(');');

        pb.writeln(methodCallBuilder.toString());
      }

      String skipExpression = 'false';

      if (supportedPlatformsOverride != null) {
        // skipExpression =
        //     '!(${desktopPlatforms.map((e) => e.toPlatformExpression()).join(' || ')})';
        skipExpression =
            '!(${supportedPlatformsOverride.map((e) => e.toPlatformExpression()).join(' || ')})';
      } else {
        if (config != null &&
            config.supportedPlatforms.length <
                GeneratorConfigPlatform.values.length) {
          skipExpression =
              '!(${config.supportedPlatforms.map((e) => e.toPlatformExpression()).join(' || ')})';
        }
      }

      String testCase = testCaseTemplate.replaceAll(
          '{{TEST_CASE_NAME}}', '${clazz.name}.$methodName');
      testCase = testCase.replaceAll('{{TEST_CASE_BODY}}', pb.toString());
      testCase = testCase.replaceAll('{{TEST_CASE_SKIP}}', skipExpression);
      testCases.add(testCase);
    }

    final output = testCasesContentTemplate.replaceAll(
      '{{TEST_CASES_CONTENT}}',
      testCases.join('\n'),
    );

    return output;
  }
}
