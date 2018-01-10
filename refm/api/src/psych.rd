category FileFormat

[[lib:yaml]] のバックエンドライブラリです。libyaml ベースで作成されてお
り、YAML バージョン 1.1 を扱う事ができます。

#@# 上記、libyaml が更新される事があれば、記述の変更をお願いします。

=== 概要

Psych を用いると YAML のパースと出力ができます。
これらの機能は libyaml [[url:http://pyyaml.org/wiki/LibYAML]] を用いて
実装されています。さらに Ruby の大半のオブジェクトと YAML フォーマットの
データの間を相互に変換することができます。

=== 基本的な使いかた

  require 'psych'
  # YAML のテキストをパースする
  Psych.load("--- foo") # => "foo"

  # YAML のデータを出力
  Psych.dump("foo")     # => "--- foo\n...\n"
  { :a => 'b'}.to_yaml  # => "---\n:a: b\n"

基本的な使い方はこれだけです。簡単な用事は
[[m:Psych.load]]、[[m:Psych.dump]] で片付きます。


==== YAML のパース

Psych は YAML ドキュメントのパースができます。
ユーザの必要に応じ、高水準な API から低水準な API まで用意されています。
最も低水準なものは、イベントベースな API です。中程度の水準のものとして
YAML の AST(Abstract Syntax Tree)にアクセスする APIがあります。
高水準な API では、YAML のドキュメントを Ruby のオブジェクトに変換する
ことができます。

===== 低水準 パース API

低水準のパース API は利用者が入力となる YAML ドキュメントについて
すでに良く知っていて、AST を構築したり Ruby のオブジェクトに変換する
のが無駄である場合に使います。この API については
[[c:Psych::Parser]] を参照してください。イベントベースの API です。

===== 中水準 パース API

Psych には YAML ドキュメントの AST にアクセスする API があります。
この AST は [[c:Psych::Parser]] と [[c:Psych::TreeBuilder]] で構築します。
[[m:Psych.parse_stream]]、[[c:Psych::Nodes]]、[[c:Psych::Nodes::Node]]
などを経由して AST を解析したり操作したりできます。

===== 高水準 パース API

YAML ドキュメントをパースして Ruby のオブジェクトに変換することができます。
詳しくは [[m:Psych.load]] を見てください。


==== YAML ドキュメントの出力

Psych は YAML ドキュメントを出力する機能があります。
高・中・底の三つの水準の API があります。
低水準 API はイベントベースの API で、中水準のものは AST を構築する API、
高水準の API は Ruby のオブジェクトを直接 YAML ドキュメントに変換する API
です。これはパースの高・中・底水準 API と対応しています。


===== 低水準出力 API

低水準出力 API はイベントベースな仕組みです。
各イベントは [[c:Psych::Emitter]] オブジェクトに送られます。
このオブジェクトには、
各イベントをどのように YAML ドキュメントに変換するかをセットしておきます。
この API は出力フォーマットがあらかじめわかっている場合や性能が重要な
場合に利用します。

詳しくは [[c:Psych::Emitter]] を見てください。

=====  中水準出力 API 

中水準 API では、利用者が AST を構築し YAML ドキュメントに変換します。
この AST は YAML ドキュメントをパースして得られるものと同じものです。
詳しくは
[[c:Psych::Nodes]]、[[c:Psych::Nodes::Node]]、[[c:Psych::TreeBuilder]]
を参照してください。

===== 高水準出力 API

高水準 API を使うと Ruby のデータ構造(オブジェクト)を YAML のドキュメントに
変換できます。
詳しくは [[m:Psych.dump]] を参照してください。

= module Psych

[[lib:yaml]] のバックエンドのためのモジュールです。

== Constants

--- VERSION -> String
Psych のバージョン。

--- LIBYAML_VERSION -> String
libyaml のバージョン。

== Class Methods

--- libyaml_version -> [Integer, Integer, Integer]
libyaml のバージョンを返します。

[major, minor patch-level] という 3 つの整数からなる配列を返します。

@see [[m:Psych::LIBYAML_VERSION]]

--- load(yaml, filename = nil) -> object
YAML ドキュメントを Ruby のデータ構造(オブジェクト)に変換します。

入力に複数のドキュメントが含まれている場合は、先頭のものを変換して
返します。

filename はパース中に発生した例外のメッセージに用います。


@param yaml YAML ドキュメント(文字列 or IO オブジェクト)
@param filename [[c:Psych::SyntaxError]] 発生時にファイル名として表示する文字列。
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します
@see [[m:Psych.parse]]

=== 例
  Psych.load("--- a")           # => 'a'
  Psych.load("---\n - a\n - b") # => ['a', 'b']

  begin
    Psych.load("--- `", "file.txt")
  rescue Psych::SyntaxError => ex
    p ex.file    # => 'file.txt'
    p ex.message # => "(file.txt): found character that cannot start any token while scanning for the next token at line 1 column 5"
  end

#@since 2.0
--- safe_load(yaml, whitelist_classes = [], whitelist_symbols = [], aliases = false, filename = nil) -> object

安全に YAML YAML フォーマットの文書を読み込み Ruby のオブジェクトを生成して返します。

デフォルトでは以下のクラスのオブジェクトしか変換しません。

 * TrueClass
 * FalseClass
 * NilClass
 * Numeric
 * String
 * Array
 * Hash

再帰的なデータ構造はデフォルトでは許可されていません。
任意のクラスを許可するには whitelist_classes を指定すると、
そのクラスが追加されます。例えば Date クラスを許可するには
以下のように書いてください:

  Psych.safe_load(yaml, [Date])

すると上のクラス一覧に加えて Date クラスが読み込まれます。

エイリアスは aliases パラメーターを変更することで明示的に許可できます。

例:

  x = []
  x << x
  yaml = Psych.dump x
  Psych.safe_load yaml               # => 例外発生
  Psych.safe_load yaml, [], [], true # => エイリアスが読み込まれる

yaml にホワイトリストにないクラスが含まれていた場合は、
Psych::DisallowedClass 例外が発生します。

yaml がエイリアスを含んでいて aliases パラメーターが false の時、
Psych::BadAlias 例外が発生します。

@param io YAMLフォーマットの文書の読み込み先のIOオブジェクト。
@param whitelist_classes 追加で読み込みを許可するクラスの配列。
@param whitelist_symbols 引数 whitelist_classesに [[c:Symbol]] を含む場
                         合に読み込みを許可する [[c:Symbol]] の配列。
                         省略した場合は全ての [[c:Symbol]] を許可します。
@param aliases エイリアスの読み込みを許可するかどうか。
@param filename [[c:Psych::SyntaxError]] 発生時にファイル名として表示する文字列。
#@end

--- parse(yaml, filename = nil) -> Psych::Nodes::Document
YAML ドキュメントをパースし、YAML の AST を返します。

入力に複数のドキュメントが含まれている場合は、先頭のものを AST に変換して
返します。

filename はパース中に発生した例外のメッセージに用います。

AST については [[c:Psych::Nodes]] を参照してください。

@param yaml YAML ドキュメント(文字列 or IO オブジェクト)
@param filename [[c:Psych::SyntaxError]] 発生時にファイル名として表示する文字列。
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します
@see [[m:Psych.load]]

=== 例

  Psych.parse("---\n - a\n - b") # => #<Psych::Nodes::Document:...>

  begin
    Psych.parse("--- `", "file.txt")
  rescue Psych::SyntaxError => ex
    p ex.file    # => 'file.txt'
    p ex.message # => "(file.txt): found character that cannot start any token while scanning for the next token at line 1 column 5"
  end

--- parse_file(filename) -> Psych::Nodes::Document
filename で指定したファイルをパースして YAML の AST を返します。

@param filename パースするファイルの名前
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します

--- parser -> Psych::Parser
デフォルトで使われるのパーサを返します。


--- parse_stream(yaml) -> Psych::Nodes::Stream
--- parse_stream(yaml){|node| ... } -> ()

YAML ドキュメントをパースします。
yaml が 複数の YAML ドキュメントを含む場合を取り扱うことができます。

ブロックなしの場合は YAML の AST (すべての YAML ドキュメントを
保持した [[c:Psych::Nodes::Stream]] オブジェクト)を返します。

ブロック付きの場合は、そのブロックに最初の YAML ドキュメント
の Psych::Nodes::Document オブジェクトが渡されます。
この場合の返り値には意味がありません。


@see [[c:Psych::Nodes]]

=== 例
  Psych.parse_stream("---\n - a\n - b") # => #<Psych::Nodes::Stream:0x00>

--- dump(o, options = {}) -> String
--- dump(o, io, options = {}) -> ()
Ruby のオブジェクト o を YAML ドキュメントに変換します。

io に IO オブジェクトを指定した場合は、変換されたドキュメントが
その IO に書き込まれます。
指定しなかった場合は変換されたドキュメントが文字列としてメソッドの返り値と
なります。

options で出力に関するオプションを以下の指定できます。

#@include(psych/dump_options)

@param o 変換するオブジェクト
@param io 出力先
@param options 出力オプション

=== 例

  # Dump an array, get back a YAML string
  Psych.dump(['a', 'b'])  # => "---\n- a\n- b\n"

  # Dump an array to an IO object
  Psych.dump(['a', 'b'], StringIO.new)  # => #<StringIO:0x000001009d0890>

  # Dump an array with indentation set
  Psych.dump(['a', ['b']], :indentation => 3) # => "---\n- a\n-  - b\n"

  # Dump an array to an IO with indentation set
  Psych.dump(['a', ['b']], StringIO.new, :indentation => 3)

--- dump_stream(*objects) -> String
オブジェクト列を YAML ドキュメント列に変換します。

@param objects 変換対象のオブジェクト列

=== 例
  Psych.dump_stream("foo\n  ", {}) # => "--- ! \"foo\\n  \"\n--- {}\n"

--- to_json(o) -> String
Ruby のオブジェクト o を JSON の文字列に変換します。

@param o 変換対象となるオブジェクト

--- load_stream(yaml, filename=nil) -> [object]
--- load_stream(yaml, filename=nil){|obj| ... } -> ()
複数の YAML ドキュメントを含むデータを
Ruby のオブジェクトに変換します。

ブロックなしの場合はオブジェクトの配列を返します。

  Psych.load_stream("--- foo\n...\n--- bar\n...") # => ['foo', 'bar']

ブロックありの場合は各オブジェクト引数としてそのブロックを呼び出します。
  list = []
  Psych.load_stream("--- foo\n...\n--- bar\n...") do |ruby|
    list << ruby
  end
  list # => ['foo', 'bar']

filename はパース中に発生した例外のメッセージに用います。

@param yaml YAML ドキュメント(文字列 or IO オブジェクト)
@param filename [[c:Psych::SyntaxError]] 発生時にファイル名として表示する文字列。
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します

--- load_file(filename) -> object
filename で指定したファイルを YAML ドキュメントとして
Ruby のオブジェクトに変換します。

@param filename ファイル名
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します

--- load_documents(yaml) ->[object]
--- load_documents(yaml){|obj| ... } -> ()
複数の YAML ドキュメントを含むデータを
Ruby のオブジェクトに変換します。
このメソッドは deprecated です。[[m:Psych.load_stream]] を代わりに
使ってください。

@param yaml YAML ドキュメント(文字列 or IO オブジェクト)
@raise Psych::SyntaxError YAMLドキュメントに文法エラーが発見されたときに発生します

#@# Deprecated methods, no documents in psych lib
#@# --- quick_emit
#@# --- detect_implicit
#@# --- add_ruby_type
#@# --- add_private_type
#@# --- tagurize
#@# --- read_type_class
#@# --- object_maker

#@# For internal use, :nodoc:
#@# --- add_domain_type(domain, type_tag, &block)
#@# --- add_builtin_type(type_tag, &block)
#@# --- remove_type(type_tag)
#@# --- add_tag(tag, klass)
#@# --- load_tags
#@# --- load_tags=(val)
#@# --- dump_tags
#@# --- dump_tags=(val)
#@# --- domain_types
#@# --- domain_types=(val)

= class Psych::Exception < RuntimeError
Psych 関連のエラーを表す例外です。

= class Psych::BadAlias < Psych::Exception
YAML の alias が不正である(本体が見つからない)というエラーを表す例外です。

= class Psych::SyntaxError < SyntaxError
YAML の文法エラーを表すクラスです。

== Instance Methods
--- file -> String|nil
エラーが生じたファイルの名前を返します。

[[m:Psych.load_file]] で指定したファイルの名前や
[[m:Psych.load]] の第2引数で指定した名前が返されます。
パース時にファイル名を指定しなかった場合は nil が返されます。

--- line -> Integer
エラーが生じた行番号を返します。

--- column -> Integer
エラーが生じた行内の位置を返します。

--- offset -> Integer
エラーが生じた位置の offset をバイト数で
返します。

offset とは、
[[m:Psych::SyntaxError#line]], [[m:Psych::SyntaxError#column]] 
で指示される位置からの相対位置です。
この位置から 0 バイトの位置でエラーが発生することが多いため、
このメソッドはしばしば 0 を返します。

--- problem -> String
生じたエラーの中身を文字列で返します。

--- context -> String
エラーが生じたコンテキストを文字列で返します。

= class Psych::Set < Hash
YAML の unordered set を表すクラスです。

= class Psych::Omap < Hash
YAML の ordered mapping を表すクラスです。

#@include(psych/Psych__Parser)
#@include(psych/Psych__Handler)
#@include(psych/Psych__TreeBuilder)
#@include(psych/Psych__Nodes)
#@include(psych/Psych__Visitors)
#@include(psych/Psych__Stream)
#@include(psych/Psych__ScalarScanner)
#@include(psych/core_ext.rd)
