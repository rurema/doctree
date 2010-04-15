require shell/error
require shell/filter
require shell/system-command
require shell/builtin-command

[[c:Shell]] で使用可能なコマンドの大半を定義するライブラリです。

= class Shell::CommandProcessor < Object

== Singleton Methods

--- new(shell)
#@todo

--- add_delegate_command_to_shell(id)
#@todo

[[c:Shell]] 自体を初期化する時に呼び出されるメソッドです。
ユーザが使用することはありません。

@param id メソッド名を指定します。

--- alias_command(alias, command, *opts) -> self
--- alias_command(alias, command, *opts){ ... } -> self
#@todo

@param alias エイリアスの名前を指定します。

@param command コマンド名を指定します。

@param opts コマンドに与えるオプションを指定します。

@raise SyntaxError コマンドのエイリアス作成に失敗した時に発生します。

--- alias_map -> Hash

[[m:Shell::CommandProcessor.alias_command]] で定義したエイリアスの一覧を返します。

--- def_builtin_commands(delegation_class, commands_specs) -> ()
#@todo

@param delegation_class 処理を委譲したいクラスかモジュールを指定します。

@param commands_specs コマンドの仕様を文字列の配列で指定します。
                      [[コマンド名, [引数1, 引数2, ...]], ...]



--- def_system_command(command, path = command) -> ()
#@todo

与えられたコマンドをメソッドとして定義します。

@param command 定義したいコマンドを指定します。

@param path command のパスを指定します。省略すると環境変数 PATH から command を探します。

--- initialize -> ()
#@todo

このクラスを初期化します。

--- install_builtin_commands -> ()

ビルトインコマンドを定義します。

--- install_system_commands(prefix = "sys_") -> ()

全てのシステムコマンドをメソッドとして定義します。

既に定義されているコマンドを再定義することはありません。
デフォルトでは全てのコマンドに "sys_" というプレフィクスが付きます。
また、メソッド名として使用できない文字は全て "_" に置換してメソッドを定義します。
このメソッドの実行中に発生した例外は単に無視されます。

@param prefix プレフィクスを指定します。

--- method_added(id)
#@todo
このクラスに定義されたメソッドを [[c:Shell]] にも定義するためのフックです。

@param id メソッド名を指定します。

--- run_config -> ()

ユーザのホームディレクトリに "~/.rb_shell" というファイルが存在すれば、それを [[m:Kernel.#load]] します。

存在しない時は何もしません。

--- unalias_command(alias) -> self

エイリアスを削除します。

@param alias 削除したいエイリアスを指定します。

--- undef_system_command(command) -> self

与えられたコマンドを削除します。

@param command 削除したいコマンド名を指定します。


== Instance Methods

--- expand_path(path) -> String

Fileクラスにある同名のクラスメソッドと同じです.

@param path ファイル名を表す文字列を指定します。

@see [[m:File.expand_path]]


#@include(builtincommands)


== Constants

--- NoDelegateMethods -> [String]

内部で使用する定数です。

