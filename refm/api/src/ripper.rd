require ripper/filter
require ripper/lexer
require ripper/sexp

Ruby プログラムを解析するためのライブラリです。

= class Ripper

以下を参照して下さい。

  * [[url:http://i.loveruby.net/w/RipperTutorial.html]]
  * [[url:http://i.loveruby.net/w/RipperTutorial.TokenStreamInterface.html]]

Ruby プログラムをテキストとして扱いたい場合、
例えばソース色付けを行いたい場合は、
[[c:Ripper::Filter]] クラスを使うとよいでしょう。

== Class Methods

--- new(src, filename = "(ripper)", lineno = 1)

Ripper オブジェクトを作成します。

第一引数 src には Ruby プログラム (文字列)、
第二引数 filename には src のファイル名、
第三引数 lineno には src の開始行番号を、それぞれ与えます。

--- parse(src, filename = '(ripper)', lineno = 1)

--- yydebug
--- yydebug=

== Instance Methods

--- parse

--- column

--- lineno

--- end_seen?

== Private Instance Methods

--- warn(fmt, *args)

--- warning(fmt, *args)

--- compile_error(msg)

== Constants

--- Version

--- EVENTS 

PARSER_EVENTS + SCANNER_EVENTS

--- PARSER_EVENTS

パーサイベントのイベント ID (シンボル) のリストを返します。

--- PARSER_EVENT_TABLE

--- SCANNER_EVENTS

スキャナイベントのイベント ID (シンボル) のリストを返します。

--- SCANNER_EVENT_TABLE

