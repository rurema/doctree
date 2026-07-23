---
library: _builtin
since: "3.3"
include:
  - Comparable
---
# class IO::Buffer < Object

メモリ領域を直接読み書きするための低レベルなバッファを表すクラスです。

[c:String] を経由せずにメモリ領域を扱えるため、コピーを避けた入出力
(zero-copy IO)を実現するために使われます。主に [c:Fiber::Scheduler] の
実装のような、低レベルな入出力を扱う場面で利用します。

バッファは以下のいずれかの方法で確保されたメモリ領域を指します。

  - 内部(internal) -- Ruby が確保したメモリ領域。[m:IO::Buffer.new] で作られます。
  - 外部(external) -- [c:String] など、Ruby の他のオブジェクトが持つメモリ領域。
  - マップ(mapped) -- 仮想メモリ機構(Unix の mmap など)で確保されたメモリ領域。

このクラスは実験的な機能です。
利用すると「IO::Buffer is experimental and both the Ruby and C interface may
change in the future!」という警告が出力されます。
将来のバージョンで Ruby と C の双方のインターフェースが変更される可能性があります。

```ruby
buf = IO::Buffer.new(8)
p buf.size          # => 8

buf.set_string("Ruby")
p buf.get_string    # => "Ruby\x00\x00\x00\x00"
p buf.get_string(0, 4)  # => "Ruby"
```

## Class Methods

### def new(size = IO::Buffer::DEFAULT_SIZE, flags = 0) -> IO::Buffer

size バイトの、0 で埋められた新しいバッファを作成して返します。

既定では内部(internal)バッファ、すなわち Ruby が直接確保したメモリ領域に
なります。ただし size が OS 依存の [m:IO::Buffer::PAGE_SIZE] より大きい場合は、
仮想メモリ機構(Unix では匿名 mmap、Windows では VirtualAlloc)を用いて
確保されます。flags に [m:IO::Buffer::MAPPED] を指定すると、
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

## Instance Methods

### def size -> Integer

バッファのバイト数を返します。

```ruby
p IO::Buffer.new(8).size # => 8
```

### def get_string(offset = 0, length = nil, encoding = Encoding::BINARY) -> String

バッファの内容を [c:String] として取り出して返します。

- **param** `offset` -- 読み出しを開始する位置をバッファの先頭からのバイト数で指定します。

- **param** `length` -- 読み出すバイト数を指定します。省略した場合は offset から
               バッファの終端までを読み出します。

- **param** `encoding` -- 返す文字列のエンコーディングを指定します。
                 省略した場合は [m:Encoding::BINARY] になります。

- **raise** `ArgumentError` -- offset と length の合計がバッファのバイト数を超える場合に発生します。

```ruby
buf = IO::Buffer.new(8)
buf.set_string("Ruby")

p buf.get_string        # => "Ruby\x00\x00\x00\x00"
p buf.get_string(0, 4)  # => "Ruby"
p buf.get_string(1, 3)  # => "uby"

p buf.get_string(0, 4).encoding                   # => #<Encoding:BINARY (ASCII-8BIT)>
p buf.get_string(0, 4, Encoding::UTF_8).encoding  # => #<Encoding:UTF-8>

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

```ruby
buf = IO::Buffer.new(8)

p buf.set_string("Ruby")   # => 4
p buf.get_string           # => "Ruby\x00\x00\x00\x00"

buf.set_string("XY", 6)
p buf.get_string           # => "Ruby\x00\x00XY"

IO::Buffer.new(2).set_string("TOOLONG") # ~> ArgumentError
```

- **SEE** [m:IO::Buffer#get_string]
