Ruby のソースコードを解析するためのサブライブラリです。

= module RubyToken

ライブラリの内部で使用します。

= class RubyLex

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

= class RDoc::RubyParser

extend RDoc::ParserFactory
include RubyToken
#@# include TokenStream

Extract code elements from a source file, returning a TopLevel
object containing the constituent file elements.

This file is based on rtags

== Class Methods

--- new(top_level, file_name, body, options, stats) -> RDoc::RubyParser

自身を初期化します。

@param top_level [[c:RDoc::TopLevel]] オブジェクトを指定します。

@param file_name ファイル名を文字列で指定します。

@param body ソースコードの内容を文字列で指定します。

@param options [[c:RDoc::Options]] オブジェクトを指定します。

@param stats [[c:RDoc::Stats]] オブジェクトを指定します。

== Instance Methods

--- scan -> RDoc::TopLevel

Rubyのソースコードからクラス/モジュールのドキュメントを解析します。

@return RDoc::TopLevel オブジェクトを返します。
