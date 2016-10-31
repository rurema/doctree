= ruby 1.8.3 feature

*((<ruby 1.8 feature>))
*((<ruby 1.8.2 feature>))

ruby 1.8.2 から ruby 1.8.3 までの変更点です。

掲載方針

*バグ修正の影響も含めて動作が変わるものを収録する。
*単にバグを直しただけのものは収録しない。
*ライブラリへの単なる定数の追加は収録しない。

以下は各変更点に付けるべきタグです。

記号について(特に重要なものは大文字(主観))

* カテゴリ
  * [ruby]: ruby インタプリタの変更
  * [api]: 拡張ライブラリ API
  * [lib]: ライブラリ
* レベル
  * [bug]: バグ修正
  * [new]: 追加されたクラス／メソッドなど
  * [compat]: 変更されたクラス／メソッドなど
    * 互換性のある変更
    * only backward-compatibility
    * 影響の範囲が小さいと思われる変更もこちら
  * [change]: 変更されたクラス／メソッドなど(互換性のない変更)
  * [obsolete]: 廃止された(される予定の)機能
  * [platform]: 対応プラットフォームの追加

bundled libraryである(rubyの一部ではない)soap4rの変更点については、以下を参考にしてください。
soap4r-1.5.3がruby-1.8.2、soap4r-1.5.5がruby-1.8.3にbundleされています。
 * ((<URL:http://dev.ctor.org/soap4r/wiki/Changes-154>))
 * ((<URL:http://dev.ctor.org/soap4r/wiki/Changes-155>))

== 1.8.2 (2004-12-25) -> 1.8.3 (2005-09-21)

=== 2005-09-19
: FileUtils.remove_entry_secure [lib] [new]
: FileUtils.remove_entry        [lib] [new]
: FileUtils.chmod_R             [lib] [new]
: FileUtils.chown               [lib] [new]
: FileUtils.chown_R             [lib] [new]
: FileUtils.commands            [lib] [new]
: FileUtils.options             [lib] [new]
: FileUtils.have_option?        [lib] [new]
: FileUtils.options_of          [lib] [new]
: FileUtils.collect_method      [lib] [new]

  追加。

: FileUtils.rm_r  [lib] [compat]
: FileUtils.rm_rf [lib] [compat]
: FileUtils.cd    [lib] [compat]
: FileUtils.cp_r  [lib] [compat]

  rm_f と rm_rf が :secure オプションを受け付けるようになりました。
  cd が :noop オプションを受け付けなくなりました。
  cp_r が :dereference_root オプションを受け付けるようになりました。

=== 2005-09-16
: File.join [ruby] [compat]

  型チェックを厳密にするようになりました。

    $ ruby-1.8.2 -e 'p File.join(1, 2)'
    "1/2"
    
    $ ruby-1.8.3 -e 'p File.join(1, 2)'
    -e:1:in `join': can't convert Fixnum into String (TypeError)
            from -e:1

=== 2005-09-16
: File.extname [ruby] [compat]

  与えられた pathname がピリオドで終る場合、ピリオドではなく空の文字列を返すようになりました。

    $ ruby-1.8.2 -e 'p File.extname("a.")'
    "."
    $ ruby-1.8.3 -e 'p File.extname("a.")'
    ""

=== 2005-09-13
: Logger#formatter  [lib] [new]
: Logger#formatter= [lib] [new]
: Logger::Formatter [lib] [new]

  追加。

=== 2005-09-13
: Net::HTTP

  https での Proxy 認証をサポートするようになりました。
 
: Net::HTTP.post_form(url, params) [lib] [new]

: Net::HTTPHeader#content_length=  [lib] [new]
: Net::HTTPHeader#content_type     [lib] [new]
: Net::HTTPHeader#main_type        [lib] [new]
: Net::HTTPHeader#sub_type         [lib] [new]
: Net::HTTPHeader#type_params      [lib] [new]
: Net::HTTPHeader#content_type=    [lib] [new]
: Net::HTTPHeader#set_content_type [lib] [new]

: Net::HTTPRequest#body(=)         [lib] [new]
: Net::HTTPRequest#body_stream(=)  [lib] [new]

  追加。

: Net::HTTPHeader#each_capitalized      [lib] [compat]
: Net::HTTPHeader#each_capitalized_name [lib] [new]

  Net::HTTPHeader#canonical_each は Net::HTTPHeader#each_capitalized
  に名前が変わりました。canonical_each も each_capitalized の別名とし
  て提供されます。

: net/http [lib] [new]

  WebDAV のメソッドをサポートするようになりました。
  PROPPATCH, LOCK, UNLOCK, OPTIONS, PROPFIND, DELETE, MOVE, COPY, MKCOL。
  
: Net::HTTPRequest#body_exist?  [lib] [obsolete]
: Net::HTTPResponse#response    [lib] [obsolete]
: Net::HTTPResponse#header      [lib] [obsolete]
: Net::HTTPResponse#read_header [lib] [obsolete]
  
  obsolete になりました。VERBOSE モードの時、警告が出ます。

=== 2005-09-10
: OpenSSL::PKCS7::RecipientInfo [lib] [new]
: OpenSSL::PKCS7::SignerInfo    [lib] [compat]

  新クラス、追加。OpenSSL::PKCS7::Signer が OpenSSL::PKCS7::SignerInfo に名前が変わりました。Signer も別名として
  引続き提供されます。

=== 2005-09-10
: OpenSSL::Digest::SHA224
: OpenSSL::Digest::SHA256
: OpenSSL::Digest::SHA384
: OpenSSL::Digest::SHA512

  新クラス、追加。OpenSSL 0.9.8 以降とともにコンパイルされた時のみ。

=== 2005-09-09
: $SAFE [ruby] [compat]

  メソッドが定義された時の $SAFE レベルを記憶するようになりました。
  メソッドは定義された時の $SAFE レベルで実行されます。
  $SAFE レベル 3 以上の環境下において定義されたメソッドを呼び出すことは、$SAFE レベル が 0 のとき
  禁止されるようになりました。

    $ cat mthd_taint.rb
    th = Thread.new{
      $SAFE = 3
      class Hoge
        def foo
          puts "safe level: #{$SAFE}"
        end
      end
    }    
    th.join
    p $SAFE
    Hoge.new.foo

    $ ruby-1.8.2 mthd_taint.rb
    0
    "safe level: 0"
    
    $ ruby-1.8.3 mthd_taint.rb
    0
    mthd_taint.rb:11:in `foo': calling insecure method: foo (SecurityError)
            from mthd_taint.rb:11

=== 2005-09-09
: String#*  [ruby] [compat]
: String#[] [ruby] [compat]
  空文字にも taint が伝播するようになりました。((<ruby-dev:26900>)) ((<ruby-dev:27121>))
    $ ruby-1.8.2 -e 'p ("x".taint * 0).tainted?'
    false
    
    $ ruby-1.8.3 -e 'p ("x".taint * 0).tainted?'
    true

    $ ruby-1.8.2 -e 'p ("x".taint[1..-1]).tainted?'
    false
    
    $ ruby-1.8.3 -e 'p ("x".taint[1..-1]).tainted?'
    true

  Range オブジェクトが taint されている場合、"string"[range] も taint されるようになりました。((<ruby-dev:27121>))

    $ ruby-1.8.2 -e 'p ("x"[(0..-1).taint]).tainted?'
    false
    
    $ ruby-1.8.3 -e 'p ("x"[(0..-1).taint]).tainted?'
    true

=== 2005-08-29
: Time.parse [lib] [compat]

  Time.parse が小数点以下の秒も扱えるようになりました。((<ruby-talk:153859>))

    $ ruby-1.8.2 -r time -e 'p  Time.parse("23 Aug 2005 19:00:01.1").to_f'
    1124791201.0
    
    $ ruby-1.8.3 -r time -e 'p  Time.parse("23 Aug 2005 19:00:01.1").to_f'
    1124791201.1

=== 2005-08-20
: Logger [lib] [bug]
  ファイルをシフト時のレースコンディションが修正されました。

=== 2005-08-07
: WIN32OLE_EVENT#on_event [lib] [bug]
  最後に定義したイベントハンドラが有効になるように修正しました。

=== 2005-07-27
: Dir#each    [ruby] [bug]
: Dir#entries [ruby] [bug]

  1回メソッドを呼んでしまうと空になるバグを修正しました。

    $ ruby-1.8.2 -e '
    d = Dir.new("/")
    d.entries
    p d.entries
    '
    []
     
    $ ruby-1.8.3 -e '
    d = Dir.new("/")
    d.entries
    p d.entries
    '
    [".", "..", "dev", "home", "proc", "var", "tmp", "etc", "usr", "sbin", "bin", "boot"]



=== 2005-07-11
: 正規表現 [ruby] [bug]

  正規表現リテラル中で \c\\ 表記があるとパースエラーになるバグを修正しました。

    $ cat r.rb
    p /[\c\\]/ =~ "\c\\"
    p /\c\\/ =~ "\c\\"
    
    $ ruby-1.8.2 r.rb
    r.rb:1: premature end of regular expression: /[\c\\]/
    r.rb:2: invalid regular expression; '\' can't be last character: /\c\\/
    
    $ ruby-1.8.3 r.rb
    0
    0

=== 2005-06-30
: Delegator [lib] [compat]

  Delegator オブジェクトが生成された後に定義されたメソッドに関しても、適切に委譲するようになりました。
  ((<ruby-talk:146776>)) ((<ruby-talk:146894>))
    $ cat test_dlg.rb
    foo = Object.new
    foo2 = SimpleDelegator.new(foo)
    def foo.bar
      puts "bar"
    end
    foo2.bar  
     
    $ ruby-1.8.2 -r delegate test_dlg.rb
    test_dlg.rb:6: undefined method `bar' for #<Object:0x4021b0a0> (NoMethodError)
    
    $ ruby-1.8.3 -r delegate test_dlg.rb
    bar

=== 2005-06-20
: DBM#closed? [lib] [new]
: GDBM#closed? [lib] [new]
: SDBM#closed? [lib] [new]

=== 2005-06-16

: Time.parse [lib] [compat]

  うるう秒 "Fri Jan  1 08:59:60 +0900 1999" をサポートしている環境において、Time.parse が
  適切に振舞うようになりました。

=== 2005-06-08
: Curses.insertln [lib] [new]
: Curses::Window.insertln [lib] [new]

=== 2005-06-08
: ext/socket [lib] [compat]

  拡張ライブラリ socket が AIX 上でコンパイルされるようになりました。((<ruby-list:40832>))

=== 2005-06-07
: Module#class_variable_get [ruby] [new]
: Module#class_variable_set [ruby] [new]
  
  クラスメソッドから((<変数と定数/クラス変数>))にアクセスするための
  ((<Module#class_variable_get|Module/class_variable_get>)) と
  ((<Module#class_variable_set|Module/class_variable_set>)) が
  追加されました。((<ruby-talk:144741>))

    class Fred
      @@foo = 99
      def foo
        @@foo
      end
    end
    
    def Fred.foo
      @@foo = 101      #=> @@foo は Fred クラスのクラス変数ではない。
    end
    
    def Fred.foo_foo   
      class_variable_set(:@@foo, 101)  # self が Fred クラス自身であることに注意。クラス変数 @@foo に値をセットする。
    end
    
    Fred.foo           # メソッドを呼んでも、Fred クラスのクラス変数 @@foo は変わらない。
    p Fred.new.foo     #=> 99 

    Fred.foo_foo       # 
    p Fred.new.foo     #=> 101


=== 2005-05-28
: WEBrick::CGI::Socket#request_line [lib] [compat]

  WEBrick を CGI 環境下で使う場合、
  request_line メソッドは REQUEST_URI ヘッダがあればそちらを優先して使うようになりました。
  ((<ruby-dev:26235>))

=== 2005-05-27
: mkmf [lib] [bug]
  MSYS 環境下において、PATHの区切り値にセミコロンを使うよう修正しました。((<ruby-dev:26232>))

=== 2005-05-24
: getopts [lib] [obsolete]
  getopts が deprecated になりました。deprecated であるという警告は、
  オプションに -w を付けた時に出ます。((<ruby-dev:26201>))

=== 2005-05-22
: OpenSSL::SSL::SSLServer#initialize(svr, ctx, session_id=nil)
  session_id を受け付けるようになりました。((<ruby-core:4663>))

=== 2005-05-19
: REXML::Encoding#decode_sjis [lib] [bug]
: REXML::Encoding#encode_sjis [lib] [bug]
  decode_sjis と encode_sjis が
  逆に定義されていたバグを修正しました。((<ruby-core:4772>))

=== 2005-05-16
: singleton class [ruby] [change]
  特異クラスは複製できなくなりました。((<ruby-talk:142749>))

    $ ruby-1.8.3 -e 'class << "str"; self end.dup'
    -e:1:in `initialize_copy': can't copy singleton class (TypeError)
            from -e:1

=== 2005-05-15
: Pathname#unlink [lib] [compat]
  ディレクトリへのシンボリックリンクも削除されるようになりました。((<ruby-core:4992>))

=== 2005-05-14
: NameError
: SystemCallError
: SystemExit
  各例外クラスのインスタンスが生成される時に、親クラスのコンストラクタ
  である Exception#initialize が呼ばれるようになりました。((<ruby-talk:142593>)) ((<ruby-dev:26177>))

=== 2005-05-11
: break [ruby] [bug]
  メソッドを越えて break が有効になるバグを修正しました。((<ruby-list:40818>))
    
    $ cat brk.rb
    def stop(n)
      break  if n == 2
    end
    
    (1..5).each do |i|
      stop(i)
      puts i
    end
    
    $ ruby-1.8.2 brk.rb
    1
    
    $ ruby-1.8.3 brk.rb
    1
    brk.rb:2:in `stop': unexpected break (LocalJumpError)
            from brk.rb:6
            from brk.rb:5

=== 2005-05-11
: WEBrick::CGI#[]     [lib] [new]
: WEBrick::CGI#logger [lib] [new]
: WEBrick::CGI#config [lib] [new]

=== 2005-05-01
: ruby -s option [ruby] [bug]
  オプション -s でアクセスできないグローバル変数ができてしまうバグを修正
  しました。- を _ に変換してグローバル変数を定義するようになりました。- 以外の
  記号がふくまれる場合は、例外 NameError を投げます。
  
    $ ruby-1.8.2 -se 'puts global_variables.grep(/foo/)' -- --foo-bar
    $-foo-bar
    $ ruby-1.8.3 -se 'puts global_variables.grep(/foo/)' -- --foo-bar
    $_foo_bar

    $ ruby-1.8.3 -se 'puts global_variables.grep(/foo/)' -- --foo\@bar    
    -e: invalid name for global variable - --foo@bar (NameError)

=== 2005-04-18
: WIN32OLE.codepage [lib] [new]
: WIN32OLE.codepage= [lib] [new]

=== 2005-04-10
: WIN32OLE#invoke [lib] [bug]
  nil を VT_ERROR に変換して Invokeを呼び出して失敗するときには VT_EMPTYに変換して
  再度 Invokeを呼び出すようにしました。
    
=== 2005-04-09
: rss [lib][new][compat]

  複数のDublin Coreの要素を扱えるようになりました。

  このためdc_#{Dublin Coreの要素名の複数形}というメソッドが導入されました。

  互換性のために以前のdc_#{Dublin Coreの要素名の単数形}というメソッドも残されています。

=== 2005-03-07
: String#<=> [ruby][compat]

  比較できないものを渡された時に false ではなく nil を返すようになりました。
  ((<ruby-dev:25811>))

    $ ruby-1.8.2 -e 'p "a" <=> 1'
    false 
    $ ruby-1.8.3 -e 'p "a" <=> 1'
    nil


=== 2005-03-06
: HTTPHeader#get_fields [lib][new]
: HTTPHeader#add_field [lib][new]

  追加。((<ruby-list:40629>))

=== 2005-02-23
: local variable and method [ruby][bug]
  レシーバを指定したメソッド呼び出しが、同名のローカル変数の有無によっ
  て影響されるバグが修正されました。
  ((<ruby-dev:25737>))
  ((<URL:http://yowaken.dip.jp/tdiary/20050220.html#p01>))

=== 2005-02-17
: Open3.popen3 [lib] [compat]
  Open3.popen3実行後の$?.exitstatusが0になるように修正されました。

: ((<クラス／メソッドの定義/defined?>)) [ruby][bug]
  (({defined?(@a = b)}))のような NODE_IASGN が nil ではなく
  "assignment" を返すようになりました。
  ((<"[yarv-dev:418]"|URL:http://www.atdot.net/mla/yarv-dev/418>))

=== 2005-02-17
: Test::Unit::AutoRunner.run [lib] [change]
  第一引数の意味が変わりました。

=== 2005-02-14

: OpenSSL::SSL::SSLSocket#post_connection_check [lib][new]

  追加 ((<ruby-dev:25690>))

=== 2005-02-13

: ERB::Util.html_escape [lib] [compat]
: ERB::Util.url_encode [lib] [compat]

  モジュール関数としても使えるようになりました。((<ruby-dev:25687>))

=== 2005-02-12

: open-uri [lib] [new]
  https をサポートするようになりました。

=== 2005-02-11

: URI::HTTP#proxy_open [lib][new]

  (({:http_basic_authentication})) オプションの追加
  ((<ruby-core:4416>))

: OpenSSL::X509::Store#set_default_paths [lib][new]

  追加 ((<ruby-dev:25670>))

=== 2005-02-06
: Resolv::DNS::Resource::TXT#strings [lib] [new]
: Resolv::DNS::Message::MessageEncoder#put_string_list [lib] [new]
: Resolv::DNS::Message::MessageDecoder#get_string_list [lib] [new]
  追加。((<ruby-talk:129732>))

=== 2005-02-04

: RSS Parser/Maker [lib] [new]

  ((<Imageモジュール|URL:http://web.resource.org/rss/1.0/modules/image/>))のサポート

=== 2005-02-03

: RSS::Element#convert(value) [lib] [new]
   valueのエンコーディングを変換するメソッドを公開。
   
   valueのエンコーディングは要素の内部エンコーディングからoutput_encoding=で設定したエンコーディングへ変換されます。

: StringIO [lib] [compat]
  close, close_read, close_write が ((<IO>)) と同じように、
  nil を返すようになりました。((<ruby-dev:25623>))

=== 2005-01-29

: Resolv::DNS::Resource::IN::SRV [lib] [new]

  追加
  (RFC2782)

=== 2005-01-26
: File#flock [ruby] [bug]
  Windows 上での File#flock(File::LOCK_UN) が正しく理解されないバグが
  修正されました。((<ruby-dev:25574>)) 

=== 2005-01-25
: RUBYOPT [ruby] [bug]
  環境変数 RUBYOPT の -T オプションを適切に解釈するようになりました。
  またハイフン - を省略できるようになりました。((<ruby-dev:25512>))

    $ env RUBYOPT='Ke rnet/http' ruby  -e 'p Net::HTTP'  
    Net::HTTP

=== 2005-01-17
: WEBrick::Config::SSL [lib] [compat]
  オプション :SSLEnable のデフォルトが false になりました。

: WEBrick::HTTPUtils#escape_path [lib] [new]

=== 2005-01-15

: RSS::VERSION [lib]

  0.1.2 -> 0.1.3

: RSS::Parser [lib] [bug]

  継承するとエラーになるバグを修正。 ((<ruby-talk:126104>))

=== 2005-01-12
: Class#superclass [ruby] [bug]
  特異クラスのメソッド superclass が特異クラスを返すように修正されました。
  ((<ruby-list:40519>))

=== 2005-01-09

: IO#read [obsolete]
: IO#readpartial [new]

  nonblocking IO に対する IO#read の挙動は ruby 1.9 以降で変化します ((<ruby-dev:25101>))。そのため、
  ruby 1.8.3 以降では、VERBOSE モードの時に IO#read がノンブロッキングモードで
  データの読み込みに失敗して ((<Errno::EAGAIN|Errno::EXXX>)) エラーが発生した場合、
  "nonblocking IO#read is obsolete" という警告が出るようになりました。
  そして ruby 1.8 の nonblocking IO#read の移行先として
  ruby 1.8.3 に IO#((<IO/readpartial>)) が追加されました。
  ((<ruby-dev:25430>)) ((<ruby-dev:25443>))

    $ ruby -e 'sleep 1; print "hoge"' | ruby-1.8.2 -rio/nonblock -we '
                                          io = IO.open(0)
                                          io.nonblock = true
                                          p io.read(4)'
    -e:4:in `read': Resource temporarily unavailable (Errno::EAGAIN)
            from -e:4
    
    $ ruby -e 'sleep 1; print "hoge"' | ruby-1.8.3 -rio/nonblock -we '
                                          io = IO.open(0)
                                          io.nonblock = true
                                          p io.read(4)'
    -e:4: warning: nonblocking IO#read is obsolete; use IO#readpartial or IO#sysread
    -e:4:in `read': Resource temporarily unavailable (Errno::EAGAIN)
            from -e:4
    
    $ ruby -e 'sleep 1; print "hoge"' | ruby-1.8.3 -rio/nonblock -we '
                                          io = IO.open(0)
                                          io.nonblock = true
                                          p io.readpartial(4)'
    "hoge"

    $ ruby -e 'sleep 1; print "hoge"' | ruby-1.9 -rio/nonblock -we '
                                          io = IO.open(0)
                                          io.nonblock = true
                                          p io.read(4)'
    "hoge"

=== 2005-01-05

: srand(bignum) [compat]

  srand が引数として unsigned long よりも大きな値も受け付けるようになりました。

: rand(bignum)  [bug]

  負の ((<Bignum>)) を受け取っても 正の ((<Bignum>)) を返すようになりました。

=== 2005-01-03

: srand [compat]

  引数を与えない場合、可能なら /dev/urandom を参照するようになりました。((<ruby-dev:25392>))
