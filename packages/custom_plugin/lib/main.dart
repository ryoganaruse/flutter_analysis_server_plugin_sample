import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:custom_plugin/src/rules/avoid_await_in_lib.dart';

final plugin = SimplePlugin();

class SimplePlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(AvoidAwaitInLib());
  }

  @override
  String get name => 'simple_plugin';
}
