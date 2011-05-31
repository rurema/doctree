require rubygems

[[c:Gem::Command]] の --version, --platform オプションのためのモジュールを
定義したライブラリです。

= module Gem::VersionOption

[[c:Gem::Command]] の --version, --platform オプションのためのモジュールです。

== Public Instance Methods

--- add_platform_option(task = command, *wrap)
#@# -> discard

option parser に対して --platform オプションを追加します。

@param task コマンド名を指定します。デフォルト値はインクルードされる側のクラスで指定されます。

@param wrap [[m:Gem::Command#add_option]] に渡すその他のオプションを指定します。

--- add_version_option(task = command, *wrap)
#@# -> discard

option parser に対して --version オプションを追加します。

@param task コマンド名を指定します。デフォルト値はインクルードされる側のクラスで指定されます。

@param wrap [[m:Gem::Command#add_option]] に渡すその他のオプションを指定します。

