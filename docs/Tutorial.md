# チュートリアル

私もリファレンスを書いてみたいわ！という方のためのチュートリアルです。このエントリは定期的に見直されるべきです。

[CONTRIBUTING.md](../CONTRIBUTING.md) も見てください。

## 1. 前提知識

リファレンスの元になるデータは、doctree/ の中に入っている Markdown ファイルです。ディレクトリ構成は以下のようになっています。

* doctree/
  * manual/
    * api/
      * 標準添付ライブラリのリファレンスが含まれます（ライブラリ名のディレクトリ・ファイル）。
      * _builtin/
        * 組み込みライブラリのリファレンスが含まれます。
    * capi/
      * Ruby の拡張ライブラリ用の C API のリファレンスが含まれます。
    * doc/
      * トップページや「Ruby言語仕様」など、その他のリファレンスが含まれます。
  * refm/
    * 旧記法（RRD）時代のソースです。2026年7月に凍結されました。**編集しないでください**。

リファレンスは GitHub Flavored Markdown ベースの書式で書かれています。テキストファイルなので、中身を見れば、なんとなく書き方が分かると思います。正確な書式については [ReferenceManualFormatDigest](ReferenceManualFormatDigest.md) を参照してください。

なお、[docs.ruby-lang.org](https://docs.ruby-lang.org/ja/) の各ページ下部の編集リンクから、そのページに対応する `manual/` のファイルへ直接飛べます。

さて、では実際にリファレンスを編集してみましょう。

## 2. GitHub で fork する

まだ GitHub のアカウントを持っていない方は、[GitHub](https://github.com) から登録をしてください。

自分のアカウントでログインしましたら、以下のページにアクセスし、Fork ボタンをクリックしてください。

https://github.com/rurema/doctree

"自分のアカウント名/doctree" というリポジトリが作られたことを確認してください。

## 3. リポジトリを作業ディレクトリへと clone する

以下のコマンドを実行し、現在の開発環境にリポジトリをコピーしてください。

```
$ git clone https://github.com/自分のアカウント名/doctree.git rubydoc
$ cd ./rubydoc
```

ディレクトリ名は、ここでは rubydoc としましたが、好きな名前を付けて構いません。
指定しなければ doctree というディレクトリ名でコピーされます。

なお、この時以下のようにしておくと rurema/doctree からの修正を取り込みやすいですが、必須ではありません。

```
$ git remote add upstream https://github.com/rurema/doctree.git
```

## 4. トピックブランチを作る

以下のコマンドを実行し、今回の Pull Request 用の一時的なブランチを作成します。

```
$ git switch -c ブランチ名
```

ブランチ名には、Pull Request の内容を表すものにすると良いと思います。

## 5. リファレンスを編集する

`manual/` 配下の `.md` ファイルを編集します。
リファレンスの体裁は、[リファレンスマニュアルの書式まとめ](ReferenceManualFormatDigest.md) を参考にしてください。

以下のコマンドを実行することで、編集内容の確認ができます。

```
$ git diff
```

ファイルは Markdown なので、エディタのプレビューや GitHub 上の表示でも
おおまかな見た目を確認できます（リンクの解決などは後述のビルドが必要です）。

## 6. 編集内容をプレビューする

ドキュメントの処理には [BitClust](https://github.com/rurema/bitclust) を使います。
doctree リポジトリで `bundle install` すれば入ります。

```
$ bundle install
```

typo の修正のような日本語の修正程度であれば以下を行わずとも pull request を送っていただいて問題ありません。
[ReferenceManualFormatDigest](ReferenceManualFormatDigest.md) にあるような書式も修正の対象となる場合はプレビューで確認後に pull request を送っていただけるとありがたいです。

もし、環境が整えられなくて困っている場合は上記は諦めて issue/pull request のどちらかを「動作確認がまだ」である事を明記して発行していただければ問題ありません。

まず、対象バージョン（例: 3.4）のデータベースを生成します。数分かかることがあります。

```
$ bundle exec rake generate:3.4
```

データベースは `/tmp/db-3.4` に作られます。

### 6.1 静的 HTML で確認する場合

```
$ bundle exec rake statichtml:3.4
```

`/tmp/html/3.4/` 以下に HTML が生成されるので、ブラウザで開いて確認します。

### 6.2 サーバを起動して確認する場合

DB の生成後、以下のコマンドでサーバを起動し、 `http://localhost:30080/` にアクセスして確認してください。

```
$ bundle exec bitclust server --database=/tmp/db-3.4 --baseurl="" --port=30080 --debug
```

動作確認後は Ctrl+C でサーバを終了します。

なお、編集をデータベースに反映するには `rake generate:3.4` を再実行してください。

## 7. commit する

編集内容を確認しましたら、commit してください。

例えば、組み込みライブラリ Array のリファレンスを編集後に commit する場合は以下のコマンドとなります。

```
$ git add ./manual/api/_builtin/Array.md
$ git commit
```

commit のコマンド入力後、ログメッセージを記述してください。
ログメッセージは、以下の形式で書くと良いと思います。

* 一行目 ： 編集内容の要約
* 二行目 ： 空行
* 三行目以下 ： 編集の具体的内容、理由など

## 8. pull request を送る

以下のコマンドを実行し、編集を加えたブランチを自分のリポジトリに push してください。

```
$ git push origin ブランチ名
```

push が成功しましたら、`https://github.com/自分のアカウント名/doctree` にアクセスしてください。
push したブランチについて「Compare & pull request」ボタンが表示されるので、
変更内容を確認して pull request を作成すれば、作業完了です。

編集を続けて行う場合は master に戻り、
「3.」で upstream を設定してある場合は以下のコマンドで rurema/doctree の修正を取り込みます。

```
$ git switch master
$ git pull upstream master
```

「4. トピックブランチを作る」に戻り、編集を再開してください。
