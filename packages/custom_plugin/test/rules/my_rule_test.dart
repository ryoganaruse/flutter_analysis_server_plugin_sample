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
}
