---
type: library
include:
  - Gem::InstallUpdateOptions
  - Gem::LocalRemoteOptions
  - Gem::VersionOption
require:
  - rubygems/command
  - rubygems/command_manager
  - rubygems/install_update_options
  - rubygems/local_remote_options
  - rubygems/spec_fetcher
  - rubygems/version_option
  - rubygems/commands/install_command
---
ローカルリポジトリにインストールされている Gem パッケージを更新するためのライブラリです。

# class Gem::Commands::UpdateCommand < Gem::Command

ローカルリポジトリにインストールされている Gem パッケージを更新するためのクラスです。

## Public Instance Methods
### def do_rubygems_update(version)

RubyGems 自体を更新します。

### def which_to_update(highest_installed_gems, gem_names) -> Array

更新が必要な Gem のリストを返します。

