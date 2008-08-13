require rubygems/command

Gem コマンドに関するヘルプを提供するためのライブラリです。

  Usage: gem help ARGUMENT [options]
#@include(common_options)
    Arguments:
      commands      gem コマンドのサブコマンドの一覧を表示します
      examples      gem コマンドの使用例を表示します
      <command>     指定されたコマンドのヘルプを表示します
    Summary:
      gem コマンドに関するヘルプを提供します


= class Gem::Commands::HelpCommand < Gem::Command

Gem コマンドに関するヘルプを提供するためのクラスです。

== Constants

--- EXAMPLES -> String

使用例を表す文字列です。

--- PLATFORMS -> String

プラットフォームに関する記述を格納している文字列です。

