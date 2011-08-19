require e2mmap
require irb/slex
#@# require rdoc/code_objects
#@# require rdoc/markup/simple_markup/preprocess
#@since 1.9.1
require rdoc/parser
#@else
require rdoc/parsers/parserfactory
#@end
#@since 1.9.3
require rdoc/token_stream
#@else
require rdoc/tokenstream
#@end

Ruby のソースコードを解析するためのサブライブラリです。

拡張子が .rb、.rbw のファイルを解析する事ができます。

#@since 1.9.1
= module RDoc::RubyToken
#@else
= module RubyToken
#@end

ライブラリの内部で使用します。

#@since 1.9.1
= class RDoc::RubyLex
#@else
= class RubyLex
#@end

ライブラリの内部で使用します。

= reopen RDoc

== Constants

--- GENERAL_MODIFIERS  -> [String]

ライブラリの内部で使用します。

--- CLASS_MODIFIERS    -> [String]

ライブラリの内部で使用します。

--- ATTR_MODIFIERS     -> [String]

ライブラリの内部で使用します。

--- CONSTANT_MODIFIERS -> [String]

ライブラリの内部で使用します。

--- METHOD_MODIFIERS   -> [String]

ライブラリの内部で使用します。

#@since 1.9.1
= class RDoc::Parser::Ruby < RDoc::Parser

include RDoc::RubyToken
include RDoc::TokenStream
#@since 1.9.2
include RDoc::Parser::RubyTools
#@end
#@else
= class RDoc::RubyParser

extend RDoc::ParserFactory

include RubyToken
include TokenStream
#@end

Ruby のソースコードを解析するためのクラスです。

#@since 1.9.1
== Constants

--- NORMAL -> "::"

RDoc::NormalClass type

--- SINGLE -> "<<"

RDoc::SingleClass type

#@end

== Class Methods

#@since 1.9.1
--- new(top_level, file_name, body, options, stats) -> RDoc::Parser::Ruby
#@else
--- new(top_level, file_name, body, options, stats) -> RDoc::RubyParser
#@end

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

#@since 1.9.1
@param options [[c:RDoc::Options]] オブジェクトを指定します。
#@else
@param options [[c:Options]] オブジェクトを指定します。
#@end

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- scan -> RDoc::TopLevel

Ruby のソースコードからクラス/モジュールのドキュメントを解析します。

@return [[c:RDoc::TopLevel]] オブジェクトを返します。
