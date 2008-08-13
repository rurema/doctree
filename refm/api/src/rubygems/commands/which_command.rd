require rubygems/command
require rubygems/gem_path_searcher

指定された Gem パッケージに含まれるライブラリのパスを見つけるためのライブラリです。

= class Gem::Commands::WhichCommand < Gem::Command

指定された Gem パッケージに含まれるライブラリのパスを見つけるためのクラスです。

  Usage: gem which FILE [...] [options]
    Options:
      -a, --[no-]all                   show all matching files
      -g, --[no-]gems-first            search gems before non-gems
#@include(common_options)
    Arguments:
      FILE          Gem パッケージ名を指定します
    Summary:
      指定された Gem パッケージのライブラリのある場所を表示します
    Defaults:
      --no-gems-first --no-all


== Public Instance Methods
--- find_paths(package_name, dirs) -> Array
#@todo


@param package_name Gem パッケージの名前を指定します。

@param dirs 探索するディレクトリを指定します。

--- gem_paths(spec) -> Array
#@todo


@param spec

== Constants

--- EXT -> Array
#@todo

拡張子を表す配列です。
