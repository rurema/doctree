---
library: fiddle
since: "3.0.0"
---
# class Fiddle::MemoryView < Object

[d:spec/memory_view] のラッパークラスです。これを使うと、メモリビューのプロデューサの内部データに Ruby レイヤからアクセスできます。

例えば [c:Fiddle::Pointer] はメモリビュープロデューサなので、 [c:Fiddle::MemoryView] でメモリビューをエクスポートさせることができます。

```ruby title="例"
ptr = Fiddle::Pointer["Hello, MemoryView"]
Fiddle::MemoryView.export(ptr) do |view|
  view.obj          # => ptr
  view.byte_size    # => 17
  view.readonly?    # => true
  view.format       # => nil
  view.item_size    # => 1
  view.ndim         # => 1
  view.shape        # => nil
  view.strides      # => nil
  view.sub_offsets  # => nil
  view.to_s         # => "Hello, MemoryView"
  view[0]           # => 72 ("H")
  view[1]           # => 101 ("e")
  view[16]          # => 119 ("w")
end
```

ポインタには `shape` などがないため、 1 次元のバイト列としてエクスポートされています。

## Singleton Methods

### def Fiddle::MemoryView.new(target) -> Fiddle::MemoryView

`target` がエクスポートしたメモリビューを保持し、 Ruby レイヤから各メンバにアクセスできるようにします。

- **param** `target` -- メモリビューをエクスポートするオブジェクトを指定します。

- **raise** `ArgumentError` -- メモリビューを取得できない場合に発生します。

### def Fiddle::MemoryView.export(target) {|view| ... } -> object

`target` がエクスポートしたメモリビューを示す [c:Fiddle::MemoryView] を作り、ブロック引数として渡します。ブロックが終了すると [#release](m:Fiddle::MemoryView#release) を呼び、メモリビューを解放します。

ブロックの結果を返します。

- **param** `target` -- メモリビューをエクスポートするオブジェクトを指定します。

- **raise** `ArgumentError` -- メモリビューを取得できない場合に発生します。

- **raise** `LocalJumpError` -- ブロックを渡さなかった場合に発生します。

## Instance Methods

### def release

メモリビューを解放します。

### def obj -> object | nil

メモリビュー経由でメモリをエクスポートしている元のオブジェクトを返します。 

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def byte_size -> Integer | nil

データのバイト数を返します。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def readonly? -> bool | nil

データが読み取り専用であれば `true` 、書き込み可能であれば `false` を返します。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def format -> String | nil

要素のフォーマットを表す文字列を返します。詳細は [d:spec/memory_view] を参照してください。

設定されていない場合は `nil` を返し、バイト列を表す `"C"` と同じ意味になります。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def item_size -> Integer | nil

各要素のバイト数を返します。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def ndim -> Integer | nil

次元数を返します。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def shape -> Array[Integer] | nil

各次元の要素数を示す、長さ [ndim](m:Fiddle::MemoryView#ndim) の配列を返します。 `ndim` が 1 の時は `nil` になることがあります。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def strides -> Array[Integer] | nil

それぞれの次元で次の要素まで進むのに何バイトスキップすればよいかを示す、長さ [ndim](m:Fiddle::MemoryView#ndim) の配列を返します。各要素は負数になることもあります。メモリビューが行指向の contiguous （連続配置）な配列の場合は `nil` になることもあります。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def sub_offsets -> Array[Integer] | nil

メモリビューがネストされた配列をエクスポートする場合に、それぞれの次元におけるオフセットからなる、長さ [ndim](m:Fiddle::MemoryView#ndim) の配列を返します。メモリビューが平坦な配列の場合は `nil` になることがあります。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

### def [](i, j, k, ...) -> Integer | Float | Array[Integer] | Array[Float] | nil

多次元配列の 1 次元目のインデックスが `i` 、 2次元目のインデックスが `j` 、 3次元目のインデックスが `k` 、……の場所にある要素を返します。

[format](m:Fiddle::MemoryView#format) が複数の [テンプレート文字](d:pack_template) からなる場合は、文字数の長さの配列になります。 1 文字の場合は要素そのものが返ります。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は `nil` になります。

- **param** `i, j, k, ...` -- 各次元のインデックスを指定します。

- **raise** `IndexError` -- 引数の数が [ndim](m:Fiddle::MemoryView#ndim) と異なる場合に発生します。

- **raise** `RuntimeError` -- メモリビューの [format](m:Fiddle::MemoryView#format) が不正の場合に発生します。

### def to_s -> String

データを、エンコーディングが ASCII-8BIT の `String` として返します。

この文字列はメモリ領域をメモリビューと共有し、データをコピーしません。

[#release](m:Fiddle::MemoryView#release) を呼んだ後は空文字列になります。
