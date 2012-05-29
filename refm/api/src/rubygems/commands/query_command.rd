require rubygems/command
require rubygems/local_remote_options
require rubygems/spec_fetcher
require rubygems/version_option

Gem パッケージの情報を検索するためのライブラリです。

Usage: gem query [options]
  Options:
    -i, --[no-]installed             Check for installed gem
    -v, --version VERSION            Specify version of gem to query
    -n, --name-matches REGEXP        与えられた正規表現にマッチする Gem パッケージを
                                     検索します
    -d, --[no-]details               Gem パッケージの詳細を表示します
        --[no-]versions              Gem パッケージ名のみ表示します
    -a, --all                        見つかった Gem パッケージの全てのバージョンを表示します
#@include(local_remote_options)
#@include(common_options)
  Summary:
    Gem パッケージの情報を検索します
  Defaults:
    --local --name-matches // --no-details --versions --no-installed


= class Gem::Commands::QueryCommand < Gem::Command

Gem パッケージの情報を検索するためのクラスです。

