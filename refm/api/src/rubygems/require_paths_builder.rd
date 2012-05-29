必要であれば、'.require_paths' というファイルを Gem ごとに作成するための
モジュールを提供するためのライブラリです。

= module Gem::RequirePathsBuilder

必要であれば、'.require_paths' というファイルを Gem ごとに作成するための
モジュールです。

== Public Instance Methods

--- write_require_paths_file_if_needed(spec = @spec, gem_home = @gem_home)
#@# -> discard
必要であれば、'.require_paths' というファイルを Gem ごとに作成します。
