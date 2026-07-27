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
[Fiber::Scheduler](https://docs.ruby-lang.org/en/4.0/Fiber/Scheduler.html) の
実装のような、低レベルな入出力を扱う場面で利用します。

バッファは以下のいずれかの方法で確保されたメモリ領域を指します。

  - 内部(internal) -- Ruby が確保したメモリ領域。[m:IO::Buffer.new] で作られます。
  - 外部(external) -- [c:String] など、Ruby の他のオブジェクトが持つメモリ領域。
  - マップ(mapped) -- 仮想メモリ機構(Unix の mmap など)で確保されたメモリ領域。

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

[m:IO::Buffer.new] は、size がこの値以上の場合に仮想メモリ機構を用いて
バッファを確保します。

値は環境依存です。

### const MAPPED -> Integer

バッファを仮想メモリ機構(Unix では匿名 mmap、Windows では VirtualAlloc)で
確保することを表すフラグです。[m:IO::Buffer.new] の flags に指定します。

### const EXTERNAL -> Integer

バッファが外部(external)のメモリ領域、すなわち [c:String] など他のオブジェクトが
所有するメモリ領域を指していることを表すフラグです。

### const INTERNAL -> Integer

バッファが内部(internal)のメモリ領域、すなわち Ruby が直接確保したメモリ領域を
指していることを表すフラグです。

#@since 3.2
### const SHARED -> Integer

バッファが他のプロセスと共有されるメモリ領域を指していることを表すフラグです。
#@end

### const LOCKED -> Integer

バッファがロックされていることを表すフラグです。

ロックされている間はバッファの解放やリサイズができません。
バッファがロックされているかどうかは [m:IO::Buffer#locked?] で調べられます。
#@# locked を収録したら、ブロックの間ロックする IO::Buffer#locked への言及も足す

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

HOST_ENDIAN は実行中の環境のバイトオーダーで、LITTLE_ENDIAN か BIG_ENDIAN の
いずれかと同じ値になります。NETWORK_ENDIAN はネットワークバイトオーダーで、
BIG_ENDIAN と同じ値です。

```ruby
p IO::Buffer::NETWORK_ENDIAN == IO::Buffer::BIG_ENDIAN # => true

# リトルエンディアンの環境の場合
p IO::Buffer::HOST_ENDIAN == IO::Buffer::LITTLE_ENDIAN # => true
```

## Class Methods

### def for(string) -> IO::Buffer
### def for(string) {|buffer| ... } -> object

文字列 string のメモリ領域を参照する、コピーを伴わないバッファを作成します。

ブロックを渡さない場合は、string の内容を複製した凍結済みの文字列を
バッファの元として使い、読み取り専用のバッファを返します。
元の文字列とは切り離されるため、あとから元の文字列を変更してもバッファの
内容は変わりません。

ブロックを渡した場合は、string 自身のメモリ領域を参照するバッファを
ブロックに渡し、ブロックの評価結果を返します。バッファへの書き込みは
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

### def map(file, size = nil, offset = 0, flags = 0) -> IO::Buffer

ファイルをメモリにマップしたバッファを作成して返します。

既定では書き込み可能かつ共有(shared)のマップになるため、file は書き込み
可能な状態で開いておく必要があります。読み込み専用で開いたファイルを
マップするには、flags に [m:IO::Buffer::READONLY] を指定します。
[m:IO::Buffer::PRIVATE] を指定するとコピーオンライトのマップになり、
バッファへの変更はファイルにも他のプロセスにも反映されません。

- **param** `file` -- マップする [c:File] を指定します。

- **param** `size` -- マップするバイト数を指定します。省略するとファイル全体を
             マップします。0 を指定した場合と空のファイルを指定した場合は
             エラーになります。

- **param** `offset` -- マップを開始する位置をファイルの先頭からのバイト数で
             指定します。指定できる値はシステム依存で、多くの環境では
             ページサイズの倍数である必要があります。

- **param** `flags` -- [m:IO::Buffer::READONLY] や [m:IO::Buffer::PRIVATE] を
             指定します。

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

### def new(size = IO::Buffer::DEFAULT_SIZE, flags = 0) -> IO::Buffer

size バイトの、0 で埋められた新しいバッファを作成して返します。

既定では内部(internal)バッファ、すなわち Ruby が直接確保したメモリ領域に
なります。ただし size が OS 依存の [m:IO::Buffer::PAGE_SIZE] 以上の場合は、
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

- **SEE** [m:IO::Buffer.for], [m:IO::Buffer.map]

#@since 3.3
### def string(length) {|buffer| ... } -> String

length バイトの文字列を新しく作り、それを元にしたコピーを伴わないバッファを
ブロックに渡します。ブロックの実行後、その文字列を返します。

ブロックの中でバッファに書き込んだ内容が、そのまま返される文字列の内容に
なります。返される文字列のエンコーディングは [m:Encoding::BINARY] です。

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
#@end

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

#@since 3.2
### def slice(offset = 0, length = nil) -> IO::Buffer
#@else
### def slice(offset, length) -> IO::Buffer
#@end

バッファの一部を指す新しい [c:IO::Buffer] を返します。

メモリのコピーは行わず、返されるバッファは元のバッファと同じメモリ領域を参照します。
そのため、一方への書き込みはもう一方からも見えます。
元のバッファが文字列やファイルに由来する場合、その関連も引き継がれます。

- **param** `offset` -- 参照を開始する位置をバッファの先頭からのバイト数で指定します。
#@since 3.2
           省略した場合は 0 になります。
#@end
- **param** `length` -- 参照するバイト数を指定します。
#@since 3.2
           省略した場合はバッファの末尾までになります。
#@end
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

- **SEE** [m:IO::Buffer#copy]

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

### def resize(size) -> self

バッファの大きさを size バイトに変更します。

変更前の内容は保持されます。
変更後の大きさによっては、メモリ領域が別の場所に確保しなおされ、
内容がそこへコピーされます。

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
#@since 3.3
この状態のバッファは大きさ 0 のバッファとして扱われます。
#@else
この状態のバッファを読み書きしようとすると
[c:IO::Buffer::AllocationError] が発生します。
#@end

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

### def empty? -> bool

バッファの大きさが 0 の場合に true を返します。

大きさ 0 のバッファは、[m:IO::Buffer.new] に 0 を渡すか、
空文字列から [m:IO::Buffer.for] で作った場合などにできます。

```ruby
p IO::Buffer.new(0).empty? # => true
p IO::Buffer.new(4).empty? # => false
```

### def null? -> bool

バッファがどのメモリ領域も指していない場合に true を返します。

[m:IO::Buffer#free] で解放したバッファ、[m:IO::Buffer#transfer] で所有権を手放した
バッファ、および最初からメモリ領域を確保していないバッファがこれにあたります。

```ruby
p IO::Buffer.new(0).null? # => true

buf = IO::Buffer.new(4)
p buf.null? # => false
buf.free
p buf.null? # => true
```

- **SEE** [m:IO::Buffer#free], [m:IO::Buffer#transfer]

### def valid? -> bool

バッファがアクセス可能な場合に true を返します。

別のバッファや文字列の一部を参照している([m:IO::Buffer#slice] で作った)バッファは、
参照元が解放されたり別のアドレスに再確保されたりすると、アクセスできなくなります。

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

### def readonly? -> bool

バッファが読み取り専用の場合に true を返します。

#@# set_value を収録したらリンクに戻す
読み取り専用のバッファは、`IO::Buffer#set_value` や [m:IO::Buffer#set_string]、
[m:IO::Buffer#copy] などで変更できません。

[m:IO::Buffer.for] にブロックを渡さずに作ったバッファは、元の文字列が freeze
されているかどうかによらず、常に読み取り専用になります。内部で作った文字列の
複製をバッファの元として使うためです。
ブロックを渡した場合は元の文字列のメモリを直接参照するため、
その文字列が freeze されている場合にだけ読み取り専用になります。
読み取り専用のファイルから作ったバッファも読み取り専用です。

```ruby
# ブロックを渡さない場合は、元の文字列が freeze されていなくても読み取り専用
p IO::Buffer.for("test").readonly?                  # => true

# ブロックを渡した場合は元の文字列に従う
p IO::Buffer.for("test") { |buf| buf.readonly? }    # => false
p IO::Buffer.for("test".freeze) { |buf| buf.readonly? } # => true

p IO::Buffer.new(4).readonly?                       # => false
```

### def mapped? -> bool

バッファがマップ(mapped)バッファである場合に true を返します。

マップバッファは、仮想メモリ機構でマップされたメモリ領域を参照します。
[m:IO::Buffer.new] に [m:IO::Buffer::MAPPED] を指定した場合や、
大きさが [m:IO::Buffer::PAGE_SIZE] 以上の場合は匿名のマップになります。
[m:IO::Buffer.map] で作った場合はファイルに紐づいたマップになります。

### def locked? -> bool

バッファがロックされている場合に true を返します。

ロックされたバッファは大きさの変更や解放ができず、
さらにロックを取得することもできません。
システムコールでバッファを使っている間に、そのバッファが移動しないことを
保証するための仕組みです。

#@since 3.2
### def shared? -> bool

バッファが共有(shared)バッファである場合に true を返します。

共有バッファは、他のプロセスと共有できるメモリ領域を参照します。
そのため、このプロセスで変更しなくても内容が変わることがあります。
#@end

#@since 3.3
### def private? -> bool

バッファがプライベート(private)バッファである場合に true を返します。

プライベートバッファに加えた変更は、元になったファイルのマッピングには反映されません。
#@end
