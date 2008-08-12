require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache

Gem パッケージをダウンロードしてカレントディレクトリに保存するためのライブラリです。

= class Gem::Commands::FetchCommand < Gem::Command
include Gem::LocalRemoteOptions
include Gem::VersionOption

Gem パッケージをダウンロードしてカレントディレクトリに保存するためのクラスです。

