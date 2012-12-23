category FileFormat

require psych/nodes
require psych/streaming
require psych/visitors
require psych/handler
require psych/tree_builder
require psych/parser
require psych/omap
require psych/set
require psych/coder
require psych/core_ext
require psych/deprecated
require psych/json
#@# 以下は autoload である事に注意。
require psych/stream

[[lib:yaml]] のバックエンドライブラリです。libyaml ベースで作成されてお
り、YAML バージョン 1.1 を扱う事ができます。

#@# 上記、libyaml が更新される事があれば、記述の変更をお願いします。

=== 概要

Psych を用いると YAML のパースと出力ができます。
これらの機能は libyaml ([[url:http://pyyaml.org/wiki/LibYAML]] を用いて
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
#@todo

The version is Psych you're using

--- LIBYAML_VERSION -> String
#@todo

The version of libyaml Psych is using

== Class Methods

#@# psych.so より。
--- libyaml_version
#@todo

Returns the version of libyaml being used

--- load(yaml) -> object
#@todo

Load +yaml+ in to a Ruby data structure.  If multiple documents are
provided, the object contained in the first document will be returned.

Example:

  Psych.load("--- a")           # => 'a'
  Psych.load("---\n - a\n - b") # => ['a', 'b']

--- parse(yaml) -> object
#@todo

Parse a YAML string in +yaml+.  Returns the first object of a YAML AST.

Example:

  Psych.parse("---\n - a\n - b") # => #<Psych::Nodes::Sequence:0x00>

[[c:Psych::Nodes]] for more information about YAML AST.

--- parse_file(filename) -> object
#@todo

Parse a file at +filename+. Returns the YAML AST.

--- parser -> Psych::Parser
#@todo

Returns a default parser

--- parse_stream(yaml)
#@todo

Parse a YAML string in +yaml+.  Returns the full AST for the YAML document.
This method can handle multiple YAML documents contained in +yaml+.

Example:

  Psych.parse_stream("---\n - a\n - b") # => #<Psych::Nodes::Stream:0x00>

See Psych::Nodes for more information about YAML AST.

--- dump(o, io = nil, options = {})
#@todo

Dump Ruby object +o+ to a YAML string.  Optional +options+ may be passed in
to control the output format.  If an IO object is passed in, the YAML will
be dumped to that IO object.

Example:

  # Dump an array, get back a YAML string
  Psych.dump(['a', 'b'])  # => "---\n- a\n- b\n"

  # Dump an array to an IO object
  Psych.dump(['a', 'b'], StringIO.new)  # => #<StringIO:0x000001009d0890>

  # Dump an array with indentation set
  Psych.dump(['a', ['b']], :indentation => 3) # => "---\n- a\n-  - b\n"

  # Dump an array to an IO with indentation set
  Psych.dump(['a', ['b']], StringIO.new, :indentation => 3)

--- dump_stream(*objects)
#@todo

Dump a list of objects as separate documents to a document stream.

Example:

  Psych.dump_stream("foo\n  ", {}) # => "--- ! \"foo\\n  \"\n--- {}\n"

--- to_json(o) -> String
#@todo

Dump Ruby object +o+ to a JSON string.

--- load_stream(yaml)
#@todo

Load multiple documents given in +yaml+.  Returns the parsed documents
as a list.  For example:

  Psych.load_stream("--- foo\n...\n--- bar\n...") # => ['foo', 'bar']

--- load_file(filename)
#@todo

Load the document contained in +filename+.  Returns the yaml contained in
+filename+ as a ruby object

#@# 以下のメソッドについては、stopdoc が指定されているため、省略。
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

#@# 以降、psych.so より。
= class Psych::Parser

== Constants

--- ANY
#@todo

Any encoding: Let the parser choose the encoding

--- UTF8
#@todo

UTF-8 Encoding

--- UTF16LE
#@todo

UTF-16-LE Encoding with BOM

--- UTF16BE
#@todo

UTF-16-BE Encoding with BOM

== Instance Methods

--- parse(yaml)
#@todo

Parse the YAML document contained in yaml.  Events will be called on
the handler set on the parser instance.

@see [[c:Psych::Parser]], [[m:Psych::Parser#handler]]

--- mark -> Psych::Parser::Mark
#@todo

Returns a Psych::Parser::Mark object that contains line, column, and index
information.

--- external_encoding=(encoding)
#@todo

自身のエンコーディングを encoding で指定したものに設定します。

@param encoding

@raise Psych::Exception 2 回以上エンコーディングを指定した場合に発生します。

= class Psych::Handler

= class Psych::Emitter < Psych::Handler

== Class Methods

--- new(io) -> Psych::Emitter
#@todo

自身を初期化します。

== Instance Methods

--- start_stream(encoding) -> Psych::Emitter
#@todo

Start a stream emission with +encoding+

自身を返します。

@see [[m:Psych::Handler#start_stream]]

--- end_stream -> Psych::Emitter
#@todo

End a stream emission

自身を返します。

@see [[m:Psych::Handler#end_stream]]

--- start_document(version, tags, implicit) -> Psych::Emitter
#@todo

Start a document emission with YAML +version+, +tags+, and an +implicit+
start.

自身を返します。

@raise RuntimeError tag tuple の長さが 2 以下の場合に発生します。

@see [[m:Psych::Handler#start_document]]

--- end_document(implicit) -> Psych::Emitter
#@todo

End a document emission with an +implicit+ ending.

自身を返します。

@see [[m:Psych::Handler#end_document]]

--- scalar(value, anchor, tag, plain, quoted, style) -> Psych::Emitter
#@todo

Emit a scalar with +value+, +anchor+, +tag+, and a +plain+ or +quoted+
string type with +style+.

自身を返します。

@see [[m:Psych::Handler#scalar]]

--- start_sequence(anchor, tag, implicit, style) -> Psych::Emitter
#@todo

Start emitting a sequence with +anchor+, a +tag+, +implicit+ sequence
start and end, along with +style+.

自身を返します。

@see [[m:Psych::Handler#start_sequence]]

--- end_sequence -> Psych::Emitter
#@todo

End sequence emission.

自身を返します。

@see [[m:Psych::Handler#end_sequence]]

--- start_mapping(anchor, tag, implicit, style) -> Psych::Emitter
#@todo

Start emitting a YAML map with +anchor+, +tag+, an +implicit+ start
and end, and +style+.

自身を返します。

@see [[m:Psych::Handler#start_mapping]]

--- end_mapping -> Psych::Emitter
#@todo

Emit the end of a mapping.

自身を返します。

See Psych::Handler#end_mapping

--- alias(anchor) -> Psych::Emitter
#@todo

Emit an alias with +anchor+.

自身を返します。

@see [[m:Psych::Handler#alias]]

--- canonical -> bool
#@todo

Get the output style, canonical or not.

--- canonical=(bool)
#@todo

Set the output style to canonical, or not.

--- indentation -> Integer
#@todo

Get the indentation level.

--- indentation=(level)
#@todo

Set the indentation level to +level+.  The level must be less than 10 and
greater than 1.

--- line_width -> Integer
#@todo

Get the preferred line width.

--- line_width=(width)
#@todo

Set the preferred line with to +width+.
