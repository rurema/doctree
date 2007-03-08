= class Tempfile < File
#@#= class Tempfile < DelegateClass(File)

テンポラリファイルを操作するためのクラスです。

 * テンポラリファイルを作成します。
   ファイルは "w+" モードで "basename.pid.n" という名前になります。
 * Tempfile オブジェクトは IO オブジェクトと同じように使うことができます。
 * Tempfile#close(true) により、作成したテンポラリファイルは削除されます。
 * スクリプトが終了するときにも削除されます。
 * Tempfile#open により、テンポラリファイルを再オープンすることができます。
 * テンポラリファイルのモードは 0600 です。

== Class Methods

--- new(basename, tempdir = Dir::tmpdir)
--- open(basename, tempdir = Dir::tmpdir)
#@todo

"basenamepid.n" というファイル名で
テンポラリファイルを作成し、インスタンスを返します。

@param tempdir テンポラリファイルが作られるディレクトリです。
このデフォルト値は、 Dir::tmpdir[[m:Dir.tmpdir]] の値となります。

== Instance Methods

--- close(real = false)
#@todo

テンポラリファイルをクローズします。
real が偽でなければ、テンポラリファイルはすぐに削除されます。
そうでなければ、GC によって削除されます。

--- open
#@todo

クローズしたテンポラリファイルを再オープンします。
"r+" でオープンされるので、クローズ前の内容を再度読む
ことができます。

--- path
#@todo

テンポラリファイルのパス名を返します。

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
#@todo

Closes and unlinks the file.

--- delete
--- unlink
#@todo

Unlinks the file. On UNIX-like systems, it is often a good idea
to unlink a temporary file immediately after creating and opening
it, because it leaves other programs zero chance to access the
file.
