---
library: _builtin
since: "4.0"
---
# class Ruby::Box < Module

クラスやモジュールをプロセス内で分離し、アプリケーションのコードやライブラリ、モンキーパッチを互いに隔離するための機能です。
Ruby 4.0 で導入されました。

`Ruby::Box` は [c:Module] のサブクラスで、その各インスタンスは 1 つの隔離された名前空間（ボックス）を表します。あるボックスの中で新しく定義したり変更したりしたクラス・モジュール・定数・グローバル変数は、そのボックスの外や他のボックスからは見えません。

`Ruby::Box` は実験的な機能です。既定では無効で、このとき [m:Ruby::Box.enabled?] は
`false` を返し、[m:Ruby::Box.new] は [c:RuntimeError] を発生させます。
利用するには、ruby プロセスの起動時に環境変数 `RUBY_BOX` に `1` を設定します。
`1` 以外の値や未設定は無効を意味します。また、プロセスの起動後に設定しても有効にはなりません。

```console
$ RUBY_BOX=1 ruby script.rb
```

有効な状態で起動すると次の警告が出力されます。
`-W:no-experimental` オプションで抑止できます。
将来のバージョンで挙動が変更される可能性があります。

```
ruby: warning: Ruby::Box is experimental, and the behavior may change in the future!
```

ボックスは [m:Ruby::Box.new] で作成し、[m:Ruby::Box#require]（あるいは
[m:Ruby::Box#require_relative] や [m:Ruby::Box#load]）でファイルをそのボックスに読み込みます。読み込んだファイルで定義されたクラス・モジュール・定数は、ボックスオブジェクト経由で参照できます。

```ruby
# foo.rb
X = 1
class Something
  def x = X
end
```

```ruby
# main.rb
box = Ruby::Box.new
box.require_relative("foo")

X = 2
p X                    # => 2
p box::X               # => 1
p box::Something.new.x # => 1
```

ボックスの中では組み込みクラスを開いて再定義できますが、その変更はボックスの外や他のボックスには影響しません。グローバル変数やトップレベルの定数・メソッドの変更も同様にボックスごとに隔離されます。

## Class Methods

### def Ruby::Box.new -> Ruby::Box

他のボックスから独立した新しいボックスを返します。

`Ruby::Box` が無効なとき（環境変数 `RUBY_BOX` に `1` を設定せずに起動したとき）は
[c:RuntimeError] が発生します。

### def Ruby::Box.enabled? -> bool

`Ruby::Box` が有効なら `true` を、無効なら `false` を返します。

環境変数 `RUBY_BOX` に `1` を設定して ruby を起動したときに `true` になります。

### def Ruby::Box.current -> Ruby::Box | nil

現在実行中のコードが属しているボックスを返します。

`Ruby::Box` が無効なときは `nil` を返します。

## Instance Methods

### def eval(code) -> object

文字列 `code` を Ruby のコードとして self（レシーバのボックス）の中で評価し、その結果を返します。

ファイルを [m:Ruby::Box#load] で読み込むのと同様に、`code` は self の中で実行されます。

### def load(path, wrap = false) -> true

`path` のファイルを self（レシーバのボックス）の中に読み込みます。

[m:Kernel?.load] と同様ですが、ファイルは self の中で実行されます。

### def require(feature) -> bool

`feature` を self（レシーバのボックス）の中に読み込みます。

[m:Kernel?.require] と同様ですが、読み込まれたファイルは self の中で実行されます。
まだ読み込まれていなければ `true` を、すでに読み込み済みなら `false` を返します。

### def require_relative(relative_feature) -> bool

`relative_feature` を self（レシーバのボックス）の中に読み込みます。

[m:Kernel?.require_relative] と同様ですが、読み込まれたファイルは self の中で実行されます。

### def load_path -> [String]

self（レシーバのボックス）のライブラリ読み込みパスを表す配列を返します。

[m:$LOAD_PATH] のボックスごとの版に相当します。

### def inspect -> String

self を表す文字列を返します。
