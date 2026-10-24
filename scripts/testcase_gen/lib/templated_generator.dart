import 'package:testcase_gen/core/paraphrase.dart';
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

class EnumTemplatedTestCase extends TemplatedTestCase {
  EnumTemplatedTestCase(
      {required String testCaseFileTemplate,
      required String testCaseTemplate,
      required String outputDir,
      required String outputFileSuffixName,
      List<String> skipMemberFunctions = const []})
      : super(
          className: "",
          testCaseFileTemplate: testCaseFileTemplate,
          testCaseTemplate: testCaseTemplate,
          outputDir: outputDir,
          outputFileSuffixName: outputFileSuffixName,
          skipMemberFunctions: skipMemberFunctions,
        );
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
      } else if (templated is EnumTemplatedTestCase) {
        output = _generateEnumCasesWithTemplate(
          enums: parseResult.enums,
          testCaseTemplate: templated.testCaseTemplate,
          testCaseFileTemplate: templated.testCaseFileTemplate,
          skipEnums: templated.skipMemberFunctions,
        );
        outputFileName =
            'enums_${templated.outputFileSuffixName}.generated.dart';
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

String _generateEnumCasesWithTemplate({
  required List<Enumz> enums,
  required String testCaseTemplate,
  required String testCaseFileTemplate,
  List<String> skipEnums = const [],
}) {
  final testCases = <String>[];

  for (final enumz in enums) {
    if (skipEnums.contains(enumz.name)) {
      print('_generateEnumCasesWithTemplate skip ${enumz.name}');
      continue;
    }

    String testCase = testCaseTemplate.replaceAll(
      '{{TEST_CASE_NAME}}',
      enumz.name,
    );

    testCase = testCase.replaceAll('{{TEST_CASE_BODY}}', '''
      for (final e in ${enumz.name}.values) {
        expect(${enumz.name}.fromValue(e.value()), isA<${enumz.name}>());
        expect(${enumz.name}.fromValue(e.value()) == e, isTrue);
      }
    ''');

    testCases.add(testCase);
  }

  final output = testCaseFileTemplate.replaceAll(
    '{{TEST_CASES_CONTENT}}',
    testCases.join('\n'),
  );

  return output;
}
