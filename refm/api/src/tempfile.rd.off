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

#@if (version >= "1.7.0")
--- size
テンポラリファイルのサイズを返します。
#@end
