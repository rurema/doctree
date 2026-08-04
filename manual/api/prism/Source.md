---
library: prism
---
# class Prism::Source < Object

解析対象のソースコード全体と各行の開始オフセットの表を保持し、バイトオフセットから行番号・桁位置への変換などを提供するクラスです。
[m:Prism::ParseResult#source] で得られます。

#%since 3.4
実際に得られるインスタンスは、ASCII のみのソース向けに最適化されたサブクラス `Prism::ASCIISource` の場合があります。クラスの判定をする場合は `instance_of?` ではなく `is_a?(Prism::Source)` を使ってください。

#%end

```ruby title="例"
require "prism"

source = Prism.parse("foo = 1\nbar = 2\nbaz = foo + bar\n").source
p source.source[0, 7] # => "foo = 1"
p source.line(9)      # => 2 (バイトオフセット 9 は 2 行目)
p source.column(9)    # => 1
p source.offsets      # => [0, 8, 16, 32]
```

## Instance Methods

### def source -> String

ソースコード全体を文字列で返します。

### def slice(byte_offset, length) -> String

byte_offset から length バイト分のソースコードを返します。

- **param** `byte_offset` -- 開始バイトオフセット
- **param** `length` -- バイト数

### def line(byte_offset) -> Integer

byte_offset の位置がある行の行番号を返します。行番号は 1 から始まります。

- **param** `byte_offset` -- バイトオフセット

### def line_start(byte_offset) -> Integer

byte_offset の位置がある行の、行頭のバイトオフセットを返します。

- **param** `byte_offset` -- バイトオフセット

### def column(byte_offset) -> Integer

byte_offset の位置の、行頭からのバイト単位の桁位置(0 origin)を返します。

- **param** `byte_offset` -- バイトオフセット

### def character_offset(byte_offset) -> Integer

byte_offset に対応する、ソースコード先頭からの文字単位のオフセットを返します。

- **param** `byte_offset` -- バイトオフセット

### def character_column(byte_offset) -> Integer

byte_offset の位置の、行頭からの文字単位の桁位置(0 origin)を返します。

- **param** `byte_offset` -- バイトオフセット

### def offsets -> Array

各行の開始バイトオフセットの配列を返します。末尾にはソースコード全体のバイト数が入ります。

### def start_line -> Integer

先頭行の行番号を返します。通常は 1 です。

#%since 3.4
### def encoding -> Encoding

ソースコードのエンコーディングを返します。

### def lines -> Array

ソースコードを行ごと(改行を含む)に分割した配列を返します。

### def line_end(byte_offset) -> Integer

byte_offset の位置がある行の終端のバイトオフセット(次の行の行頭と同じ位置)を返します。

- **param** `byte_offset` -- バイトオフセット

### def byte_offset(line, column) -> Integer

行番号と桁位置からバイトオフセットを求めます。

- **param** `line` -- 行番号(1 origin)
- **param** `column` -- 行頭からのバイト単位の桁位置(0 origin)

```ruby title="例"
require "prism"

source = Prism.parse("foo = 1\nbar = 2\n").source
p source.byte_offset(2, 1) # => 9
p source.line(9)           # => 2
```

### def code_units_offset(byte_offset, encoding) -> Integer

byte_offset に対応する、指定エンコーディングのコード単位でのオフセットを返します。UTF-16 のコード単位で位置をやりとりする
LSP(Language Server Protocol)などとの連携向けです。

- **param** `byte_offset` -- バイトオフセット
- **param** `encoding` -- コード単位の基準となるエンコーディング

### def code_units_column(byte_offset, encoding) -> Integer

byte_offset の位置の、行頭からの指定エンコーディングのコード単位での桁位置を返します。

- **param** `byte_offset` -- バイトオフセット
- **param** `encoding` -- コード単位の基準となるエンコーディング

#%end
