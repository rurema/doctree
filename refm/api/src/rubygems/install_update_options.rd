require rubygems
require rubygems/security

[[c:Gem::Command]] で使用するインストールとアップデートに関するオプションを
扱うためのモジュールを定義したライブラリです。

= module Gem::InstallUpdateOptions

[[c:Gem::Command]] で使用するインストールとアップデートに関するオプションを
扱うためのモジュールです。

== Public Instance Methods

--- add_install_update_options
#@# -> discard

インストールとアップデートに関するオプションを追加します。

--- install_update_defaults_str -> String

Gem コマンドの install サブコマンドに渡されるデフォルトのオプションを返します。

デフォルトのオプションは以下の通りです。
  --rdoc --no-force --no-test --wrappers

