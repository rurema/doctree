require tmpdir

テンポラリファイルを操作するためのクラスです

= class Tempfile < File
#@#= class Tempfile < DelegateClass(File)

テンポラリファイルを操作するためのクラスです。

 * テンポラリファイルを作成します。
   ファイルは "w+" モードで "basename.pid.n" という名前になります。
 * Tempfile オブジェクトは[[c:File]]オブジェクトと同じように使うことができます。
 * Tempfile#close(true) により、作成したテンポラリファイルは削除されます。
 * スクリプトが終了するときにも削除されます。
 * [[m:Tempfile#open]]により、テンポラリファイルを再オープンすることができます。
 * テンポラリファイルのモードは 0600 です。

== Class Methods

--- new(basename, tempdir = Dir::tmpdir)
--- open(basename, tempdir = Dir::tmpdir)

"basename.pid.n" というファイル名で
テンポラリファイルを作成し、インスタンスを返します。

@param tempdir テンポラリファイルが作られるディレクトリです。
このデフォルト値は、[[m:Dir.tmpdir]] の値となります。

== Instance Methods

--- close(real = false)

テンポラリファイルをクローズします。
real が偽ならば、テンポラリファイルはGCによって削除されます。
そうでなければ、すぐに削除されます。

@param real false もしくはそれ以外を指定します。

--- open

クローズしたテンポラリファイルを再オープンします。
"r+" でオープンされるので、クローズ前の内容を再度読む
ことができます。

  tf = Tempfile.new("foo")
  tf.print("foobar,hoge\n")
  tf.print("bar,ugo\n")
  tf.close
  tf.open
  p tf.gets # => "foobar,hoge\n"

--- path

テンポラリファイルのパス名を返します。

  tf = Tempfile.new("hoo")
  p tf.path # => "/tmp/hoo.10596.0" 

#@since 1.6.8
--- length
--- size
テンポラリファイルのサイズを返します。

  tf = Tempfile.new("foo")
  tf.print("bar,ugo")
  p tf.size # => 7
  tf.close
  p tf.size # => 0
#@end

--- close!
テンポラリファイルをクローズし、すぐに削除します。

--- delete
--- unlink
#@todo
テンポラリファイルをクローズせずに、削除します。
UNIXライクなシステムでは、
作成したテンポラリファイルが他のプログラムに使用される機会をなくすために
テンポラリファイルを作成しオープンした後
すぐに削除するということがしばしばおこなわれます。

#@# Unlinks the file. On UNIX-like systems, it is often a good idea
#@# to unlink a temporary file immediately after creating and opening
#@# it, because it leaves other programs zero chance to access the
#@# file.

  tf = Tempfile.new("foo")
  tf.unlink
  p tf.path # => nil
  tf.print("foobar,hoge\n")
  tf.rewind
  p tf.gets("\n") # => "foobar,hoge\n"
