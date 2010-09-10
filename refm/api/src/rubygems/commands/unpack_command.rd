require rubygems/command
require rubygems/installer
require rubygems/version_option

指定された Gem パッケージをカレントディレクトリに展開するためのライブラリです。

  Usage: gem unpack GEMNAME [options]
    Options:
          --target                     展開先のディレクトリを指定します
      -v, --version VERSION            展開する Gem パッケージのバージョンを指定します
#@include(common_options)
    Arguments:
      GEMNAME       展開する Gem パッケージ名を指定します
    Summary:
      Gem パッケージをカレントディレクトリに展開します
    Defaults:
      --version '>= 0'


= class Gem::Commands::UnpackCommand < Gem::Command
include Gem::VersionOption

指定された Gem パッケージをカレントディレクトリに展開するためのクラスです。

== Public Instance Methods

--- get_path(gemname, version_req) -> String | nil

引数で指定された条件にマッチする Gem パッケージを保存しているパスを返します。

@param gemname Gem パッケージの名前を指定します。

@param version_req バージョンの満たすべき条件を文字列で指定します。


