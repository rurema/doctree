require rubygems/command
require rubygems/installer
require rubygems/version_option

指定された Gem パッケージをカレントディレクトリに展開するためのライブラリです。

= class Gem::Commands::UnpackCommand < Gem::Command
include Gem::VersionOption

指定された Gem パッケージをカレントディレクトリに展開するためのクラスです。

== Public Instance Methods

--- get_path(gemname, version_req) -> String | nil
#@todo

引数で指定された条件にマッチする Gem パッケージのキャッシュがあるパスを返します。

@param gemname Gem パッケージの名前を指定します。

@param version_req バージョンの満たすべき条件を文字列で指定します。


