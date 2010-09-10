require rubygems/command
require rubygems/user_interaction
#@# --
require rubygems/commands/build_command
require rubygems/commands/cert_command
require rubygems/commands/check_command
require rubygems/commands/cleanup_command
require rubygems/commands/contents_command
require rubygems/commands/dependency_command
require rubygems/commands/environment_command
require rubygems/commands/fetch_command
require rubygems/commands/generate_index_command
require rubygems/commands/help_command
require rubygems/commands/install_command
require rubygems/commands/list_command
require rubygems/commands/lock_command
require rubygems/commands/mirror_command
require rubygems/commands/outdated_command
require rubygems/commands/pristine_command
require rubygems/commands/query_command
require rubygems/commands/rdoc_command
require rubygems/commands/search_command
require rubygems/commands/server_command
require rubygems/commands/sources_command
require rubygems/commands/specification_command
require rubygems/commands/stale_command
require rubygems/commands/uninstall_command
require rubygems/commands/unpack_command
require rubygems/commands/update_command
require rubygems/commands/which_command


gem コマンドによってサポートされているサブコマンドを管理するライブラリです。

Extra commands can be provided by writing a rubygems_plugin.rb
file in an installed gem.  You should register your command against the
Gem::CommandManager instance, like this:

  # file rubygems_plugin.rb
  require 'rubygems/command_manager'

  class Gem::Commands::EditCommand < Gem::Command
    # ...
  end

  Gem::CommandManager.instance.register_command :edit

See Gem::Command for instructions on writing gem commands.

= class Gem::CommandManager
include Gem::UserInteraction

gem コマンドによってサポートされているサブコマンドを管理するクラスです。

== Singleton Methods

--- instance -> Gem::CommandManager

自身をインスタンス化します。


== Public Instance Methods

--- [](command_name) -> Gem::Command | nil

引数で指定されたコマンド名に対応するクラスのインスタンスを返します。

@param command_name コマンド名を文字列で指定します。

--- command_names -> Array

登録されているコマンド名の配列を返します。

--- find_command(command_name) -> Gem::Command | nil

登録されているコマンドからマッチしたものを返します。

@param command_name コマンド名を文字列で指定します。

@return [[c:Gem::Command]] のサブクラスのインスタンスを返します。

@raise RuntimeError マッチする可能性のあるコマンドが複数ある場合に発生します。
                    また、マッチするコマンドが無かった場合にも発生します。

--- find_command_possibilities(command_name) -> Array

登録されているコマンドでマッチする可能性のあるものを返します。

@param command_name コマンド名を文字列で指定します。

--- process_args(args) -> ()

引数 args を処理して gem コマンドを実行するために必要な処理を行います。

@param args コマンドラインから受け取った引数を指定します。

--- register_command(command_name) -> false

コマンドを自身に登録します。

@param command_name コマンド名をシンボルで指定します。

--- run(args) -> ()

引数 args を処理して gem コマンドを実行中のエラーを捕捉します。

@param args コマンドラインから受け取った引数を指定します。

