---
type: library
include:
  - Gem::LocalRemoteOptions
  - Gem::VersionOption
require:
  - rubygems/command
  - rubygems/local_remote_options
  - rubygems/version_option
  - rubygems/source_info_cache
  - rubygems/format
---
指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのライブラリです。

`````
Usage: gem specification [GEMFILE] [options]
  Options:
    -v, --version VERSION            Specify version of gem to examine
        --platform PLATFORM          Specify the platform of gem to specification
        --all                        Output specifications for all versions of
                                     the gem
`````
#@include(local_remote_options)
#@include(common_options)
```````
Arguments:
  GEMFILE       gemspec を表示する Gem パッケージ名を指定します
Summary:
  Gem パッケージの仕様を YAML 形式で表示します
Defaults:
  --local --version '>= 0'
```````


# class Gem::Commands::SpecificationCommand < Gem::Command

指定された Gem パッケージの gemspec の情報を YAML 形式で表示するためのクラスです。
