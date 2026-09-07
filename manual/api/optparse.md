---
type: library
category: CommandLine
---
コマンドラインのオプションを取り扱うためのライブラリです。

#%include(optparse/optparse-tut)

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

- **param** `eq` -- self が管理するエラーのあったオプションの一覧の先頭を置き換えるかどうかを指定します。

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

### def additional -> object | nil
### def additional=(additional)

`self` のエラーメッセージに追加する情報を作る、呼び出し可能オブジェクトです。

[m:OptionParser::ParseError#message] は、この値が nil でなければ、
エラーの原因となった引数を渡してこれを呼び出し、その結果をエラーメッセージの末尾に追加します。
デフォルトは nil です。[m:OptionParser#parse] などのパース時に発生する例外では、
綴りの近い候補を提示するメッセージを組み立てる [c:Proc] が自動的に設定されます。

- **param** `additional` -- エラーメッセージに追加する情報を作る、呼び出し可能オブジェクトを指定します。

```ruby
require "optparse"

opts = OptionParser.new
opts.on("--foobar")
begin
  opts.parse!(["--foobaz"])
rescue OptionParser::ParseError => e
  e.additional = proc {|arg| " (hint for #{arg})" }
  puts e.message   # => invalid option: --foobaz (hint for foobaz)
end
```

- **SEE** [m:OptionParser::ParseError#message]

## Class Methods

### def OptionParser::ParseError.filter_backtrace(array) -> [String]

array で指定されたバックトレースから optparse ライブラリに関する行を除外します。

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
