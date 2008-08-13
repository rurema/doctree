require rubygems/command
require rubygems/version_option

インストールされている Gem パッケージに含まれているファイルリストを表示するためのライブラリです。

  Usage: gem contents GEMNAME [options]
    Options:
      -v, --version VERSION            指定されたバージョンの Gem パッケージの内容を表示します
      -s, --spec-dir a,b,c             指定されたパス以下にある Gem パッケージを検索します
      -l, --[no-]lib-only              Gem パッケージの lib ディレクトリ以下にある
                                       ファイルのみを表示します
#@include(common_options)
    Arguments:
      GEMNAME       Gem パッケージの名前を指定します
    Summary:
      インストールされている Gem パッケージに含まれるファイルの一覧を表示します
    Defaults:
      --no-lib-only

= class Gem::Commands::ContentsCommand < Gem::Command
include Gem::VersionOption

インストールされている Gem パッケージに含まれているファイルリストを表示するためのクラスです。

