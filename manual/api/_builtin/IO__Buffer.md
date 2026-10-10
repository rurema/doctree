---
library: _builtin
since: "3.1"
include:
  - Comparable
---
# class IO::Buffer < Object

メモリ領域を直接読み書きするための低レベルなバッファを表すクラスです。
Ruby 3.1 で導入されました。

[c:String] を経由せずにメモリ領域を扱えるため、コピーを避けた入出力
(zero-copy IO)を実現するために使われます。主に
[Fiber::Scheduler](https://docs.ruby-lang.org/en/4.0/Fiber/Scheduler.html) の実装のような、低レベルな入出力を扱う場面で利用します。

バッファは以下のいずれかの方法で確保されたメモリ領域を指します。

  - 内部(internal) -- Ruby が確保したメモリ領域。[m:IO::Buffer.new] で作られます。
  - 外部(external) -- [c:String] など、Ruby の他のオブジェクトが持つメモリ領域。
  - マップ(mapped) -- 仮想メモリ機構(Unix の mmap など)で確保されたメモリ領域。

#%since 4.1
Ruby 4.1 から、このクラスのインスタンスは必ず [c:IO::Buffer::Storage] か [c:IO::Buffer::Slice] のどちらかになります。
[c:IO::Buffer] 自身のインスタンスは作れません。

[m:IO::Buffer.new]・[m:IO::Buffer.for]・[m:IO::Buffer.map] が返すのは [c:IO::Buffer::Storage] で、メモリ領域を管理します。
[m:IO::Buffer#slice] が返すのは [c:IO::Buffer::Slice] で、別のバッファの一部を参照します。

メモリ領域の確保と解放に関するメソッド([m:IO::Buffer::Storage#resize]・[m:IO::Buffer::Storage#free]・[m:IO::Buffer::Storage#transfer] と [m:IO::Buffer::Storage#internal?]・[m:IO::Buffer::Storage#external?]・[m:IO::Buffer::Storage#mapped?]・[m:IO::Buffer::Storage#shared?]・[m:IO::Buffer::Storage#private?])を持つのは [c:IO::Buffer::Storage] だけです。
[c:IO::Buffer::Slice] が持つのは [m:IO::Buffer::Slice#resize] だけです。

```ruby
buf = IO::Buffer.new(8)
p buf.class             # => IO::Buffer::Storage
p buf.slice(2, 4).class # => IO::Buffer::Slice
```

#%end
このクラスは実験的な機能です。
利用すると「IO::Buffer is experimental and both the Ruby and C interface may
change in the future!」という警告が出力されます。
将来のバージョンで Ruby と C の双方のインターフェースが変更される可能性があります。

この警告は `Warning[:experimental] = false` を指定すると抑止できます。

```ruby
buf = IO::Buffer.new(8)
p buf.size          # => 8

buf.set_string("Ruby")
p buf.get_string    # => "Ruby\x00\x00\x00\x00"
p buf.get_string(0, 4)  # => "Ruby"
```

## Constants

### const DEFAULT_SIZE -> Integer

[m:IO::Buffer.new] で size を省略した場合に使われる既定のバイト数です。

値は環境依存です。

### const PAGE_SIZE -> Integer

OS のページサイズをバイト数で表した値です。

[m:IO::Buffer.new] は、size がこの値以上の場合に仮想メモリ機構を用いてバッファを確保します。

値は環境依存です。

### const MAPPED -> Integer

バッファを仮想メモリ機構(Unix では匿名 mmap、Windows では VirtualAlloc)で確保することを表すフラグです。[m:IO::Buffer.new] の flags に指定します。

### const EXTERNAL -> Integer

バッファが外部(external)のメモリ領域、すなわち [c:String] など他のオブジェクトが所有するメモリ領域を指していることを表すフラグです。

### const INTERNAL -> Integer

バッファが内部(internal)のメモリ領域、すなわち Ruby が直接確保したメモリ領域を指していることを表すフラグです。

#%since 3.2
### const SHARED -> Integer

バッファが他のプロセスと共有されるメモリ領域を指していることを表すフラグです。
#%end

### const LOCKED -> Integer

バッファがロックされていることを表すフラグです。

ロックされている間はバッファの解放やリサイズができません。
バッファは [m:IO::Buffer#locked] のブロックを実行している間ロックされます。
ロックされているかどうかは [m:IO::Buffer#locked?] で調べられます。

### const PRIVATE -> Integer

バッファがコピーオンライトで確保されていることを表すフラグです。

このバッファへの変更は元のメモリ領域には反映されません。

### const READONLY -> Integer

バッファが読み込み専用であることを表すフラグです。

このフラグが立っているバッファに書き込もうとすると
[c:IO::Buffer::AccessError] が発生します。

### const LITTLE_ENDIAN -> Integer
### const BIG_ENDIAN -> Integer
### const HOST_ENDIAN -> Integer
### const NETWORK_ENDIAN -> Integer

バイトオーダー(エンディアン)を表す定数です。

HOST_ENDIAN は実行中の環境のバイトオーダーで、LITTLE_ENDIAN か BIG_ENDIAN のいずれかと同じ値になります。NETWORK_ENDIAN はネットワークバイトオーダーで、
BIG_ENDIAN と同じ値です。

```ruby
p IO::Buffer::NETWORK_ENDIAN == IO::Buffer::BIG_ENDIAN # => true

# リトルエンディアンの環境の場合
p IO::Buffer::HOST_ENDIAN == IO::Buffer::LITTLE_ENDIAN # => true
```

## Class Methods

#%since 4.1
### def IO::Buffer.for(string) -> IO::Buffer::Storage
#%else
### def IO::Buffer.for(string) -> IO::Buffer
#%end
### def IO::Buffer.for(string) {|buffer| ... } -> object

文字列 string のメモリ領域を参照する、コピーを伴わないバッファを作成します。

#%since 4.1
Ruby 4.1 からは [c:IO::Buffer::Storage] のインスタンスを返します。
ブロックを渡した場合は、ブロックにも [c:IO::Buffer::Storage] のインスタンスが渡されます。

#%end

ブロックを渡さない場合は、string の内容を複製した凍結済みの文字列をバッファの元として使い、読み取り専用のバッファを返します。
元の文字列とは切り離されるため、あとから元の文字列を変更してもバッファの内容は変わりません。

ブロックを渡した場合は、string 自身のメモリ領域を参照するバッファをブロックに渡し、ブロックの評価結果を返します。バッファへの書き込みは
string に反映されます。ブロックの実行中、string は変更できません。
string が freeze されている場合は読み取り専用のバッファになります。

- **param** `string` -- バッファの元にする [c:String] を指定します。

```ruby title="例: ブロックを渡さない場合"
buffer = IO::Buffer.for("test")
p buffer.get_string # => "test"
p buffer.external?  # => true
p buffer.readonly?  # => true

# 元の文字列を変更してもバッファには影響しない
str = +"test"
buffer = IO::Buffer.for(str)
str << "XY"
p str               # => "testXY"
p buffer.get_string # => "test"
```

```ruby title="例: ブロックを渡した場合"
str = +"test"
IO::Buffer.for(str) do |buffer|
  p buffer.readonly? # => false
  buffer.set_string("Ruby")
end
p str # => "Ruby"
```

- **SEE** [m:IO::Buffer.new], [m:IO::Buffer.map]

#%since 4.1
### def IO::Buffer.map(file, size = nil, offset = 0, flags = 0) -> IO::Buffer::Storage
#%else
### def IO::Buffer.map(file, size = nil, offset = 0, flags = 0) -> IO::Buffer
#%end

ファイルをメモリにマップしたバッファを作成して返します。

#%since 4.1
Ruby 4.1 からは [c:IO::Buffer::Storage] のインスタンスを返します。

#%end

既定では書き込み可能かつ共有(shared)のマップになるため、file は書き込み可能な状態で開いておく必要があります。読み込み専用で開いたファイルをマップするには、flags に [m:IO::Buffer::READONLY] を指定します。
[m:IO::Buffer::PRIVATE] を指定するとコピーオンライトのマップになり、バッファへの変更はファイルにも他のプロセスにも反映されません。

- **param** `file` -- マップする [c:File] を指定します。

- **param** `size` -- マップするバイト数を指定します。省略するとファイル全体をマップします。0 を指定した場合と空のファイルを指定した場合はエラーになります。

- **param** `offset` -- マップを開始する位置をファイルの先頭からのバイト数で指定します。指定できる値はシステム依存で、多くの環境ではページサイズの倍数である必要があります。

- **param** `flags` -- [m:IO::Buffer::READONLY] や [m:IO::Buffer::PRIVATE] を指定します。

```ruby title="例: 読み込み専用でマップする"
File.write("test.txt", "hello world")

buffer = IO::Buffer.map(File.open("test.txt"), nil, 0, IO::Buffer::READONLY)
p buffer.get_string # => "hello world"
p buffer.mapped?    # => true
p buffer.readonly?  # => true
```

```ruby title="例: 書き込み可能なマップ"
File.write("test.txt", "hello world")

buffer = IO::Buffer.map(File.open("test.txt", "r+"))
buffer.set_string("HELLO")
p File.read("test.txt") # => "HELLO world"
```

- **SEE** [m:IO::Buffer.new], [m:IO::Buffer.for]

#%since 4.1
### def IO::Buffer.new(size = IO::Buffer::DEFAULT_SIZE, flags = 0) -> IO::Buffer::Storage
#%else
### def IO::Buffer.new(size = IO::Buffer::DEFAULT_SIZE, flags = 0) -> IO::Buffer
#%end

size バイトの、0 で埋められた新しいバッファを作成して返します。

#%since 4.1
Ruby 4.1 からは [c:IO::Buffer::Storage] のインスタンスを返します。

#%end

既定では内部(internal)バッファ、すなわち Ruby が直接確保したメモリ領域になります。ただし size が OS 依存の [m:IO::Buffer::PAGE_SIZE] 以上の場合は、仮想メモリ機構(Unix では匿名 mmap、Windows では VirtualAlloc)を用いて確保されます。flags に [m:IO::Buffer::MAPPED] を指定すると、
size によらず後者の方法で確保されます。

- **param** `size` -- 確保するバッファのバイト数を整数で指定します。
             省略した場合は [m:IO::Buffer::DEFAULT_SIZE] になります。

- **param** `flags` -- バッファの確保方法を [m:IO::Buffer::MAPPED] などの定数で指定します。

```ruby
buf = IO::Buffer.new(4)
p buf.size       # => 4
p buf.internal?  # => true
p buf.get_string # => "\x00\x00\x00\x00"
```

- **SEE** [m:IO::Buffer.for], [m:IO::Buffer.map]

#%since 3.3
### def IO::Buffer.string(length) {|buffer| ... } -> String

length バイトの文字列を新しく作り、それを元にしたコピーを伴わないバッファをブロックに渡します。ブロックの実行後、その文字列を返します。

ブロックの中でバッファに書き込んだ内容が、そのまま返される文字列の内容になります。返される文字列のエンコーディングは [m:Encoding::BINARY] です。

- **param** `length` -- 作成する文字列のバイト数を整数で指定します。

- **raise** `LocalJumpError` -- ブロックを渡さなかった場合に発生します。

```ruby
str = IO::Buffer.string(4) do |buffer|
  buffer.set_string("Ruby")
end
p str                 # => "Ruby"
p str.encoding.name   # => "ASCII-8BIT"
```

- **SEE** [m:IO::Buffer.for]
#%end

#%since 3.2
### def IO::Buffer.size_of(buffer_type) -> Integer
### def IO::Buffer.size_of(buffer_types) -> Integer

数値の型が占めるバイト数を返します。

型の配列を渡した場合は、それぞれのバイト数の合計を返します。
指定できる型については [m:IO::Buffer#get_value] を参照してください。

- **param** `buffer_type` -- 型を表すシンボルを指定します。
- **param** `buffer_types` -- 型を表すシンボルの配列を指定します。

- **raise** `ArgumentError` -- 型として使えないシンボルを指定した場合に発生します。

- **raise** `TypeError` -- シンボルでも配列でもないオブジェクトを指定した場合に発生します。

```ruby
p IO::Buffer.size_of(:U8)          # => 1
p IO::Buffer.size_of(:u32)         # => 4
p IO::Buffer.size_of(:f64)         # => 8

# 配列を渡すと合計を返す
p IO::Buffer.size_of([:u32, :u32]) # => 8
```

- **SEE** [m:IO::Buffer#get_value], [m:IO::Buffer#get_values]
#%end

## Instance Methods

### def size -> Integer

バッファのバイト数を返します。

```ruby
p IO::Buffer.new(8).size # => 8
```

### def get_string(offset = 0, length = nil, encoding = Encoding::BINARY) -> String

バッファの内容を [c:String] として取り出して返します。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `length` -- 読み出すバイト数を指定します。省略した場合は offset からバッファの終端までを読み出します。

- **param** `encoding` -- 返す文字列のエンコーディングを指定します。
                 省略した場合は [m:Encoding::BINARY] になります。

- **raise** `ArgumentError` -- offset と length の合計がバッファのバイト数を超える場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_string("Ruby")

p buf.get_string        # => "Ruby\x00\x00\x00\x00"
p buf.get_string(0, 4)  # => "Ruby"
p buf.get_string(1, 3)  # => "uby"

p buf.get_string(0, 4).encoding.name                   # => "ASCII-8BIT"
p buf.get_string(0, 4, Encoding::UTF_8).encoding.name  # => "UTF-8"

buf.get_string(0, 99)   # ~> ArgumentError
```

- **SEE** [m:IO::Buffer#set_string]

### def set_string(string, offset = 0, length = nil, source_offset = 0) -> Integer

文字列 string の内容をバッファに書き込みます。書き込んだバイト数を返します。

- **param** `string` -- 書き込む内容を [c:String] で指定します。

- **param** `offset` -- 書き込みを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `length` -- 書き込むバイト数を指定します。省略した場合は string 全体を書き込みます。

- **param** `source_offset` -- string のどの位置から読み出すかをバイト数で指定します。

- **raise** `ArgumentError` -- offset と length の合計がバッファのバイト数を超える場合に発生します。

- **raise** `IO::Buffer::AccessError` -- 書き込みできないバッファに対して呼び出した場合に発生します。
             詳しくは [c:IO::Buffer::AccessError] を参照してください。

```ruby
buf = IO::Buffer.new(8)

p buf.set_string("Ruby")   # => 4
p buf.get_string           # => "Ruby\x00\x00\x00\x00"

buf.set_string("XY", 6)
p buf.get_string           # => "Ruby\x00\x00XY"

IO::Buffer.new(2).set_string("TOOLONG") # ~> ArgumentError
```

- **SEE** [m:IO::Buffer#get_string]

### def get_value(buffer_type, offset) -> Integer | Float

バッファの offset の位置から、buffer_type で指定した型の値を読み出して返します。

buffer_type には以下のシンボルを指定します。
小文字で始まるものはリトルエンディアン、大文字で始まるものはビッグエンディアンです
(1 バイトの `:U8` と `:S8` にバイトオーダーの区別はありません)。

- **整数**: `:U8` `:S8` (1 バイト)、`:u16` `:U16` `:s16` `:S16` (2 バイト)、
  `:u32` `:U32` `:s32` `:S32` (4 バイト)、`:u64` `:U64` `:s64` `:S64` (8 バイト)
#%since 4.0
  、`:u128` `:U128` `:s128` `:S128` (16 バイト)
#%end
- **浮動小数点数**: `:f32` `:F32` (4 バイト)、`:f64` `:F64` (8 バイト)

小文字の `u` `s` `f` で始まるものが符号なし整数・符号付き整数・浮動小数点数を表し、
`u` と `s` の対応する大文字はビッグエンディアンを意味します。

- **param** `buffer_type` -- 読み出す値の型を上記のシンボルで指定します。

- **param** `offset` -- 読み出す位置をバッファの先頭からのバイト数で指定します。

- **raise** `ArgumentError` -- buffer_type が上記以外の場合や、読み出す範囲がバッファの外にはみ出す場合に発生します。

```ruby
buf = IO::Buffer.for([1.5].pack("f"))
p buf.get_value(:f32, 0) # => 1.5

buf = IO::Buffer.for("\x01\x02")
p buf.get_value(:u16, 0) # => 513
p buf.get_value(:U16, 0) # => 258
```

#%since 3.2
- **SEE** [m:IO::Buffer#set_value], [m:IO::Buffer#get_values], [m:IO::Buffer#values]
#%else
- **SEE** [m:IO::Buffer#set_value]
#%end

#%since 3.2
### def get_values(buffer_types, offset) -> [Integer | Float]

[m:IO::Buffer#get_value] と同じですが、複数の型をまとめて読み出し、値の配列を返します。

- **param** `buffer_types` -- 読み出す値の型のシンボルの配列を指定します。
             指定できるシンボルは [m:IO::Buffer#get_value] を参照してください。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **raise** `ArgumentError` -- 型が不正な場合や、読み出す範囲がバッファの外にはみ出す場合に発生します。

```ruby
buf = IO::Buffer.for([1.5, 2.5].pack("ff"))
p buf.get_values([:f32, :f32], 0) # => [1.5, 2.5]
```

- **SEE** [m:IO::Buffer#get_value], [m:IO::Buffer#set_values]
#%end

### def set_value(buffer_type, offset, value) -> Integer

バッファの offset の位置に、buffer_type で指定した型で value を書き込みます。

指定できる型は [m:IO::Buffer#get_value] を参照してください。
整数の型に [c:Float] を渡した場合は、小数点以下が切り捨てられます。

#%since 3.2
書き込んだ値の次の位置を返します。
#%else
offset をそのまま返します。
#%end

- **param** `buffer_type` -- 書き込む値の型をシンボルで指定します。

- **param** `offset` -- 書き込む位置をバッファの先頭からのバイト数で指定します。

- **param** `value` -- 書き込む値を数値で指定します。

- **raise** `ArgumentError` -- buffer_type が不正な場合や、書き込む範囲がバッファの外にはみ出す場合に発生します。

- **raise** `IO::Buffer::AccessError` -- 読み取り専用のバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_value(:U8, 1, 111)
p buf.get_string # => "\x00o\x00\x00\x00\x00\x00\x00"

# 整数の型に Float を渡すと小数点以下は切り捨てられる
buf = IO::Buffer.new(8)
buf.set_value(:U32, 0, 2.5)
p buf.get_value(:U32, 0) # => 2
```

- **SEE** [m:IO::Buffer#get_value]

#%since 3.2
### def set_values(buffer_types, offset, values) -> Integer

[m:IO::Buffer#set_value] と同じですが、複数の値をまとめて書き込みます。
書き込んだ値の次の位置を返します。

- **param** `buffer_types` -- 書き込む値の型のシンボルの配列を指定します。

- **param** `offset` -- 書き込みを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `values` -- 書き込む値の配列を指定します。

- **raise** `ArgumentError` -- 型が不正な場合や、書き込む範囲がバッファの外にはみ出す場合に発生します。

- **raise** `IO::Buffer::AccessError` -- 読み取り専用のバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(8)
p buf.set_values([:U8, :U16], 0, [1, 2]) # => 3
p buf.get_string(0, 3)                   # => "\x01\x00\x02"
```

- **SEE** [m:IO::Buffer#set_value], [m:IO::Buffer#get_values]

### def values(buffer_type, offset = 0, count = nil) -> [Integer | Float]

バッファの offset の位置から、buffer_type で指定した型の値を順に読み出し、配列にして返します。

指定できる型は [m:IO::Buffer#get_value] を参照してください。

- **param** `buffer_type` -- 読み出す値の型をシンボルで指定します。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `count` -- 読み出す個数を指定します。省略した場合はバッファの末尾まで読み出します。

```ruby
buf = IO::Buffer.for("Hello World")
p buf.values(:U8, 2, 2) # => [108, 108]
p buf.values(:U8, 9)    # => [108, 100]
```

- **SEE** [m:IO::Buffer#each], [m:IO::Buffer#get_values]

### def each(buffer_type, offset = 0, count = nil) {|offset, value| ... } -> self
### def each(buffer_type, offset = 0, count = nil) -> Enumerator

バッファの offset の位置から、buffer_type で指定した型の値を順に読み出し、その位置と値をブロックに渡して繰り返します。

指定できる型は [m:IO::Buffer#get_value] を参照してください。
ブロックを省略した場合は [c:Enumerator] を返します。

- **param** `buffer_type` -- 読み出す値の型をシンボルで指定します。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `count` -- 読み出す個数を指定します。省略した場合はバッファの末尾まで読み出します。

```ruby
IO::Buffer.for("Hello World").each(:U8, 2, 2) do |offset, value|
  p [offset, value]
end
# => [2, 108]
#    [3, 108]
```

- **SEE** [m:IO::Buffer#values], [m:IO::Buffer#each_byte]

### def each_byte(offset = 0, count = nil) {|byte| ... } -> self
### def each_byte(offset = 0, count = nil) -> Enumerator

バッファの offset の位置から 1 バイトずつ読み出し、ブロックに渡して繰り返します。

ブロックを省略した場合は [c:Enumerator] を返します。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `count` -- 読み出すバイト数を指定します。省略した場合はバッファの末尾まで読み出します。

#%until 4.0
Ruby 3.4 までは引数が正しく扱われません。引数を 1 つだけ渡した場合は無視されて先頭から末尾まで読み出し、2 つ渡した場合は 2 番目の引数が読み出しの開始位置として使われます。位置や個数を指定するには Ruby 4.0 以降が必要です。
#%end

```ruby
IO::Buffer.for("Hello").each_byte do |byte|
  p byte
end
# => 72
#    101
#    108
#    108
#    111
```

#%since 4.0

```ruby title="例: 位置と個数を指定する"
IO::Buffer.for("Hello World").each_byte(2, 2) do |byte|
  p byte
end
# => 108
#    108
```

#%end

- **SEE** [m:IO::Buffer#each]
#%end

#%since 4.1
### def slice(offset = 0, length = nil) -> IO::Buffer::Slice
#%end
#%version 3.2...4.1
### def slice(offset = 0, length = nil) -> IO::Buffer
#%end
#%until 3.2
### def slice(offset, length) -> IO::Buffer
#%end

バッファの一部を指す新しい [c:IO::Buffer] を返します。

メモリのコピーは行わず、返されるバッファは元のバッファと同じメモリ領域を参照します。
そのため、一方への書き込みはもう一方からも見えます。
元のバッファが文字列やファイルに由来する場合、その関連も引き継がれます。

#%since 4.1
Ruby 4.1 からは [c:IO::Buffer::Slice] のインスタンスを返します。
返されたスライスは `self` を参照元として保持し、[m:IO::Buffer#source] で取得できます。
スライスからさらにスライスを作った場合の参照元は、直接の親です。

参照元が [m:IO::Buffer::Storage#free] や [m:IO::Buffer::Storage#transfer] で手放されたときや、縮小されて参照範囲が外に出たときは、スライスは無効になります。
参照範囲が再び参照元の範囲内に収まれば、有効に戻ります。
参照元のメモリ領域が別のアドレスに再確保されても、無効にはなりません。

#%end
- **param** `offset` -- 参照を開始する位置をバッファの先頭からのバイト数で指定します。
#%since 3.2
           省略した場合は 0 になります。
#%end
- **param** `length` -- 参照するバイト数を指定します。
#%since 3.2
           省略した場合はバッファの末尾までになります。
#%end
- **raise** `ArgumentError` -- offset や length が負の場合、
             または offset と length の合計がバッファのバイト数を超える場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_string("Ruby")

part = buf.slice(0, 4)
p part.get_string # => "Ruby"

# 同じメモリ領域を参照しているので、変更は元のバッファにも反映される
part.set_string("Xy")
p buf.get_string  # => "Xyby\x00\x00\x00\x00"
```

#%since 4.1
- **SEE** [m:IO::Buffer#copy], [m:IO::Buffer::Slice.new], [m:IO::Buffer#source], [m:IO::Buffer#advance]
#%else
- **SEE** [m:IO::Buffer#copy]
#%end

#%since 4.1
### def advance(amount) -> self

自身がメモリ領域を所有していないバッファの先頭を、`amount` バイト進めます。

進めた分だけ、バッファの大きさが減ります。
メモリ領域の移動や変更は行われません。
対象になるのは [c:IO::Buffer::Slice] と、[m:IO::Buffer.for] で作った外部バッファです。
`self` を返します。

参照元とロックの状態は変わりません。
バッファの見え方を変えるだけなので、読み取り専用のバッファやロック中のバッファに対しても呼べます。
`amount` が現在の大きさと同じ場合は、大きさ 0 の空のバッファになります。

親のスライスを進めると、そこから作った子のスライスの見える範囲も同じだけずれます。

- **param** `amount` -- 進めるバイト数を指定します。

- **raise** `ArgumentError` -- `amount` が負の場合や、現在の大きさを超える場合に発生します。

- **raise** `IO::Buffer::AccessError` -- 自身がメモリ領域を所有するバッファに対して呼び出した場合に発生します。
  [m:IO::Buffer.new] で作った内部バッファ、マップバッファ、[m:IO::Buffer.map] で作ったバッファが該当します。

- **raise** `IO::Buffer::InvalidatedError` -- 無効になったスライスに対して呼び出した場合に発生します。

- **raise** `FrozenError` -- 凍結済みのバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_string("abcdefgh")

part = buf.slice(2, 4)
p part.get_string   # => "cdef"

part.advance(1)
p part.size         # => 3
p part.get_string   # => "def"
p buf.get_string    # => "abcdefgh"

p IO::Buffer.for("test").advance(1).get_string # => "est"

buf.advance(1) # ~> IO::Buffer::AccessError
```

```ruby title="例: 親のスライスを進める"
buf = IO::Buffer.for("abcdef")
parent = buf.slice(1, 4)
child = parent.slice(1, 2)
p child.get_string  # => "cd"

parent.advance(1)
p child.get_string  # => "de"
```

- **SEE** [m:IO::Buffer#slice], [m:IO::Buffer#source], [m:IO::Buffer::Slice#resize]

### def source -> IO::Buffer | String | nil

バッファの参照元を返します。

返す値はバッファの作り方によって異なります。

  - [m:IO::Buffer#slice] で作ったスライス -- [m:IO::Buffer#slice] を呼んだバッファ。スライスからさらに作った場合は、直接の親
  - [m:IO::Buffer.for] にブロックを渡して作ったバッファ -- 渡した文字列そのもの
  - [m:IO::Buffer.for] にブロックを渡さずに作ったバッファ -- 内部で作った凍結済みの複製。渡した文字列が凍結済みの場合は、その文字列そのもの
  - [m:IO::Buffer.new] や [m:IO::Buffer.map] で作ったバッファ -- nil

無効になったスライスでも、参照元を返します。
[m:IO::Buffer::Storage#free] や [m:IO::Buffer::Storage#transfer] を呼んだあとのバッファと、[m:IO::Buffer.for] のブロックを抜けたあとのバッファでは nil を返します。

```ruby
buf = IO::Buffer.new(8)
p buf.source                    # => nil

part = buf.slice(2, 4)
p part.source.equal?(buf)       # => true

# スライスからさらに作った場合は、直接の親が参照元になる
child = part.slice(1, 2)
p child.source.equal?(part)     # => true
p part.source.equal?(buf)       # => true
```

```ruby title="例: IO::Buffer.for で作ったバッファ"
str = +"abc"
p IO::Buffer.for(str) {|b| b.source.equal?(str) } # => true

copy = IO::Buffer.for(str).source
p copy.frozen?        # => true
p copy.equal?(str)    # => false
```

- **SEE** [m:IO::Buffer#slice], [m:IO::Buffer#advance]
#%end

### def copy(source, offset = 0, length = nil, source_offset = 0) -> Integer

別の [c:IO::Buffer] の内容を自身へコピーします。コピーしたバイト数を返します。

[c:String] の内容を書き込む場合は [m:IO::Buffer#set_string] を使用してください。

- **param** `source` -- コピー元を [c:IO::Buffer] で指定します。
- **param** `offset` -- 書き込みを開始する位置をバッファの先頭からのバイト数で指定します。
- **param** `length` -- コピーするバイト数を指定します。省略した場合は source 全体をコピーします。
- **param** `source_offset` -- source のどの位置から読み出すかをバイト数で指定します。
- **raise** `ArgumentError` -- offset と length の合計がバッファのバイト数を超える場合に発生します。
- **raise** `IO::Buffer::AccessError` -- 書き込みできないバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(8)

p buf.copy(IO::Buffer.for("test"), 2) # => 4
p buf.get_string                      # => "\x00\x00test\x00\x00"

# 長さを指定して先頭 3 バイトだけコピーする
other = IO::Buffer.new(8)
p other.copy(IO::Buffer.for("abcdef"), 0, 3) # => 3
p other.get_string(0, 3)                     # => "abc"
```

- **SEE** [m:IO::Buffer#set_string], [m:IO::Buffer#slice]

### def clear(value = 0, offset = 0, length = nil) -> self

バッファを value で埋めます。

- **param** `value` -- 埋める値を 0 から 255 の [c:Integer] で指定します。
- **param** `offset` -- 埋め始める位置をバッファの先頭からのバイト数で指定します。
- **param** `length` -- 埋めるバイト数を指定します。省略した場合はバッファの末尾までを埋めます。
- **raise** `IO::Buffer::AccessError` -- 書き込みできないバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("test")

buf.clear
p buf.get_string # => "\x00\x00\x00\x00"

# 位置と長さを指定して "A" (0x41) で埋める
buf.clear(0x41, 1, 2)
p buf.get_string # => "\x00AA\x00"
```

#%until 4.1
### def resize(size) -> self

バッファの大きさを size バイトに変更します。

変更前の内容は保持されます。
変更後の大きさによっては、メモリ領域が別の場所に確保しなおされ、内容がそこへコピーされます。

[m:IO::Buffer.for] で作った外部バッファや、ロックされたバッファは大きさを変更できません。

- **param** `size` -- 変更後の大きさをバイト数で指定します。
- **raise** `IO::Buffer::AccessError` -- 大きさを変更できないバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("test")

buf.resize(8)
p buf.size             # => 8
p buf.get_string(0, 4) # => "test"

IO::Buffer.for("abc").resize(8) # ~> IO::Buffer::AccessError
```

### def transfer -> IO::Buffer

メモリ領域の所有権を新しい [c:IO::Buffer] へ移し、その新しいバッファを返します。

所有権を手放した自身は、どのメモリ領域も指さない状態になります。
この状態は [m:IO::Buffer#null?] で調べられます。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("Ruby")

other = buf.transfer
p other.get_string # => "Ruby"

p buf.null? # => true
p buf.size  # => 0
```

- **SEE** [m:IO::Buffer#free], [m:IO::Buffer#null?]

### def free -> self

バッファが確保しているメモリ領域を解放します。

解放の内容はバッファの種類によって異なります。

  - 内部(internal) -- 確保したメモリを解放します。
  - 外部(external) -- 元のオブジェクトとの関連を解消します。
  - マップ(mapped) -- マッピングを解除します。

解放後は、どのメモリ領域も指さない状態になります。
#%since 3.3
この状態のバッファは大きさ 0 のバッファとして扱われます。
#%else
この状態のバッファを読み書きしようとすると
[c:IO::Buffer::AllocationError] が発生します。
#%end

解放したバッファでも [m:IO::Buffer#resize] を呼べば、あらためてメモリ領域を確保できます。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("Ruby")

buf.free
p buf.null? # => true
p buf.size  # => 0

# resize すれば再び使える
buf.resize(4)
p buf.size  # => 4
```

- **SEE** [m:IO::Buffer#transfer], [m:IO::Buffer#null?]
#%end

### def empty? -> bool

バッファの大きさが 0 の場合に true を返します。

大きさ 0 のバッファは、[m:IO::Buffer.new] に 0 を渡すか、空文字列から [m:IO::Buffer.for] で作った場合などにできます。

```ruby
p IO::Buffer.new(0).empty? # => true
p IO::Buffer.new(4).empty? # => false
```

### def null? -> bool

バッファがどのメモリ領域も指していない場合に true を返します。

#%since 4.1
[m:IO::Buffer::Storage#free] で解放したバッファ、[m:IO::Buffer::Storage#transfer] で所有権を手放したバッファ、および最初からメモリ領域を確保していないバッファがこれにあたります。
#%else
[m:IO::Buffer#free] で解放したバッファ、[m:IO::Buffer#transfer] で所有権を手放したバッファ、および最初からメモリ領域を確保していないバッファがこれにあたります。
#%end

```ruby
p IO::Buffer.new(0).null? # => true

buf = IO::Buffer.new(4)
p buf.null? # => false
buf.free
p buf.null? # => true
```

#%since 4.1
- **SEE** [m:IO::Buffer::Storage#free], [m:IO::Buffer::Storage#transfer]
#%else
- **SEE** [m:IO::Buffer#free], [m:IO::Buffer#transfer]
#%end

### def valid? -> bool

バッファがアクセス可能な場合に true を返します。

#%until 4.1
別のバッファや文字列の一部を参照している([m:IO::Buffer#slice] で作った)バッファは、参照元が解放されたり別のアドレスに再確保されたりすると、アクセスできなくなります。
#%end
#%since 4.1
別のバッファの一部を参照している([m:IO::Buffer#slice] で作った)[c:IO::Buffer::Slice] は、参照元が [m:IO::Buffer::Storage#free] や [m:IO::Buffer::Storage#transfer] で手放されたときや、縮小されて参照範囲が外に出たときに、アクセスできなくなります。
参照範囲が再び参照元の範囲内に収まれば、有効に戻ります。
参照元のメモリ領域が別のアドレスに再確保されても、無効にはなりません。
#%end

```ruby
buf = IO::Buffer.new(8)
part = buf.slice(4, 4)
p part.valid? # => true

buf.resize(4)
p part.valid? # => false

buf.resize(8)
p part.valid? # => true
```

#%until 4.1
### def internal? -> bool

バッファが内部(internal)バッファである場合に true を返します。

内部バッファは、バッファ自身が確保したメモリ領域を参照します。
文字列などの外部のメモリやファイルのマッピングとは結び付いていません。
[m:IO::Buffer.new] で作られるバッファは既定で内部バッファです。

```ruby
p IO::Buffer.new(4).internal? # => true
```

- **SEE** [m:IO::Buffer#external?]

### def external? -> bool

バッファが外部(external)バッファである場合に true を返します。

外部バッファは、バッファ自身が確保・マップしたのではないメモリ領域を参照します。
[m:IO::Buffer.for] で作ったバッファは、文字列のメモリを外部参照します。
外部バッファは大きさを変更できません。

```ruby
p IO::Buffer.for("test").external? # => true
p IO::Buffer.new(4).external?      # => false
```

- **SEE** [m:IO::Buffer#internal?]
#%end

### def readonly? -> bool

バッファが読み取り専用の場合に true を返します。

読み取り専用のバッファは、[m:IO::Buffer#set_value] や [m:IO::Buffer#set_string]、
[m:IO::Buffer#copy] などで変更できません。

[m:IO::Buffer.for] にブロックを渡さずに作ったバッファは、元の文字列が freeze
されているかどうかによらず、常に読み取り専用になります。内部で作った文字列の複製をバッファの元として使うためです。
ブロックを渡した場合は元の文字列のメモリを直接参照するため、その文字列が freeze されている場合にだけ読み取り専用になります。
読み取り専用のファイルから作ったバッファも読み取り専用です。

```ruby
# ブロックを渡さない場合は、元の文字列が freeze されていなくても読み取り専用
p IO::Buffer.for("test").readonly?                  # => true

# ブロックを渡した場合は元の文字列に従う
p IO::Buffer.for("test") { |buf| buf.readonly? }    # => false
p IO::Buffer.for("test".freeze) { |buf| buf.readonly? } # => true

p IO::Buffer.new(4).readonly?                       # => false
```

#%until 4.1
### def mapped? -> bool

バッファがマップ(mapped)バッファである場合に true を返します。

マップバッファは、仮想メモリ機構でマップされたメモリ領域を参照します。
[m:IO::Buffer.new] に [m:IO::Buffer::MAPPED] を指定した場合や、大きさが [m:IO::Buffer::PAGE_SIZE] 以上の場合は匿名のマップになります。
[m:IO::Buffer.map] で作った場合はファイルに紐づいたマップになります。
#%end

### def locked? -> bool

バッファがロックされている場合に true を返します。

#%until 4.1
ロックされたバッファは大きさの変更や解放ができず、さらにロックを取得することもできません。
#%end
#%since 4.1
ロックされた [c:IO::Buffer::Storage] は、大きさの変更や解放、所有権の移動ができません。
[m:IO::Buffer#locked] は入れ子にして呼べます。

ロックは、同じメモリ領域を参照する [c:IO::Buffer::Slice] と共有されます。
参照元がロックされている間は、スライスの `locked?` も true になります。
スライスをロックすると、メモリ領域全体がロックされます。
#%end
システムコールでバッファを使っている間に、そのバッファが移動しないことを保証するための仕組みです。

- **SEE** [m:IO::Buffer#locked]

### def locked { ... } -> object

ブロックを実行する間、バッファをロックします。ブロックの値を返します。

#%until 4.1
ロックされている間、そのバッファに対して [m:IO::Buffer#resize] や
[m:IO::Buffer#free]、さらに [m:IO::Buffer#locked] を呼ぶと
[c:IO::Buffer::LockedError] が発生します。
#%end
#%since 4.1
ロックされている間、そのバッファに対して [m:IO::Buffer::Storage#resize] や
[m:IO::Buffer::Storage#free]、[m:IO::Buffer::Storage#transfer] を呼ぶと
[c:IO::Buffer::LockedError] が発生します。
[m:IO::Buffer#locked] は、ロック中のバッファに対しても呼べます。
ロックは同じメモリ領域を参照する [c:IO::Buffer::Slice] と共有されるため、
スライスをロックしている間は、参照元の [m:IO::Buffer::Storage#resize] も [c:IO::Buffer::LockedError] になります。
ロック中でも、スライスの [m:IO::Buffer::Slice#resize] と [m:IO::Buffer#advance] は呼べます。
#%end
バッファへの読み書き自体はロック中も行えます。

システムコールでバッファを使っている間に、そのバッファが移動したり解放されたりしないことを保証するための仕組みです。
スレッド安全ではないため、複数のスレッドでバッファを共有する場合は別に同期の手段が必要です。

#%until 3.4
ブロックの実行中に例外が発生すると、ロックは解除されずに残ります。
そのバッファは以降も大きさの変更や解放ができません。
#%end
#%version 3.4
ブロックの実行中に例外が発生した場合、Ruby 3.4.10 以降ではロックが解除されます。
Ruby 3.4.9 までは解除されずに残ります。
#%end
#%version 4.0
ブロックの実行中に例外が発生した場合、Ruby 4.0.6 以降ではロックが解除されます。
Ruby 4.0.5 までは解除されずに残ります。
#%end
#%since 4.1
ブロックの実行中に例外が発生した場合もロックは解除されます。
#%end

- **raise** `LocalJumpError` -- ブロックを渡さなかった場合に発生します。

#%until 4.1
- **raise** `IO::Buffer::LockedError` -- すでにロックされているバッファに対して呼び出した場合に発生します。
#%end

```ruby
buf = IO::Buffer.new(4)

p buf.locked?                # => false
p buf.locked { buf.locked? } # => true
p buf.locked?                # => false

# ブロックの値がそのまま返る
p buf.locked { "done" }      # => "done"
```

```ruby title="例: ロック中は大きさの変更や解放ができない"
buf = IO::Buffer.new(4)
buf.locked { buf.resize(8) } # ~> IO::Buffer::LockedError
```

- **SEE** [m:IO::Buffer#locked?], [m:IO::Buffer::LOCKED]

#%version 3.2...4.1
### def shared? -> bool

バッファが共有(shared)バッファである場合に true を返します。

共有バッファは、他のプロセスと共有できるメモリ領域を参照します。
そのため、このプロセスで変更しなくても内容が変わることがあります。
#%end

#%version 3.3...4.1
### def private? -> bool

バッファがプライベート(private)バッファである場合に true を返します。

プライベートバッファに加えた変更は、元になったファイルのマッピングには反映されません。
#%end

#%since 3.2
### def &(mask) -> IO::Buffer
### def |(mask) -> IO::Buffer
### def ^(mask) -> IO::Buffer

バッファの各バイトと mask の各バイトのビット演算(AND / OR / XOR)を行い、結果を格納した新しいバッファを返します。

返されるバッファの大きさは元のバッファと同じです。
mask が元のバッファより短い場合は、mask を先頭から繰り返し使います。

- **param** `mask` -- マスクを [c:IO::Buffer] で指定します。

- **raise** `IO::Buffer::MaskError` -- mask の大きさが 0 の場合に発生します。

```ruby
# 4 バイトのマスクが 10 バイトに繰り返し適用される
buf = IO::Buffer.for("1234567890") & IO::Buffer.for("\xFF\x00\x00\xFF")
p buf.size                                              # => 10
p buf.get_string.bytes.map {|b| "%02x" % b }.join(" ")  # => "31 00 00 34 35 00 00 38 39 00"
```

- **SEE** [m:IO::Buffer#and!], [m:IO::Buffer#or!], [m:IO::Buffer#xor!]

### def ~ -> IO::Buffer

バッファの各バイトのビットを反転した、新しいバッファを返します。

返されるバッファの大きさは元のバッファと同じです。

```ruby
buf = ~IO::Buffer.for("1234567890")
p buf.size                                              # => 10
p buf.get_string.bytes.map {|b| "%02x" % b }.join(" ")  # => "ce cd cc cb ca c9 c8 c7 c6 cf"
```

- **SEE** [m:IO::Buffer#not!]

### def and!(mask) -> self
### def or!(mask) -> self
### def xor!(mask) -> self

[m:IO::Buffer#&] などと同じビット演算を、新しいバッファを作らずに自身に対して行います。`self` を返します。

mask が自身より短い場合は、mask を先頭から繰り返し使います。

- **param** `mask` -- マスクを [c:IO::Buffer] で指定します。

- **raise** `IO::Buffer::MaskError` -- mask の大きさが 0 の場合に発生します。

- **raise** `IO::Buffer::AccessError` -- 読み取り専用のバッファに対して呼び出した場合に発生します。

```ruby
# IO::Buffer.for はブロックを渡さないと読み取り専用になるので、dup で複製する
buf = IO::Buffer.for("1234567890").dup
buf.and!(IO::Buffer.for("\xFF\x00\x00\xFF"))
p buf.get_string.bytes.map {|b| "%02x" % b }.join(" ")  # => "31 00 00 34 35 00 00 38 39 00"

IO::Buffer.for("1234").and!(IO::Buffer.for("\xFF")) # ~> IO::Buffer::AccessError
```

- **SEE** [m:IO::Buffer#&], [m:IO::Buffer#|], [m:IO::Buffer#^]

### def not! -> self

[m:IO::Buffer#~] と同じビット反転を、新しいバッファを作らずに自身に対して行います。`self` を返します。

- **raise** `IO::Buffer::AccessError` -- 読み取り専用のバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.for("1234567890").dup
buf.not!
p buf.get_string.bytes.map {|b| "%02x" % b }.join(" ")  # => "ce cd cc cb ca c9 c8 c7 c6 cf"
```

- **SEE** [m:IO::Buffer#~]
#%end

### def to_s -> String

バッファの状態を短く表した文字列を返します。

メモリ領域のアドレスと大きさ、状態を表すフラグが含まれます。
この表示形式は将来変更される可能性があります。

```ruby
#%since 4.1
p IO::Buffer.new(4).to_s # => "#<IO::Buffer::Storage 0x0000600002d10000+4 INTERNAL>"
#%else
p IO::Buffer.new(4).to_s # => "#<IO::Buffer 0x0000600002d10000+4 INTERNAL>"
#%end
```

アドレスの部分は実行するたびに変わります。

- **SEE** [m:IO::Buffer#inspect]

### def inspect -> String

バッファの状態と内容を表した文字列を返します。

[m:IO::Buffer#to_s] と同じ 1 行に続けて、バッファの内容を
[m:IO::Buffer#hexdump] と同じ 16 進ダンプ形式で表示します。
この表示形式は将来変更される可能性があります。

#%since 3.3
ダンプするのは先頭 256 バイトまでです。
これを超える分は表示されず、代わりに残りのバイト数が示されます。
#%else
内容をダンプするのは、バッファの大きさが 256 バイト以下の場合だけです。
256 バイトを超える場合、内容は表示されません。
#%end

```ruby
buf = IO::Buffer.for("Hello World")
puts buf.inspect
#%since 4.1
# => #<IO::Buffer::Storage 0x0000000100e726b8+11 EXTERNAL READONLY SLICE>
#%else
# => #<IO::Buffer 0x0000000100e726b8+11 EXTERNAL READONLY SLICE>
#%end
#    0x00000000  48 65 6c 6c 6f 20 57 6f 72 6c 64                Hello World
```

#%since 3.3

```ruby title="例: 256 バイトを超えるバッファ"
puts IO::Buffer.new(300).inspect.lines.last
# => (and 44 more bytes not printed)
```

#%end
- **SEE** [m:IO::Buffer#to_s], [m:IO::Buffer#hexdump]

#%since 3.3
### def hexdump(offset = 0, length = nil, width = 16) -> String | nil
#%else
### def hexdump -> String | nil
#%end

バッファの内容を 16 進ダンプ形式の文字列で返します。

各行は、バッファの先頭からの位置、16 進数で表したバイト列、印字できる文字による表現の順に並びます。
この表示形式は将来変更される可能性があります。

メモリ領域を指していないバッファでは nil を返します。
これは [m:IO::Buffer#null?] が真の場合です。
#%since 3.3

- **param** `offset` -- ダンプを開始する位置をバイト単位の整数で指定します。
- **param** `length` -- ダンプする長さをバイト単位の整数で指定します。
             省略した場合は offset からバッファの終わりまでです。
- **param** `width` -- 1 行に表示するバイト数を整数で指定します。

- **raise** `ArgumentError` -- offset と length の合計がバッファの大きさを超える場合に発生します。
- **raise** `ArgumentError` -- width に 1 未満を指定した場合に発生します。
#%end

```ruby
buf = IO::Buffer.for("Hello World")
puts buf.hexdump
# => 0x00000000  48 65 6c 6c 6f 20 57 6f 72 6c 64                Hello World
```

```ruby title="例: メモリ領域を指していないバッファ"
buf = IO::Buffer.new(4)
buf.free
p buf.hexdump # => nil
```

#%since 3.3

```ruby title="例: 位置と長さを指定する"
buf = IO::Buffer.for("Hello World")
puts buf.hexdump(6, 5)
# => 0x00000006  57 6f 72 6c 64                                  World
```

```ruby title="例: 1 行に表示するバイト数を指定する"
buf = IO::Buffer.for("Hello World")
puts buf.hexdump(0, 11, 4)
# => 0x00000000  48 65 6c 6c Hell
#    0x00000004  6f 20 57 6f o Wo
#    0x00000008  72 6c 64    rld
```

#%end
- **SEE** [m:IO::Buffer#inspect], [m:IO::Buffer#null?]

### def <=>(other) -> Integer

バッファの大きさと内容を other と比較します。

まず大きさを比較し、大きさが同じ場合に内容をバイト列として比較します。
`self` の方が小さければ負の整数を、等しければ 0 を、大きければ正の整数を返します。

大きさが同じ場合の比較には C の `memcmp` を使い、その結果をそのまま返します。
このため返る整数の絶対値に意味はありません。0 との大小だけを見てください。

[c:Comparable] を include しているため、`<` や `==` などの比較演算子も使えます。

- **param** `other` -- 比較対象のバッファを [c:IO::Buffer] で指定します。

- **raise** `TypeError` -- other が [c:IO::Buffer] でない場合に発生します。

```ruby
buf = IO::Buffer.for("abc")

p(buf <=> IO::Buffer.for("abc")) # => 0
p(buf <=> IO::Buffer.for("ab"))  # => 1
p buf < IO::Buffer.for("abd")    # => true
```

```ruby title="例: 大きさが同じ場合は memcmp の結果がそのまま返る"
p(IO::Buffer.for("abc") <=> IO::Buffer.for("abz")) # => -23
```

#%version 4.1...
### def read(io, offset = 0, length = nil) -> Integer
#%end
#%version 3.2...4.1
### def read(io, length = nil, offset = 0) -> Integer
#%end
#%version ...3.2
### def read(io, length) -> Integer
#%end

io から読み込んだ内容をバッファに書き込みます。

#%since 4.1
io から最大 length バイトを 1 回の操作で読み込み、バッファの offset の位置から書き込みます。
短い読み込みも正常な結果で、読み込めたバイト数がそのまま返ります。

#%else
読み込むのは、少なくとも length バイトです。バッファに空きがあれば、それより多く読み込むことがあります。

#%end
読み込みは io の現在の位置から行われ、io の位置は読み込んだ分だけ進みます。

- **param** `io` -- 読み込み元の [c:IO] を指定します。

#%since 4.1
- **param** `offset` -- 読み込んだ内容を書き込む位置を、バッファの先頭からの
             バイト数で指定します。省略した場合は 0 です。

- **param** `length` -- 読み込む最大のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を
             引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は何もしません。
#%else
#%since 3.2
- **param** `length` -- 読み込む最小のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を
             引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は [man:read(2)] をちょうど 1 回呼びます。

- **param** `offset` -- 読み込んだ内容を書き込む位置を、バッファの先頭からの
             バイト数で指定します。
#%else
- **param** `length` -- 読み込む最小のバイト数を整数で指定します。
#%end
#%end

- **return** -- 読み込んだバイト数を返します。読み込みに失敗した場合は
             errno を負にした整数を返します。例外は発生しません。

- **raise** `ArgumentError` -- offset と length の合計がバッファの大きさを超える場合に発生します。

#%since 4.1

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(11)
File.open("test.txt") do |io|
  p buf.read(io, 0, 11) # => 11
end
p buf.get_string        # => "Hello World"
```

```ruby title="例: 読み込みに失敗した場合は -errno を返す"
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(4)
# 書き込み専用で開いたファイルからは読み込めない
File.open("test.txt", "w") do |io|
  p buf.read(io, 0, 4)   # => -9
end
p(-Errno::EBADF::Errno)  # => -9
```

#%else

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(11)
File.open("test.txt") do |io|
  p buf.read(io, 11) # => 11
end
p buf.get_string     # => "Hello World"
```

```ruby title="例: 読み込みに失敗した場合は -errno を返す"
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(4)
# 書き込み専用で開いたファイルからは読み込めない
File.open("test.txt", "w") do |io|
  p buf.read(io, 4)      # => -9
end
p(-Errno::EBADF::Errno)  # => -9
```

#%end

- **SEE** [m:IO::Buffer#pread], [m:IO::Buffer#write]

#%version 4.1...
### def write(io, offset = 0, length = nil) -> Integer
#%end
#%version 3.2...4.1
### def write(io, length = nil, offset = 0) -> Integer
#%end
#%version ...3.2
### def write(io, length) -> Integer
#%end

バッファの内容を io に書き込みます。

#%since 4.1
バッファの offset の位置から最大 length バイトを、1 回の操作で io に書き込みます。
短い書き込みも正常な結果で、書き込めたバイト数がそのまま返ります。

#%else
書き込むのは、少なくとも length バイトです。バッファに続きがあれば、それより多く書き込むことがあります。

#%end
書き込みは io の現在の位置から行われ、io の位置は書き込んだ分だけ進みます。

- **param** `io` -- 書き込み先の [c:IO] を指定します。

#%since 4.1
- **param** `offset` -- 書き込む内容の開始位置を、バッファの先頭からの
             バイト数で指定します。省略した場合は 0 です。

- **param** `length` -- 書き込む最大のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を
             引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は何もしません。
#%else
#%since 3.2
- **param** `length` -- 書き込む最小のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を
             引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は [man:write(2)] をちょうど 1 回呼びます。

- **param** `offset` -- 書き込む内容の開始位置を、バッファの先頭からの
             バイト数で指定します。
#%else
- **param** `length` -- 書き込む最小のバイト数を整数で指定します。
#%end
#%end

- **return** -- 書き込んだバイト数を返します。書き込みに失敗した場合は
             errno を負にした整数を返します。例外は発生しません。

- **raise** `ArgumentError` -- offset と length の合計がバッファの大きさを超える場合に発生します。

#%since 4.1

```ruby
buf = IO::Buffer.for("Ruby!")
File.open("test.txt", "w") do |io|
  p buf.write(io, 0, 5) # => 5
end
p File.read("test.txt") # => "Ruby!"
```

#%else

```ruby
buf = IO::Buffer.for("Ruby!")
File.open("test.txt", "w") do |io|
  p buf.write(io, 5) # => 5
end
p File.read("test.txt") # => "Ruby!"
```

#%end

- **SEE** [m:IO::Buffer#pwrite], [m:IO::Buffer#read]

#%version 4.1...
### def pread(io, from, offset = 0, length = nil) -> Integer
#%end
#%version 3.2...4.1
### def pread(io, from, length = nil, offset = 0) -> Integer
#%end
#%version ...3.2
### def pread(io, length, from) -> Integer
#%end

io の指定した位置から読み込んだ内容をバッファに書き込みます。

#%since 4.1
最大 length バイトを 1 回の操作で読み込み、バッファの offset の位置から書き込みます。
短い読み込みも正常な結果で、読み込めたバイト数がそのまま返ります。

#%end
[m:IO::Buffer#read] と異なり、読み込む位置を io の中で直接指定します。
io の現在の位置は変わりません。

- **param** `io` -- 読み込み元の [c:IO] を指定します。

#%since 4.1
- **param** `from` -- 読み込みを開始する位置を、io の先頭からのバイト数で
             指定します。

- **param** `offset` -- 読み込んだ内容を書き込む位置を、バッファの先頭からの
             バイト数で指定します。省略した場合は 0 です。

- **param** `length` -- 読み込む最大のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は何もしません。
#%else
#%since 3.2
- **param** `from` -- 読み込みを開始する位置を、io の先頭からのバイト数で
             指定します。

- **param** `length` -- 読み込む最小のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は [man:pread(2)] をちょうど 1 回呼びます。

- **param** `offset` -- 読み込んだ内容を書き込む位置を、バッファの先頭からの
             バイト数で指定します。
#%else
- **param** `length` -- 読み込む最小のバイト数を整数で指定します。

- **param** `from` -- 読み込みを開始する位置を、io の先頭からのバイト数で
             指定します。
#%end
#%end

- **return** -- 読み込んだバイト数を返します。読み込みに失敗した場合は
             errno を負にした整数を返します。例外は発生しません。

- **raise** `ArgumentError` -- offset と length の合計がバッファの大きさを超える場合に発生します。

#%since 4.1

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(5)
File.open("test.txt") do |io|
  p buf.pread(io, 6, 0, 5) # => 5
  p io.pos                 # => 0
end
p buf.get_string           # => "World"
```

#%else
#%since 3.2

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(5)
File.open("test.txt") do |io|
  p buf.pread(io, 6, 5) # => 5
  p io.pos              # => 0
end
p buf.get_string        # => "World"
```

#%else

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.new(5)
File.open("test.txt") do |io|
  p buf.pread(io, 5, 6) # => 5
  p io.pos              # => 0
end
p buf.get_string        # => "World"
```

#%end
#%end

- **SEE** [m:IO::Buffer#read], [m:IO::Buffer#pwrite], [man:pread(2)]

#%version 4.1...
### def pwrite(io, from, offset = 0, length = nil) -> Integer
#%end
#%version 3.2...4.1
### def pwrite(io, from, length = nil, offset = 0) -> Integer
#%end
#%version ...3.2
### def pwrite(io, length, from) -> Integer
#%end

バッファの内容を io の指定した位置に書き込みます。

#%since 4.1
バッファの offset の位置から最大 length バイトを、1 回の操作で書き込みます。
短い書き込みも正常な結果で、書き込めたバイト数がそのまま返ります。

#%end
[m:IO::Buffer#write] と異なり、書き込む位置を io の中で直接指定します。
io の現在の位置は変わりません。

- **param** `io` -- 書き込み先の [c:IO] を指定します。

#%since 4.1
- **param** `from` -- 書き込みを開始する位置を、io の先頭からのバイト数で
             指定します。

- **param** `offset` -- 書き込む内容の開始位置を、バッファの先頭からの
             バイト数で指定します。省略した場合は 0 です。

- **param** `length` -- 書き込む最大のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は何もしません。
#%else
#%since 3.2
- **param** `from` -- 書き込みを開始する位置を、io の先頭からのバイト数で
             指定します。

- **param** `length` -- 書き込む最小のバイト数を整数で指定します。
             省略するか nil を指定した場合は、バッファの大きさから offset を引いた値、つまりバッファの残り全体になります。
             0 を指定した場合は [man:pwrite(2)] をちょうど 1 回呼びます。

- **param** `offset` -- 書き込む内容の開始位置を、バッファの先頭からの
             バイト数で指定します。
#%else
- **param** `length` -- 書き込む最小のバイト数を整数で指定します。

- **param** `from` -- 書き込みを開始する位置を、io の先頭からのバイト数で
             指定します。
#%end
#%end

- **return** -- 書き込んだバイト数を返します。書き込みに失敗した場合は
             errno を負にした整数を返します。例外は発生しません。

- **raise** `ArgumentError` -- offset と length の合計がバッファの大きさを超える場合に発生します。

#%since 4.1

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.for("RUBY!")
File.open("test.txt", "r+") do |io|
  p buf.pwrite(io, 6, 0, 5) # => 5
end
p File.read("test.txt")     # => "Hello RUBY!"
```

#%else
#%since 3.2

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.for("RUBY!")
File.open("test.txt", "r+") do |io|
  p buf.pwrite(io, 6, 5) # => 5
end
p File.read("test.txt")  # => "Hello RUBY!"
```

#%else

```ruby
File.write("test.txt", "Hello World")

buf = IO::Buffer.for("RUBY!")
File.open("test.txt", "r+") do |io|
  p buf.pwrite(io, 5, 6) # => 5
end
p File.read("test.txt")  # => "Hello RUBY!"
```

#%end
#%end

- **SEE** [m:IO::Buffer#write], [m:IO::Buffer#pread], [man:pwrite(2)]

#%since 4.1
### def bit_count(offset = 0, length = nil) -> Integer

バッファに含まれる、立っているビット(値が `1` のビット)の数を返します。

ポピュレーションカウント、あるいはハミング重みとも呼ばれます。

`offset` と `length` を指定すると、バッファの一部の範囲だけを対象に数えます。

- **param** `offset` -- 数える範囲の開始位置をバッファの先頭からのバイト数で指定します。省略した場合は `0` です。
- **param** `length` -- 数える範囲の長さをバイト数で指定します。省略した場合は `offset` からバッファの終端までです。
- **return** -- 対象の範囲に含まれる、立っているビットの数を返します。
- **raise** `ArgumentError` -- `offset` と `length` の合計がバッファのバイト数を超える場合に発生します。

```ruby title="例"
p IO::Buffer.for("\xFF\x00\x0F").bit_count       # => 12
p IO::Buffer.for("\xFF\x00\x0F").bit_count(1, 2) # => 4
```

- **SEE** [m:IO::Buffer#~], [m:String#bit_count]

#%end

