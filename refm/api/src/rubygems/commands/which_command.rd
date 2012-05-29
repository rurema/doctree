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

dirs から package_name という名前を持つファイルを探索します。

以下の拡張子を持つファイルが対象です。

  %w[.rb .rbw .so .dll .bundle]

@param package_name ファイルの名前を指定します。

@param dirs 探索するディレクトリを文字列の配列で指定します。

--- gem_paths(spec) -> Array

与えられた [[c:Gem::Specification]] のインスタンスからその Gem が
require するファイルのあるディレクトリをまとめて返します。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

== Constants

--- EXT -> [String]

拡張子を表す配列です。

  %w[.rb .rbw .so .dll .bundle]
