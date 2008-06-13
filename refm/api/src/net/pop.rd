メールを受信するためのプロトコル
POP3 (Post Office Protocol version 3) を扱うライブラリです。

POP3 の実装は [[RFC:1939]] に基いています。

=== 使用例

==== メールの受信

以下のコードは、メールを受信してファイル 'inbox/1' 'inbox/2'... に
書きこみ、サーバ上からメールを消します。pop3.server.address は適宜
読みかえてください。

  require 'net/pop'
  
  pop = Net::POP3.new('pop3.server.address', 110)
  pop.start('YourAccount', 'YourPassword')          ###
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
  pop.finish                                        ###

POP サーバはネットワークのむこうに存在するので、
なにか仕事をさせるにはその前に開始手続きを、
終わったら終了手続きを、行わなければいけません。
それを行うのが [[m:Net::POP3#start]] と [[m:Net::POP#finish]] で、
POP3 オブジェクトはその二つのメソッドの間でだけ有効になります。

サーバ上のメールは POPMail オブジェクトとして表現されており、この
オブジェクトのメソッドを呼ぶことでメールを取ってきたり消したりする
ことができます。[[m:Net::POP3#mails]] はこの POPMail オブジェクトの配列であり、
[[m:Net::POP3#each_mail]] はさらに pop.mails.each のショートカットです。

==== 短くする

上の例はあえて省略や短縮用メソッドを避けたためにかなり冗長です。
まず、ブロック付きの [[m:Net::POP3.start]] を使うことで
POP3.new, #start, #finish を併合できます。

  require 'net/pop'
  
  Net::POP3.start('pop3.server.address', 110,
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
[[m:Net::POP3#delete]] を併合できます。

  require 'net/pop'
  
  Net::POP3.start('pop3.server.address', 110,
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
  Net::POP3.delete_all('pop3.server.address', 110,
                       'YourAccount', 'YourPassword') do |m|
    File.open("inbox/#{i}", 'w') {|f|
      f.write m.pop
    }
    i += 1
  end

==== ファイルに直接書く

これまでの例では [[m:Net::POPMail#pop]] を使い、
メールをひとつの文字列としてうけとっていました。
しかし、もしメールが 100MB を越えるような巨大なメールだった場合、
この方法ではまずいかもしれません。
そのような場合は以下のように [[m:Net::POPMail#pop]] に
File オブジェクトを与える手が使えます。

  require 'net/pop'

  Net::POP3.delete_all('pop3.server.address', 110,
                       'YourAccount', 'YourPassword') do |m|
    File.open('inbox', 'w') {|f|
        m.pop f   ####
    }
  end

==== APOP を使う

Net::POP3 クラスのかわりに Net::APOP クラスを使うと、
認証時に APOP を使うようになります。
また動的にノーマル POP と APOP を選択するには、
以下のように [[m:Net::POP3.APOP]] メソッドを使うのが便利です。

  require 'net/pop'
  
  # use APOP authentication if $isapop == true
  pop = Net::POP3.APOP($isapop).new('apop.server.address', 110)
  pop.start(YourAccount', 'YourPassword') {|pop|
    # 残りのコードは同じ
  }

この方法はクラス自体を変えるので、クラスメソッドの start や foreach、
delete_all、auth_only なども APOP とともに使えます。



= class Net::POP3 < Object
#@# class alias: Net::POP
#@# class alias: Net::POPSession

== Class Methods

--- new(address, port = 110, apop = false)
#@todo

Net::POP3 オブジェクトを生成します。まだ接続はしません。
apop が真のときは APOP 認証を行うオブジェクトを生成します。

--- start(address, port = 110, account, password)
--- start(address, port = 110, account, password) {|pop| .... }
#@todo

address の port 番ポートに接続し、アカウント account パスワード
password で POP ログインします。第二引数 port に nil を渡すと
POP3 のデフォルトポート(110)を使います。
  
使用例:

  require 'net/pop'

  Net::POP3.start(addr, port, account, password) {|pop|
    pop.each_mail do |m|
      file.write m.pop
      m.delete
    end
  }

--- APOP(is_apop)
#@todo

bool が真なら Net::APOP クラス、偽なら Net::POP3 クラスを返します。
  
使用例:

  require 'net/pop'

  pop = Net::POP3::APOP($isapop).new(addr, port)
  pop.start(account, password) {
    ....
  }

--- foreach(address, port = 110, account, password) {|mail| .... }
#@todo

POP セッションを開き、サーバ上のすべてのメールに対して繰り返します。
以下と同じです。

  Net::POP3.start(address, port, account, password) {|pop|
    pop.each_mail do |m|
      yield m
    end
  }
  
使用例:

  require 'net/pop'

  Net::POP3.foreach('your.pop.server', 110,
                    'YourAccount', 'YourPassword') do |m|
    file.write m.pop
    m.delete if $DELETE
  end

--- delete_all(address, port = 110, account, password)
--- delete_all(address, port = 110, account, password) {|mail| .... }
#@todo

POP セッションを開き、サーバ上のメールをすべて削除します。
ブロックが与えられた時は削除する前にブロックにそのメールを渡します。

使用例:

  require 'net/pop'

  Net::POP3.delete_all(addr, nil, 'YourAccount', 'YourPassword') do |m|
    puts m.pop
  end

--- auth_only(address, port = 110, account, password)
#@todo

POP セッションを開き認証だけを行って接続を切ります。
主に POP before SMTP のために用意されています。

使用例:

  require 'net/pop'

  Net::POP3.auth_only('your.pop3.server', nil,     # using default port (110)
                      'YourAccount', 'YourPassword')

--- default_port
#@since 1.9.0
--- default_pop3_port
#@todo

--- default_pop3s_port
#@todo

--- certs
#@todo

will be altered by #ssl_context.

--- verify
#@todo

will be altered by #ssl_context.

--- use_ssl?
#@todo

--- enable_ssl(verify, certs)
#@todo

signature will be changed to enable_ssl(ctx).

--- disable_ssl
#@todo

#@end

--- socket_type
#@todo

このメソッドは obsolete です。
使わないでください。

== Instance Methods

#@since 1.9.0
--- use_ssl?
#@todo

--- enable_ssl(verify, certs)
#@todo

--- disable_ssl
#@todo
#@end

--- inspect
#@todo

#@# --- logging   # internal use only

--- start(account, password)
--- start(account, password) {|pop| .... }
#@todo

リモートホストとの TCP 接続を開始し、アカウントに account、
パスワードに password を使って POP ログインします。

--- started?
--- active?
#@todo

POP3 セッションが開始されていたら真を返します。

Ruby 1.8.0 以降では active? は obsolete です。
これからは常に started? を使ってください。

--- address
#@todo

接続するアドレスです。

--- port
#@todo

接続するポート番号です。

--- set_debug_output(f)
#@todo
#@# --- debug_output=(f)

デバッグ用の出力 f をセットします。
f は << メソッドを持っているオブジェクトでなければなりません。

使用例:

  require 'net/pop'

  pop = Net::POP3.new('your.pop3.server', 110)
  pop.set_debug_output $stderr
  pop.start('YourAccount', 'YourPassword') {
    p pop.n_bytes
  }

実行結果:

  POP session started: your.pop3.server:110 (POP)
  -> "+OK popd <1162042773.26346.155555a1861c@your.pop3.server>\r\n"
  <- "APOP YourAccount XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\r\n"
  -> "+OK\r\n"
  <- "STAT\r\n"
  -> "+OK 37 339936\r\n"
  339936
  <- "QUIT\r\n"
  -> "+OK\r\n"

--- open_timeout
--- open_timeout=(n)
#@todo

接続時に待つ最大秒数です。
この秒数たってもコネクションが開かないときは
例外 TimeoutError を発生します。

--- read_timeout
--- read_timeout=(n)
#@todo

読みこみ ([[man:read(2)]] 一回) でブロックしてよい最大秒数です。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

--- finish
#@todo

POP3 セッションを終了します。セッション開始前にこのメソッドが
呼ばれた場合は例外 IOError を発生します。

--- apop?
#@todo

このインスタンスが APOP を使ってサーバに接続するなら true を返します。

--- n_bytes
#@todo

サーバにあるメールの総バイト数を返します。

--- n_mails
#@todo

サーバにあるメールの数を返します。

--- mails
#@todo

[[c:Net::POPMail]] オブジェクトの配列をかえします。
この配列はセッションを開始したときに自動的に更新されます。

--- each_mail {|popmail| .... }
--- each {|popmail| .... }
#@todo

pop3.mails.each と同じです。

--- delete_all
--- delete_all {|popmail| .... }
#@todo

サーバ上のメールを全て消去します。
ブロックを与えられたときは消去する前にその POPMail オブジェクトを
ブロックに渡します。

使用例:

  require 'net/pop'

  n = 1
  pop.delete_all do |m|
    File.open("inbox/#{n}") {|f| f.write m.pop }
    n += 1
  end

--- auth_only(account, password)
#@todo

POP セッションを開き認証だけを行って接続を切ります。
主に POP before SMTP のために用意されています。

使用例:

  require 'net/pop'

  pop = Net::POP3.new('your.pop3.server')
  pop.auth_only 'YourAccount', 'YourPassword'

--- reset
#@todo

セッションをリセットします。
具体的には [[m:Net::POPMail#delete]] で消去したメールが全て復活します。

POP3 ではメール一個だけを復活する方法はありません。

#@# --- set_all_uids   # internal use only

== Constants

--- Revision
#@todo

net/pop3 file revision.



= class Net::APOP < Net::POP3

このクラスでは新しいメソッドは導入していません。
認証方式が APOP に変わるだけです。



= class Net::POPMail < Object

POP サーバー上のメール一通を表現するクラス。
メールの取得や消去といった操作をカプセル化します。

== Instance Methods

--- pop
--- all
--- mail
#@todo

メールを受信して文字列で返します。

pop, all, mail はすべて同じ効果ですが、
all と mail は obsolete です。
これからは常に pop を使ってください。

使用例:

  require 'net/pop'

  Net::POP3.start('your.pop3.server', 110,
                  'YourAccount, 'YourPassword') {|pop|
    pop.mails.each do |m|
      puts m.pop
    end
  }

--- pop {|str| .... }
--- all {|str| .... }
--- mail {|str| .... }
#@todo

メールの文字列を少しずつ読みこみ、順次ブロックに与えます。

pop, all, mail はすべて同じ効果ですが、
all と mail は obsolete です。
これからは常に pop を使ってください。

使用例:

  require 'net/pop'

  Net::POP3.start('localhost', 110) {|pop|
    pop.each_mail do |m|
      m.pop do |str|
        print str
      end
    end
  }

--- header
#@todo

ヘッダだけを受信して文字列で返します。

--- top(lines)
#@todo

メールヘッダと lines 行ぶんの本文を取得し文字列で返します。

--- delete
--- delete!
#@todo

サーバ上からメールを削除します。

Ruby 1.8 以降では delete と delete! は同じ効果です。
また、delete! は obsolete なので、
これからは常に delete を使うべきです。

--- deleted?
#@todo

メールがサーバ上で消去されていたら true を返します。

いったんメールを消去したら
[[m:Net::POP3#reset]] を使う以外に復活する方法はありません。

--- size
#@todo

メールのサイズ (単位はバイト) をかえします。

--- number
#@todo

メールに対して振られた、そのメールボックスで一意な番号です。
サーバに接続しなおすとこの番号は変化する場合があります。
メールごとに一意な識別子が必要なときは
[[m:Net::POPMail#uidl]] を使ってください。

--- uidl
--- unique_id
#@todo

メールに対して振られた、サーバ上で一意な識別子 (UIDL) をかえします。
[[m:Net::POPMail#number]] と違い、
この UIDL は接続しなおしても変化しません。



= class Net::POPError < Net::ProtocolError

POP3 の、認証以外のエラーが起きたときに発生します。

= class Net::POPBadResponse < Net::POPError

サーバから予期しないレスポンスが帰ってきたときに発生します。

= class Net::POPAuthenticationError < Net::ProtoAuthError

POP3 で認証に失敗したときに発生します。
