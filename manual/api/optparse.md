---
type: library
category: CommandLine
---
コマンドラインのオプションを取り扱うためのライブラリです。

#@include(optparse/optparse-tut)

# class OptionParser::ParseError < StandardError

OptionParser の例外クラスの基底クラスです。

## Instance Methods

### def recover(argv) -> Array

argv の先頭に self.args を戻します。

argv を返します。

- **param** `argv` -- [m:OptionParser#parse] に渡したオブジェクトなどの配列を指定します。

- **return** -- argv を返します。

### def set_option(opt, eq) -> self

エラーのあったオプションを指定します。

eq が真の場合、self が管理するエラーのあったオプションの一覧の先頭を
opt で置き換えます。そうでない場合は先頭に opt を追加します。

- **param** `opt` -- エラーのあったオプションを指定します。

- **param** `eq` -- self が管理するエラーのあったオプションの一覧の先頭を置き換え
          るかどうかを指定します。

- **return** -- self を返します。

### def args -> Array

エラーのあったオプションの一覧を配列で返します。

- **return** -- エラーのあったオプションの一覧。

### def reason -> String

エラーの内容を文字列で返します。

- **return** -- 文字列を返します。

### def reason=(reason)

エラーの内容を指定します。

- **param** `reason` -- 文字列を指定します。

### def inspect -> String

自身を人間が読みやすい形の文字列表現にして返します。

- **return** -- 文字列を返します。

- **SEE** [m:Object#inspect]

### def message -> String
### def to_s    -> String

標準エラーに出力するメッセージを返します。

- **return** -- 文字列を返します。

### def set_backtrace(array) -> [String]

自身に array で指定したバックトレースを設定します。

- **param** `array` -- バックトレースを文字列の配列で指定します。

- **return** -- array を返します。

## Class Methods

### def filter_backtrace(array) -> [String]

array で指定されたバックトレースから optparse ライブラリに関する行を除
外します。

デバッグモード([m:$DEBUG]が真)の場合は何もしません。

- **param** `array` -- バックトレースを文字列の配列で指定します。

- **return** -- array を返します。

# class OptionParser::AmbiguousOption < OptionParser::ParseError

補完が曖昧にしかできないオプションがあった場合に投げられます。

# class OptionParser::NeedlessArgument < OptionParser::ParseError

引数を取らないはずのオプションに引数が与えられた場合に投げられます。

# class OptionParser::MissingArgument < OptionParser::ParseError

引数が必要なオプションに引数が与えられなかった場合に投げられます。

# class OptionParser::InvalidOption < OptionParser::ParseError

定義されていないオプションが与えられた場合に投げられます。

# class OptionParser::InvalidArgument < OptionParser::ParseError

オプションの引数が指定されたパターンにマッチしない時に投げられます。

# class OptionParser::AmbiguousArgument < OptionParser::ParseError

オプションの引数が曖昧にしか補完できない場合に投げられます。

# redefine Object
## Constants
### const ARGV -> Array

Ruby スクリプトに与えられた引数を表す配列です。

[lib:optparse] を require することにより、ARGV は
OptionParser::Arguable を [m:Object#extend] します。

- **SEE** [c:OptionParser::Arguable]
