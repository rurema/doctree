category Text

require ripper/filter
require ripper/lexer
require ripper/sexp

Ruby プログラムを解析するためのライブラリです。

= class Ripper

Ruby プログラムのパーサです。

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

--- parse(src, filename = '(ripper)', lineno = 1) -> nil

指定された文字列を解析します。常に nil を返します。

@param src Ruby プログラムを文字列か IO オブジェクトで指定します。

@param filename src のファイル名を文字列で指定します。省略すると "(ripper)" になります。

@param lineno src の開始行番号を指定します。省略すると 1 になります。

@see [[m:Ripper#parse]]

--- yydebug -> bool

yydebugの構文解析器の追跡機能が有効か無効かを返します。

--- yydebug=(flag)

yydebugの構文解析器の追跡機能が有効か無効かを指定します。

@param flag true か false を指定します。

== Instance Methods

--- parse -> nil

自身の持つ Ruby プログラムを解析します。常に nil を返します。

サブクラスでオーバライドして使用します。Ruby プログラムの解析は行います
が、そのままでは解析結果は利用できません。サブクラスでイベントハンドラ
の定義や本メソッドの戻り値の追加などで対応する必要があります。

@see [[m:Ripper.parse]]

--- column -> Integer | nil

現在のトークンの桁番号を 0 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.column を実行してください。

--- filename -> String

自身の持つ Ruby プログラムのファイル名を文字列で返します。

--- lineno -> Integer | nil

現在のトークンの行番号を 1 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.lineno を実行してください。

--- end_seen? -> bool

これまでに解析した Ruby プログラムの中に __END__ が含まれていたかどうか
を返します。

--- encoding -> Encoding

自身の持つ Ruby プログラムの文字エンコーディングを返します。

Ruby プログラムの解析前は [[m:Encoding::US_ASCII]] を返します。

== Private Instance Methods

--- warn(fmt, *args) -> nil

解析した Ruby プログラムの中に警告([[m:$-w]] が true の時だけ出力される
警告)を出力するようなものがあった場合に実行されます。

@param fmt エラーメッセージのフォーマット文字列です。

@param args エラーメッセージのフォーマットされる引数です。

サブクラスでオーバライドして使用します。

引数のエラーメッセージは printf フォーマットに従って渡されます。

--- warning(fmt, *args) -> nil

解析した Ruby プログラムの中に重要な警告([[m:$-w]] が false の時だけ出
力される警告)を出力するようなものがあった場合に実行されます。

@param fmt エラーメッセージのフォーマット文字列です。

@param args エラーメッセージのフォーマットされる引数です。

サブクラスでオーバライドして使用します。

引数のエラーメッセージは printf フォーマットに従って渡されます。

--- compile_error(msg) -> nil

解析した Ruby プログラムの中にコンパイルエラーがあった場合に実行されま
す。

@param msg エラーメッセージ。

サブクラスでオーバライドして使用します。

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
