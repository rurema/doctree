require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache

インストールされている Gem パッケージの依存関係を表示するためのライブラリです。

  Usage: gem dependency GEMNAME [options]
    Options:
      -v, --version VERSION            指定したバージョンの依存関係を表示します
          --platform PLATFORM          指定したプラットフォームの依存関係を表示します
      -R, --[no-]reverse-dependencies  この Gem を使用している Gem を表示します
      -p, --pipe                       Pipe Format (name --version ver)
#@include(local_remote_options)
#@include(common_options)
    Arguments:
      GEMNAME       依存関係を表示する Gem の名前を指定します
    Summary:
      インストールされている Gem の依存関係を表示します
    Defaults:
      --local --version '>= 0' --no-reverse-dependencies


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
