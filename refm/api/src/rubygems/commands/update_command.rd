require rubygems/command
require rubygems/command_manager
require rubygems/install_update_options
require rubygems/local_remote_options
require rubygems/spec_fetcher
require rubygems/version_option
require rubygems/commands/install_command

ローカルリポジトリにインストールされている Gem パッケージを更新するためのライブラリです。

= class Gem::Commands::UpdateCommand < Gem::Command
include Gem::InstallUpdateOptions
include Gem::LocalRemoteOptions
include Gem::VersionOption

ローカルリポジトリにインストールされている Gem パッケージを更新するためのクラスです。

== Public Instance Methods
--- do_rubygems_update(version)

RubyGems 自体を更新します。

--- which_to_update(highest_installed_gems, gem_names) -> Array

更新が必要な Gem のリストを返します。

