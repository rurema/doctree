require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache
require rubygems/format

指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのライブラリです。

= class Gem::Commands::SpecificationCommand < Gem::Command
include Gem::LocalRemoteOptions
include Gem::VersionOption

指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのクラスです。
