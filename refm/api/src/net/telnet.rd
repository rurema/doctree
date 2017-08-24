category Network

Telnet プロトコルをクライアント側で扱うライブラリです。

#@since 2.3.0
このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

  * rubygems.org: [[url:https://rubygems.org/gems/net-telnet]]
  * プロジェクトページ: [[url:https://github.com/ruby/net-telnet]]
  * リファレンス: [[url:http://www.rubydoc.info/gems/net-telnet]]

#@else
=== 参考文献
Telnet に関する RFC は数多く存在します。
[[RFC:854]], [[RFC:855]], [[RFC:856]], [[RFC:857]], [[RFC:858]], 
[[RFC:859]], [[RFC:860]], [[RFC:861]], でプロトコルの
基本が定義されています。

=== 注意

このライブラリは 2.3.0 で bundled gem(gemファイルのみを同梱)になりました。

= class Net::Telnet < SimpleDelegator

このクラスは telnet のクライアント機能を提供します。

#@until 1.9.1
このクラスは接続に利用している
ソケットオブジェクト(通常は [[c:TCPSocket]])のメソッドを
すべて利用することができます([[c:SimpleDelegator]] を用いて
います)。
これによって、[[m:IO#close]] で接続を
閉じたり、[[m:IO#sysread]] で [[m:Net::Telnet#waitfor]] を
使わずにデータを直接読むことができます。
#@end

telnet でリモートホストにログインしてシェル経由で
コマンドを実行することを考えてみましょう。
これを Net::Telnet で実現するためには、
まず [[m:Net::Telnet.new]] に "Host" オプションを
与えてオブジェクトを作り、 [[m:Net::Telnet#login]] で
ユーザ名とパスワードを送ってログインし、
[[m:Net::Telnet#cmd]] でコマンドを
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

通信プロトコルによっては、[[m:Net::Telnet.new]] に"Prompt"
を渡しておいて [[m:Net::Telnet#cmd]] をうまく動作させることが
できるかもしれません。
また、[[m:Net::Telnet#cmd]] を呼ぶごとに "Match" を
指定しても同様のことができます。
また、[[m:Net::Telnet#puts]] や [[m:Net::Telnet#waitfor]] を
直接使ってやりとりすることもできます。
それでうまくいかない場合は、
[[m:IO#sysread]] を直接呼ぶ必要があるかもしれません。


[[m:Net::Telnet.new]] には "Proxy" オプションで指定した
オブジェクトを通して通信をすることができます。
"Proxy" オプションに [[c:Net::Telnet]] のオブジェクトを
渡した場合には、通信路が共用されます。[[c:Socket]]
のような読み書き可能な [[c:IO]] オブジェクトを渡した場合には、
そのオブジェクトを通してやり取りが行われます。
この機能はユニットテストをする場合などに便利でしょう。

=== 使用例

ログインしてコマンドを送る例、リモートホストから返ってきた文字列は
すべて標準出力に表示する
  require 'net/telnet'

  # リモートホスト "foobar" に接続
  # タイムアウトは 10 秒
  localhost = Net::Telnet.new("Host" => "localhost",
                              "Timeout" => 10)
  
  # ログインし、プロンプトが出るまで待ち合わせる
  telnet.login("your name", "your password") {|c| print c}
  
  # ls コマンドを実行し、実行後、プロンプトが出るまで待ち合わせる
  telnet.cmd("ls") {|c| print c}
  
  # sleep で 5 秒
  telnet.cmd("sleep 5 && echo foobar &") {|c| print c}
  
  STDOUT.flush # <- これがないとここまで処理が来てることがわかりにくい
  
  # 前のコマンドの出力を待ち合わせる
  telnet.waitfor(/foobar\Z/) {|c| print c}
  
  # ログインセッションの終了
  telnet.cmd("exit") {|c| print c}
  telnet.close

POP サーバにメールが来ているかどうかを見る。リモートホストからきた文字列は
すべて標準出力に表示
  require 'net/telnet'

  # リモートホスト(POPサーバ) "foobar" に接続
  # ポート番号は110(POPのwell-knownポート)、
  # "Telnetmode" は off (telnet用の特殊なバイト列を解釈しない)、
  # Prompt (コマンドの区切り) は POP の仕様により /^\+OK/n とする
  pop = Net::Telnet::new("Host" => "foobar",
                         "Port" => 110,
                         "Telnetmode" => false,
                         "Prompt" => /^\+OK/n)
  # 認証をする
  # Net::Telnet#login は使えない(ログインのコマンドが異なる)ので
  # Net::Telnet#cmd でユーザ名とパスワードを送る
  pop.cmd("user " + "your_username") { |c| print c }
  pop.cmd("pass " + "your_password") { |c| print c }
  
  # list コマンドで来ているメールを表示する
  pop.cmd("list") { |c| print c }
  
  # 終了する
  pop.close

== Class Methods

--- new(opts) -> Net::Telnet
--- new(opts){|message| ... } -> Net::Telnet

Telnet オブジェクトを生成します。

このときリモートホストへの接続も行います("Proxy"を指定しない場合)。
opts には Telnet オブジェクトに設定する以下のオプションをハッシュで指定します。
オプションは省略時にはそれぞれ右に示すデフォルト値が適用されます。

 "Host"       => "localhost"
 "Port"       => 23
 "Prompt"     => /[$%#>] \z/n
 "Timeout"    => 10  # 接続待ちタイムアウト値(sec)
 "Waittime"   => 0   # Prompt を待ち合わせる時間。この値を nil にしてはいけません
 "Binmode"    => false
 "Telnetmode" => true
 "Output_log" => nil # ログの出力ファイル名
 "Dump_log"   => nil # 出力ファイル名
 "Proxy"      => nil # Net::Telnet または IO のオブジェクトを指定する

それぞれの意味は以下の通りです。

"Host" 接続するホストのホスト名もしくはIPアドレスを文字列で指定します。
デフォルトは "localhost" です。

"Port" 接続するポート番号です。デフォルトは23です。

"Binmode" これを偽にすると、改行を変換します。ホストへの
LF は CRLF に変換され、ホストからの CRLF は LF に変換されます。
これを真にすると、変換をしません。この変換は 
[[m:Net::Telnet#binmode]] でも無効化できます。
ホストへ送る文字列の変換は [[m:Net::Telnet#puts]] と
[[m:Net::Telnet#puts]] に適用され、[[m:Net::Telnet#write]] には適用され
ません。改行の変換に関しては telnet の SGA と BIN オプションにも
影響されることに注意してください。

"Prompt" コマンドライン上のプロンプトを表わす正規表現を指定します。
これはホストからの出力が終了し、ホストが新しい入力を
待っているかどうかを判断するために必要となります。


"Output_log" 接続状態メッセージや受け取った通信を記録する
ファイル名を指定します。通常の Telnet セッションでは、ログには
サーバ側からエコーされたクライアントからの入力を含みます。
エコーがないようなプロトコルの場合はクライアントからの入力は
ログに含まれません。ログは指定したファイルの後ろに追記されます。
デフォルトではログは出力されません。

"Dump_log" "Output_log"と同様にログを出力するファイル名を指定します。
ただしこのログは hexdump 形式 (1行に 16byte の 16進文字列と、
対応する ASCII 文字列)。ログの各行の1行目には以下のような文字が
付加されます。
ステータスメッセージの前には「#」、
クライアントからサーバへの通信の前には「>」、
サーバからクライアントへの通信の前には「<」が出力されます。

"Telnetmode" これに真を指定した場合には、ホストからの通信
を解釈して telnet の特殊なバイト列をエスケープします。
[[m:Net::Telnet#puts]] や [[m:Net::Telnet#print]] で送られる文字列も
エスケープされます。[[m:Net::Telnet#write]] ではエスケープされません。
[[c:Net::Telnet]] を telnet プロトコル以外(SMPTやPOPなど)で利用したい
場合には、この値を偽にしてエスケープを止めてください。この
値は [[m:Net::Telnet#telnetmode]] でも指定できます。


"Timeout" 接続時やホストからのデータの読み込みを待つときに、
ここで指定した秒数でタイムアウト([[c:TimeoutError]]が発生)します
([[m:Net::Telnet#login]]、[[m:Net::Telnet#waitfor]]、[[m:Net::Telnet#cmd]]で
有効になります)。デフォルトは10(秒)です。
falseを指定することでタイムアウトが無効になります。その場合には
接続できない場合には [[man:connect(2)]] で Errno::ETIMEOUT が出て
止まります(通常数分待つことになりますが)が、
それ以外の点ではホストからデータが来ないといつまでも待ちつづけることに
なります。

"Waittime" は [[m:Net::Telnet#waitfor]] メソッドの "Waittime" のデフォ
ルト値になります。[[m:Net::Telnet#waitfor]]
メソッドのプロンプト待ち合わせの処理は、リモートホストからの出力が 
"Prompt" で指定した正規表現にマッチしてから
"Waittime" 秒待っても出力がないかどうかで判断されます。
"Prompt" で指定した正規表現が本当のプロンプト以外の文字列にマッチしてしまう場合に
この値が意味を持ちます。
[[m:Net::Telnet#waitfor]] メソッドは [[m:Net::Telnet#cmd]] や [[m:Net::Telnet#login]]
の内部でも使用されています。
デフォルトは0(秒)で、正規表現にマッチしたら直ちに待合せ処理に入ります。

"Proxy" ホストに直接接続するかわりにこれで指定したオブジェクトを
経由して通信します。[[c:IO]]オブジェクトか [[c:Net::Telnet]] のオブジェクト
を指定しなければなりません。[[c:Net::Telnet]]オブジェクトを指定した場合には
それが持っているソケットを経由して通信します。[[c:IO]]オブジェクトを
指定した場合には、それを直接使って通信します。それ以外のオブジェクトを
指定するとエラーとなります。

ブロックを指定した場合、サーバに繋ぐときに
表示されるステータスメッセージをそのブロックに渡します。
通常は、接続前に
  "Trying #{ホスト名} ...\n"
接続後に
  "Connected to #{ホスト名}.\n"
という文字列がブロックに渡されます。

#@until 1.9.1
生成されたインスタンスは [[c:TCPSocket]] あるいは "Proxy" で指定したオ
ブジェクトが持つメソッドを受け付けます([[c:SimpleDelegator]]により
delegateされる)．
#@end

@param opts 各種オプションを指定します。全てのオプションをデフォルト値で指定したい場合には、{}(空のハッシュ)を指定してください。
@raise TimeoutError 接続時にタイムアウトすると発生します。タイムアウトの時間はオプションで指定します。
 

== Instance Methods

--- login(opts, password=nil) -> String
--- login(opts, password=nil){|mesg| ...}  -> String
指定したユーザ名とパスワードでログインします。

opts が文字列である場合は、 それをユーザ名、passwordをパスワードと
してログインします。
opts がハッシュである場合には、"Name" と "Password" をキーとする文字列を
ユーザ名、パスワードとしてログインします。
また、opts がハッシュの場合には以下のオプションが利用できます。

"LoginPrompt" ログインプロンプトを正規表現で指定します。
デフォルト値は /[Ll]ogin[: ]*\z/n です。

"PasswordPrompt" パスワード入力プロンプトを正規表現で指定します。
デフォルト値は /[Pp]ass(?:word|phrase)[: ]*\z/n です。

パスワードを省略した場合には、パスワード入力プロンプトを
待ちません。[[m:Net::Telnet.new]]の"Prompt"で指定した
正規表現でプロンプトを待ちます。

ログイン処理が終わるまでにホストから送られた文字列を返します。
通常はユーザ名はエコーされるためそこに含まれているはずです。また
パスワードはエコーされないため含まれいはずです。

ブロックを指定した場合、ホストからの文字列を引数にブロックを逐次実行します。

例
  # 1つめの引数が文字列の場合
  telnet.login("your name", "your password")
  # 1つめの引数がハッシュの場合
  telnet.login("Name" => "your name", "Password" => "your password")


--- waitfor(opt) -> String|nil
--- waitfor(opt){|buf| ...} -> String|nil
指定した正規表現にマッチする文字列がホストから来るまでデータを読み込みます。

opt に正規表現を指定した場合には、それにマッチするまで読みこみます。
opt にハッシュを指定した場合には、以下のオプションを指定できます。

"Match" 待ち合わせたい正規表現を指定します。

"Prompt" "Match"と同じです。"Match"が指定されなかった場合にのみ使われます。

"String" "Match"と似ていますが、与えられた [[c:String]] のインスタンスに
完全に一致するデータを待ち合わせます。"Match"も"Prompt"も指定されなかった
場合にのみ利用されます。

"Timeout" タイムアウトの秒数を指定します。指定しない場合は [[m:Net::Telnet.new]] で
指定した"Timeout"の値をデフォルト値として利用します。

"Waittime" 指定した正規表現にマッチしてからこれで指定した秒数だけホストからの
通信がない場合にこのメソッドが終わります。指定しない場合は [[m:Net::Telnet.new]] で
指定した"Waittime"の値をデフォルト値として利用します。

"FailEOF" これを真にすると、ホスト側から接続を切られた場合には例外 [[c:IOError]] 
が発生するようになります。偽だとホスト側から接続を切られた場合にはブロックに
nil が渡されます。さらにこのオプションが偽で、ホストからのデータが
一切来なかった場合には nil を返します。デフォルトは偽です。

"Match" "Prompt" "String" のいずれかは必ず指定する必要があります。

ブロックを指定した場合、ホストからの文字列を引数にブロックを逐次呼びだします。

@param opt 待ち合わせに必要な情報を指定します。正規表現を指定するとそれにマッチするデータまで待ち、ハッシュを指定すると正規表現とオプションを指定できます。
@raise TimeoutError タイムアウトした場合に発生します
@see [[m:Net::Telnet.new]]

--- cmd(opts) -> String
--- cmd(opts){|mesg| ...} -> String
コマンドをホストに送ります。

より正確にいうと、文字列をホストに送り、プロンプト、もしくは指定した
正規表現にマッチするまでホストからのデータを読み込みます。

ブロックを指定した場合、ホストからの文字列を引数にブロックを逐次実行します。

ホストから受け取った文字列を返します。

opts が文字列であれば、その文字列をホストに送り、
デフォルトオプションでプロンプトを待ちます。

opts がハッシュである場合には、送る文字列とオプションを指定することができます。
その場合には以下の

"String" 送る文字列です。必ず指定する必要があります。

"Match" ホストからのデータをどこまで読みこむかを指定する正規表現を
指定します。デフォルトは [[m:Net::Telnet.new]] で "Prompt" で指定した 
正規表現となります。

"Timeout" タイムアウトまでの時間です。デフォルトは [[m:Net::Telnet.new]] で
指定した値となります。

コマンド文字列には改行が付加されてホストに送られます。

@param opts ホストに送るコマンドを文字列で指定します。もしくは送る文字列とオプションをハッシュで指定します。
@raise TimeoutError タイムアウトしたときに発生します。


--- puts(string) -> ()
改行を付加した文字列をホストに送ります。

改行の付加以外は [[m:Net::Telnet#print]] と同じです。

@param string ホストに送る文字列
@see [[m:Net::Telnet#write]], [[m:Net::Telnet#print]]

--- telnetmode(mode=nil) -> bool|()
引数を指定しない場合には"Telnetmode"の値を返します。
引数を与えた場合は"Telnetmode"の値を変更します。

これは telnet の特殊なバイト列を解釈するかどうかを
意味します。

@see [[m:Net::Telnet.new]]


--- telnetmode=(mode)
"Telnetmode" を設定します。これは telnet の特殊なバイト列を解釈するかどうかを
意味します。

@param mode 設定する値を真偽値で与えます
@see [[m:Net::Telnet#new]]

--- binmode(mode=nil) -> bool
引数を指定しない場合には"Binmode"の値を返します。
引数を与えた場合は"Binmode"の値を変更します。

これは改行文字の変換をするかどうかを意味します。


@param mode 設定する値をtrue/falseで与えます
@see [[m:Net::Telnet.new]]


--- binmode=(mode)
"Binmode" を設定します。これは改行文字の変換をするかどうかを意味します。

@param mode 設定する値をtrue/falseで与えます
@see [[m:Net::Telnet.new]], [[m:Net::Telnet#binmode]]


--- sock -> IO
リモートホストに接続している [[c:IO]] オブジェクトを返します。

Telnet オブジェクトのメソッドはこのオブジェクトに
移譲されているので、Telnetオブジェクトは [[c:IO]] オブジェクト
オブジェクトのメソッドを持ち、それらを呼ぶと IO オブジェクトに
転送されます。


--- preprocess(string) -> String

ホストから受け取った文字列の前処理をします。

受け取った文字列に改行の変換とtelnetコマンドの検出をします。
通常は [[m:Net::Telnet#waitfor]] から呼びだされます。
"Telnetmode" を利用している場合、
[[m:IO#sysread]] などで直接ホストからのデータを読みこんだ場合にのみ
このメソッドを呼ぶ必要があるでしょう。

前処理の内容は [[m:Net::Telnet#telnetmode]] や
[[m:Net::Telnet#binmode]] によって変わります。

@param string 前処理対象の文字列
@return 変換後の文字列
@see [[m:Net::Telnet.new]], [[m:Net::Telnet#telnetmode]], [[m:Net::Telnet#binmode]]

--- print(string) -> ()
ホストに文字列を送ります。

改行は付加されません。文字列中の改行は変換されます。telnetコマンドはエスケープされます。
これらの変換は[[m:Net::Telnet#telnetmode]], [[m:Net::Telnet#binmode]], 
およびホストから設定された telnet オプションによって(変換するしないなどが)
制御されます。

@param string ホストに送る文字列
@see [[m:Net::Telnet#write]], [[m:Net::Telnet#puts]]

--- write(string) -> ()
ホストに文字列を送ります。
文字列に変換は一切施しません。

@param string ホストに送る文字列
@see [[m:Net::Telnet#print]], [[m:Net::Telnet#puts]]

#@since 1.9.2
--- close -> ()
通信路を閉じます。
#@end

== Constants

#@# telnet の特殊文字
#@# --- IAC
#@# --- DONT
#@# --- DO
#@# --- WONT
#@# --- WILL
#@# --- SB
#@# --- GA
#@# --- EL
#@# --- EC
#@# --- AYT
#@# --- AO
#@# --- IP
#@# --- BREAK
#@# --- DM
#@# --- NOP
#@# --- SE
#@# --- EOR
#@# --- ABORT
#@# --- SUSP
#@# --- EOF
#@# --- SYNCH

#@# --- OPT_BINARY
#@# --- OPT_ECHO
#@# --- OPT_RCP
#@# --- OPT_SGA
#@# --- OPT_NAMS
#@# --- OPT_STATUS
#@# --- OPT_TM
#@# --- OPT_RCTE
#@# --- OPT_NAOL
#@# --- OPT_NAOP
#@# --- OPT_NAOCRD
#@# --- OPT_NAOHTS
#@# --- OPT_NAOHTD
#@# --- OPT_NAOFFD
#@# --- OPT_NAOVTS
#@# --- OPT_NAOVTD
#@# --- OPT_NAOLFD
#@# --- OPT_XASCII
#@# --- OPT_LOGOUT
#@# --- OPT_BM
#@# --- OPT_DET
#@# --- OPT_SUPDUP
#@# --- OPT_SUPDUPOUTPUT
#@# --- OPT_SNDLOC
#@# --- OPT_TTYPE
#@# --- OPT_EOR
#@# --- OPT_TUID
#@# --- OPT_OUTMRK
#@# --- OPT_TTYLOC
#@# --- OPT_3270REGIME
#@# --- OPT_X3PAD
#@# --- OPT_NAWS
#@# --- OPT_TSPEED
#@# --- OPT_LFLOW
#@# --- OPT_LINEMODE
#@# --- OPT_XDISPLOC
#@# --- OPT_OLD_ENVIRON
#@# --- OPT_AUTHENTICATION
#@# --- OPT_ENCRYPT
#@# --- OPT_NEW_ENVIRON
#@# --- OPT_EXOPL

#@# 改行など
#@# --- NULL
#@# --- CR
#@# --- LF
#@# --- EOL
#@# SVNのリビジョン
#@# --- REVISION
#@end
