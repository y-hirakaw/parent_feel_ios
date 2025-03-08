# 要件

* コードを追加・修正した場合はビルドしてコンパイルエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。
* テストコードはswift-testingで書いてください。
* テストコードを追加・修正した場合はテストを実行してエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。

# このアプリで利用されているSVVSアーキテクチャについての説明
  
* SVVSでは、ViewのアクションがViewStateを通じてStoreに伝達されます。StoreはAPIやDBと通信し、シングルトンでデータを保持します。
* Storeのデータ変更はViewStateを介してViewに反映され、単方向データフローを実現します。

# 動作確認について

* ビルドは以下のコマンドで行ってください。
```
xcodebuild -scheme ParentFeel \
  -configuration Debug \
  -workspace ParentFeel/ParentFeel.xcodeproj/project.xcworkspace \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -allowProvisioningUpdates build | xcbeautify
```
* テストは以下のコマンドで行ってください。
```
xcodebuild -scheme ParentFeel \
  -configuration Debug \
  -workspace ParentFeel/ParentFeel.xcodeproj/project.xcworkspace \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -allowProvisioningUpdates \
  -only-testing:ParentFeelTests test | xcbeautify
```