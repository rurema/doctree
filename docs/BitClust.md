[[BitClust]] は新リファレンスマニュアルの核となるプログラムです。
ドキュメントデータベースからウェブインターフェイス、
執筆支援ツールまで、いろいろ入ってます。
計画に参加するメンバーは必ず入手しておいてください。

## 入手方法

[[BitClust]] は Git レポジトリと Gem パッケージで公開されています。
Git レポジトリからの入手方法については [[GitRepository]] を見てください。

tar.gz や zip で提供していたパッケージ版の提供は不定期に行うので、最新のドキュメントが読みたい人は web 版を見るか Gem パッケージ版を使用して自分でドキュメントを生成してください。

## インストール

Gem パッケージがリリースされています。

ReFe2 だけ使用したい人は以下のコマンドでインストールすることができます。

```
$ gem install refe2
```

るりまのリリース作業など読んだり使ったりするだけでは物足りない人は
以下のコマンドで関連するパッケージを全てインストールすることができます。

```
$ gem install bitclust-core bitclust-dev refe2
```

## 使用方法

[[Phase2WorkingScheme]] などが参考になります。

また各コマンドに --help を付けて起動するとオプションの簡単な説明が表示されます。

## 主要コマンド

<dl>
<dt>bitclust</dt>
<dd>
リファレンスデータベースの更新、表示、検索などを行う。
以下の「bitclust サブコマンド」の項も参照。
</dd>
<dt>refe</dt>
<dd>[[BitClust]] データベースに対応した ReFe (ReFe2)。</dd>
</dl>

## bitclust サブコマンド

$HOME/.bitclust/config がある場合は、```-d```オプションは省略可能です。

### ユーザー向け

<dl>
<dt>bitclust setup</dt>
<dd>
設定ファイルの初期化と [[BitClust]] データベースの初期化・生成を実行します。
今のところ git コマンドに PATH が通っている必要があります。
</dd>
</dl>

例

```
bitclust setup
```

<dl>
</dd>
<dt>bitclust init</dt>
<dd>
[[BitClust]] データベースを初期化する。
setup があるので内部を理解している人以外は使わない。
</dd>
</dl>

例

```
bitclust -d ./db-1_9_3 init version=1.9.3 encoding=utf-8
```

<dl>
<dt>bitclust update</dt>
<dd>BitClust データベースを更新する。</dl>
</dl>

例

```
bitclust -d ./db-1_9_3 update --stdlibtree=../doctree/refm/api/src
bitclust -d ./db-1_9_3 --capi update ../doctree/refm/capi/src/*
```

<dl>
<dt>bitclust list</dt>
<dd>特定の種類のエントリをリストする。</dd>
</dl>

例

```
bitclust -d ./db list --library
bitclust -d ./db list --class
bitclust -d ./db list --method
bitclust -d ./db --capi list --function
```

<dl>
<dt>bitclust lookup</dt>
<dd>指定されたエントリの内容を出力する。</dd>
</dl>

例

```
bitclust -d ./db lookup --library=_builtin
bitclust -d ./db lookup --class=Object
bitclust -d ./db lookup --method=Object#inspect
bitclust -d ./db lookup --method=Object#inspect --html
bitclust -d ./db --capi lookup --function=rb_ary_new3
```

<dl>
<dt>bitclust search</dt>
<dd>refe と同じ(refeの本体)。</dd>
</dl>

例

```
bitclust -d ./db search Object#inspect
bitclust -d ./db --capi search rb_ary_new3
```

### 開発者向け

<dl>
<dt>bitclust ancestors</dt>
<dd>クラスの継承階層をRubyとBitClustのDB間で比較する。</dd>
<dt>bitclust htmlfile</dt>
<dd>リファレンスの1ファイルを HTML に変換する。データベースの更新なしにhtmlへの変換結果が見られて便利。</dd>
</dl>

例

```
bitclust htmlfile --target=Range Range > t.html
bitclust htmlfile ../doctree/refm/api/src/_builtin/Array --target Array > t.html
bitclust htmlfile ../doctree/refm/api/src/net/https.rd > a.html
bitclust htmlfile src/zlib/GzipReader                              #ライブラリGzipReader
bitclust htmlfile src/zlib/GzipReader --target=Zlib::GZipReader    #クラスGzipReader
bitclust htmlfile --force mkmf.rd                                  #ファイルの全体を強制的に出力する
bitclust htmlfile --ruby=1.8.6 --target=Array Array > t.html       #rubyのバージョンを指定
bitclust htmlfile --capi ../doctree/refm/capi/src/array.c.rd --target=rb_ary_new3 # C API では現状 --target 必須
```

<dl>
<dt>bitclust query</dt>
<dt>bitclust property</dt>
<dd>データベースプロパティを操作する。</dd>
</dl>

例

```
bitclust -d ./db property --list
bitclust -d ./db property --get encoding
bitclust -d ./db property --set encoding euc-jp
```

<dt>bitclust preproc</dt>
<dd>プリプロセスだけを行う</dd>
<dt>bitclust extract</dt>
<dd>リファレンスファイルに含まれるメソッドエントリをリストする</dd>
<dt>bitclust classes</dt>
<dd>システムに存在する全 ruby について、定義されているクラスを表示する</dd>
<dt>bitclust methods</dt>
<dd>
システムに存在する全 ruby について、定義されているメソッドを表示する。
るりまの *.rd ファイルに書かれてあるメソッドに不足がないかもチェックできる。
 -c をつけると不足しているメソッドの ri の内容が表示される。
ライブラリに対して使うときは -r オプションが必須。
[<a href="http://www.fdiary.net/ml/ruby-reference-manual/msg/468">ruby-reference-manual:468</a>], [<a href="http://www.fdiary.net/ml/ruby-reference-manual/msg/558">ruby-reference-manual:558</a>]
</dd>

例

```
bitclust methods Object
bitclust methods -rLIBRARY --ruby=RUBY_VERSION --diff=RDFILE CLASS_NAME
bitclust methods -rstringio --ruby=1.9.3 --diff=StringIO StringIO
ruby-1.9 -S bitclust methods --ruby=1.9.3 --diff=Object Object  -c
```

### パッケージ作成者向け

<dl>
<dt>bitclust chm</dt>
<dd>Microsoft HTML Workshop用のchm素材を出力する。</dd>
</dl>

例

```
bitclust chm -d ./db -o ~/tmp/chm    #-o省略時は ./chm に出力される
このあと、hhc.exe ~/tmp/chm/refm.hhp とするとrefm.chmができる
```

<dl>
<dt>bitclust statichtml</dt>
<dd>静的 HTML を出力する。</dd>
<dt>bitclust info</dt>
<dd>未実装。info を出力する。</dd>
</dl>

## ツール (tools/*.rb)

るりまを書く人用のツールです。gem install bitclust-devでインストールできます。

<dl>
<dt>bc-rdoc</dt>
<dd>RDoc データベースと BitClust データベースを比較処理。 [<a href="http://www.fdiary.net/ml/ruby-reference-manual/msg/468">ruby-reference-manual:468</a>]</dd>
<dt>forall-ruby</dt>
<dd>システムに存在する全 ruby について、同じコマンドラインオプションを付けて実行する</dd>
<dt>bc-convert</dt>
<dd>旧リファレンスマニュアルのファイルを BitClustフォーマットに変換します。今はもう使われていません。</dd>
</dl>

## 実装の詳細

* [[BitClustDatabase]]
* [[ClassReferenceManualFormat]]
