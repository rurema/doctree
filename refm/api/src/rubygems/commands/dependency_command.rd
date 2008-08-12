require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache

インストールされている Gem パッケージの依存関係を表示するためのライブラリです。

= class Gem::Commands::DependencyCommand < Gem::Command
include Gem::LocalRemoteOptions
include Gem::VersionOption

インストールされている Gem パッケージの依存関係を表示するためのクラスです。


== Public Instance Methods

--- find_gems(name, source_index) -> Hash
#@todo

@param name

@param source_index

--- find_reverse_dependencies(spec) -> Array
#@todo

@param spec

--- print_dependencies(spec, level = 0) -> String
#@todo

@param spec

@param level
