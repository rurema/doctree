= class Net::Telnet < SimpleDelegator

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

"Waittime" は [[unknown:"net/telnet"/Net::Telnet#waitfor]] メソッドの "Waittime" のデフォ
ルト値になります。waitfor メソッドのプロンプト待ち合わせの処理は、リモー
トホストからの出力が "Prompt" で指定した正規表現にマッチしてから
"Waittime" 秒待っても出力がないかどうかで判断されます。
waitfor メソッドは [[unknown:"net/telnet"/Net::Telnet#cmd]] や [[unknown:"net/telnet"/Net::Telnet#login]]
の内部でも使用されています。

ブロックを指定した場合、接続前に
  "Trying #{ホスト名} ...\n"
接続後に
  "Connected to #{ホスト名}.\n"
という文字列を引数にそれぞれブロックを実行します。

== Instance Methods

--- login(user[, password])
--- login("Name" => user, "Password" => password)

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

string を改行付きでリモートホストに送り、次のプロンプト
match が出力されるまで待ちます。

match のデフォルト値は new で指定した "Prompt" の値です。
timeout のデフォルト値は new で指定した "Timeout" の値です。

ブロックを指定した場合、出力文字列を引数にブロックを逐次実行します。

--- puts(string)

string を改行を付けてリモートホストに送ります。

--- telnetmode
--- telnetmode(bool)
--- telnetmode=(bool)
    ...

--- binmode
--- binmode(bool)
--- binmode=(bool)
    ...

--- sock

リモートホストに接続している IO オブジェクトを返します。
