require rubygems/command
require rubygems/version_option
require rubygems/doc_manager

RDoc と ri のライブラリを生成するためのライブラリです。

  Usage: gem rdoc [args] [options]
    Options:
          --all                        インストールされている全ての Gem パッケージの
                                       RDoc/RI ドキュメントを生成します。
          --[no-]rdoc                  RDoc を含めます
          --[no-]ri                    RI を含めます
      -v, --version VERSION            指定したバージョンのドキュメントを生成します
#@include(common_options)
    Arguments:
      GEMNAME       ドキュメントを生成する Gem パッケージを指定します。省略すると全ての
                    Gem パッケージのドキュメントを生成します。
    Summary:
      RDoc/RI ドキュメントを生成します
    Defaults:
      --version '>= 0' --rdoc --ri

= class Gem::Commands::RdocCommand < Gem::Command

RDoc と ri のライブラリを生成するためのクラスです。

