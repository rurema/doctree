疑似端末(Pseudo tTY)を扱うライブラリです。

= module PTY

疑似端末(Pseudo tTY)を扱うモジュールです。

== Module Functions

--- getpty(command)                          -> [IO, IO, Integer]
--- getpty(command){|read, write, pid| ... } -> nil
--- spawn(command)                           -> [IO, IO, Integer]
--- spawn(command){|read, write, pid| ... }  -> nil

擬似 tty を確保し、指定されたコマンドをその擬似 tty の向こうで実行し、配列を返します。

このメソッドによって作られたサブプロセスが動いている間、子プロセス
の状態を監視するために SIGCHLD シグナルを捕捉します。子プロセス
が終了したり停止した場合には、例外 [[c:PTY::ChildExited]] が発生します。
この間、すべての SIGCHLD が PTY モジュールのシグナルハンドラに捕捉されるので、
サブプロセスを生成する他のメソッド([[m:Kernel.#system]] や [[m:IO.popen]]など)を
使うと、予期しない例外が発生することがあります。これを防ぐため
には、下記の [[m:PTY.#protect_signal]] を参照してください。

このメソッドがブロック付きで呼ばれた場合には、そのブロック
の中でのみ SIGCHLD が捕捉されます。したがって、ブロックパラメータ
として渡されたIOオブジェクトを、ブロックの外に持ち出して使うの
は勧められません。

@param command 擬似 tty 上で実行するコマンド

@return 返値は3つの要素からなる配列です。最初の要素は擬似 tty から
        読み出すための IO オブジェクト、2番目の要素は書きこむための IO オブジェクト、
        3番目の要素は子プロセスのプロセス ID です。
        このメソッドがブロック付き呼ばれた場合、これらの要素はブロックパラメータとして渡され、
        メソッド自体は nil を返します。

@raise PTY::ChildExited 子プロセスが終了したり停止したりした場合に発生します。

@see [[m:Kernel.#system]], [[m:IO.popen]], [[m:PTY.#protect_signal]], [[man:signal(2)]]

#@until 1.9.2
--- protect_signal{ ... } -> self
このメソッドは何もしません。
このメソッドは obsolete です。

--- reset_signal -> self
このメソッドは何もしません。
このメソッドは obsolete です。
#@end

== Singleton Methods
#@since 1.9.2
--- check(pid, exc)
#@todo

--- open -> [IO, File]
--- open{|master_io, slave_file| ... } -> object
#@todo

#@end
#@since 1.8.0
= class PTY::ChildExited < RuntimeError

子プロセスが終了したり停止した場合に発生する例外です。

== Instance Methods

--- status -> Process::Status

子プロセスの終了ステータスを[[c:Process::Status]]オブジェクトで返します。
#@end

