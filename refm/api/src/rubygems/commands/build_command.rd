
Gem パッケージをビルドするためのライブラリです。

= class Gem::Commands::BuildCommand < Gem::Command

Gem パッケージをビルドするためのクラスです。

== Public Instance Methods

--- load_gemspecs(filename) -> Array
#@todo

gemspec ファイルをロードします。

@param filename ファイル名を指定します。

--- usage -> String
#@todo

使用方法を表す文字列を返します。

--- yaml?(filename) -> bool
#@todo

引数が yaml ファイルである場合に真を返します。

@param filename ファイル名を指定します。
