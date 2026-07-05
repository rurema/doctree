---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems/command
  - rubygems/user_interaction
  - rubygems/commands/build_command
  - rubygems/commands/cert_command
  - rubygems/commands/check_command
  - rubygems/commands/cleanup_command
  - rubygems/commands/contents_command
  - rubygems/commands/dependency_command
  - rubygems/commands/environment_command
  - rubygems/commands/fetch_command
  - rubygems/commands/generate_index_command
  - rubygems/commands/help_command
  - rubygems/commands/install_command
  - rubygems/commands/list_command
  - rubygems/commands/lock_command
  - rubygems/commands/mirror_command
  - rubygems/commands/outdated_command
  - rubygems/commands/pristine_command
  - rubygems/commands/query_command
  - rubygems/commands/rdoc_command
  - rubygems/commands/search_command
  - rubygems/commands/server_command
  - rubygems/commands/sources_command
  - rubygems/commands/specification_command
  - rubygems/commands/stale_command
  - rubygems/commands/uninstall_command
  - rubygems/commands/unpack_command
  - rubygems/commands/update_command
  - rubygems/commands/which_command
---
gem コマンドによってサポートされているサブコマンドを管理するライブラリです。

Extra commands can be provided by writing a rubygems_plugin.rb
file in an installed gem.  You should register your command against the
Gem::CommandManager instance, like this:

`````
# file rubygems_plugin.rb
require 'rubygems/command_manager'

class Gem::Commands::EditCommand < Gem::Command
  # ...
end

Gem::CommandManager.instance.register_command :edit
`````

See Gem::Command for instructions on writing gem commands.

# class Gem::CommandManager

gem コマンドによってサポートされているサブコマンドを管理するクラスです。

## Singleton Methods

### def instance -> Gem::CommandManager

自身をインスタンス化します。


## Public Instance Methods

### def [](command_name) -> Gem::Command | nil

引数で指定されたコマンド名に対応するクラスのインスタンスを返します。

- **param** `command_name` -- コマンド名を文字列で指定します。

### def command_names -> Array

登録されているコマンド名の配列を返します。

### def find_command(command_name) -> Gem::Command | nil

登録されているコマンドからマッチしたものを返します。

- **param** `command_name` -- コマンド名を文字列で指定します。

- **return** -- [c:Gem::Command] のサブクラスのインスタンスを返します。

- **raise** `RuntimeError` -- マッチする可能性のあるコマンドが複数ある場合に発生します。
                    また、マッチするコマンドが無かった場合にも発生します。

### def find_command_possibilities(command_name) -> Array

登録されているコマンドでマッチする可能性のあるものを返します。

- **param** `command_name` -- コマンド名を文字列で指定します。

### def process_args(args) -> ()

引数 args を処理して gem コマンドを実行するために必要な処理を行います。

- **param** `args` -- コマンドラインから受け取った引数を指定します。

### def register_command(command_name) -> false

コマンドを自身に登録します。

- **param** `command_name` -- コマンド名をシンボルで指定します。

### def run(args) -> ()

引数 args を処理して gem コマンドを実行中のエラーを捕捉します。

- **param** `args` -- コマンドラインから受け取った引数を指定します。

