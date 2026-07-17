---
library: rake
---
# reopen String

## Public Instance Methods

### def ext(newext = '') -> String

自身の拡張子を与えられた拡張子で置き換えます。

自身に拡張子が無い場合は、与えられた拡張子を追加します。
与えられた拡張子が空文字列の場合は、自身の拡張子を削除します。

- **param** `newext` -- 新しい拡張子を指定します。

```ruby title="例"
require "rake"

p "hoge".ext(".rb")        # => "hoge.rb"
p "hoge.rb".ext(".erb")    # => "hoge.erb"
p "hoge.tar.gz".ext(".bz2")  # => "hoge.tar.bz2"
```

### def pathmap(spec = nil){ ... } -> String

与えられた書式指定文字列に応じてパス(自身)を変換します。

与えられた書式指定文字列は変換の詳細を制御します。
指定できる書式指定文字列は以下の通りです。

- **`%p`**:
  完全なパスを表します。
- **`%f`**:
  拡張子付きのファイル名を表します。ディレクトリ名は含まれません。
- **`%n`**:
  拡張子なしのファイル名を表します。
- **`%d`**:
  パスに含まれるディレクトリのリストを表します。
- **`%x`**:
  パスに含まれるファイルの拡張子を表します。拡張子が無い場合は空文字列を表します。
- **`%X`**:
  拡張子以外すべてを表します。
- **`%s`**:
  定義されていれば、代替のファイルセパレータを表します。
  定義されてい無い場合は、標準のファイルセパレータを表します。
- **`%%`**:
  パーセント自身を表します。


%d は数値のプレフィクスを取ることができます。

```ruby title="例"
p 'a/b/c/d/file.txt'.pathmap("%2d")  # => "a/b"
p 'a/b/c/d/file.txt'.pathmap("%-2d") # => "c/d"
```

また、%d, %p, %f, %n, %x, %X には単純な文字列置換を行うための
置換パターンを表すパラメータを指定することが出来ます。
パターンと置換文字列はコンマで区切り全体を中括弧でくくります。
置換指定は、% と指示子の間に置きます。(例: "%{old,new}d")
複数の置換を行う場合はパターンをセミコロンで区切ってください。
(例: "%{old,new;src,bin}d")

正規表現や後方参照をパターンとして使用することがあるかもしれません。
中括弧、コンマ、セミコロンはパターンと置換文字列に使用しないでください。

```ruby title="例"
p "src/org/onestepback/proj/A.java".pathmap("%{^src,bin}X.class")
#=> "bin/org/onestepback/proj/A.class"
```

置換文字列に '*' を指定した場合は、置換文字列を計算するためにブロックを評価します。

```ruby title="例"
p "/path/to/file.TXT".pathmap("%X%{.*,*}x") { |ext| ext.downcase }
#=> "/path/to/file.txt"
```


## Protected Instance Methods

### def pathmap_explode -> Array

自身をパスを表す部分ごとに分解して配列にして返します。
[m:String#pathmap] で利用される protected メソッドです。

- **SEE** [m:String#pathmap]

### def pathmap_partial(n) -> String

自身から与えられた階層分パスを抜粋します。

与えられた数値が正である場合は左から、負である場合は右から抜粋します。

### def pathmap_replace(patterns){ ... } -> String

与えられたパスを前もって置き換えます。

- **param** `patterns` -- 'pat1,rep1;pat2,rep2;...' のような形式で置換パターンを指定します。


