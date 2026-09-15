---
library: _builtin
since: "4.1"
---
# class Ruby::SourceRange < Object

Ruby のソースコード上のある範囲を表すクラスです。

インスタンスは [m:Proc#source_range]・[m:Method#source_range]・[m:UnboundMethod#source_range]・[m:Thread::Backtrace::Location#source_range] から得られます。`Ruby::SourceRange.new` は未定義で、これらのメソッド以外から生成することはできません。ソースパス、(可能なら)絶対パス、開始行、開始のバイト単位の桁、終了行、終了のバイト単位の桁を保持します。

このクラスの主な目的は、`node_id` のような実装の詳細に依存しない形で、`Prism.find` をすべての Ruby 実装で正確に実装できるようにすることです。そのために必要な開始・終了の行と桁、および絶対パスをこのクラスが提供します。

`Prism.find` の利用者は、必要に応じて結果を調整できます。例えば [m:Ruby::SourceRange#end_line] で触れているようにヒアドキュメントの分だけ範囲を広げたり、[m:Proc#source_range] の結果に対してブロックが渡されたメソッド呼び出しまで範囲を広げたりといった調整です。

なお、返されるソース範囲は、それだけで評価可能なコード片であるとは限りません。ヒアドキュメントがメソッドの `end` を越えて続くことがあるほか、ブロックの場合は範囲が `{` や `do` から始まるためです。

## Instance Methods

### def path -> String

`self` に対応する呼び出し可能オブジェクトのソースパスを返します。[m:Proc#source_location] や [m:Method#source_location] が返す配列の最初の要素と同じものです。

```ruby title="例"
range = eval("proc {}", binding, "/tmp/sample.rb", 10).source_range
p range.path # => "/tmp/sample.rb"
```

- **SEE** [m:Ruby::SourceRange#absolute_path]

### def absolute_path -> String | nil

`self` に対応する呼び出し可能オブジェクトの絶対パスを返します。eval したコードなど、ソースが絶対パスを持たない場合は nil を返します。

```ruby title="例"
range = eval("proc {}", binding, "/tmp/sample.rb", 10).source_range
p range.absolute_path # => nil
```

- **SEE** [m:Ruby::SourceRange#path]

### def start_line -> Integer

この範囲が開始する行番号を返します。1 から数えます。

```ruby title="例"
range = eval("proc {}", binding, "/tmp/sample.rb", 10).source_range
p range.start_line # => 10
```

- **SEE** [m:Ruby::SourceRange#end_line]

### def start_column -> Integer

この範囲が開始するバイト単位の桁を返します。0 から数えます。

lambda の範囲は `->` から、ブロックの範囲は `{` または `do` から、メソッドの範囲は `def` から始まります。

```ruby title="例"
l = -> {}
p l.source_range.start_column # => 4

pr = proc {}
p pr.source_range.start_column # => 10

meth = method(def m = 42)
p meth.source_range.start_column # => 14
```

- **SEE** [m:Ruby::SourceRange#end_column]

### def end_line -> Integer

この範囲が終了する行番号を返します。1 から数えます。

呼び出し可能オブジェクトの `end` を越えて続くヒアドキュメントは範囲に含まれないことに注意してください。最後のヒアドキュメントまでの範囲を得たい場合は、`Prism.find` に `Proc`・`Method`・`UnboundMethod` を渡した結果から、子ノードの終了行・終了桁の最大値を計算してください。

```ruby title="例"
pr = proc { <<~HEREDOC }
  heredoc
  contents
HEREDOC
p pr.source_range.end_line # => 1
```

- **SEE** [m:Ruby::SourceRange#end_column]

### def end_column -> Integer

この範囲が終了するバイト単位の桁を返します。0 から数えます。

呼び出し可能オブジェクトの `end` を越えて続くヒアドキュメントは範囲に含まれないことに注意してください。最後のヒアドキュメントまでの範囲を得たい場合は、`Prism.find` に `Proc`・`Method`・`UnboundMethod` を渡した結果から、子ノードの終了行・終了桁の最大値を計算してください。

```ruby title="例"
pr = proc { <<~HEREDOC }
  heredoc
  contents
HEREDOC
p pr.source_range.end_column # => 24
```

- **SEE** [m:Ruby::SourceRange#end_line]

### def inspect -> String

[m:Ruby::SourceRange#absolute_path] が利用できればそれを、そうでなければ [m:Ruby::SourceRange#path] を使い、開始・終了の座標とあわせて人間が読みやすい形式の文字列にして返します。

```ruby title="例"
range = eval("proc {}", binding, "/tmp/sample.rb", 10).source_range
p range.inspect # => "#<Ruby::SourceRange /tmp/sample.rb:(10,5)-(10,7)>"
```
