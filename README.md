Pub Workspacesを一部しか使えていないため以下のセットアップコマンドで環境構築を行なってください

Flutter 3.47.8（Dart 3.13.7）で動作を確認しています（`.fvmrc` で指定。FVM を使う場合は `fvm flutter` / `fvm dart` で実行してください）。

## setup
```terminal
flutter pub get
cd packages/example
flutter pub get
```

## test
`custom_plugin` のカスタムルールは `analyzer_testing` の `AnalysisRuleTest` でテストしています。リポジトリのルートから実行してください。

```terminal
cd packages/custom_plugin
dart test
```
