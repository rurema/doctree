require ripper/filter
require ripper/lexer
require ripper/sexp

Ruby プログラムを解析するためのライブラリです。

= class Ripper

Ruby プログラムのパーサです。

以下を参照して下さい。

  * [[url:http://i.loveruby.net/w/RipperTutorial.html]]
  * [[url:http://i.loveruby.net/w/RipperTutorial.TokenStreamInterface.html]]

Ruby プログラムをテキストとして扱いたい場合、
例えばソース色付けを行いたい場合は、
[[c:Ripper::Filter]] クラスを使うとよいでしょう。

== Class Methods

--- new(src, filename = "(ripper)", lineno = 1) -> Ripper

Ripper オブジェクトを作成します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "(ripper)" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

src の解析を行うには更に [[m:Ripper#parse]] などの呼び出しが必要です。

@see [[m:Ripper.parse]], [[m:Ripper#parse]]

--- parse(src, filename = '(ripper)', lineno = 1)
#@todo

指定された文字列を解析します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "(ripper)" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

@see [[m:Ripper#parse]]

--- yydebug -> bool

yydebugの構文解析器の追跡機能が有効か無効かを返します。

--- yydebug=(flag)

yydebugの構文解析器の追跡機能の有効/無効を指定します。

@param flag true か false を指定します。

== Instance Methods

--- parse
#@todo

--- column
#@todo

--- lineno
#@todo

--- end_seen?
#@todo

== Private Instance Methods

--- warn(fmt, *args)
#@todo

--- warning(fmt, *args)
#@todo

--- compile_error(msg)
#@todo

== Constants

--- Version -> String

ripper のバージョンを文字列で返します。

--- EVENTS -> [Symbol]

ripper の扱う全てのイベント ID (シンボル) のリストを返します。

--- PARSER_EVENTS -> [Symbol]

パーサイベントのイベント ID (シンボル) のリストを返します。

--- PARSER_EVENT_TABLE -> {Symbol => Integer}

パーサイベントのイベント ID (シンボル) と対応するハンドラの引数の個数の
リストをハッシュで返します。

--- SCANNER_EVENTS -> [Symbol]

スキャナイベントのイベント ID (シンボル) のリストを返します。

--- SCANNER_EVENT_TABLE -> {Symbol => Integer}

スキャナイベントのイベント ID (シンボル) と対応するハンドラの引数の個数
のリストをハッシュで返します。
