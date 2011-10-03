プロセスを制御するためのクラスを定義したライブラリです。

= class Shell::ProcessController < Object

== Singleton Methods

--- new(shell)

自身を初期化します。

@param shell [[c:Shell]] のインスタンスを指定します。

--- activate(pc) -> ()
#@todo

--- each_active_object{|ref| ... } -> ()
#@todo

--- inactivate(pc) -> ()
#@todo

--- process_controllers_exclusive -> ()
#@todo

#@since 1.9.1
--- active_process_controllers -> ()
#@todo

--- block_output_synchronize{ ... } -> ()
#@todo

--- wait_to_finish_all_process_controllers -> ()
#@todo

#@end

== Instance Methods

--- active_job?(job) -> bool

指定されたジョブが実行中である場合は真を返します。
そうでない場合は偽を返します。

@param job ジョブを指定します。

--- active_jobs -> Array

実行中のジョブの配列を返します。

--- active_jobs_exist? -> bool

実行中のジョブが存在する場合は真を返します。
そうでない場合は偽を返します。

--- add_schedule(command) -> ()

指定されたコマンドを待機ジョブとして登録します。
ただし、実行中のジョブが存在しない場合は、そのジョブを直ちに実行します。

@param command コマンドを指定します。

--- jobs -> Array

全てのジョブの配列を返します。

--- jobs_exist? -> bool

実行中か待機中のジョブが存在する場合は真を返します。
そうでない場合は偽を返します。

--- kill_job(signal, command) -> Integer

指定されたコマンドにシグナルを送ります。

@param signal シグナルを整数かその名前の文字列で指定します。
              負の値を持つシグナル(あるいはシグナル名の前に-)を指定すると、
              プロセスではなくプロセスグループにシグナルを送ります。 

@param command コマンドを指定します。

@see [[m:Process.#kill]]

--- sfork(command){ ... } -> [Integer, IO, IO]

シンプルな fork です。

@param command コマンドを指定します。

@return [PID, 入力用 IO, 出力用 IO] からなる配列を返します。


--- start_job(command = nil)

指定されたコマンドの実行を開始します。

コマンドを省略した場合は、待ち状態のジョブのうち先頭のものを実行します。

@param command コマンドを指定します。

--- terminate_job(command)

指定されたコマンドを終了します。

@param command コマンドを指定します。

--- wait_all_jobs_execution -> ()

全てのジョブの実行が終わるまで待ちます。

--- waiting_job?(job) -> bool

指定されたジョブが存在する場合は真を返します。
そうでない場合は偽を返します。

@param job ジョブを指定します。

--- waiting_jobs -> Array

待機中のジョブを返します。

--- waiting_jobs_exist? -> bool

待機中のジョブが存在する場合は真を返します。
そうでない場合は偽を返します。

#@since 1.9.1
--- shell -> Shell
#@todo

#@end

== Constants

#@since 1.9.1
--- USING_AT_EXIT_WHEN_PROCESS_EXIT -> true
#@todo

#@end
