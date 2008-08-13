require rubygems/command

RubyGems の環境に関する情報を表示するためのライブラリです。

  Usage: gem environment [arg] [options]
#@include(common_options)
    Arguments:
      packageversion  gem のバージョンを表示します
      gemdir          Gem パッケージのインストール先を表示します
      gempath         Gem パッケージを探索するディレクトリを表示します
      version         Gem パッケージのフォーマットのバージョンを表示します
      remotesources   Gem パッケージを検索するサーバを表示します
      <omitted>       省略すると全て表示します
    Summary:
      RubyGems の環境や設定を表示します

= class Gem::Commands::EnvironmentCommand < Gem::Command

RubyGems の環境に関する情報を表示するためのクラスです。


