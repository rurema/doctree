---
library: optparse
---
# module OptionParser::Arguable

主に [m:Object::ARGV] を拡張するために用意されたモジュールです。
[lib:optparse] を require することにより、ARGV は
OptionParser::Arguable を [m:Object#extend] します。

コマンドライン引数を表す文字列の配列を、拡張するためにも使うことができます。

## Instance Methods

### def options=(opt)

自身をパースするための [c:OptionParser] オブジェクトをセットします。

- **param** `opt` -- 自身をパースする [c:OptionParser] 、あるいは nil か false を指定します。
           nil か false である場合、自身の options= メソッドと options メソッドを
           undef します。

### def options                -> OptionParser
### def options{|opt| ... }    -> object | nil

自身をパースするための [c:OptionParser] オブジェクトを返します。
初回呼び出し時に自動的に生成されます。
この [m:OptionParser#default_argv] には self がセットされています。

ブロックを与えた場合は、[c:OptionParser] を引数としてブロックを実行します。
ブロックの実行結果を返します。
ブロックの実行途中で [c:OptionParser::ParseError]
が発生した場合は、全て rescue し、エラーメッセージを出力し、
nil を返します。

```ruby
require 'optparse'

o = nil
ARGV.options{|opt|
  opt.on('-a'){ o = true }
  opt.parse!
}
p o                         # => true
```

#%since 3.4
### def order!(into: nil, exact: options.require_exact)               -> [String]
### def order!(into: nil, exact: options.require_exact) {|s| ... }   -> [String]
#%else
### def order!               -> [String]
### def order!{|s| ... }     -> [String]
#%end

自身を破壊的にパースし、パースされずに残った引数を文字列の配列として返します。
[m:OptionParser#order!] を参照して下さい。

#%since 3.4
`into` と `exact` のキーワード引数は [m:OptionParser#order!] にそのまま渡します。それ以外のキーワード引数を渡しても無視されます([c:ArgumentError] は発生しません)。

- **param** `into` -- オプションを格納するハッシュを指定します。[m:OptionParser#order!] の `into` と同じです。

- **param** `exact` -- 真を指定すると、ロングオプションを省略した形([m:OptionParser#require_exact] を参照)を受け付けなくなります。省略時は [m:OptionParser#require_exact] の値です。
#%end

- **raise** `OptionParser::ParseError` -- 自身のパースに失敗した場合、発生します。
                                実際は OptionParser::ParseError のサブクラスの例外になります。

```ruby
require 'optparse'

o = nil
ARGV.options.on('-a'){ o = true }
ARGV.order!
p o                                # => true
```

#%since 3.4
### def permute!(into: nil, exact: options.require_exact)   -> [String]
#%else
### def permute!             -> [String]
#%end

自身を破壊的にパースし、パースされずに残った引数を文字列の配列として返します。
[m:OptionParser#permute!] を参照して下さい。

#%since 3.4
`into` と `exact` のキーワード引数は [m:OptionParser#permute!] にそのまま渡します。それ以外のキーワード引数を渡しても無視されます([c:ArgumentError] は発生しません)。

- **param** `into` -- オプションを格納するハッシュを指定します。[m:OptionParser#permute!] の `into` と同じです。

- **param** `exact` -- 真を指定すると、ロングオプションを省略した形([m:OptionParser#require_exact] を参照)を受け付けなくなります。省略時は [m:OptionParser#require_exact] の値です。
#%end

- **raise** `OptionParser::ParseError` -- 自身のパースに失敗した場合、発生します。
                                実際は OptionParser::ParseError のサブクラスの例外になります。

```ruby
require 'optparse'

o = nil
ARGV.options.on('-a'){ o = true }
ARGV.permute!
p o                                # => true
```

#%since 3.4
### def parse!(into: nil, exact: options.require_exact)     -> [String]
#%else
### def parse!               -> [String]
#%end

自身を破壊的にパースし、パースされずに残った引数を文字列の配列として返します。
[m:OptionParser#parse!] を参照して下さい。

#%since 3.4
`into` と `exact` のキーワード引数は [m:OptionParser#parse!] にそのまま渡します。それ以外のキーワード引数を渡しても無視されます([c:ArgumentError] は発生しません)。

- **param** `into` -- オプションを格納するハッシュを指定します。[m:OptionParser#parse!] の `into` と同じです。

- **param** `exact` -- 真を指定すると、ロングオプションを省略した形([m:OptionParser#require_exact] を参照)を受け付けなくなります。省略時は [m:OptionParser#require_exact] の値です。
#%end

- **raise** `OptionParser::ParseError` -- 自身のパースに失敗した場合、発生します。
                                実際は OptionParser::ParseError のサブクラスの例外になります。

```ruby
require 'optparse'

o = nil
ARGV.options.on('-a'){ o = true }
ARGV.parse!
p o                                # => true
```

#%since 3.4

```ruby
require 'optparse'

argv = ["--verbose", "--name", "foo", "file.txt"]
argv.extend(OptionParser::Arguable)
argv.options.on("-v", "--verbose")
argv.options.on("--name NAME")
h = {}
argv.parse!(into: h)
p argv                             # => ["file.txt"]
p h                                # => {verbose: true, name: "foo"}
```

#%end

#%since 3.4
### def getopts(short_opt, *long_opt, symbolize_names: false, exact: options.require_exact)    -> Hash
#%end
#%version 3.3...3.4
### def getopts(short_opt, *long_opt, symbolize_names: false)    -> Hash
#%end
#%until 3.3
### def getopts(short_opt, *long_opt)    -> Hash
#%end

指定された short_opt や long_opt に応じて自身をパースし、結果を Hash として返します。

コマンドラインに - もしくは -- を指定した場合、それ以降の解析を行ないません。

#%since 3.4
`symbolize_names` と `exact` 以外のキーワード引数を渡しても無視されます([c:ArgumentError] は発生しません)。

#%end

- **param** `short_opt` -- ショートネームのオプション(-f や -fx)を文字列で指定します。オプションが -f と -x の
                 2つの場合は "fx" の様に指定します。ここでオプションがないときは空文字列を指定します。
                 オプションが引数をとる場合は直後に ":" を付けます。

- **param** `long_opt` -- ロングネームのオプション(--version や --bufsize=512)を文字列で指定をします。
                オプションが引数をとる場合は後ろに ":" を付けます。
                オプションの引数のデフォルト値を ":" の直後に指定できます。
                例えば、"bufsize:1024" となります。

#%since 3.3
- **param** `symbolize_names` -- true を指定すると、戻り値の Hash はキーがシンボルになります。false を指定した場合、戻り値の Hash はキーが文字列になります。
#%end

#%since 3.4
- **param** `exact` -- 真を指定すると、ロングオプションを省略した形([m:OptionParser#require_exact] を参照)を受け付けなくなります。省略時は [m:OptionParser#require_exact] の値です。
#%end

- **raise** `OptionParser::ParseError` -- 自身のパースに失敗した場合、発生します。
                                実際は OptionParser::ParseError のサブクラスの例外になります。

```ruby title="t.rb"
require 'optparse'
params = ARGV.getopts("ab:", "foo", "bar:", "bufsize:1024")
p params
```

```console
# 実行結果
$ ruby t.rb -b 1 --foo  --bar xxx -- -a
#%since 3.4
{"bufsize" => "1024", "a" => false, "b" => "1", "foo" => true, "bar" => "xxx"}  # "a" => false であることに注意。
#%else
{"bufsize"=>"1024", "a"=>false, "b"=>"1", "foo"=>true, "bar"=>"xxx"}  # "a"=>false であることに注意。
#%end
```
