require rubygems/ext/builder

Rake を使用して拡張ライブラリをビルドするためのクラスを扱うライブラリです。

= class Gem::Ext::RakeBuilder < Gem::Ext::Builder

Rake を使用して拡張ライブラリをビルドするためのクラスです。

== Singleton Methods

--- build(extension, directory, dest_path, results) -> Array
#@todo

mkrf_conf が存在する場合は、それを実行してから Rake を実行します。

@param extension ファイル名を指定します。

@param directory このメソッドでは使用していません。

@param dest_path ???

@param results コマンドの実行結果を格納します。破壊的に変更されます。

@see [[m:Gem::Ext::Builder.make]]
