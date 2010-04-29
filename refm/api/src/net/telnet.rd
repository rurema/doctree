Telnet プロトコルをクライアント側で扱うライブラリです。

=== 参考文献
Telnet に関する RFC は数多く存在します。
[[RFC:854]], [[RFC:855]], [[RFC:856]], [[RFC:857]], [[RFC:858]], 
[[RFC:859]], [[RFC:860]], [[RFC:861]], でプロトコルの
基本が定義されています。

= class Net::Telnet < SimpleDelegator

このクラスは telnet のクライアント機能を提供します。

このクラスは接続に利用している
ソケットオブジェクト(通常は [[c:TCPSocket]])のメソッドを
すべて利用することができます([[c:SimpleDelegator]] を用いて
います)。
これによって、[[m:IO#close]] で接続を
閉じたり、[[m:IO#sysread]] で [[m:Net::Telnet#waitfor]] を
使わずにデータを直接読むことができます。

telnet でリモートホストにログインしてシェル経由で
コマンドを実行することを考えてみましょう。
これを Net::Telnet で実現するためには、
まず [[m:Net::Telnet.new]] に "Host" オプションを
与えてオブジェクトを作り、 [[m:Net::Telnet#login]] で
ユーザ名をパスワードを送り
ログインし、[[m:Net::Telnet#cmd]] でコマンドを
実行、最後に IO#close で接続を閉じます。
[[m:Net::Telnet#waitfor]], [[m:Net::Telnet#print]],
[[m:Net::Telnet#puts]], [[m:Net::Telnet#write]] などと
いったメソッドはより複雑なことをする場合にのみ使ってください。

Net::Telnet のオブジェクトは SMTP や HTTP のような telnet で
ないサービスにも利用できます。この場合には 
[[m:Net::Telnet.new]] に "Port" オプションを与えることで
ポートを指定する必要があるでしょう。また、
"Telnetmode" オプションに false を
渡すことで telnet のコマンド列を解釈しないように
しなければなりません。[[m:Net::Telnet#login]] は普通
うまく動かないので、認証をプログラマ自身が実装
する必要があります。

[[m:Net::Telnet.new]] には "Proxy" オプションで指定した
オブジェクトを通して通信をすることができます。
"Proxy" オプションに [[c:Net::Telnet]] のオブジェクトを
渡した場合には、通信路が共用されます。[[c:Socket]] の
のような読み書き可能な [[c:IO]] オブジェクトを渡した場合には、
そのオブジェクトを通してやり取りが行われます。
この機能はユニットテストをする場合などに便利でしょう。

=== 使用例

  require 'net/telnet'
  
  # リモートホスト foobar に接続
  telnet = Net::Telnet.new("Host" => "foobar") {|c| print c}
  
  # ログイン
  telnet.login("your name", "your password") {|c| print c}
  # ログイン後、プロンプトが出るまで待ち合わせる
  
  telnet.cmd("ls") {|c| print c}
  # コマンド実行後、プロンプトが出るまで待ち合わせる
  
  # 少し複雑な例
  telnet.cmd("sleep 5 && echo foobar &") {|c| print c}
  
  STDOUT.flush # <- これがないとここまで処理が来てることがわかりにくい
  
  # 前のコマンドの出力を待ち合わせる
  telnet.waitfor(/foobar\Z/) {|c| print c}
  
  # ログインセッションの終了
  telnet.cmd("exit") {|c| print c}
  telnet.close


Net::Telnet のインスタンスは、ソケットのメソッドをdelegateします(例え
ば、セッションが終わった後は close を実行した方が良いでしょう)。

== Class Methods

--- new(opts)
#@todo

Telnet オブジェクトを生成します。このときリモートホストへの接続も行いま
す。opts には Telnet オブジェクトに設定する以下のオプションをハッ
シュで指定します。オプションは省略時にはそれぞれ右に示すデフォルト値が
適用されます。

 "Host"       => "localhost"
 "Port"       => 23
 "Prompt"     => /[$%#>] \z/n
 "Timeout"    => 10  # 接続待ちタイムアウト値(sec)
 "Waittime"   => 0   # Prompt を待ち合わせる時間。この値を nil にしてはいけません
 "Binmode"    => false
 "Telnetmode" => true
 "Output_log" => nil # 出力ファイル名
 "Dump_log"   => nil # 出力ファイル名
 "Proxy"      => nil # Net::Telnet または IO のオブジェクトを指定する

生成されたインスタンスは [[c:TCPSocket]] あるいは "Proxy" で指定したオ
ブジェクトが持つメソッドを受け付けます([[c:SimpleDelegator]]により
delegateされる)．

"Timeout" で指定した時間までに接続できない場合 [[c:TimeoutError]] 例外
が発生します。

"Waittime" は [[m:Net::Telnet#waitfor]] メソッドの "Waittime" のデフォ
ルト値になります。waitfor メソッドのプロンプト待ち合わせの処理は、リモー
トホストからの出力が "Prompt" で指定した正規表現にマッチしてから
"Waittime" 秒待っても出力がないかどうかで判断されます。
waitfor メソッドは [[m:Net::Telnet#cmd]] や [[m:Net::Telnet#login]]
の内部でも使用されています。

ブロックを指定した場合、接続前に
  "Trying #{ホスト名} ...\n"
接続後に
  "Connected to #{ホスト名}.\n"
という文字列を引数にそれぞれブロックを実行します。

== Instance Methods

--- login(user[, password])
--- login("Name" => user, "Password" => password)
#@todo

ユーザ名 user, パスワード password でログインします。
リモートホストが以下のプロンプトでユーザ名、パスワードの入力を要求する
ことを期待しています。

  xxxlogin:
  Password:

これに適合しない場合は、自分で例えば以下のようにログインを行う必要があ
ります。

  # ログイン時にいきなりパスワードの問い合わせが来る場合
  telnet = Net::Telnet.new("Host"=>"localhost") {|c| print c}
  telnet.waitfor(/Password[: ]*\z/n) {|c| print c}
  telnet.cmd("your password")

ブロックを指定した場合、出力文字列を引数にブロックを逐次実行します。

--- waitfor(match)
--- waitfor("Match" => match, "Timeout" => timeout, "Waittime" => waittime)
#@todo

正規表現 match で指定した文字列が出力されるまで待ち合わせます。
match の代わりに "String" をキーに文字列を指定した場合、
リモートホストからの出力にその文字列が現れるまで待ち合わせます。

timeout 待っても何も出力がなければ [[c:TimeoutError]] 例外が発生
します．

timeout, waittime のデフォルト値は new で指定した
"Timeout", "Waittime" の値です。

ブロックを指定した場合、出力文字列を引数にブロックを逐次実行します。

--- cmd(string)
--- cmd("String" => string, "Match" => match, "Timeout" => timeout)
#@todo

string を改行付きでリモートホストに送り、次のプロンプト
match が出力されるまで待ちます。

match のデフォルト値は new で指定した "Prompt" の値です。
timeout のデフォルト値は new で指定した "Timeout" の値です。

ブロックを指定した場合、出力文字列を引数にブロックを逐次実行します。

--- puts(string)
#@todo

string を改行を付けてリモートホストに送ります。

--- telnetmode
--- telnetmode(bool)
--- telnetmode=(bool)
#@todo
    ...

--- binmode
--- binmode(bool)
--- binmode=(bool)
#@todo
    ...

--- sock
#@todo

リモートホストに接続している IO オブジェクトを返します。


--- preprocess(string)
#@todo

--- print(string)
#@todo

--- write(string)
#@todo


== Constants

--- IAC
--- DONT
--- DO
--- WONT
--- WILL
--- SB
--- GA
--- EL
--- EC
--- AYT
--- AO
--- IP
--- BREAK
--- DM
--- NOP
--- SE
--- EOR
--- ABORT
--- SUSP
--- EOF
--- SYNCH
--- OPT_BINARY
--- OPT_ECHO
--- OPT_RCP
--- OPT_SGA
--- OPT_NAMS
--- OPT_STATUS
--- OPT_TM
--- OPT_RCTE
--- OPT_NAOL
--- OPT_NAOP
--- OPT_NAOCRD
--- OPT_NAOHTS
--- OPT_NAOHTD
--- OPT_NAOFFD
--- OPT_NAOVTS
--- OPT_NAOVTD
--- OPT_NAOLFD
--- OPT_XASCII
--- OPT_LOGOUT
--- OPT_BM
--- OPT_DET
--- OPT_SUPDUP
--- OPT_SUPDUPOUTPUT
--- OPT_SNDLOC
--- OPT_TTYPE
--- OPT_EOR
--- OPT_TUID
--- OPT_OUTMRK
--- OPT_TTYLOC
--- OPT_3270REGIME
--- OPT_X3PAD
--- OPT_NAWS
--- OPT_TSPEED
--- OPT_LFLOW
--- OPT_LINEMODE
--- OPT_XDISPLOC
--- OPT_OLD_ENVIRON
--- OPT_AUTHENTICATION
--- OPT_ENCRYPT
--- OPT_NEW_ENVIRON
--- OPT_EXOPL
--- NULL
--- CR
--- LF
--- EOL
--- REVISION
#@todo

