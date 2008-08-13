require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache

Gem パッケージをダウンロードしてカレントディレクトリに保存するためのライブラリです。

  Usage: gem fetch GEMNAME [GEMNAME ...] [options]
    Options:
      -v, --version VERSION            指定されたバージョンの Gem を取得します
          --platform PLATFORM          指定されたプラットフォームの Gem を取得します
    Local/Remote Options:
      -B, --bulk-threshold COUNT       Threshold for switching to bulk
                                       synchronization (default 1000)
      -p, --[no-]http-proxy [URL]      リモートの操作に HTTP プロクシを使用します
          --source URL                 Gem パッケージのリモートリポジトリの URL を指定します
#@include(common_options)
    Arguments:
      GEMNAME       ダウンロードする Gem パッケージの名前を指定します
    Summary:
      Gem パッケージをダウンロードしてカレントディレクトリに保存します
    Defaults:
      --version '>= 0'


= class Gem::Commands::FetchCommand < Gem::Command
include Gem::LocalRemoteOptions
include Gem::VersionOption

Gem パッケージをダウンロードしてカレントディレクトリに保存するためのクラスです。

