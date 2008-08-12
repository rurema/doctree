require rubygems/command
require rubygems/format
require rubygems/installer
require rubygems/version_option

インストールされている Gem パッケージを初期状態にするためのライブラリです。

= class Gem::Commands::PristineCommand < Gem::Command
include Gem::VersionOption

インストールされている Gem パッケージを初期状態にするためのクラスです。

