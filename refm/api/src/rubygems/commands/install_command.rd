require rubygems/command
require rubygems/doc_manager
require rubygems/install_update_options
require rubygems/dependency_installer
require rubygems/local_remote_options
require rubygems/validator
require rubygems/version_option

Gem パッケージをローカルリポジトリにインストールするためのライブラリです。

= class Gem::Commands::InstallCommand < Gem::Command
include Gem::VersionOption
include Gem::LocalRemoteOptions
include Gem::InstallUpdateOptions

Gem パッケージをローカルリポジトリにインストールするためのクラスです。
