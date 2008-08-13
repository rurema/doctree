require rubygems/command
require rubygems/commands/query_command

指定された文字列を含む Gem パッケージを全て表示するためのライブラリです。

  Usage: gem search [STRING] [options]
    Options:
      -i, --[no-]installed             Check for installed gem
      -v, --version VERSION            Specify version of gem to search
      -d, --[no-]details               Display detailed information of gem(s)
          --[no-]versions              Display only gem names
      -a, --all                        Display all gem versions
#@include(local_remote_options)
#@include(common_options)
    Arguments:
      STRING        検索したい Gem パッケージ名の一部を指定します
    Summary:
      STRING を含む全ての Gem パッケージ名を表示します
    Defaults:
      --local --no-details


= class Gem::Commands::SearchCommand < Gem::Commands::QueryCommand

指定された文字列を含む Gem パッケージを全て表示するためのクラスです。

