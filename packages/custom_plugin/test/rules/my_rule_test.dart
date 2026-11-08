import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:custom_plugin/src/rules/my_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MyRuleTest);
  });
}

@reflectiveTest
class MyRuleTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = MyRule();
    super.setUp();
  }

  /// `await`式を指摘する。
  Future<void> test_reportsAwaitExpression() async {
    const code = '''
Future<void> f(Future<int> p) async {
  await p;
}
''';
    await assertDiagnostics(code, [
      lint(code.indexOf('await p'), 'await p'.length),
    ]);
  }

  /// `await`式が無ければ指摘しない。
  Future<void> test_ignoresAsyncFunctionWithoutAwait() async {
    const code = '''
Future<void> f(Future<int> p) async {
  p.then((_) {});
}
''';
    await assertNoDiagnostics(code);
  }

  /// `lib/`の外（`test/`）にあるファイルは指摘しない。
  Future<void> test_ignoresFileOutsideLibDir() async {
    final file = newFile('$testPackageRootPath/test/f_test.dart', '''
Future<void> f(Future<int> p) async {
  await p;
}
''');
    await assertNoDiagnosticsInFile(file.path);
  }

  /// `// ignore:` で抑制できる。
  Future<void> test_isSuppressedByIgnoreComment() async {
    const code = '''
Future<void> f(Future<int> p) async {
  // ignore: my_rule
  await p;
}
''';
    await assertNoDiagnostics(code);
  }

  /// `// ignore_for_file:` で、ファイル内の `my_rule` の指摘をすべて抑制できる。
  Future<void> test_isSuppressedByIgnoreForFileComment() async {
    const code = '''
// ignore_for_file: my_rule

Future<void> f(Future<int> p) async {
  await p;
  await p;
}
''';
    await assertNoDiagnostics(code);
  }

  /// `await for` も指摘するべきだが、今は見逃している。
  /// ルールを直したら `test_reportsAwaitFor` に名前を変える。
  Future<void> fail_test_reportsAwaitFor() async {
    const code = '''
Future<void> f(Stream<int> s) async {
  await for (final _ in s) {}
}
''';
    await assertDiagnostics(code, [
      lint(code.indexOf('await for'), 'await'.length),
    ]);
  }

  /// ファイルの読み込みを `await` するコードも指摘する。
  /// 模擬 SDK の `File` に `readAsString` がないため、今はスキップしている。
  Future<void> skip_test_reportsAwaitFileRead() async {
    const code = '''
import 'dart:io';

Future<String> f() async {
  return await File('a.txt').readAsString();
}
''';
    await assertDiagnostics(code, [
      lint(code.indexOf('await'), "await File('a.txt').readAsString()".length),
    ]);
  }
}
