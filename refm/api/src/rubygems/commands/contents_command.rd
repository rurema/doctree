require rubygems/command
require rubygems/version_option

インストールされている Gem パッケージに含まれているファイルリストを表示するためのライブラリです。

= class Gem::Commands::ContentsCommand < Gem::Command
include Gem::VersionOption

インストールされている Gem パッケージに含まれているファイルリストを表示するためのクラスです。

