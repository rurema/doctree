---
type: library
since: "1.9.0"
category: Text
require:
  - ripper/filter
  - ripper/lexer
  - ripper/sexp
---
Ruby プログラムを解析するためのライブラリです。

# class Ripper

Ruby プログラムのパーサです。

Ruby プログラムをテキストとして扱いたい場合、
例えばソース色付けを行いたい場合は、
[c:Ripper::Filter] クラスを使うとよいでしょう。

## Class Methods

### def new(src, filename = "(ripper)", lineno = 1) -> Ripper

Ripper オブジェクトを作成します。

- **param** `src` -- Ruby プログラムを文字列か IO オブジェクトで指定します。

- **param** `filename` -- src のファイル名を文字列で指定します。省略すると "(ripper)" になります。

- **param** `lineno` -- src の開始行番号を指定します。省略すると 1 になります。

src の解析を行うには更に [m:Ripper#parse] などの呼び出しが必要です。

- **SEE** [m:Ripper.parse], [m:Ripper#parse]

### def parse(src, filename = '(ripper)', lineno = 1) -> nil

指定された文字列を解析します。常に nil を返します。

- **param** `src` -- Ruby プログラムを文字列か IO オブジェクトで指定します。

- **param** `filename` -- src のファイル名を文字列で指定します。省略すると "(ripper)" になります。

- **param** `lineno` -- src の開始行番号を指定します。省略すると 1 になります。

- **SEE** [m:Ripper#parse]

## Instance Methods

### def parse -> nil

自身の持つ Ruby プログラムを解析します。常に nil を返します。

サブクラスでオーバライドして使用します。Ruby プログラムの解析は行います
が、そのままでは解析結果は利用できません。サブクラスでイベントハンドラ
の定義や本メソッドの戻り値の追加などで対応する必要があります。

- **SEE** [m:Ripper.parse]

### def column -> Integer | nil

現在のトークンの桁番号を 0 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.column を実行してください。

### def filename -> String

自身の持つ Ruby プログラムのファイル名を文字列で返します。

### def lineno -> Integer | nil

現在のトークンの行番号を 1 から始まる数値で返します。

このメソッドはイベントハンドラの中でのみ意味のある値を返します。イベン
トハンドラの中で self.lineno を実行してください。

### def end_seen? -> bool

これまでに解析した Ruby プログラムの中に `__END__` が含まれていたかどうか
を返します。

### def encoding -> Encoding

自身の持つ Ruby プログラムの文字エンコーディングを返します。

Ruby プログラムの解析前は [m:Encoding::US_ASCII] を返します。

### def yydebug -> bool

yydebugの構文解析器の追跡機能が有効か無効かを返します。

### def yydebug=(flag)

yydebugの構文解析器の追跡機能が有効か無効かを指定します。

- **param** `flag` -- true か false を指定します。

## Private Instance Methods

### def warn(fmt, *args) -> nil

解析した Ruby プログラムの中に警告([m:$-w] が true の時だけ出力される
警告)を出力するようなものがあった場合に実行されます。

- **param** `fmt` -- エラーメッセージのフォーマット文字列です。

- **param** `args` -- エラーメッセージのフォーマットされる引数です。

サブクラスでオーバライドして使用します。

引数のエラーメッセージは printf フォーマットに従って渡されます。

### def warning(fmt, *args) -> nil

解析した Ruby プログラムの中に重要な警告([m:$-w] が false の時だけ出
力される警告)を出力するようなものがあった場合に実行されます。

- **param** `fmt` -- エラーメッセージのフォーマット文字列です。

- **param** `args` -- エラーメッセージのフォーマットされる引数です。

サブクラスでオーバライドして使用します。

引数のエラーメッセージは printf フォーマットに従って渡されます。

### def compile_error(msg) -> nil

解析した Ruby プログラムの中にコンパイルエラーがあった場合に実行されま
す。

- **param** `msg` -- エラーメッセージ。

サブクラスでオーバライドして使用します。

## Constants

### const Version -> String

ripper のバージョンを文字列で返します。

### const EVENTS -> [Symbol]

ripper の扱う全てのイベント ID (シンボル) のリストを返します。

### const PARSER_EVENTS -> [Symbol]

パーサイベントのイベント ID (シンボル) のリストを返します。

### def PARSER_EVENT_TABLE -> {Symbol => Integer}

パーサイベントのイベント ID (シンボル) と対応するハンドラの引数の個数の
リストをハッシュで返します。

### const SCANNER_EVENTS -> [Symbol]

スキャナイベントのイベント ID (シンボル) のリストを返します。

### def SCANNER_EVENT_TABLE -> {Symbol => Integer}

スキャナイベントのイベント ID (シンボル) と対応するハンドラの引数の個数
のリストをハッシュで返します。
