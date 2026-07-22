---
library: _builtin
include:
  - Enumerable
---
# class ARGF.class

[c:ARGF] を表すクラスです。

## Public Instance Methods

### def filename -> String
{: since=""}
### def path -> String
{: since=""}

現在開いている処理対象のファイル名を返します。

標準入力に対しては - を返します。
組み込み変数 [m:$FILENAME] と同じです。

```console
$ echo "foo" > foo
$ echo "bar" > bar
$ echo "glark" > glark

$ ruby argf.rb foo bar glark

ARGF.filename # => "foo"
ARGF.read(5)  # => "foo\nb"
ARGF.filename # => "bar"
ARGF.skip
ARGF.filename # => "glark"
```

### def to_s -> String
{: since=""}
### def inspect -> String

常に文字列 "ARGF" を返します。

### def file -> IO
{: since=""}

現在開いている処理対象の [c:File] オブジェクト(または [c:IO] オブジェ
クト)を返します。

```console
$ echo "foo" > foo
$ echo "bar" > bar

$ ruby argf.rb foo bar

ARGF.file      # => #<File:foo>
ARGF.read(5)   # => "foo\nb"
ARGF.file      # => #<File:bar>
```

ARGFが現在開いている処理対象が標準入力の場合、$stdin を返します。

### def lineno -> Integer
{: since=""}

全引数ファイルを一つのファイルとみなしたときの現在の行番号を返します。
個々の引数ファイル毎の行番号を得るには ARGF.file.lineno とします。

この値を書き換えたい場合は [m:ARGF.class#lineno=] を使用してください。

```ruby
p ARGF.lineno # => 0
p ARGF.readline # => "This is line 1\n"
p ARGF.lineno # => 1
```

- **SEE** [m:ARGF.class#lineno=]

### def lineno=(number)
{: since=""}

全引数ファイルを一つのファイルとみなしたときの現在の行番号を number に書き換えます。

この値を読み込みたい場合は [m:ARGF.class#lineno] を使用してください。

- **param** `number` -- 更新後の行番号を指定する

```ruby
p ARGF.lineno    # => 0
p ARGF.readline  # => "This is line 1\n"
p ARGF.lineno    # => 1
ARGF.lineno = 0  # => 0
p ARGF.lineno    # => 0
```

- **SEE** [m:ARGF.class#lineno]

### def skip -> self
{: since=""}

現在開いている処理対象のファイルをクローズします。
次回の読み込みは次の引数が処理対象になります。
self を返します。

```console
$ echo "foo" > foo
$ echo "bar" > bar

$ ruby argf.rb foo bar
ARGF.filename  # => "foo"
ARGF.skip
ARGF.filename  # => "bar"
```

### def binmode -> self
{: since=""}

self をバイナリモードにします。一度バイナリモードになった後は非バイナリ
モードに戻る事はできません。

バイナリモード下では以下のように動作します。

- 改行の変換を停止する
- 文字エンコーディングの変換を停止する
- 内容を ASCII-8BIT として扱う

```ruby title="例"
# test1.png - 164B
# test2.png - 128B
# test1.png + test2.png = 292B

# $ ruby test.rb test1.png test2.png

ARGF.binmode
p ARGF.read.size  # => 292
```

```ruby title="例"
# test1.png - 164B
# test2.png - 128B
# test1.png + test2.png = 292B

# $ ruby test.rb test1.png test2.png

p ARGF.read.size  # => 290
```

- **SEE** [m:IO#binmode], [m:ARGF.class#binmode?]

### def binmode? -> bool
{: since="1.9.1"}

ARGF の入力ストリームがバイナリモードなら true を返します。
そうでない場合、false を返します。

バイナリモードにするためには [m:ARGF.class#binmode] を使用します。

```ruby
p ARGF.binmode? # => false
ARGF.binmode
p ARGF.binmode? # => true
```

- **SEE** [m:IO#binmode?], [m:ARGF.class#binmode]

### def close -> self
{: since=""}

現在開いている処理対象のファイルをクローズします。開くファイルが残って
いる場合は次のファイルをオープンします。
ただし、標準入力はクローズされません。

```console
$ echo "foo" > foo
$ echo "bar" > bar

$ ruby argf.rb foo bar

ARGF.filename  # => "foo"
ARGF.close
ARGF.filename  # => "bar"
ARGF.close
```

- **SEE** [m:ARGF.class#closed?]

### def closed? -> bool
{: since=""}

現在開いている処理対象のファイルがARGFがcloseされていればtrueを返します。

```ruby title="例"
# $ echo "foo" > foo
# $ echo "bar" > bar
# $ ruby argf.rb foo bar

p ARGF.filename  # => "foo"
ARGF.close
# 複数のファイルを開いているので1度のARGF.closeではまた全てのファイルを閉じていないのでfalseになる
p ARGF.closed? # => false
p ARGF.filename  # => "bar"
ARGF.close
# 2つのファイルを開いていたので2度目のARGF.closeで全てのファイルを閉じたためtrueになる
p ARGF.closed? # => true
```

- **SEE** [m:IO#closed?], [m:ARGF.class#close]

### def each(rs = $/) { |line| ... }             -> self
{: since=""}
### def each_line(rs = $/) { |line| ... }        -> self
{: since=""}
### def each(rs = $/, limit) { |line| ... }      -> self
{: since=""}
### def each_line(rs = $/, limit) { |line| ... } -> self
{: since=""}
### def each(rs = $/)                            -> Enumerator
{: since=""}
### def each_line(rs = $/)                       -> Enumerator
{: since=""}
### def each(rs = $/, limit)                     -> Enumerator
{: since=""}
### def each_line(rs = $/, limit)                -> Enumerator
{: since=""}

ARGFの現在位置から 1 行ずつ文字列として読み込み、それを引数として与えら
れたブロックを実行します。

ブロックが与えられなかった場合は、[c:Enumerator] オブジェクトを生成し
て返します。

このメソッドはスクリプトに指定した引数([m:Object::ARGV] を参照) をファ
イル名とみなして、それらのファイルを連結した 1 つの仮想ファイルを表すオ
ブジェクトです。そのため、最初のファイルを最後まで読んだ後は次のファイ
ルの内容を返します。現在の行についてファイル名や行数を得るには
[m:ARGF.class#filename] と [m:ARGF.class#lineno] を使用します。

- **param** `rs` -- 行の区切りを文字列で指定します。nil を指定すると行区切りなし
          とみなします。空文字列 "" を指定すると連続する改行を行の区切
          りとみなします(パラグラフモード)。

- **param** `limit` -- 各行の最大の読み込みバイト数

例: ARGFの各ファイル名(最初に1回のみ)、行番号、内容を表示

```ruby
ARGF.each_line do |line|
  puts ARGF.filename if ARGF.lineno == 1
  puts "#{ARGF.lineno}: #{line}"
end
```

- **SEE** [m:IO#each], [m:IO#each_line]

### def each_byte { |byte| ...} -> self
{: since=""}
### def each_byte               -> Enumerator
{: since=""}

ARGF の現在位置から 1 バイトずつ読み込み、それを整数として与え、ブロックを実行します。
ブロック引数byteは0..255のいずれかの整数です。

このメソッドはスクリプトに指定した引数([m:Object::ARGV] を参照) をファ
イル名とみなして、それらのファイルを連結した 1 つの仮想ファイルを表すオ
ブジェクトです。そのため、最初のファイルを最後まで読んだ後は次のファイ
ルの内容を返します。現在位置の1バイトについてファイル名を得るには
[m:ARGF.class#filename] を使用します。

ブロックが与えられなかった場合は、[c:Enumerator] オブジェクトを生成して返します。

```ruby title="例"
p ARGF.each_byte.to_a  # => [35, 32, ... 95, 10]
```

- **SEE** [m:IO#each_byte]

### def each_char { |c| ... } -> self
{: since=""}
### def each_char             -> Enumerator
{: since=""}

レシーバに含まれる文字を一文字ずつブロックに渡して評価します。

このメソッドはスクリプトに指定した引数([m:Object::ARGV] を参照) をファ
イル名とみなして、それらのファイルを連結した 1 つの仮想ファイルを表すオ
ブジェクトです。そのため、最初のファイルを最後まで読んだ後は次のファイ
ルの内容を返します。現在位置の1文字についてファイル名を得るには
[m:ARGF.class#filename] を使用します。

ブロックが与えられなかった場合は、[c:Enumerator] オブジェクトを生成し
て返します。

```ruby title="例"
# $ echo "line1\n" > test1.txt
# $ echo "line2\n" > test2.txt
# $ ruby test.rb test1.txt test2.txt

# test.rb
p ARGF.each_char        # => #<Enumerator: ARGF:each_char>
ARGF.each_char{|e|p e}

# => "l"
#    "i"
#    "n"
#    "e"
#    "1"
#    "\n"
#    "l"
#    "i"
#    "n"
#    "e"
#    "2"
#    "\n"
```

- **SEE** [m:IO#each_char]

### def each_codepoint { |c| ... }   -> self
### def each_codepoint               -> Enumerator

self の各コードポイントに対して繰り返しブロックを呼びだします。

ブロックの引数にはコードポイントを表す整数が渡されます。

ブロックを省略した場合には、[c:Enumerator] を返します。

```ruby title="例"
# $ echo "line1\n" > test1.txt
# $ echo "line2\n" > test2.txt
# $ ruby test.rb test1.txt test2.txt

# test.rb
p ARGF.each_codepoint                # => #<Enumerator: ARGF:each_codepoint>
p ARGF.each_codepoint{|e|print e, ","} # => 108,105,110,101,49,10,108,105,110,101,50,10,
```

### def eof  -> bool
{: since=""}
### def eof? -> bool
{: since=""}

現在開いているファイルがEOFに達したらtrueを返します。そうでない場合は
falseを返します。

- **raise** `IOError` -- ファイルがopenされていない場合に発生します。

```console
$ echo "eof" | ruby argf.rb

ARGF.eof?                 # => false
3.times { ARGF.readchar }
ARGF.eof?                 # => false
ARGF.readchar             # => "\n"
ARGF.eof?                 # => true
```

- **SEE** [m:IO#eof], [m:IO#eof?]

### def fileno -> Integer
{: since=""}
### def to_i   -> Integer
{: since=""}

現在オープンしているファイルのファイル記述子を表す整数を返します。

```ruby
p ARGF.fileno  # => 3
```

- **raise** `ArgumentError` -- 現在開いているファイルがない場合に発生します。

### def getc -> String | nil
{: since=""}

self から 1 文字読み込んで返します。EOF に到達した時には nil を返します。

ARGF はスクリプトに指定した引数([m:Object::ARGV] を参照) をファイル名
とみなして、それらのファイルを連結した 1 つの仮想ファイルを表すオブジェ
クトです。そのため、最初のファイルを最後まで読んだ後は次のファイルの内
容を返します。

```console
$ echo "foo" > file1
$ echo "bar" > file2
$ ruby argf.rb file1 file2

ARGF.getc # => "f"
ARGF.getc # => "o"
ARGF.getc # => "o"
ARGF.getc # => "\n"
ARGF.getc # => "b"
ARGF.getc # => "a"
ARGF.getc # => "r"
ARGF.getc # => "\n"
ARGF.getc # => nil
```

- **SEE** [m:ARGF.class#getbyte], [m:ARGF.class#gets]

### def gets(rs = $/, chomp: false)   -> String | nil
{: since=""}
### def gets(limit, chomp: false)     -> String | nil
{: since=""}
### def gets(rs, limit, chomp: false) -> String | nil
{: since=""}

ARGFの現在位置から一行ずつ文字列として読み込みます。EOF に到達した時に
は nil を返します。

- **param** `rs` -- 行の区切りを文字列で指定します。rs に nil を指定すると行区切
          りなしとみなします。空文字列 "" を指定すると連続する改行を行
          の区切りとみなします(パラグラフモード)。

- **param** `limit` -- 最大の読み込みバイト数

- **param** `chomp` -- true を指定すると各行の末尾から "\n", "\r", または "\r\n" を取り除きます。

```ruby title="例"
# $ echo "line1\nline2\nline3\n\nline4\n" > test.txt
# $ ruby test.rb test.txt

# test.rb
p ARGF.gets                # => "line1\n"
```

```ruby title="例"
# $ echo "line1\nline2\nline3\n\nline4\n" > test.txt
# $ ruby test.rb test.txt

# test.rb
p ARGF.gets(2)                # => "li"
```

```ruby title="例"
# $ echo "line1\nline2\nline3\n\nline4\n" > test.txt
# $ ruby test.rb test.txt

# test.rb
p ARGF.gets("e")                # => "line"
```


```ruby title="例"
# $ echo "line1\nline2\nline3\n\nline4\n" > test.txt
# $ ruby test.rb test.txt

# test.rb
p ARGF.gets("")                # => "line1\nline2\nline3\n\n"
```

- **SEE** [m:Kernel?.gets], [m:IO#gets], [m:ARGF.class#getbyte], [m:ARGF.class#getc]

### def pos  -> Integer
{: since=""}
### def tell -> Integer
{: since=""}

ARGFが現在開いているファイルのファイルポインタの現在の位置をバイト単位
の整数で返します。

```ruby
p ARGF.pos  # => 0
p ARGF.gets # => "This is line one\n"
p ARGF.pos  # => 17
```

- **SEE** [m:IO#pos], [m:IO#tell], [m:ARGF.class#pos=]

### def pos=(n)
{: since=""}

ARGFが開いているファイルのファイルポインタを指定位置に移動します。

- **param** `n` -- 先頭からのオフセットをバイト単位の整数で指定します。

```ruby
ARGF.pos = 17
p ARGF.gets # => "This is line two\n"
```

- **SEE** [m:IO#pos=], [m:ARGF.class#pos]

### def read(length = nil, str = nil) -> String | nil
{: since=""}

ARGVに指定されたファイルを先頭のファイルからlengthバイト読み込み、
その文字列をstrに出力します。読み込んだ文字列を返します。

- **param** `length` -- 読み込むバイト数を指定します。nilの場合はARGVのすべてのファ
              イルを読み込みます。

- **param** `str` -- 出力先の文字列。内容は上書きされます。

```console
$ echo "small" > small.txt
$ echo "large" > large.txt
$ ruby glark.rb small.txt large.txt

ARGF.read      # => "small\nlarge"
ARGF.read(200) # => "small\nlarge"
ARGF.read(2)   # => "sm"
ARGF.read(0)   # => ""
```

- **SEE** [m:IO#read]

### def readchar -> String
{: since=""}

ARGFから 1 文字読み込んで、その文字に対応する String を返します。EOF に
到達した時には EOFErrorを発生します。

- **raise** `EOFError` -- EOFに達した時発生する

```console
$ echo "foo" > file
$ ruby argf.rb file

ARGF.readchar  # => "f"
ARGF.readchar  # => "o"
ARGF.readchar  # => "o"
ARGF.readchar  # => "\n"
ARGF.readchar  # => end of file reached (EOFError)
```

- **SEE** [m:ARGF.class#getc]

### def readline(rs = $/)   -> String
{: since=""}
### def readline(limit)     -> String
{: since=""}
### def readline(rs, limit) -> String
{: since=""}

ARGFの現在位置から一行ずつ文字列として読み込みます。EOF に到達した時に
は [c:EOFError] を発生します。

- **param** `rs` -- 行の区切りを文字列で指定します。rs に nil を指定すると行区切
          りなしとみなします。空文字列 "" を指定すると連続する改行を行
          の区切りとみなします(パラグラフモード)。

- **param** `limit` -- 最大の読み込みバイト数

- **raise** `EOFError` -- EOFに達したら発生する

- **SEE** [m:Kernel?.readline], [m:ARGF.class#gets]

### def readlines(rs = $/)   -> Array
{: since=""}
### def readlines(limit)     -> Array
{: since=""}
### def readlines(rs, limit) -> Array
{: since=""}
### def to_a(rs = $/)        -> Array
{: since=""}
### def to_a(limit)          -> Array
{: since=""}
### def to_a(rs, limit)      -> Array
{: since=""}

ARGFの各行を配列に読み込んで返します。rsがnilの場合は要素に各ファイルを
すべて読み込んだ配列を返します。

- **param** `rs` -- 行区切り文字

- **param** `limit` -- 最大の読み込みバイト数

```ruby
lines = ARGF.readlines
p lines[0]              # => "This is line one\n"
```

- **SEE** [m:$/], [m:Kernel?.readlines], [m:IO#readlines]

### def rewind -> 0
{: since=""}

ARGFが現在開いているファイルのファイルポインタを先頭に戻します。

```ruby
p ARGF.readline # => "This is line one\n"
p ARGF.rewind   # => 0
p ARGF.lineno   # => 0
p ARGF.readline # => "This is line one\n"
```

### def seek(offset, whence = IO::SEEK_SET) -> 0
{: since=""}

ARGFが現在開いているファイルのファイルポインタを whence の位置から
offset だけ移動させます。 offset 位置への移動が成功すれば 0 を返します。

- **param** `offset` -- ファイルポインタを移動させるオフセットを整数で指定します。
- **param** `whence` -- [m:IO#seek] を参照。

- **SEE** [m:IO#seek]

### def to_io -> IO
{: since=""}

ARGFが現在開いているファイルの[c:File]、または[c:IO]オブジェクトを
返します。

```ruby
p ARGF.to_io  # => #<File:glark.txt>
p ARGF.to_io  # => #<IO:<STDIN>>
```

- **SEE** [m:ARGF.class#file], [m:ARGF.class#to_write_io]

### def getbyte   -> Integer | nil
{: since=""}

self から 1 バイト(0..255)を読み込み整数として返します。
既に EOF に達していれば nil を返します。

ARGF はスクリプトに指定した引数([m:Object::ARGV] を参照) をファイル名
とみなして、それらのファイルを連結した 1 つの仮想ファイルを表すオブジェ
クトです。そのため、最初のファイルを最後まで読んだ後は次のファイルの内
容を返します。

```console
$ echo "foo" > file1
$ echo "bar" > file2
$ ruby argf.rb file1 file2

ARGF.getbyte # => 102
ARGF.getbyte # => 111
ARGF.getbyte # => 111
ARGF.getbyte # => 10
ARGF.getbyte # => 98
ARGF.getbyte # => 97
ARGF.getbyte # => 114
ARGF.getbyte # => 10
ARGF.getbyte # => nil
```

- **SEE** [m:ARGF.class#getc], [m:ARGF.class#gets]

### def readbyte   -> Integer
{: since=""}

自身から 1 バイトを読み込み整数として返します。
既に EOF に達していれば EOFError が発生します。

- **raise** `EOFError` -- 既に EOF に達している場合に発生します。

```console
$ echo "foo" > file
$ ruby argf.rb file

ARGF.readbyte  # => 102
ARGF.readbyte  # => 111
ARGF.readbyte  # => 111
ARGF.readbyte  # => 10
ARGF.readbyte  # => end of file reached (EOFError)
```

### def readpartial(maxlen, outbuf = nil) -> String

[m:IO#readpartial]を参照。[m:ARGF.class#read] などとは違って複数ファ
イルを同時に読み込むことはありません。

- **param** `maxlen` -- 読み込む長さの上限を整数で指定します。
- **param** `outbuf` -- 読み込んだデータを格納する [c:String] オブジェクトを指定します。

- **SEE** [m:IO#readpartial], [m:ARGF.class#read_nonblock]

### def argv -> Array
{: since="1.9.1"}

[m:Object::ARGV] を返します。

ARGF が ARGV をどう扱うかについては [c:ARGF] を参照してください。

例:

```console
$ ruby argf.rb -v glark.txt

ARGF.argv   #=> ["-v", "glark.txt"]
```

### def external_encoding -> Encoding
{: since="1.9.1"}

ARGF が処理するファイルに対する外部エンコーディングを返します。
デフォルトは [m:Encoding.default_external] です。

[m:ARGF.class#set_encoding] で設定します。

```ruby title="例"
p ARGF.external_encoding  # =>  #<Encoding:UTF-8>
```

- **SEE** [c:IO], [m:ARGF.class#internal_encoding]

### def internal_encoding -> Encoding | nil
{: since="1.9.1"}

ARGF から読み込んだ文字列の内部エンコーディングを返します。
内部エンコーディングが指定されていない場合は nil を返します。

まだ読み込み処理を始めていない場合は [m:Encoding.default_external] を返します。

[m:ARGF.class#set_encoding] で設定します。


```ruby title="例"
# $ ruby -Eutf-8 test.rb

# test.rb
p ARGF.internal_encoding          # => #<Encoding:UTF-8>
ARGF.set_encoding('utf-8','ascii')
p ARGF.internal_encoding          # => #<Encoding:US-ASCII>
```

```ruby title="例"
ARGF.binmode
p ARGF.internal_encoding          # => nil
```

- **SEE** [c:IO], [m:ARGF.class#external_encoding]

### def set_encoding(ext_enc)                        -> self
{: since="1.9.1"}
### def set_encoding(enc_str, options = {})          -> self
{: since="1.9.1"}
### def set_encoding(ext_enc, int_enc, options = {}) -> self
{: since="1.9.1"}

ARGF の外部／内部エンコーディングを設定します。
次以降に処理するファイルにも同じ設定が適用されます。

外部エンコーディングは ARGF を介して読み込むファイルの、
内部エンコーディングは読み込んだ文字列のエンコーディングです。

詳しくは [m:IO#set_encoding] を参照してください。

- **param** `enc_str` -- 外部／内部エンコーディングを"A:B" のようにコロンで
               区切って指定します。
- **param** `ext_enc` -- 外部エンコーディングを表す文字列か
               [c:Encoding] オブジェクトを指定します。
- **param** `int_enc` -- 内部エンコーディングを表す文字列か
               [c:Encoding] オブジェクトを指定します。
- **param** `options` -- エンコーディング変換のオプション。
               [m:String#encode] と同じものが指定できます。

- **SEE** [m:String#encode]

### def inplace_mode -> String | nil
{: since="1.9.1"}

[ref:c:ARGF#inplace] で書き換えるファイルのバックアップに付加される拡
張子を返します。拡張子が設定されていない場合は空文字列を返します。イン
プレースモードでない場合は nil を返します。

Ruby 起動時の -i オプション や [m:ARGF.class#inplace_mode=] で設定します。

```ruby title="例"
# $ echo "test" > test.txt
# $ ruby -i.bak test.rb test.txt
# $ cat test.txt # => "TEST"
# $ cat test.txt.bak # => "test"

# test.rb
p ARGF.inplace_mode                 # => ".bak"
p ARGF.each_line {|e|print e.upcase}  # => "TEST"
```

```ruby title="例"
# $ echo "test" > test.txt
# $ ruby test.rb test.txt
# $ cat test.txt # => "test"

# test.rb
p ARGF.inplace_mode                 # => nil
p ARGF.each_line {|e|print e.upcase}  # => "TEST"
```

- **SEE** [ref:d:spec/rubycmd#cmd_option], [m:ARGF.class#inplace_mode=]

### def inplace_mode=(ext)
{: since="1.9.1"}

[ref:c:ARGF#inplace]時にバックアップファイルに付加する拡張子を設定します。
ピリオドも含めて指定する必要があります。

バックアップを残さない場合は空文字列を指定します。
#@# 要確認。分岐はないように見える。
この機能は Windows では使用出来ません。

設定が有効になるのは次のファイルの処理に移った時です。
インプレースモードに入っていない場合はその時点でモードに入ります。

Ruby 起動時の -i オプションで設定することも出来ます。

- **param** `ext` -- インプレースモード時にバックアップファイルに付加する拡張子を
           文字列で指定します。
           ピリオドも含める必要があります。

```console
$ ruby argf.rb file.txt

---- argf.rb ----
# 引数のファイル中の各行の最初の "foo" を "bar" で置き換える
ARGF.inplace_mode = '.bak'
ARGF.lines do |line|
  print line.sub("foo","bar")
end


---- -i オプションを使う場合 ----
$ ruby -i.bak -p -e '$_.sub!("foo","bar")' file.txt

---- -i オプションを使う場合その２ ----
$ ruby -i.bak -n -e 'print $_.sub("foo","bar")' file.txt
```

- **SEE** [ref:d:spec/rubycmd#cmd_option], [m:ARGF.class#inplace_mode]

### def print(*arg)  -> nil
{: since="1.9.3"}

引数を順に処理対象のファイルに出力します。

[ref:c:ARGF#inplace]時にのみ使用できます。
また [m:$stdout] への代入の影響を受けません。
それ以外は [m:Kernel?.print] と同じです。

- **param** `arg` -- 出力するオブジェクトを任意個指定します。

### def printf(format, *arg)  -> nil
{: since="1.9.3"}

C 言語の printf と同じように、format に従い引数を
文字列に変換して処理対象のファイルに出力します。

[ref:c:ARGF#inplace]時にのみ使用できます。
また [m:$stdout] への代入の影響を受けません。
それ以外は出力先を指定しない形式の [m:Kernel?.printf] と同じです。

- **param** `format` -- フォーマット文字列です。
- **param** `arg` -- フォーマットされる引数です。


### def putc(ch)  -> object
{: since="1.9.3"}

文字 ch を処理対象のファイルに出力します。
ch を返します。

[ref:c:ARGF#inplace]時にのみ使用できます。
また [m:$stdout] への代入の影響を受けません。
それ以外は [m:Kernel?.putc] と同じです。

- **param** `ch` -- 出力する文字を [c:String] オブジェクトで指定します。

### def puts(*arg)  -> nil
{: since="1.9.3"}

引数と改行を順番に処理対象のファイルに出力します。
引数がなければ改行のみを出力します。

[ref:c:ARGF#inplace]時にのみ使用できます。
また [m:$stdout] への代入の影響を受けません。
それ以外は [m:Kernel?.puts] と同じです。

- **param** `arg` -- 出力するオブジェクトを任意個指定します。

### def read_nonblock(maxlen, outbuf = nil, exception: true) -> String | Symbol | nil
{: since="1.9.3"}
#@# TODO: Windows では使えない？

処理中のファイルからノンブロッキングモードで最大 maxlen バイト読み込みます。
詳しくは [m:IO#read_nonblock] を参照してください。

[m:ARGF.class#read] などとは違って複数ファイルを同時に読み込むことはありません。

- **param** `maxlen` -- 読み込む長さの上限を整数で指定します。
- **param** `outbuf` -- 読み込んだデータを格納する [c:String] オブジェクトを指定します。
- **param** `exception` -- 読み込み時に [c:Errno::EAGAIN]、
                 [c:Errno::EWOULDBLOCK] が発生する代わりに
                 :wait_readable を返すかどうかを指定します。また、false
                 を指定した場合は既に EOF に達していれば
                 [c:EOFError] の代わりに nil を返します。

- **SEE** [m:ARGF.class#readpartial]

### def to_write_io  -> IO
{: since="1.9.3"}

処理対象のファイルへの書き出し用 [c:IO] オブジェクトを返します。

[ref:c:ARGF#inplace]時以外は読み込み用の IO オブジェクトを返します。
このため [m:ARGF.class#write] などの書き出し用メソッドを呼ぶと [c:IOError] が発生します。

### def write(str)  -> Integer
{: since="1.9.3"}

処理対象のファイルに対して str を出力します。
str が文字列でなければ to_s による文字列化を試みます。
実際に出力できたバイト数を返します。

[ref:c:ARGF#inplace]時にのみ使用できます。

- **param** `str` -- 出力する文字列を指定します。

- **SEE** [m:ARGF.class#to_write_io]
