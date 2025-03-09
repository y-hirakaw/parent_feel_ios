# 要件

* コードを追加した場合はビルドしてコンパイルエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。
* テストコードはswift-testingで書いてください。
* 既存コードの修正、テストコードを追加・修正した場合はテストを実行してエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。
  * ただし、現状テストコードの実行時Agentはコマンド実行完了を待てないので、テストの手動実行を依頼してください。

# このアプリで利用されているSVVSアーキテクチャについての説明
  
* SVVSでは、ViewのアクションがViewStateを通じてStoreに伝達されます。StoreはAPIやDBと通信し、シングルトンでデータを保持します。
* Storeのデータ変更はViewStateを介してViewに反映され、単方向データフローを実現します。

# 動作確認について

* ビルドは以下のコマンドで行ってください。
```
xcodebuild -scheme ParentFeel \
  -configuration Debug \
  -workspace ParentFeel/ParentFeel.xcodeproj/project.xcworkspace \
  -destination 'id=B3F517A2-0287-4161-9C05-0C71FA26DF92' \
  -allowProvisioningUpdates build | xcbeautify
```
* テストの実行は以下のコマンドで行ってください。
```
xcodebuild -scheme ParentFeel \
  -configuration Debug \
  -workspace ParentFeel/ParentFeel.xcodeproj/project.xcworkspace \
  -destination 'id=B3F517A2-0287-4161-9C05-0C71FA26DF92' \
  -destination-timeout 60 \
  -only-testing:ParentFeelTests test \
  -verbose | xcbeautify
```
テスト実行時はビルド→テスト実行するので時間がかかります。実行時は最大2分程度待機してください。

# PRのレビューコメント取得について

以下の方法で取得してください。

```
% gh api repos/{owner}/{repo}/pulls/{pull_number}/reviews
% gh api repos/{owner}/{repo}/pulls/{pull_number}/reviews/{review_id}/comments
```

{owner}=y-hirakaw
{repo}=parent_feel_ios

# PR作成について

* ghコマンドはインストール済みです。
* 以下のフォーマットで対応内容をPRに書いてください。

```
## 概要

## 変更内容

## レビュアーへの補足情報

```