category Network

このライブラリは、POP3 (Post Office Protocol version 3) を
用いてPOPサーバからメールを受信する機能を提供するライブラリです。

POP3 の実装は [[RFC:1939]] に基いています。

[[RFC:2449]] で定義されているPOP3拡張には対応していません。
=== 使用例

==== メールの受信

以下のコードは、メールを受信してファイル 'inbox/1' 'inbox/2'... に
書きこみ、サーバ上からメールを消します。

'pop.example.com' は適当なPOP3のサーバのホスト名に、
'YourAccount' と 'YourPassword' は適当なアカウント名とパスワード
に適宜読みかえてください。

  require 'net/pop'
  
  pop = Net::POP3.new('pop.example.com', 110)
  pop.start('YourAccount', 'YourPassword') # POPのセッションを開始
  if pop.mails.empty?
    $stderr.puts 'no mail.'
  else
    pop.mails.each_with_index do |m, idx|  # 各メッセージにアクセスする
      File.open("inbox/#{idx + 1}", 'w') {|f|
        f.write m.pop
      }
      m.delete
    end
    $stderr.puts "#{pop.mails.size} mails popped."
  end
  pop.finish                                        # セッションを終了する

POP サーバはネットワークのむこうに存在するので、
なにか仕事をさせるにはその前に開始手続きを、
終わったら終了手続きを、行わなければいけません。
それを行うのが [[m:Net::POP3#start]] と [[m:Net::POP3#finish]] で、
POP3 オブジェクトはその二つのメソッドの間でだけ有効になります。

サーバ上のメールは [[c:Net::POPMail]] オブジェクトとして表現されており、この
オブジェクトのメソッドを呼ぶことでメールを取ってきたり消したりする
ことができます。[[m:Net::POP3#mails]] はこの [[c:Net::POPMail]] オブジェクトの配列であり、
[[m:Net::POP3#each_mail]] はさらに pop.mails.each のショートカットです。

==== 短くする

上の例はあえて省略や短縮用メソッドを避けたためにかなり冗長です。
まず、ブロック付きの [[m:Net::POP3.start]] を使うことで
POP3.new, #start, #finish を併合できます。

  require 'net/pop'
  
  Net::POP3.start('pop.example.com', 110,
                  'YourAccount', 'YourPassword') {|pop|
    if pop.mails.empty?
      $stderr.puts 'no mail.'
    else
      pop.mails.each_with_index do |m, idx|
        File.open("inbox/#{idx + 1}", 'w') {|f|
          f.write m.pop
        }
        m.delete
      end
      $stderr.puts "#{pop.mails.size} mails popped."
    end
  }

[[m:Net::POP3#delete_all]] を使うと
さらに [[m:Net::POP3#each_mail]] と
[[m:Net::POPMail#delete]] を併合できます。

  require 'net/pop'
  
  Net::POP3.start('pop.example.com', 110,
                  'YourAccount', 'YourPassword') {|pop|
    if pop.mails.empty?
      $stderr.puts 'no mail.'
    else
      i = 0
      pop.delete_all do |m|
        File.open("inbox/#{i}", 'w') {|f|
          f.write m.pop
        }
        i += 1
      end
    end
  }

クラスメソッドの [[m:Net::POP3.delete_all]] を使うとさらに短くなります。

  require 'net/pop'
  
  i = 0
  Net::POP3.delete_all('pop.example.com', 110,
                       'YourAccount', 'YourPassword') do |m|
    File.open("inbox/#{i}", 'w') {|f|
      f.write m.pop
    }
    i += 1
  end

==== メモリ使用量を減らす

これまでの例では [[m:Net::POPMail#pop]] を使い、
メールをひとつの文字列としてうけとっていました。
しかし、もしメールが 100MB を越えるような巨大なメールだった場合、
この方法ではまずいかもしれません。
そのような場合は以下のように [[m:Net::POPMail#pop]] に
File オブジェクトを与える手が使えます。

  require 'net/pop'
  
  i = 0
  Net::POP3.delete_all('pop.example.com', 110,
                       'YourAccount', 'YourPassword') do |m|
    File.open('inbox/#{i}', 'w') {|f|
        m.pop f
    }
    i += 1
  end

[[m:Net::POPMail#pop]]にブロックを渡すと、
メールデータを細かく分割してブロックを呼びだします。
この機能を使って同様のことができます。

  require 'net/pop'
  
  i = 0
  Net::POP3.delete_all('pop.example.com', 110,
                       'YourAccount', 'YourPassword') do |m|
    File.open('inbox/#{i}', 'w') {|f|
      m.pop {|chunk|
        f.write(chunk)
      }
    }
    i += 1
  end

==== APOP を使う

Net::POP3 クラスのかわりに Net::APOP クラスを使うと、
認証時に APOP を使うようになります。
また動的にノーマル POP と APOP を選択するには、
以下のように [[m:Net::POP3.APOP]] メソッドを使うのが便利です。

  require 'net/pop'
  
  # use APOP authentication if $isapop == true
  pop = Net::POP3.APOP($isapop).new('apop.example.com', 110)
  pop.start('YourAccount', 'YourPassword') {|pop|
    # 残りのコードは同じ
  }

この方法はクラス自体を変えるので、クラスメソッドの start や foreach、
delete_all、auth_only なども APOP とともに使えます。


==== UIDL コマンドを使って特定のメールだけを取り出す

利用しているPOP3サーバが UIDL 機能を提供している場合には、
以下のようにして特定のメールだけを取り出すことができます。

  def need_pop?(id)
    # 取り出したいメールの場合に真を返す
  end
  
  Net::POP3.start('pop.example.com', 110,
                  'Your account', 'Your password') do |pop|
    pop.mails.select { |m| need_pop?(m.unique_id) }.each do |m|
      do_something(m.pop)
    end
  end

[[m:Net::POPMail#unique_id]] はメッセージのユニークIDを文字列で返します。
これは通常そのメッセージのハッシュ値です。

==== SSL/TLS による暗号化
このライブラリは pop3s と呼ばれる、995番ポートを使いPOP3の通信全体を
SSLで包む方法での通信の認証および暗号化が可能です。
この方法は標準化されていません。

[[RFC:2595]] で定義されている STLS 拡張による TLS の利用はできません。

[[m:Net::POP3#enable_ssl]] でそのオブジェクトが SSL を利用するように
設定します。

また、[[m:Net::POP3.enable_ssl]] で以降生成されるすべての
[[c:Net::POP3]] オブジェクトで SSL を利用するように設定できます。
グローバルに状態を変更するのであまり利用しないほうがよいでしょう。


= class Net::POP3 < Object
alias Net::POP
alias Net::POPSession

POP3 のセッションを表すクラスです。

== Class Methods

--- new(address, port = nil, apop = false) -> Net::POP3
[[c:Net::POP3]] オブジェクトを生成します。

このメソッドではサーバの接続は行いません。
apop が真のときは APOP 認証を行うオブジェクトを生成します。

port に nil を渡すと、適当なポート(通常は110、SSL利用時には 995)を
使います。

@param address POP3サーバのホスト名文字列
@param port 接続するPOP3サーバのポート番号
@param apop 真の場合にはAPOPで認証します

@see [[m:Net::POP3#start]]
--- start(address, port = nil, account=nil, password=nil, isapop=false) -> Net::POP3
--- start(address, port = nil, account=nil, password=nil, isapop=false) {|pop| .... } -> object

[[c:Net::POP3]] オブジェクトを生成し、サーバへ接続します。

ブロックを与えない場合には生成したオブジェクトを返します。

ブロックを与えた場合には、生成した [[c:Net::POP3]] オブジェクトが
ブロックに渡され、ブロックが終わったときにセッションを終了させます。
この場合返り値はブロックの返り値となります。

port に nil を渡すと、適当なポート(通常は110、SSL利用時には 995)を
使います。

以下のコードと同じ動作をします。
  Net::POP3.new(address, port, isapop).start(account, password)

使用例:

  require 'net/pop'

  Net::POP3.start(addr, port, account, password) {|pop|
    pop.each_mail do |m|
      file.write m.pop
      m.delete
    end
  }

@param address POP3サーバのホスト名文字列
@param port 接続するPOP3サーバのポート番号
@param account アカウント名文字列
@param password パスワード文字列
@param isapop 真でAPOPを利用します

@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

@see [[m:Net::POP3#start]]
--- APOP(is_apop) -> Class
bool が真なら [[c:Net::APOP]] クラス、偽なら [[c:Net::POP3]] クラスを返します。

使用例:

  require 'net/pop'

  pop = Net::POP3::APOP($isapop).new(addr, port)
  pop.start(account, password) {
    ....
  }

@param is_apop 真の場合に Net::APOP を返します。

--- foreach(address, port = nil, account, password, isapop=false) {|mail| .... } -> ()
POP セッションを開始し、
サーバ上のすべてのメールを取りだし、
個々のメールを引数としてブロックを呼びだします。

個々のメールは [[c:Net::POPMail]] のインスタンスで渡されます。

port に nil を渡すと、適当なポート(通常は110、SSL利用時には 995)を
使います。

以下のコードと同様の処理をします。
  Net::POP3.start(address, port, account, password, isapop=false) {|pop|
    pop.each_mail do |m|
      yield m
    end
  }
  
使用例:

  require 'net/pop'

  Net::POP3.foreach('pop.example.com', 110,
                    'YourAccount', 'YourPassword') do |m|
    file.write m.pop
    m.delete if $DELETE
  end

@param address POP3サーバのホスト名文字列
@param port 接続するPOP3サーバのポート番号
@param account アカウント名文字列
@param password パスワード文字列
@param isapop 真でAPOPを利用します

@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します
@see [[m:Net::POP3.start]], [[m:Net::POP3#each_mail]]

--- delete_all(address, port = nil, account, password, isapop=false) -> ()
--- delete_all(address, port = nil, account, password, isapop=false) {|mail| .... } -> ()
POP セッションを開始し、サーバ上のメールを全て消去します。

ブロックを与えられたときは消去する前に各メールを引数としてブロックを呼びだします。
メールは [[c:Net::POPMail]] のインスタンスとして渡されます。

port に nil を渡すと、適当なポート(通常は110、SSL利用時には 995)を
使います。

使用例:

  require 'net/pop'

  Net::POP3.delete_all(addr, nil, 'YourAccount', 'YourPassword') do |m|
    puts m.pop
  end

@param address POP3サーバのホスト名文字列
@param port 接続するPOP3サーバのポート番号
@param account アカウント名文字列
@param password パスワード文字列
@param isapop 真でAPOPを利用します

@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します
@see [[m:Net::POP3.start]], [[m:Net::POP3#delete_all]]

--- auth_only(address, port = nil, account, password, isapop=false)
POP セッションを開き、認証だけを行って接続を切ります。

主に POP before SMTP のために用意されています。


使用例:

  require 'net/pop'

  Net::POP3.auth_only('pop.example.com', nil,     # using default port (110)
                      'YourAccount', 'YourPassword')

@param address POP3サーバのホスト名文字列
@param port 接続するPOP3サーバのポート番号
@param account アカウント名文字列
@param password パスワード文字列
@param isapop 真でAPOPを利用します

@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- default_port -> Integer
#@since 1.8.7
--- default_pop3_port -> Integer
#@end
POP3 のデフォルトのポート番号(110)を返します。

#@since 1.8.7
--- default_pop3s_port -> Integer
デフォルトのPOP3Sのポート番号(995)を返します。

--- certs -> String|nil
SSL のパラメータの ca_file (なければ ca_path) を返します。

どちらも設定されていない場合は nil を返します。

@see [[m:OpenSSL::SSL::SSLContext#ca_file]], [[m:OpenSSL::SSL::SSLContext#ca_path]]

--- verify -> Integer|nil
SSL のパラメータの verify_mode を返します。

設定されていない場合は nil を返します。

@see [[m:OpenSSL::SSL::SSLContext#verify_mode]]

--- use_ssl? -> bool
新しく生成する [[c:Net::POP3]] オブジェクトが
SSL による通信利用するならば真を返します。


--- enable_ssl(verify_or_params={}, certs=nil) -> ()
新しく生成する [[c:Net::POP3]] オブジェクトが
SSL による通信利用するように設定します。

verify_or_params にハッシュを渡した場合には、接続時に生成される
[[c:OpenSSL::SSL::SSLContext]] オブジェクトの
[[m:OpenSSL::SSL::SSLContext#set_params]] に渡されます。
certs は無視されます。

verify_or_params がハッシュでない場合には、接続時に生成される
[[c:OpenSSL::SSL::SSLContext]] オブジェクトの
[[m:OpenSSL::SSL::SSLContext#set_params]] に
  { :verify_mode => verify_or_params, :ca_path => certs }
というハッシュが渡されます。

@param verify_or_params SSLの設定のハッシュ、もしくは SSL の verify_mode
@param certs SSL の ca_path

@see [[m:Net::POP3.disable_ssl]], [[m:Net::POP3.use_ssl?]]

--- ssl_params -> Hash|nil
SSL での接続を有効にしている場合には、
SSL の設定のハッシュを返します。

このハッシュは、接続時に生成される
[[c:OpenSSL::SSL::SSLContext]] オブジェクトの
[[m:OpenSSL::SSL::SSLContext#set_params]] に渡されます。
このハッシュを変更することで、利用されるパラメータが
変更されます。

SSL を有効にしていない場合には nil を返します。

#@# internal use
#@# --- create_ssl_params(verify_or_params = {}, certs = nil)
#@# 

--- disable_ssl -> ()
新しく生成する [[c:Net::POP3]] オブジェクトが
SSL を利用しないように設定します。

@see [[m:Net::POP3.enable_ssl]], [[m:Net::POP3.use_ssl?]]

#@end

--- socket_type -> Class

このメソッドは obsolete です。
使わないでください。

== Instance Methods

#@since 1.8.7

--- use_ssl? -> bool
このインスタンスが SSL を使って接続するなら真を返します。

@see [[m:Net::POP3#enable_ssl]], [[m:Net::POP3#disable_ssl]]

--- enable_ssl(verify_or_params={}, certs=nil) -> ()
このインスタンスが SSL による通信を利用するように設定します。

verify_or_params にハッシュを渡した場合には、接続時に生成される
[[c:OpenSSL::SSL::SSLContext]] オブジェクトの
[[m:OpenSSL::SSL::SSLContext#set_params]] に渡されます。
certs は無視されます。

verify_or_params がハッシュでない場合には、接続時に生成される
[[c:OpenSSL::SSL::SSLContext]] オブジェクトの
[[m:OpenSSL::SSL::SSLContext#set_params]] に
  { :verify_mode => verify_or_params, :ca_path => certs }
というハッシュが渡されます。

@param verify_or_params SSLの設定のハッシュ、もしくは SSL の設定の verify_mode
@param certs SSL の設定の ca_path

@see [[m:Net::POP3.enable_ssl]], [[m:Net::POP3#disable_ssl]], [[m:Net::POP3#use_ssl?]]


--- disable_ssl -> ()
このインスタンスが SSL による通信を利用しないように設定します。

@see [[m:Net::POP3#enable_ssl]], [[m:Net::POP3#disable_ssl]], [[m:Net::POP3#use_ssl?]], [[m:Net::POP3.enable_ssl]]

#@end

#@# --- inspect

#@# --- logging   # internal use only

--- start(account, password) -> self
--- start(account, password) {|pop| .... } -> object
サーバへ接続し、POP3のセッションを開始します。

ブロックが渡された場合にはセッション開始後
そのオブジェクト自身を引数としてブロックが呼びだされます。
ブロック終了時にセッションを終了させます。

ブロックが渡されなかった場合にはそのオブジェクト自身を返します。
この場合セッションを終了させるのはユーザの責任となります。


@param account アカウント名文字列
@param password パスワード文字列
@raise IOError セッションが既に開始されている場合に発生します
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

#@# TLS利用時にはそれに関する例外が発生する可能性があります

--- started? -> bool
--- active? -> bool
POP3 セッションが開始されていたら真を返します。

active? は obsolete です。

--- address -> String
接続するアドレスです。

--- port -> Integer
接続するポート番号です。

--- set_debug_output(f) -> ()
デバッグ用の出力 f をセットします。

このメソッドは深刻なセキュリティホールの原因となりえます。
デバッグ以外の用途では使わないでください。

f は << メソッドを持っているオブジェクトでなければなりません。

使用例:

  require 'net/pop'

  pop = Net::POP3.new('pop.example.com', 110)
  pop.set_debug_output $stderr
  pop.start('YourAccount', 'YourPassword') {
    p pop.n_bytes
  }

実行結果:

  POP session started: pop.example.com:110 (POP)
  -> "+OK popd <1162042773.26346.155555a1861c@pop.example.com>\r\n"
  <- "APOP YourAccount XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\r\n"
  -> "+OK\r\n"
  <- "STAT\r\n"
  -> "+OK 37 339936\r\n"
  339936
  <- "QUIT\r\n"
  -> "+OK\r\n"

--- open_timeout -> Integer
接続時に待つ最大秒数を返します。

#@until 2.0.0
この秒数たってもコネクションが開かないときは例外 [[c:TimeoutError]] を発生します。
#@else
この秒数たってもコネクションが開かないときは例外 [[c:Net::OpenTimeout]] を発生します。
#@end

デフォルトは30秒です。

@see [[m:Net::POP3#open_timeout=]]

--- open_timeout=(n)
接続時に待つ最大秒数を設定します。

@param n タイムアウトまでの秒数
@see [[m:Net::POP3#open_timeout]]

--- read_timeout -> Integer
読み込みでブロックしてよい最大秒数を返します。

#@until 2.0.0
この秒数たっても読みこめなければ例外 [[c:TimeoutError]] を発生します。
#@else
この秒数たっても読みこめなければ例外 [[c:ReadTimeout]] を発生します。
#@end

デフォルトは60秒です。

@see [[m:Net::POP3#read_timeout=]]

--- read_timeout=(n)
読み込みでブロックしてよい最大秒数を設定します。

#@until 2.0.0
この秒数たっても読みこめなければ例外 [[c:TimeoutError]] を発生します。
#@else
この秒数たっても読みこめなければ例外 [[c:ReadTimeout]] を発生します。
#@end

@param n タイムアウトまでの秒数
@see [[m:Net::POP3#read_timeout]]

--- finish -> ()
POP3 セッションを終了し、接続を閉じます。

@raise IOError セッション開始前にこのメソッドを呼ぶと発生します

--- apop? -> bool
このインスタンスが APOP を使ってサーバに接続するなら true を返します。

--- n_bytes -> Integer
サーバにあるメールの総バイト数を返します。

@see [[m:Net::POP3#n_mails]]
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPError サーバがエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- n_mails -> Integer
サーバにあるメールの数を返します。

@see [[m:Net::POP3#n_bytes]]
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPError サーバがエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- mails -> [Net::POPMail]
サーバ上の全てのメールを、[[c:Net::POPMail]]オブジェクトの配列として返します。

この配列はメールを最初に取得しようとしたときに生成され、セッションの間
キャッシュされます。

@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPError サーバがエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します


--- each_mail {|popmail| .... } -> [Net::POPMail]
--- each {|popmail| .... } -> [Net::POPMail]
サーバ上の各メールを引数としてブロックを呼びだします。

メールは [[c:Net::POPMail]] のインスタンスとして渡されます。

pop3.mails.each と同じです。

@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::POPError サーバがエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- delete_all -> ()
--- delete_all {|popmail| .... } -> ()
サーバ上のメールを全て消去します。

ブロックを与えられたときは消去する前に各メールを引数としてブロックを呼びだします。
メールは [[c:Net::POPMail]] のインスタンスとして渡されます。

使用例:

  require 'net/pop'

  n = 1
  pop.delete_all do |m|
    File.open("inbox/#{n}") {|f| f.write m.pop }
    n += 1
  end

--- auth_only(account, password) -> ()
POP セッションを開き、認証だけを行って接続を切ります。

主に POP before SMTP のために用意されています。

使用例:

  require 'net/pop'

  pop = Net::POP3.new('pop.example.com')
  pop.auth_only 'YourAccount', 'YourPassword'

@param account アカウント名文字列
@param password パスワード文字列
@raise IOError セッションが既に開始されている場合に発生します
@raise Net::POPAuthenticationError 認証に失敗した、もしくはAPOPを利用しようとしたがサーバがAPOPを提供していない場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- reset -> ()
セッションをリセットします。

リセットによって [[m:Net::POPMail#delete]] で付けた削除マークがすべて
取り除かれます。

POP3 ではメール一個だけを復活する方法はありません。

#@# --- set_all_uids   # internal use only

== Constants

--- Revision -> String
ライブラリ(ファイル)のリビジョンです。
使わないでください。



= class Net::APOP < Net::POP3
alias Net::APOPSession

このクラスでは新しいメソッドは導入していません。
認証方式が APOP に変わるだけです。



= class Net::POPMail < Object

POP サーバー上のメール一通を表現するクラス。

メールの取得や消去といった操作をカプセル化します。
[[c:Net::POP3]] クラスが生成するもので、ユーザが直接は生成しません。

== Instance Methods

--- pop -> String
--- all -> String
--- mail -> String
--- pop {|str| .... } -> nil
--- all {|str| .... } -> nil
--- mail {|str| .... } -> nil
--- pop(io) -> object
--- all(io) -> object
--- mail(io) -> object

メールを受信します。

引数もブロックも与えられなかった場合にはメール
の内容を文字列で返します。

ブロックが渡されたときは、メールの内容を
少しずつ読み込み、読みこんだ文字列を
引数としてブロックを呼びだします。

ブロックなしで、オブジェクトを
引数として渡すとそのオブジェクトに
メールの内容を << メソッドで順次書き込みます。
通常 [[c:IO]] オブジェクトを渡します。
この場合引数として渡したオブジェクトを返します。

pop, all, mail はすべて同じ効果ですが、
all と mail は obsolete です。


使用例:

  require 'net/pop'

  Net::POP3.start('pop.example.com', 110,
                  'YourAccount', 'YourPassword') {|pop|
    pop.mails.each do |m|
      puts m.pop
    end
  }


ブロックを利用する例:
  require 'net/pop'

  Net::POP3.start('pop.example.com', 110) {|pop|
    pop.each_mail do |m|
      m.pop do |str|
        print str
      end
    end
  }

@param io メールの内容を書きこむオブジェクト
@raise TimeoutError 通信がタイムアウトした場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- header(dest='') -> String
メールヘッダを受信し、文字列として返します。

destを渡すとそのオブジェクトにデータを書き込みますが、これは
obsolete なので使わないでください。

@param dest ヘッダを書き込む先(obsoleteなので使わないでください)
@raise TimeoutError 通信がタイムアウトした場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します

--- top(lines, dest='') -> String
メールヘッダと本文 lines 行を受信し、文字列として返します。

destを渡すとそのオブジェクトにデータを書き込みますが、これは
obsolete なので使わないでください。

@param lines 本文を読みだす行数
@param dest データを書き込む先(obsoleteなので使わないでください)
@raise TimeoutError 通信がタイムアウトした場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します


--- delete -> ()
--- delete! -> ()
メールに削除マークを付けます。

削除マークを付けたメールは読み出せなくなります。
セッション終了時に実際に削除されます。
[[m:Net::POP3#reset]] を呼ぶと削除マークは取り消されます。

delete! は obsolete です。

@raise TimeoutError 通信がタイムアウトした場合に発生します
@raise Net::POPError サーバが認証失敗以外のエラーを報告した場合に発生します
@raise Net::POPBadResponse サーバからの応答がプロトコル上不正であった場合に発生します
@see [[m:Net::POPMail#deleted?]]
--- deleted? -> bool
メールに削除マークが付けられている場合に真を返します。

@see [[m:Net::POPMail#delete]]

--- size -> Integer
--- length -> Integer
メールのサイズ (単位はバイト) をかえします。

--- number -> Integer
メールに対して振られた、そのメールボックスで一意な番号を返します。

サーバに接続しなおすとこの番号は変化する場合があります。
メールごとに一意な識別子が必要なときは
[[m:Net::POPMail#uidl]] を使ってください。

--- uidl -> String
--- unique_id -> String
メールに対して振られた、サーバ上で一意な識別子 (UIDL) をかえします。

[[m:Net::POPMail#number]] と違い、
この UIDL は接続しなおしても変化しません。

#@# internal use
#@# --- uid=
= class Net::POPError < Net::ProtocolError

POP3 の、認証以外のエラーが起きたときに発生します。
サーバからの "-ERR" 応答コードに対応します。

= class Net::POPBadResponse < Net::POPError

サーバから予期しないレスポンスが帰ってきたときに発生します。

= class Net::POPAuthenticationError < Net::ProtoAuthError

POP3 で認証に失敗したときに発生します。

#@# memo:
#@# いくつかのメソッドはaccountとpasswordを省略できるように書いているが
#@# これを省略した場合、認証は必ず失敗する
