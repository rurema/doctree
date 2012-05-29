require rubygems/ext

拡張ライブラリをビルドするためのクラスを扱うライブラリです。

= class Gem::Ext::Builder

拡張ライブラリをビルドするためのクラスです。
他のビルダークラスはこのクラスを継承しています。

== Singleton Methods

--- class_name -> String
#@todo

ビルダーのクラス名を返します。

--- make(dest_path, results)
#@todo

Makefile を編集して make, make install を実行します。

@param dest_path ???

@param results 結果を入れるための配列です。この変数は破壊的に変更されます。

@raise Gem::InstallError Makefile が存在しない場合に発生します。

@raise Gem::InstallError make の実行に失敗した場合に発生します。

--- redirector -> String
#@todo

'2>&1' という文字列を返します。

--- run(command, results)
#@todo

与えられたコマンドを実行します。

@param command 実行するコマンドを文字列で指定します。

@param results 結果を入れるための配列です。この変数は破壊的に変更されます。

@raise Gem::InstallError コマンドの実行に失敗した場合に発生します。
