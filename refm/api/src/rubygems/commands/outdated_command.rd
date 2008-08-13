require rubygems/command
require rubygems/local_remote_options
require rubygems/spec_fetcher
require rubygems/version_option

更新が必要な Gem パッケージの一覧を出力するためのライブラリです。

  Usage: gem outdated [options]
    Options:
          --platform PLATFORM          指定されたプラットフォームに関する情報を表示します
#@include(local_remote_options)
#@include(common_options)
    Summary:
      更新が必要な Gem パッケージを全て表示します。


= class Gem::Commands::OutdatedCommand < Gem::Command

更新が必要な Gem パッケージの一覧を出力するためのクラスです。


