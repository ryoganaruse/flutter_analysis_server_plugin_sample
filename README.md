Pub Workspacesを一部しか使えていないため以下のセットアップコマンドで環境構築を行なってください

## setup
```terminal
flutter pub get
cd packages/example
flutter pub get
```

## test
`custom_plugin` のカスタムルールは `analyzer_testing` の `AnalysisRuleTest` でテストしています。

```terminal
cd packages/custom_plugin
dart test
```
