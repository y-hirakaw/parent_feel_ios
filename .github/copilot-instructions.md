# このソースコードの説明

* このアプリはSwiftで書かれたiOSアプリです。
  * 親が子育ての中でどのような感情が生まれたかを記録できます。
  * オプションで子どもがどのような行動をしたか、その時自分はどうしたかを入力でき、メモ欄もあります。

# 要件

* コードを追加した場合はビルドしてコンパイルエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。
* テストコードはswift-testingで書いてください。XCTestは極力書かないでください。
  * ViewStateのテストは必ず書いてください。
* 既存コードの修正、テストコードを追加・修正した場合はテストを実行してエラーが発生していないか確認し、エラーがある場合は解消してから再度ビルドして確かめてください。
  * ただし、現状テストコードの実行時Agentはコマンド実行完了を待てない場合があるので、一度実行して結果を取得できない場合はテストの手動実行を依頼してください。
* 意図の把握が難しい関数がある場合はSwiftDocを記載してください。可能なら意図がわかるように実装してください。
* このアプリのプライマリー言語は日本語ですが、英語も対応しています。日本語のテキストを追加した場合は英語対応も必要です。

# このアプリで利用されているSVVSアーキテクチャについての説明
  
* SVVSでは、ViewのアクションがViewStateを通じてStoreに伝達されます。StoreはAPIやDBと通信し、シングルトンでデータを保持します。
* Storeのデータ変更はViewStateを介してViewに反映され、単方向データフローを実現します。

# テストコードについての補足

* ViewStateのテストコードはstructの定義の上に`@MainActor`が必要です。

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

## 手動でテストが必要な箇所(チェックボックス有りで最大10個)

```