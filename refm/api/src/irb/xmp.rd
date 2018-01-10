require irb
require irb/frame

#@# Author: Keiju ISHITSUKA

Ruby のソースコードとその実行結果を、行ごとに交互に表示するためのライブ
ラリです。irb を実行しなくても、使用することが出来ます。

#@# ごとけん xmp ([[ruby-list:8489]])の上位互換バージョンです.
#@# ただ, 非常に重いのでごとけん xmp では対応できない時に使用すると良いでしょう.

実行結果を得るためには、[[m:Kernel#xmp]] と、[[m:XMP#puts]] を使った方
法があります。どちらの場合も [[c:XMP]] がコンテキスト情報を保持するため、
実行結果に差分はありません。([[c:Binding]] を指定できるタイミングは違い
ます)

=== 関数(Kernel#xmp)を使って実行結果を得る

[[m:Kernel#xmp]] では、以下のように Ruby のソースコードを文字列として渡
す事で実行結果を標準出力に表示します。

  $ cat t.rb
  require "irb/xmp"
  xmp <<END
  foo = 1
  foo
  END
  $ ruby t.rb
  foo = 1
      ==>1
  foo
      ==>1

=== XMP インスタンス(XMP#puts)を使って実行結果を得る

[[m:XMP#puts]] では、以下のように Ruby のソースコードを文字列として渡す
事で実行結果を標準出力に表示します。

  $ cat t.rb
  require "irb/xmp"
  xmp = XMP.new
  xmp.puts <<END
  foo = 1
  foo
  END
  xmp.puts <<END
  foo
  END
  $ ruby t.rb
  foo = 1
      ==>1
  foo
      ==>1
  foo
      ==>1

[[c:XMP]] がコンテキスト情報を管理しているため、変数 foo を 2 度目の呼
び出しでも保持しています。[[m:Kernel#xmp]] でも同様の操作を行えます。

=== コンテキスト

[[c:XMP]] メソッド群のコンテキストは、呼び出す前のコンテキストで評価さ
れます。明示的にコンテキストを指定するとそのコンテキストで評価します。

例:

  xmp "foo", an_binding

[注意] マルチスレッドには対応していません。

=== 注意

[[lib:irb/xmp]] は内部で irb を使用する事で実行結果を表示しています
([[m:IRB::Context#prompt_mode]] で選択できる :XMP モードはそのために用
意されています)。そのため、irb プロンプト中で使用可能なコマンドを実行し
た時に実行結果を得る事ができる点に注意してください。(例. nil が返る事を
期待して conf を実行する)

= reopen Kernel

== Private Instance Methods

--- xmp(exps, bind = nil) -> XMP

引数 exps で指定されたRuby のソースコードとその実行結果を、標準出力に行
ごとに交互に表示します。

@param exps 評価するRuby のソースコードを文字列で指定します。

@param bind [[c:Binding]] オブジェクトを指定します。省略した場合は、最
            後に実行した [[m:XMP#puts]]、[[m:Kernel#xmp]] の
            [[c:Binding]] を使用します。まだ何も実行していない場合は
            [[m:Object::TOPLEVEL_BINDING]] を使用します。

= class XMP

Ruby のソースコードとその実行結果を、行ごとに交互に表示するためのクラスです。

== Class Methods

--- new(bind = nil) -> XMP

自身を初期化します。

@param bind [[c:Binding]] オブジェクトを指定します。省略した場合は、最
            後に実行した [[m:XMP#puts]]、[[m:Kernel#xmp]] の
            [[c:Binding]] を使用します。まだ何も実行していない場合は
            [[m:Object::TOPLEVEL_BINDING]] を使用します。

@see [[m:XMP#puts]]

== Instance Methods

--- puts(exps) -> nil

引数 exps で指定されたRuby のソースコードとその実行結果を、標準出力に行
ごとに交互に表示します。

@param exps 評価するRuby のソースコードを文字列で指定します。
