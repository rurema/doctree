#@since 1.9.1
require irb/src_encoding
require irb/magic-file
#@end
require readline

irb が入力を扱うためのサブライブラリです。

ユーザが直接使用するものではありません。

= reopen IRB

== Constants

--- STDIN_FILE_NAME -> "(line)"

標準入力を使用する際のファイル名を文字列で返します。

= class IRB::InputMethod < Object

抽象的な入力を表すクラスです。ライブラリ内部で使用します。

== Class Methods

--- new(file = STDIN_FILE_NAME) -> IRB::InputMethod

自身を初期化します。

== Instance Methods

--- file_name -> String

ファイル名を文字列で返します。

#@# 使用されていないようなので省略。
#@# --- prompt -> String
#@# --- prompt=(val)

--- gets

[[c:NotImplementedError]] が発生します。

@raise NotImplementedError 必ず発生します。

--- readable_atfer_eof? -> false

入力が EOF(End Of File)に達した後も読み込みが行えるかどうかを返します。

= class IRB::StdioInputMethod < IRB::InputMethod

標準入力を表すクラスです。ライブラリ内部で使用します。

== Class Methods

--- new -> IRB::StdioInputMethod

自身を初期化します。

== Instance Methods

--- gets -> String

標準入力から文字列を 1 行読み込みます。

#@# また、呼び出す度に irb のプロンプトを標準出力に表示します。

--- eof? -> bool

入力が EOF(End Of File)に達したかどうかを返します。

--- readable_atfer_eof? -> true

入力が EOF(End Of File)に達した後も読み込みが行えるかどうかを返します。

--- line(line_no) -> String

引数 line_no で指定した過去の入力を行単位で返します。

@param line_no 取得する行番号を整数で指定します。

--- encoding -> Encoding

自身の文字エンコーディングを返します。

= class IRB::FileInputMethod < IRB::InputMethod

ファイルからの入力を表すクラスです。ライブラリ内部で使用します。

== Class Methods

--- new(path) -> IRB::FileInputMethod

自身を初期化します。

@param path パスを文字列で指定します。

== Instance Methods

--- gets -> String

読み込んだファイルから文字列を 1 行読み込みます。

#@# また、呼び出す度に irb のプロンプトを標準出力に表示します。

--- encoding -> Encoding

読み込んだファイルの文字エンコーディングを返します。

= class IRB::ReadlineInputMethod < IRB::InputMethod

include Readline

readline を用いた標準入力からの入力を表すクラスです。ライブラリ内部で使
用します。[[lib:readline]] の require に失敗した場合は定義されません。

== Class Methods

--- new -> IRB::ReadlineInputMethod

自身を初期化します。

== Instance Methods

--- gets -> String

標準入力から文字列を 1 行読み込みます。

--- eof? -> bool

入力が EOF(End Of File)に達したかどうかを返します。

--- readable_atfer_eof? -> false

入力が EOF(End Of File)に達した後も読み込みが行えるかどうかを返します。

--- line(line_no) -> String

引数 line_no で指定した過去の入力を行単位で返します。

@param line_no 取得する行番号を整数で指定します。

--- encoding -> Encoding

自身の文字エンコーディングを返します。
