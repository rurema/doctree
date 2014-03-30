私もリファレンスを書いてみたいわ！という方のためのチュートリアルです。このエントリは定期的に見直されるべきです。

[[HowToContribute]] も見てください。

## 1. ダウンロード

BitClust の Gem をインストースしてドキュメントのソースをリポジトリから取ってきます。

```
$ gem install bitclust-core bitclust-dev refe2
$ git clone git://github.com/rurema/doctree.git rubydoc
```

## 2. データベースの作成

BitClustは、一つのリファレンスファイルから各バージョンごとのリファレンスを自動生成する仕組みになっています。

まず、以下のコマンドでデータベースのディレクトリを作ります。(typoの修正くらいならデータベースを作る必要はありません)

```
$ cd rubydoc/refm/api
$ bitclust -d ./db-2.0.0 init version=2.0.0 encoding=UTF-8
```
次に、以下のコマンドでデータベースを更新します。これには数分かかることがあります。

```
$ bitclust -d ./db-2.0.0 update --stdlibtree=src
```
データベースのディレクトリ名は、ここではdb-2.0.0/としましたが、好きな名前を付けて構いません。

1.8.7や1.9.3など、Rubyの他のバージョンのリファレンスを書きたい場合は、versionを変えて上記の手順を繰り返して下さい。

## 3. リファレンスの記述

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

TODO

### 3.1 GitHubでforkする

まだGitHubのアカウントを持っていない方は、[GitHub](https://github.com)から登録をしてください。

自分のアカウントでログインしましたら、以下のページにアクセスし、Forkボタンをクリックしてください。

https://github.com/rurema/doctree

"自分のアカウント名/doctree" というリポジトリが作られたことを確認してください。

### 3.2 リポジトリを作業ディレクトリへとcloneする

以下のコマンドを実行し、現在の開発環境にリポジトリをコピーしてください。

```
$ git clone https://github.com/rurema/doctree.git rubydoc
$ cd ./rubydoc
```

ディレクトリ名は、ここではrubydocとしましたが、好きな名前を付けて構いません。

またディレクトリ名を指定しなくても構いません。その場合、doctreeというディレクトリ名でリポジトリがコピーされます。

### 3.3 トピックブランチを作る

以下のコマンドを実行し、今回のPull Request用の一時的なブランチを作成します。

```
$ git checkout -b ブランチ名
Switched to a new branch 'ブランチ名'
```
ブランチ名には、Pull Requestの内容を表すものにすると良いと思います。

### 3.4 リファレンスを編集する

リファレンスの体裁は、[[リファレンスマニュアルの書式まとめ|ReferenceManualFormatDigest]]を参考にしてください。

以下のコマンドを実行することで、編集内容の確認ができます。

```
$ git diff
```

### 3.5 編集内容をプレビューする

編集したファイルをhtmlファイルとして出力できます。

例えば、ruby1.9.2 レファレンスマニュアル、Array クラス pop メソッドをファイル名 Array\_pop.html として/tmp ディレクトリに出力する場合は以下のコマンドとなります。

```
$ bitclust htmlfile ./refm/api/src/_builtin/Array --target=Array#pop --ruby=1.9.2 > /tmp/Array_pop.html
```
出力されたhtmlファイルをお使いのブラウザーで確認してみてください。

### 3.6 commit する

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

### 3.7 pull request を送る

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

ページ上で、ブランチを master から編集を加えたブランチへと変更し、Comapare & view　より変更を確認してください。 編集内容に問題ないようであれば、pull request ボタンをクリックしてください。

次に表示されるページにて、Send pull request ボタンをクリックすれば、作業完了です。

編集を続けて行う場合、以下のコマンドを実行し、ブランチをmasterへと変更してください。

```
$ git checkout master
Switched to branch 'master'
```

「3.3 トピックブランチを作る」に戻り、編集を再開してください。

## 4. プレビュー

```
$ bitclust htmlfile doctree/refm/api/src/_builtin/Array --target=Array#pop --ruby=1.9.2 > /tmp/a.html
```
zsh なら以下のようにすれば、一時ファイルを作成しません。

```
$ firefox =(bitclust htmlfile doctree/refm/api/src/_builtin/Array --target=Array#pop --ruby=1.9.2)
```

## 5. パッチを送る

るりまプロジェクトは Redmine でチケット管理を行っています。まずは[アカウントを作成](http://redmine.ruby-lang.org/account/register)してください。

ログインすると、「新しいチケット」というメニューが増えて、チケットを新規作成できるようになります。

各項目は以下のように設定してください。

<dl>
<dt>題名</dt>
<dd>どのメソッドやライブラリに関する修正かわかるようなタイトルをつけて下さい。</dd>
<dt>説明</dt>
<dd>変更内容を書いてください。</dd>
<dt>カテゴリ</dt>
<dd>普通の修正依頼の場合は、docを選べばOKです。リンク切れの報告の場合はdoc:brokenlinkにしてください。</dd>
<dt>ruby_version</dt>
<dd>Rubyの特定のバージョンに限る場合は、1.9.3, 2.0.0, 2.1.0, あるいは 1.9 や 2.0 などと書きます。分かる場合だけで構いません。</dd>
<dt>ファイル</dt>
<dd>ここにパッチファイルを添付します。</dd>
</dl>

その他の項目は、デフォルトのままで構いません。
