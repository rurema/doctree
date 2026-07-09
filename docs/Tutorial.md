私もリファレンスを書いてみたいわ！という方のためのチュートリアルです。このエントリは定期的に見直されるべきです。

[[HowToContribute]] も見てください。

## 1. 前提知識

リファレンスの元になるデータは、doctree/の中に入っているテキストファイルです。ディレクトリ構成は以下のようになっています。

* doctree/
  * refm/
    * api/
      * src/
        * ここに標準添付ライブラリのリファレンスが含まれます。
        * _builtin/
          * 組み込みライブラリのリファレンスが含まれます。
    * capi/
      * Rubyの拡張ライブラリ用のC APIのリファレンスが含まれます。
    * doc/
      * トップページや「Ruby言語仕様」など、その他のリファレンスが含まれます。優先順位は低めです。
    * old/
      * 旧リファレンスマニュアルの雑多なコンテンツのコピーです。Webからは見られません。
  * faq/
    * 旧リファレンスマニュアルの、Ruby FAQのデータのコピーです。いまのところ、Webからは見られません。

リファレンスはRDに似た書式で書かれています。テキストファイルなので、中身を見れば、なんとなく書き方が分かると思います。正確な書式については[[ReferenceManualFormatDigest]]を参照してください。

さて、では実際にリファレンスを編集してみましょう。

## 2. GitHubでforkする

まだGitHubのアカウントを持っていない方は、[GitHub](https://github.com)から登録をしてください。

自分のアカウントでログインしましたら、以下のページにアクセスし、Forkボタンをクリックしてください。

https://github.com/rurema/doctree

"自分のアカウント名/doctree" というリポジトリが作られたことを確認してください。

## 3. リポジトリを作業ディレクトリへとcloneする

以下のコマンドを実行し、現在の開発環境にリポジトリをコピーしてください。

```
$ git clone https://github.com/自分のアカウント名/doctree.git rubydoc
$ cd ./rubydoc
```

ディレクトリ名は、ここではrubydocとしましたが、好きな名前を付けて構いません。

またディレクトリ名を指定しなくても構いません。その場合、doctreeというディレクトリ名でリポジトリがコピーされます。

なお、この時以下のようにしておくとrurema/doctreeからの修正を取り込みやすいですが、必須ではありません。

```
$ git remote add upstream https://github.com/rurema/doctree.git
$ git remote -v
origin  git@github.com:自分のアカウント名/doctree.git (fetch)
origin  git@github.com:自分のアカウント名/doctree.git (push)
upstream        https://github.com/rurema/doctree.git (fetch)
upstream        https://github.com/rurema/doctree.git (push)
```

## 4. トピックブランチを作る

以下のコマンドを実行し、今回のPull Request用の一時的なブランチを作成します。

```
$ git checkout -b ブランチ名
Switched to a new branch 'ブランチ名'
```

ブランチ名には、Pull Requestの内容を表すものにすると良いと思います。

## 5. リファレンスを編集する

リファレンスの体裁は、[[リファレンスマニュアルの書式まとめ|ReferenceManualFormatDigest]]を参考にしてください。

以下のコマンドを実行することで、編集内容の確認ができます。

```
$ git diff
```

## 6. 編集内容をプレビューする

[BitClust](https://github.com/rurema/doctree/wiki/BitClust) は Ruby リファレンスマニュアルの核となるプログラムです。 ドキュメントデータベースからウェブインターフェイス、 執筆支援ツールまで、いろいろ入ってます。
BitClust は Gem パッケージがリリースされています。

```
$ gem install refe2
```

インストール後、セットアップコマンドを実行してください。

```
$ bitclust setup
``` 

BitClustは、一つのリファレンスファイルから各バージョンごとのリファレンスを自動生成する仕組みになっています。
6.1か6.2のどちらかの方法でプレビューしてください。

typoの修正のような日本語の修正程度であれば以下のどちらも行わずともpull requestを送っていただいて問題ありません。
[[ReferenceManualFormatDigest]] にあるような書式も修正の対象となる場合はどちらかの方法で確認後にpull requestを送っていただけるとありがたいです。

もし、環境が整えられなくて困っている場合は上記は諦めてissue/pull requestのどちらかを「動作確認がまだ」である事を明記して発行していただいければ問題ありません。

### 6.1 単一ファイル

`bitclust htmlfile` コマンドで編集したファイルをhtmlファイルとして出力できます。

例えば、Ruby 2.5.0 レファレンスマニュアル、Array クラス pop メソッドをファイル名 Array\_pop.html として/tmp ディレクトリに出力する場合は以下のコマンドとなります。

```
$ bitclust htmlfile ./refm/api/src/_builtin/Array --target=Array#pop --ruby=2.5.0 > /tmp/Array_pop.html
```

出力されたhtmlファイルをお使いのブラウザーで確認してみてください。
zsh なら以下のようにすれば、一時ファイルを作成しません。

```
$ firefox =(bitclust htmlfile doctree/refm/api/src/_builtin/Array --target=Array#pop --ruby=2.5.0)
```

### 6.2 全体をプレビューする場合

以下のコマンドでデータベースのディレクトリを作ります。

```
$ bitclust -d ./db-2.5.0 init version=2.5.0 encoding=UTF-8
```

次に、以下のコマンドでデータベースを更新します。C API以外の全てのデータベースを作成します。これには数分かかることがあります。

```
$ bitclust -d ./db-2.5.0 update --stdlibtree=refm/api/src
```

「singleton object class not implemented yet」と警告が2行程出力されますが無視して問題ありません。

データベースのディレクトリ名は、ここではdb-2.5.0/としましたが、好きな名前を付けて構いません。

2.3.0や2.4.0など、Rubyの他のバージョンのリファレンスをプレビューしたい場合は、versionを変えて上記の手順を繰り返して下さい。

DBの更新後は以下のコマンドでサーバを起動し、 `http://localhost:30080/` にアクセスして確認してください。

```
$ bitclust server --database=db-2.5.0 --baseurl=""  --port=30080 --debug
```

動作確認後は Ctrl+C でサーバを終了します。

## 7. commit する

編集内容を確認しましたら、commit してください。

例えば、組み込みライブラリ Array のリファレンスを編集後に commit する場合は以下のコマンドとなります。

```
$ git add ./refm/api/src/_builtin/Array
$ git commit
```

commit のコマンド入力後、ログメッセージを記述してください。

ログメッセージは、以下の形式で書くと良いと思います。

一行目 ： 編集内容の要約

二行目 ： 空行（改行します）

三行目以下 ： 編集の具体的内容、理由など

## 8. pull request を送る

以下のコマンドを実行し、編集を加えたブランチを自分のリポジトリに作成してください。

コマンド実行後、user name と password の入力を求められるので、順に入力してください。

ただし、GitHub に SSH Key の登録をしている方は、 user name と password の入力を求められません。 詳しくは、[Generating SSH Keys（英文）](https://help.github.com/articles/generating-ssh-keys)を参照ください。

```
$ git push origin ブランチ名
Username for 'https://github.com': 自分のアカウント名
Password for 'https://自分のアカウント名@github.com':　パスワード
```
push が成功しましたら、以下のページにアクセスしてください。

```
https://github.com/自分のアカウント名/doctree
```

ページ上で、ブランチを master から編集を加えたブランチへと変更し、Compare & view　より変更を確認してください。 編集内容に問題ないようであれば、pull request ボタンをクリックしてください。

次に表示されるページにて、Send pull request ボタンをクリックすれば、作業完了です。

編集を続けて行う場合、以下のコマンドを実行し、ブランチをmasterへと変更してください。

```
$ git checkout master
Switched to branch 'master'
```

「3. リポジトリを作業ディレクトリへとcloneする」の最後の設定がしてある時に以下のコマンドを実行する事でrurema/doctreeの修正を取り込みます。

```
$ git branch
(以下のようにmasterを見ている事)
* master

$ git status
(修正がない事)

$ git fetch upstream && git merge upstream/master
```

「4. トピックブランチを作る」に戻り、編集を再開してください。