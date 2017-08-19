= module WEBrick::Utils

ライブラリ webrick のための小さなユーティリティ関数を提供するモジュールです。

== Module Functions

--- set_non_blocking(io)    -> ()

指定された io をノンブロッキングに設定します。

@param io IO オブジェクトを指定します。

--- set_close_on_exec(io)    -> ()

指定された io の Fcntl::FD_CLOEXEC を 1 に設定します。
この io は [[m:Kernel.#exec]] などが実行される時に close されるようになります。

@param io IO オブジェクトを指定します。

@see [[man:fcntl(2)]]

--- su(user) -> ()

指定されたユーザに [[m:Process::Sys.#setuid]],
[[m:Process::Sys.#setgid]] します。

setuid できないプラットフォームでは警告を表示し、何もしません。

@param user ユーザを指定します。

--- getservername    -> String

プロセスが動いているマシンのホスト名を文字列で返します。

  require 'webrick'
  p WEBrick::Utils.getservername   #=> "localhost"

--- random_string(len)    -> String

A-Z, a-z, 0-9 からなる長さ len のランダムな文字列を返します。

@param len 得たい文字列の長さを整数で指定します。単位はバイトです。

 require 'webrick'
 p WEBrick::Utils.random_string(10)   #=> "xF0jwU4RJd"

--- create_listeners(address, port, logger = nil) -> [TCPServer]

与えられたアドレスとポートで [[c:TCPServer]] オブジェクトを生成し
ます。

@param address アドレスを指定します。

@param port ポート番号を指定します。

@param logger ロガーオブジェクトを指定します。

@raise ArgumentError port を指定しなかった場合に発生します。

@see [[m:Socket.getaddrinfo]], [[c:TCPServer]]
