require rubygems/command
require rubygems/local_remote_options
require rubygems/version_option
require rubygems/source_info_cache
require rubygems/format

指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのライブラリです。

  Usage: gem specification [GEMFILE] [options]
    Options:
      -v, --version VERSION            Specify version of gem to examine
          --platform PLATFORM          Specify the platform of gem to specification
          --all                        Output specifications for all versions of
                                       the gem
#@include(local_remote_options)
#@include(common_options)
    Arguments:
      GEMFILE       gemspec を表示する Gem パッケージ名を指定します
    Summary:
      Gem パッケージの仕様を YAML 形式で表示します
    Defaults:
      --local --version '>= 0'


= class Gem::Commands::SpecificationCommand < Gem::Command
include Gem::LocalRemoteOptions
include Gem::VersionOption

指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのクラスです。
