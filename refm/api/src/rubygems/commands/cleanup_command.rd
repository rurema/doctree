require rubygems/command
require rubygems/source_index
require rubygems/dependency_list

ローカルにインストールされている古い Gem を削除するライブラリです。

  Usage: gem cleanup [GEMNAME ...] [options]
    Options:
      -d, --dryrun
#@include(common_options)
    Arguments:
      GEMNAME       削除する Gem パッケージの名前を指定します
    Summary:
      ローカルリポジトリにインストールされている古いバージョンの
      Gem パッケージを削除します
    Defaults:
      --no-dryrun


= class Gem::Commands::CleanupCommand < Gem::Command

ローカルにインストールされている古い Gem を削除するクラスです。

