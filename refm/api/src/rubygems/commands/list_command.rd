require rubygems/command
require rubygems/commands/query_command

Gem パッケージの名前を前方一致で検索するためのライブラリです。

  Usage: gem list [STRING] [options]
    Options:
      -i, --[no-]installed             Check for installed gem
      -v, --version VERSION            指定されたバージョンの一覧を出力します
      -d, --[no-]details               Gem パッケージの詳細も表示します
          --[no-]versions              Gem パッケージの名前のみ表示します
      -a, --all                        全ての Gem パッケージを表示します
#@include(local_remote_options)
#@include(common_options)
    Arguments:
      STRING        探したい Gem の名前を前方一致で指定します
    Summary:
      指定された文字列で始まる Gem パッケージを列挙します
    Defaults:
      --local --no-details


= class Gem::Commands::ListCommand < Gem::Commands::QueryCommand

Gem パッケージの名前を前方一致で検索するためのクラスです。
