---
library: _builtin
since: "4.1"
---
# class IO::Buffer::Storage < IO::Buffer

メモリ領域を管理する [c:IO::Buffer] です。
Ruby 4.1 で導入されました。

[m:IO::Buffer.new]・[m:IO::Buffer.for]・[m:IO::Buffer.map] が返すのは、このクラスのインスタンスです。
管理するメモリ領域は、Ruby が確保した内部(internal)のもの、仮想メモリ機構でマップされたもの、[c:String] など他のオブジェクトから借りた外部(external)のもののいずれかです。

バイト単位の読み書きなどの基本的な操作は、[c:IO::Buffer] と共通です。
このクラスに固有なのは、メモリ領域の確保と解放に関する次のメソッドです。

  - 大きさと所有権: [m:IO::Buffer::Storage#resize]、[m:IO::Buffer::Storage#transfer]、[m:IO::Buffer::Storage#free]
  - 種類の判定: [m:IO::Buffer::Storage#internal?]、[m:IO::Buffer::Storage#external?]、[m:IO::Buffer::Storage#mapped?]、[m:IO::Buffer::Storage#shared?]、[m:IO::Buffer::Storage#private?]

このクラスのインスタンスが、必ずメモリ領域を所有しているわけではありません。
[m:IO::Buffer.for] で作った外部バッファも、このクラスのインスタンスです。

[m:IO::Buffer::Storage#dup] と [m:IO::Buffer::Storage#clone] は、バイトをコピーして独立した [c:IO::Buffer::Storage] を作ります。
別のバッファの一部を参照する [c:IO::Buffer::Slice] とは、この点が異なります。

```ruby
buf = IO::Buffer.new(8)
p buf.class             # => IO::Buffer::Storage

# dup で作った複製は、元のバッファとは独立している
copy = buf.dup
copy.set_string("Ruby")
p copy.get_string(0, 4) # => "Ruby"
p buf.get_string(0, 4)  # => "\x00\x00\x00\x00"
```

- **SEE** [c:IO::Buffer], [c:IO::Buffer::Slice]

## Instance Methods

### def resize(size) -> self

バッファの大きさを `size` バイトに変更します。

変更前の内容は保持されます。
変更後の大きさによっては、メモリ領域が別の場所に確保しなおされ、内容がそこへコピーされます。

[m:IO::Buffer.for] で作った外部バッファや、ロックされたバッファは大きさを変更できません。
[c:IO::Buffer::Slice] の大きさは、[m:IO::Buffer::Slice#resize] で変更します。

- **param** `size` -- 変更後の大きさをバイト数で指定します。
- **raise** `IO::Buffer::AccessError` -- 大きさを変更できないバッファに対して呼び出した場合に発生します。
- **raise** `FrozenError` -- 凍結済みのバッファに対して呼び出した場合に発生します。
- **raise** `IO::Buffer::LockedError` -- ロックされているバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("test")

buf.resize(8)
p buf.size             # => 8
p buf.get_string(0, 4) # => "test"

IO::Buffer.for("abc").resize(8) # ~> IO::Buffer::AccessError
```

- **SEE** [m:IO::Buffer::Slice#resize]

### def transfer -> IO::Buffer::Storage

メモリ領域の所有権を新しい [c:IO::Buffer::Storage] へ移し、その新しいバッファを返します。

所有権を手放した自身は、どのメモリ領域も指さない状態になります。
この状態は [m:IO::Buffer#null?] で調べられます。
自身から [m:IO::Buffer#slice] で作った [c:IO::Buffer::Slice] は、無効になります。

[c:IO::Buffer::Slice] には、このメソッドはありません。

- **raise** `FrozenError` -- 凍結済みのバッファに対して呼び出した場合に発生します。
- **raise** `IO::Buffer::LockedError` -- ロックされているバッファに対して呼び出した場合に発生します。

```ruby
buf = IO::Buffer.new(4)
buf.set_string("Ruby")

other = buf.transfer
p other.get_string # => "Ruby"

p buf.null? # => true
p buf.size  # => 0
```

- **SEE** [m:IO::Buffer::Storage#free], [m:IO::Buffer#null?]

### def free -> self

バッファが確保しているメモリ領域を解放します。

解放の内容はバッファの種類によって異なります。

  - 内部(internal) -- 確保したメモリを解放します。
  - 外部(external) -- 元のオブジェクトとの関連を解消します。
  - マップ(mapped) -- マッピングを解除します。

解放後は、どのメモリ領域も指さない状態になります。
この状態のバッファは大きさ 0 のバッファとして扱われます。

解放したバッファでも [m:IO::Buffer::Storage#resize] を呼べば、あらためてメモリ領域を確保できます。

[c:IO::Buffer::Slice] には、このメソッドはありません。

- **raise** `FrozenError` -- 凍結済みのバッファに対して呼び出した場合に発生します。
- **raise** `IO::Buffer::LockedError` -- ロックされているバッファに対して呼び出した場合に発生します。

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

- **SEE** [m:IO::Buffer::Storage#transfer], [m:IO::Buffer#null?]

### def internal? -> bool

バッファが内部(internal)バッファである場合に true を返します。

内部バッファは、バッファ自身が確保したメモリ領域を参照します。
文字列などの外部のメモリやファイルのマッピングとは結び付いていません。
[m:IO::Buffer.new] で作られるバッファは既定で内部バッファです。

```ruby
p IO::Buffer.new(4).internal? # => true
```

- **SEE** [m:IO::Buffer::Storage#external?]

### def external? -> bool

バッファが外部(external)バッファである場合に true を返します。

外部バッファは、バッファ自身が確保・マップしたのではないメモリ領域を参照します。
[m:IO::Buffer.for] で作ったバッファは、文字列のメモリを外部参照します。
外部バッファは大きさを変更できません。

```ruby
p IO::Buffer.for("test").external? # => true
p IO::Buffer.new(4).external?      # => false
```

- **SEE** [m:IO::Buffer::Storage#internal?]

### def mapped? -> bool

バッファがマップ(mapped)バッファである場合に true を返します。

マップバッファは、仮想メモリ機構でマップされたメモリ領域を参照します。
[m:IO::Buffer.new] に [m:IO::Buffer::MAPPED] を指定した場合や、大きさが [m:IO::Buffer::PAGE_SIZE] 以上の場合は匿名のマップになります。
[m:IO::Buffer.map] で作った場合はファイルに紐づいたマップになります。

### def shared? -> bool

バッファが共有(shared)バッファである場合に true を返します。

共有バッファは、他のプロセスと共有できるメモリ領域を参照します。
そのため、このプロセスで変更しなくても内容が変わることがあります。

### def private? -> bool

バッファがプライベート(private)バッファである場合に true を返します。

プライベートバッファに加えた変更は、元になったファイルのマッピングには反映されません。

### def dup -> IO::Buffer::Storage
### def clone -> IO::Buffer::Storage

バッファの内容を、独立した内部バッファにコピーして返します。

複製への変更は元のバッファに影響せず、元のバッファへの変更も複製に影響しません。
元のバッファが外部バッファや読み取り専用でも、複製は内部バッファで、書き込みできます。

```ruby
buf = IO::Buffer.for("abc")
p buf.external?  # => true
p buf.readonly?  # => true

copy = buf.dup
p copy.internal? # => true
p copy.readonly? # => false
p copy.source    # => nil
```

- **SEE** [m:IO::Buffer::Slice#dup]
