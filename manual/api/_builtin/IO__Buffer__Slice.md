---
library: _builtin
since: "4.1"
---
# class IO::Buffer::Slice < IO::Buffer

別の [c:IO::Buffer] の一部を参照する [c:IO::Buffer] です。
Ruby 4.1 で導入されました。

[m:IO::Buffer#slice] か [m:IO::Buffer::Slice.new] で作ります。
バイトのコピーはせず、参照元(`source`)への参照を保持します。
参照元は [m:IO::Buffer#source] で取得できます。
スライスからさらにスライスを作った場合の参照元は、平坦化されずに直接の親になります。

スライスは、参照範囲が参照元の範囲に収まっている間だけ有効です。
参照元が [m:IO::Buffer::Storage#free] や [m:IO::Buffer::Storage#transfer] で手放されたときや、縮小されて参照範囲が外に出たときは、無効になります。
無効なスライスの内容を読み出そうとすると [c:IO::Buffer::InvalidatedError] が発生します。
無効かどうかは [m:IO::Buffer#valid?] で調べられます。

参照範囲が再び参照元の範囲内に収まれば、有効に戻ります。
参照元のメモリ領域が別のアドレスに再確保されても、無効にはなりません。
無効なスライスでも、[m:IO::Buffer#source] は参照元を返します。

書き込みは参照元のメモリに反映されます。
読み取り専用かどうかなどの権限は、参照元に従います。
読み取り専用のバッファのスライスに書き込もうとすると、[c:IO::Buffer::AccessError] が発生します。

参照元がロックされている間は、スライスの [m:IO::Buffer#locked?] も true になります。
スライスを [m:IO::Buffer#locked] でロックすると、メモリ領域全体がロックされ、参照元の [m:IO::Buffer::Storage#resize] は [c:IO::Buffer::LockedError] になります。
ロック中でも、スライスの [m:IO::Buffer::Slice#resize] と [m:IO::Buffer#advance] は呼べます。

[m:IO::Buffer::Slice#resize] と [m:IO::Buffer#advance] は、見える範囲を変えるだけです。
メモリ領域の確保・解放・コピーは行いません。

メモリ領域の確保と解放に関するメソッドは、このクラスにはありません。
[m:IO::Buffer::Storage#free]・[m:IO::Buffer::Storage#transfer] と、[m:IO::Buffer::Storage#mapped?]・[m:IO::Buffer::Storage#external?]・[m:IO::Buffer::Storage#internal?]・[m:IO::Buffer::Storage#shared?]・[m:IO::Buffer::Storage#private?] を呼ぶと、[c:NoMethodError] が発生します。
また [m:IO::Buffer.for]・[m:IO::Buffer.map]・[m:IO::Buffer.string] も、このクラスでは未定義です。

[m:IO::Buffer::Slice#dup] と [m:IO::Buffer::Slice#clone] は、ビューをコピーします。
バイトはコピーされません。
複製は元と同じ参照元・位置・大きさを持ち、どちらから書き込んでも同じメモリに書かれます。

```ruby
buf = IO::Buffer.for("abcdef")
parent = buf.slice(1, 4)
child = parent.slice(1, 2)

p child.source.equal?(parent) # => true
p parent.source.equal?(buf)   # => true
p child.get_string            # => "cd"

# 親のスライスを進めると、子のスライスの見える範囲もずれる
parent.advance(1)
p child.get_string            # => "de"
```

- **SEE** [c:IO::Buffer], [c:IO::Buffer::Storage], [m:IO::Buffer#slice]

## Class Methods

### def IO::Buffer::Slice.new(source, offset = 0, length = nil) -> IO::Buffer::Slice

`source` の一部を参照するスライスを作って返します。

バイトのコピーはせず、`source` への参照を保持します。
`offset` と `length` を省略すると、`source` 全体を参照します。
`length` だけを省略すると、`offset` から末尾までを参照します。

- **param** `source` -- 参照元を [c:IO::Buffer] で指定します。[c:IO::Buffer::Storage] でも [c:IO::Buffer::Slice] でも指定できます。
- **param** `offset` -- 参照を開始する位置を、`source` の先頭からのバイト数で指定します。
- **param** `length` -- 参照するバイト数を指定します。省略すると、`offset` から末尾までになります。
- **raise** `ArgumentError` -- 引数を渡さなかった場合、`offset` や `length` が負の場合、`offset` が `source` の大きさを超える場合、または `offset` と `length` の合計が `source` の大きさを超える場合に発生します。
- **raise** `TypeError` -- `source` が [c:IO::Buffer] でない場合に発生します。

```ruby
buf = IO::Buffer.for("abcdefgh")

p IO::Buffer::Slice.new(buf, 2, 4).get_string # => "cdef"
p IO::Buffer::Slice.new(buf, 2).get_string    # => "cdefgh"
p IO::Buffer::Slice.new(buf).get_string       # => "abcdefgh"

# offset が source の大きさと同じ場合は、大きさ 0 のスライスになる
p IO::Buffer::Slice.new(buf, 8).size          # => 0

IO::Buffer::Slice.new(buf, 9)    # ~> ArgumentError
IO::Buffer::Slice.new(buf, 6, 4) # ~> ArgumentError
IO::Buffer::Slice.new("abc")     # ~> TypeError
```

- **SEE** [m:IO::Buffer#slice]

## Instance Methods

### def resize(size) -> self

スライスの大きさを `size` バイトに変更します。

参照元の範囲内で、見える範囲の大きさを変えるだけです。
メモリ領域の確保・解放・コピーは行わず、参照元も変更されません。
大きくした場合は、参照元にある既存のバイトが見えるようになります。クリアはされません。
入れ子のスライスでは、直接の親の範囲が上限になります。

参照元がロックされていても呼べます。

- **param** `size` -- 変更後の大きさをバイト数で指定します。
- **raise** `ArgumentError` -- `size` が負の場合や、参照元の範囲を超える場合に発生します。無効になったスライスに対して呼び出した場合も、範囲外として扱われて発生します。
- **raise** `FrozenError` -- 凍結済みのスライスに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_string("abcdefgh")

part = buf.slice(2, 4)
p part.get_string  # => "cdef"

part.resize(2)
p part.size        # => 2
p part.get_string  # => "cd"

part.resize(6)
p part.get_string  # => "cdefgh"

part.resize(7)     # ~> ArgumentError
```

- **SEE** [m:IO::Buffer#advance], [m:IO::Buffer::Storage#resize]

### def dup -> IO::Buffer::Slice
### def clone -> IO::Buffer::Slice

スライスのビューをコピーして返します。

バイトはコピーしません。
複製は元と同じ参照元・位置・大きさを持ちます。
複製に対する [m:IO::Buffer#advance] や [m:IO::Buffer::Slice#resize] は、元のスライスのビューに影響しません。
どちらから書き込んでも、同じメモリに書かれます。

凍結済みのスライスに対しては、`dup` の結果は凍結されず、`clone` の結果は凍結されます。

```ruby
buf = IO::Buffer.for("abcdef").dup
slice = buf.slice(1, 3)

# 複製の advance は、元のスライスのビューに影響しない
copy = slice.dup
copy.advance(1)
p copy.get_string   # => "cd"
p slice.get_string  # => "bcd"

# どちらから書き込んでも、同じメモリに書かれる
other = slice.dup
other.set_string("XY")
p buf.get_string    # => "aXYdef"
```

- **SEE** [m:IO::Buffer::Storage#dup]
