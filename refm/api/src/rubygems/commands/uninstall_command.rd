require rubygems/command
require rubygems/version_option
require rubygems/uninstaller

Gem パッケージをアンインストールするためのライブラリです。

= class Gem::Commands::UninstallCommand < Gem::Command
include VersionOption

Gem パッケージをアンインストールするためのクラスです。

