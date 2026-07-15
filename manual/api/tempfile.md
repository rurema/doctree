---
type: library
category: File
require:
  - tmpdir
  - delegate
---
テンポラリファイルを操作するためのクラスです

### 参考
標準添付ライブラリ紹介 【第 15 回】 tmpdir, tempfile  <https://magazine.rubyist.net/articles/0029/0029-BundledLibraries.html>

# class Tempfile < Delegator
#@#= class Tempfile < DelegateClass(File)

テンポラリファイルを操作するためのクラスです。

 - テンポラリファイルを作成します。
   ファイルは "w+" モードで "basename.pid.n" という名前になります。
 - Tempfile オブジェクトは[c:File]クラスへのDelegatorとして定義されており、[c:File]クラスのオブジェクトと同じように使うことができます。
 - Tempfile#close(true) により、作成したテンポラリファイルは削除されます。
 - スクリプトが終了するときにも削除されます。
 - [m:Tempfile#open]により、テンポラリファイルを再オープンできます。
 - テンポラリファイルのモードは 0600 です。

## Class Methods

### def new(basename = '', tempdir = nil, mode: 0, **options) -> Tempfile
### def open(basename = '', tempdir = nil, mode: 0, **options) -> Tempfile
### def open(basename = '', tempdir = nil, mode: 0, **options){|fp| ...} -> object

テンポラリファイルを作成し、それを表す Tempfile オブジェクトを生成して返します。
ファイル名のプレフィクスには指定された basename が使われます。
ファイルは指定された tempdir に作られます。
open にブロックを指定して呼び出した場合は、Tempfile オブジェクトを引数として ブロックを実行します。ブロックの実行が終了すると、ファイルは自動的に クローズされ、
ブロックの値をかえします。
new にブロックを指定した場合は無視されます。

- **param** `basename` -- ファイル名のプレフィクスを文字列で指定します。
                文字列の配列を指定した場合、先頭の要素がファイル名のプレフィックス、次の要素が
                サフィックスとして使われます。

- **param** `tempdir` -- テンポラリファイルが作られるディレクトリです。
               このデフォルト値は、[m:Dir.tmpdir] の値となります。

- **param** `mode` -- ファイルのモードを定数の論理和で指定します。[m:IO.open]
            と同じ([m:Kernel?.open]と同じ)ものが指定できます。

- **param** `options` -- ファイルのオプション引数を指定します。[m:IO.open] と同
               じものが指定できます。ただし、:permオプションは無視され
               ます。

```ruby title="例"
require "tempfile"
t = Tempfile.open(['hoge', 'bar'])
p t.path                            #=> "/tmp/hoge20080518-6961-5fnk19-0bar"
t2 = Tempfile.open(['t', '.xml'])
p t2.path                           #=> "/tmp/t20080518-6961-xy2wvx-0.xml"
```

```ruby title="例：ブロックを与えた場合"
require 'tempfile'

tf = Tempfile.open("temp"){|fp|
  fp.puts "hoge"
  fp
}
# テンポラリファイルへのパスを表示
p tf.path
p File.read(tf.path) #=> "hoge\n"
```

- **SEE** [m:Tempfile.create]

#@since 3.4
### def create(basename="", tmpdir=nil, mode: 0, anonymous: false, **options) -> File
### def create(basename="", tmpdir=nil, mode: 0, anonymous: false, **options){|fp| ...} -> object
#@else
### def create(basename="", tmpdir=nil, mode: 0, **options) -> File
### def create(basename="", tmpdir=nil, mode: 0, **options){|fp| ...} -> object
#@end

テンポラリファイルを作成し、それを表す File オブジェクトを生成して返します(Tempfileではありません)。
createはopenに似ていますが、finalizerによるファイルの自動unlinkを行いません。

ブロックを指定しなかった場合、tmpdirにファイルを作り、Fileオブジェクトを返します。
このファイルは自動的に削除されません。ファイルを削除する場合は明示的にunlinkすべきです。

ブロックを指定して呼び出した場合、tmpdirにファイルを作り、
Fileオブジェクトを引数としてブロックを呼び出します。
ブロック終了時にファイルをクローズするのはopenと同じですが、
createではファイルのunlinkも自動で行います。

- **param** `basename` -- ファイル名のプレフィクスを文字列で指定します。
               文字列の配列を指定した場合、先頭の要素がファイル名のプレフィックス、次の要素が
               サフィックスとして使われます。
- **param** `tmpdir` -- ファイルが作られるディレクトリです。
              このデフォルト値は、[m:Dir.tmpdir] の値となります。
- **param** `mode` -- ファイルのモードを定数の論理和で指定します。[m:IO.open]
            と同じ([m:Kernel?.open]と同じ)ものが指定できます。

#@since 3.4
- **param** `anonymous` -- テンポラリファイルを即時unlinkするかを指定します。
                 デフォルトは false です。
#@end

- **param** `options` -- ファイルのオプション引数を指定します。[m:IO.open] と同
               じものが指定できます。ただし、:permオプションは無視され
               ます。
- **SEE** [m:Tempfile.open]

```ruby title="例"
require "tempfile"
GC.disable
path = ""
Tempfile.create("foo") do |f|
  path = f.path
  p File.exist?(path) #=> true
end
p File.exist?(path) #=> false
```



## Instance Methods

### def close(real = false) -> nil

テンポラリファイルをクローズします。
real が偽ならば、テンポラリファイルはGCによって削除されます。
そうでなければ、すぐに削除されます。

- **param** `real` -- false もしくはそれ以外を指定します。

```ruby
require "tempfile"
tf = Tempfile.open("bar")
tf.close
p FileTest.exist?(tf.path) # => true
```
### def open -> self

クローズしたテンポラリファイルを再オープンします。
"r+" でオープンされるので、クローズ前の内容を再度読む
ことができます。

```ruby
require "tempfile"
tf = Tempfile.new("foo")
tf.print("foobar,hoge\n")
tf.print("bar,ugo\n")
tf.close
tf.open
p tf.gets # => "foobar,hoge\n"
```

### def path -> String | nil

テンポラリファイルのパス名を返します。

[m:Tempfile#close!] を実行後だった場合にはnilを返します。

```ruby
require "tempfile"
tf = Tempfile.new("hoo")
p tf.path # => "/tmp/hoo.10596.0"
tf.close!
p tf.path # => nil
```

### def length -> Integer
### def size -> Integer
テンポラリファイルのサイズを返します。

```ruby
require "tempfile"
tf = Tempfile.new("foo")
tf.print("bar,ugo")
p tf.size # => 7
tf.close
p tf.size # => 7
```

### def close! -> nil

テンポラリファイルをクローズし、すぐに削除します。

```ruby
require "tempfile"
tf = Tempfile.open("bar")
path = tf.path
tf.close!
p FileTest.exist?(path) # => false
```

### def delete -> self
### def unlink -> self

テンポラリファイルをクローズせずに、削除します。
UNIXライクなシステムでは、
作成したテンポラリファイルが他のプログラムに使用される機会をなくすために、
テンポラリファイルを作成しオープンした後、
すぐに削除するということがしばしばおこなわれます。

#@# Unlinks the file. On UNIX-like systems, it is often a good idea
#@# to unlink a temporary file immediately after creating and opening
#@# it, because it leaves other programs zero chance to access the
#@# file.

```ruby
require "tempfile"
tf = Tempfile.new("foo")
tf.unlink
p tf.path # => nil
tf.print("foobar,hoge\n")
tf.rewind
p tf.gets("\n") # => "foobar,hoge\n"
```
