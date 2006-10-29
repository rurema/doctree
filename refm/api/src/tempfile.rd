= class Tempfile < DelegateClass(File)

テンポラリファイルを操作するためのクラスです。

 * テンポラリファイルを作成します。ファイルは "w+" モードで 
   "basename.pid.n" という名前になります。
 * Tempfile オブジェクトは IO オブジェクトと同じように使うことができます。
 * Tempfile#close(true) により、作成したテンポラリファイルは削除されます。
 * スクリプトが終了するときにも削除されます。
 * Tempfile#open により、テンポラリファイルを再オープンすることができます。
 * テンポラリファイルのモードは 0600 です。

== Class Methods
--- new(basename[, tempdir])
--- open(basename[, tempdir])
"basenamepid.n" というファイル名で
テンポラリファイルを作成します。

テンポラリファイルは、ディレクトリ tempdir に作成されます。
このデフォルト値は、
        ENV['TMPDIR'] || ENV['TMP'] || ENV['TEMP'] || '/tmp'
です。

== Instance Methods
--- close([real])
テンポラリファイルをクローズします。
realが偽でなければ、テンポラリファイルはすぐに削除されます。
そうでなければ、GC によって削除されます。realのデフォルト値は
false です。

--- open
クローズしたテンポラリファイルを再オープンします。
"r+" でオープンされるので、クローズ前の内容を再度読む
ことができます。

--- path
テンポラリファイルのパス名を返します。

#@if (version >= "1.8.0")
#@todo
#@# このバージョン情報は正しいか?
--- length
--- size
テンポラリファイルのサイズを返します。
#@end

--- close!

Closes and unlinks the file.

--- delete
--- unlink

Unlinks the file. On UNIX-like systems, it is often a good idea
to unlink a temporary file immediately after creating and opening
it, because it leaves other programs zero chance to access the
file.

