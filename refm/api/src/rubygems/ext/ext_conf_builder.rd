require 'rubygems/ext/builder'

= class Gem::Ext::ExtConfBuilder < Gem::Ext::Builder

== Singleton Methods

--- build(extension, directory, dest_path, results) -> Array
#@todo

Makefile が存在しない場合は、extconf.rb を実行して
Makefile を作成してから make を実行します。

@param extension ファイル名を指定します。

@param directory このメソッドでは使用していません。

@param dest_path

@param results コマンドの実行結果を格納します。破壊的に変更されます。

@see [[m:Gem::Ext::Builder.make]]
