= ruby 1.8.2 feature

ruby 1.8.2 での ruby 1.8.1 からの変更点です。

掲載方針

*バグ修正の影響も含めて動作が変わるものを収録する。
*単にバグを直しただけのものは収録しない。
*ライブラリへの単なる定数の追加は収録しない。

以下は各変更点に付けるべきタグです。

*カテゴリ
  * [ruby]: ruby インタプリタの変更
  * [api]: 拡張ライブラリ API
  * [lib]: ライブラリ
*レベル
  * [bug]: バグ修正
  * [new]: 追加されたクラス／メソッドなど
  * [compat]: 変更されたクラス／メソッドなど
    * 互換性のある変更
    * only backward-compatibility
    * 影響の範囲が小さいと思われる変更
  * [change]: 変更されたクラス／メソッドなど(互換性のない変更)
  * [experimental]: 変更の中でも特に実験的なもの(将来再考して欲しいもの？)
  * [obsolete]: 廃止された(される予定の)機能
  * [platform]: 対応プラットフォームの追加

== 1.8.1 (2003-12-25) -> 1.8.2 (2004-12-25) 

* cgi/session においてクライアントからセッション ID を指定できてしまうバグが
  修正されました。
* cgi/session においてセッション情報を保存するファイル名にセッション ID が
  使われるバグが修正されました。
* cgi の無限ループに陥る可能性のあるバグが修正されました。
  ((<URL:http://www.debian.org/security/2004/dsa-586>))
* 一連の core dumps バグが修正されました。
  ((<URL:https://magazine.rubyist.net/articles/0002/0002-RubyCore.html>))
* tk の変更点は 
  ((<URL:https://magazine.rubyist.net/articles/0003/0003-RubyTkMovement.html>))
  を参照して下さい。
* soap, wsdl の変更点は
  ((<URL:http://rrr.jin.gr.jp/projects/soap4r/wiki/Changes-ruby181_ruby182>))
  を参照して下さい。
* rss, rdoc, yaml の変更点は収録していません。


=== 日時未詳
: CGI#server_port [lib] [bug]
  常に 0 を返すバグが修正されました。

=== 2004-12-19

: OpenSSL::X509::Store#time=           [lib] [new]
: OpenSSL::X509::StoreContext#time=    [lib] [new]
  追加。

: OpenSSL::X509::Name::RFC2253DN       [lib] [new]
  module for RFC2253 DN format.

: OpenSSL::X509::Name.parse_rfc2253    [lib] [new]
  new method to parse RFC2253 DN format.

=== 2004-12-18

: Object#id [ruby] [obsolete]
  常に警告がでるようになりました。Object#object_id を使って下さい。

=== 2004-12-17
: CGI::Session#initialize [lib] [compat]
  'no_hidden' オプションを指定できるようになりました。((<ruby-talk:123850>))

=== 2004-12-16

: Hash#eql? [ruby] [obsolete]
: Hash#hash [ruby] [obsolete]

  削除
  ((<ruby-dev:25206>))?

=== 2004-12-14
: CGI::Session.initialize [lib] [change]
  存在しないセッション ID がクライアントから送られてきた場合
  例外を投げずに新しいセッションを作成するようになりました。
  ((<ruby-list:40368>))

=== 2004-12-09
: eval('Foo #@ bar'.inspect) [ruby] [bug]
  シンタックスエラーにならないように修正しました。
  ((<ruby-core:03922>))

: String#inspect [ruby] [bug]
  式展開になる '#'がエスケープされるようになりました。 
  ((<ruby-core:03922>))
    $ ruby1.8.1 -e "puts '# #{}'.inspect"
    "# #{}"

    $ ruby1.8.2 -e "puts '# #{}'.inspect"
    "# \#{}"

: String#dump [ruby] [bug]
  式展開にならない '#'がエスケープされないようになりました。 
  ((<ruby-core:03922>))
    $ ruby1.8.1 -e "puts '# #{}'.dump"
    "\# \#{}"

    $ ruby1.8.2 -e "puts '# #{}'.dump"
    "# \#{}"

=== 2004-12-08
: rss/rss [lib] [obsolete]
  #item=/#set_item and so on are obsolete.

=== 2004-12-06 
: Hash#hash [ruby] [new]

  追加

  ((<ruby-talk:122482>))

  Hash#hash は 2004-12-16 に削除されました。
  ((<ruby-dev:25206>))?

: OpenSSL::PKey::RSA.public_encrypt   [lib] [compat]
: OpenSSL::PKey::RSA.public_decrypt   [lib] [compat]
: OpenSSL::PKey::RSA.private_encrypt  [lib] [compat]
: OpenSSL::PKey::RSA.private_decrypt  [lib] [compat]

  パディングを指定出来るようになりました。((<ruby-talk:122539>))。PKCS1_PADDING, SSLV23_PADDING, NO_PADDING and PKCS1_OAEP_PADDING under OpenSSL::PKey::RSA.

=== 2004-12-05
: OptionParser::Completion#complete [lib] [compat]
  new parameter to direct case insensitiveness.

: OptionParser#order!               [lib] [change]
  ((<ruby-dev:25048>))

=== 2004-12-04
: NKF.guess [lib] [compat]
  NKF.guess は NKF.guess2 の alias になりました。 従来のものを使いたい場合は
  NKF.guess1 を使って下さい。

=== 2004-11-20
: ext/nkf/nkf-utf8/  [lib] [new]
  utf8 対応 nkf (nkf 2.x) の追加。

: kconv [lib] [new]
: Kconv.guess_old(str)
: Kconv.toutf8(str)
: Kconv.toutf16(str)
: String#toutf8,
: String#toutf16
: String#iseuc
: String#issjis
: String#isutf8

=== 2004-11-18
: StringIO.new   [lib] [compat]
  StringIO.newの第二引数にIO.newと同様、Fixnum も指定できるようになりました。
  ((<ruby-dev:24896>))

=== 2004-11-16
: Test::Unit::AutoRunner.options [lib] [compat]
  add new option --exclude (-x). ((<ruby-dev:24865>))

: CGI::Session.initialize [lib] [compat]
  'sufix' オプションを設定できるようになりました。

=== 2004-11-10
: Array#pack [ruby] [change]
  P 指定子以外では nil を 0 に変換しなくなりました。

    $ ruby-1.8.1 -e 'p [nil].pack("L")'
    "\000\000\000\000"
    
    $ ruby-1.8.2 -e 'p [nil].pack("L")'
    -e:1:in `pack': cannot convert nil into Integer (TypeError)
        from -e:1
    
    $ ruby-1.8.2 -e 'p [nil].pack("P")'
    "\000\000\000\000"

=== 2004-10-27
: CGI [lib] [bug]
  無限ループに陥る可能性のあるバグを修正しました。
  ((<URL:http://www.debian.org/security/2004/dsa-586>))

=== 2004-10-21
: PStore#transaction  [lib] [compat]
  PStore.new に指定したファイルがまだ存在しない場合に、PStore#transaction(true) を呼
  び出しても例外 Errno::ENOENT が発生しなくなりました。((<ruby-dev:24561>))

=== 2004-10-20

: Proc#dup [new]

  追加 ((<ruby-talk:116915>))

=== 2004-10-19

: ARGF [change]

  コマンドライン引数に与えたファイルを読んだ後には標準入力を読まなくなりました。
  ((<ruby-dev:24452>))

: IO#gets [ruby] [bug]
  "\377" を引数に受け取っても適切に振舞うようになりました。((<ruby-dev:24460>))

: Dir.glob [change]
  ブロックを渡したとき、false ではなく nil を返すようになりました。また、readdir しながらブロックを呼ぶのではなく、全部を配列に貯めてから each するようになりました。((<ruby-dev:24528>))

=== 2004-10-18

: WEBrick::HTTPRequest [lib] [new]
  new methods. accept, accept_charset, accept_encoding, accept_language, 
  content_length and content_type.

: WEBrick::HTTPResponse#content_length= [lib] [new]
: WEBrick::HTTPResponse#content_type= [lib] [new]
: WEBrick::HTTPUtils.parse_qvalues [lib] [new]
: WEBrick::HTTPServer#virtual_host [lib] [new]
: WEBrick::HTTPServer#lookup_server [lib] [new]
: WEBrick::HTTPServlet::FileHandler#get_servlet [lib] [new]

=== 2004-09-03
: Struct.new  [ruby] [bug]
  同じ名前で二度定義したときのバグを修正しました。((<ruby-dev:24210>))

=== 2004-08-24
: CGI::Session::FileStore#initialize [lib] [bug]
  セッションを保存するファイル名にセッション ID が使われるバグを修正しました。

=== 2004-08-23
: OpenSSL::SSL#pending [lib] [new]

=== 2004-08-14
: FileUtils.copy_entry [lib] [new]
: FileUtils::DryRun [lib] [new]
  追加。
: FileUtils.mv [lib] [compat]
  mv が :force オプションを受け付けるようになりました。

=== 2004-08-07
: Zlib::GzipReader#read(0) [lib] [compat]
  Zlib::GzipReader#read(0) が nil ではなく "" を返すようになりました。

=== 2004-07-28
: CGI::CGI_PARAMS [lib] [obsolete]
: CGI::CGI_COOKIES [lib] [obsolete]
  常に警告がでるようになりました。

=== 2004-07-23
: Net::IMAP#disconnected? [lib] [new]

: CGI::Session::FileStore#update [lib] [compat]
  セッションを保存するファイルの mode をデフォルトで 0600 に
  セットするようになりました。

=== 2004-07-16

: ((<SystemExit#success?|SystemExit/success?>)) [ruby] [new]

  追加。((<ruby-dev:23912>))

: File::Stat#dev_major [ruby] [new]
: File::Stat#dev_minor [ruby] [new]
  ((<ruby-core:03195>))

=== 2004-07-05

: Kernel#URI    [lib] [new]

  uri で追加。((<ruby-dev:23784>))

=== 2004-07-01
: OpenSSL::Cipher::Cipher#pkcs5_keyivgen  [lib] [new]
: OpenSSL::Cipher::Cipher#key_len=        [lib] [new]
  new methods.

: OpenSSL::PKey::DH                       [lib] [new]
: OpenSSL::PKey::DSA                      [lib] [new]
  many new methods. p, p=, g, g=, pub_key, pub_key=, priv_key, priv_key=.

=== 2004-07-01
: PStore [lib] [change]
  データベースの更新が成功したらバックアップファイルを残さず削除するようになりました。
  ファイル名に "~" が付いたバックアップファイルは残されません。((<ruby-list:39102>))

=== 2004-06-29

: misc
  $SAFEが保存されない問題を修正しました。((<ruby-dev:23829>))

=== 2004-06-23
: net/imap [lib] [new]
  added new option --ssl

=== 2004-06-16

: object.c     [ruby] [bug]
  特異クラスが特異オブジェクトのクラスを継承していると見なされて
  いるバグを修正しました。((<ruby-dev:23690>))

    $ ruby1.8.1 -e 'class X;end; x=X.new; class << x;p self < X; end' 
    true

    $ ruby1.8.2 -e 'class X;end; x=X.new; class << x;p self < X; end' 
    nil

=== 2004-06-04

: IO#gets, $_ [ruby] [change]
  gets の返り値が nil でも、$_ に nil がセットされるようになりました。
  ((<ruby-dev:23663>))

=== 2004-05-27

: CSV.parse  [lib] [change]
  引数としてファイル名を受け付けなくなりました。
  文字列が渡されると、それをパースすべき文字列だと解釈します。

    CSV.parse("1,2\n3,r") #=> [['1', '2'], ['3', 'r']]
  
: CSV::Row   [lib] [obsolete]
: CSV::Cell  [lib] [obsolete]
  CSV::Row と CSV::Cell が deprecated になりました。

: CSV.open, CSV.parse, and CSV,generate 
  必要ならばユーザが binmode をセットしなければならなくなりました。

: CSV.read      [lib] [new]
: CSV.readlines [lib] [new]
  追加。

: Marshal.dump [ruby] [bug]
  特異メソッドを定義されていないオブジェクトを dump できない場合があったのを
  修正しました。 ((<ruby-dev:22631>))

: Marshal.dump [ruby] [bug]
  特異クラス内のクラスを dump するとエラーになるようになりました。
  ((<ruby-dev:22588>))

=== 2004-05-16

: DBM.open              [lib] [compat]
: DBM::READER           [lib] [new]
: DBM::WRITER           [lib] [new]
: DBM::WRCREAT          [lib] [new]
: DBM::NEWDB            [lib] [new]

  DBM.open に第3引数を追加し、DBM::READER,
  DBM::WRITER, DBM::WRCREAT, DBM::NEWDB を指定できるようになりました。  
  ((<ruby-dev:23520>))

=== 2004-05-13

: Net::Telnet#login    [lib] [compat]
  "options" でログインプロンプトとパスワードプロンプトのための正規表現を
  指定できるようになりました。

: String#unpack [ruby] [change]
  Z* が最初の null までしかマッチしないようになりました。((<ruby-talk:98281>))

    $ ruby1.8.1 -e 'p "abc\000def\000".unpack("Z*Z*")' 
    ["abc\000def", ""]

    $ ruby1.8.2 -e 'p "abc\000def\000".unpack("Z*Z*")' 
    ["abc", "def"]

=== 2004-05-10
: superclass mismatch [ruby] [change]
  親クラスの違う同じ名前のクラスを再定義した時  TypeError を投げるようになりました。
  ((<ruby-list:39567>))

    $ ruby-1.8.2 -e '
    class Foo
      Bar = 1
    end
    
    class Foo < String
      Baz = 2
    end
    '
    -e:6: superclass mismatch for class Foo (TypeError)

=== 2004-04-19

: Hash#==   [change]
: Hash#eql? [new]

  Hash#== は内容が一致していれば真に、Hash#eql? は、さらに 
  ハッシュのデフォルト値が同じ(==)なら真になるよう定義されました。

        h1 = Hash.new("a")
        h2 = Hash.new("a")
        h3 = Hash.new("b")

        p h1 == h2
        p h1.eql?(h2)

        p h1 == h3
        p h1.eql?(h3)

        # => ruby 1.8.1 (2003-12-25) [i586-linux]
             true
             false
             false
             false
        # => ruby 1.8.2 (2004-07-17) [i586-linux]
             true
             true
             true
             false
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             true
             true
             true
             false

  ((<ruby-talk:97559>))

  Hash#eql? は 2004-12-16 に削除されました。
  ((<ruby-dev:25206>))?

=== 2004-04-16
: String#== [lib] [change]
  nil を返さず、常に false か true を返すようになりました。((<ruby-dev:23404>))

    $ ruby1.8.1 -e 'p "a" == :a'
    nil

    $ ruby1.8.2 -e 'p "a" == :a'
    false

=== 2004-04-15

: GDBM::READER          [lib] [new]
: GDBM::WRITER          [lib] [new]
: GDBM::WRCREAT         [lib] [new]
: GDBM::NEWDB           [lib] [new]

  GDBM に read only などで access できるようになりました。((<ruby-dev:23381>))

: Process::Status#success? [ruby][new]
  ((<ruby-dev:23385>))

=== 2004-04-11

: ruby.c    [ruby] [bug]

  オプション --with-static-linked-ext 付きでコンパイルした時の、
  -r オプションのエラーメッセージを修正。((<ruby-dev:23357>))

=== 2004-03-8
: WEBrick::Config::HTTP [lib] [change]
  オプション :RequestHander は :RequestCallback に名前が変わりました。
  オプション :ServerAlias が追加されました。

=== 2004-02-24
: OpenSSL::Config#each [lib] [new]

: Dir.glob [ruby] [change]
  File::FNM_DOTMATCH がセットされない限り Dir.glob('test/**/') は 'test/.test/' などに
  マッチしなくなりました。((<ruby-dev:23014>))

=== 2004-02-20
: irb [lib] [new]
  -I オプションが使えるようになりました。((<ruby-list:39243>))

=== 2004-02-18
: StringScanner#peep [lib] [obsolete]
  $VERVOSE が設定されている時に警告がでるようになりました。use #peek.
: StringScanner#empty? [lib] [obsolete]
  $VERVOSE が設定されている時に警告がでるようになりました。use #eos?.
: StringScanner#clear [lib] [obsolete] 
  $VERVOSE が設定されている時に警告がでるようになりました。use #terminate.
: StringScanner#getbyte [lib] [obsolete] 
  $VERVOSE が設定されている時に警告がでるようになりました。use #get_byte.
: StringScanner#restsize [lib] [obsolete]
  $VERVOSE が設定されている時に警告がでるようになりました。use #rest_size.
: StringScanner#matchedsize [lib] [obsolete]
  $VERVOSE が設定されている時に警告がでるようになりました。use #matched_size.
: ScanError  [lib] [obsolete]
  use StringScanner::Error.

=== 2004-02-10

: ((<String#~|String/~>))  [obsolete]
: ((<String#=~|String/=~>)) [obsolete]

  String#~ は削除されました。また、str =~ str を実行すると例外
  が発生するようになりました。
  ((<ruby 1.8 feature/2003-07-19>)), ((<ruby 1.8 feature/2003-05-26>))、
  ((<ruby-dev:22851>))

=== 2004-02-09
: File.fnmatch  [ruby] [bug]
  適切にマッチしないバグを修正しました。
  ((<ruby-dev:22815>)) ((<ruby-dev:22819>))

=== 2004-02-06
: PrettyPrint#first? [lib] [obsolete]

=== 2004-02-05
: PrettyPrint#seplist [lib] [new]

=== 2004-01-29
: OpenSSL::X509::Name#add_entry [lib] [new]

=== 2004-01-26
: Regexp.new [ruby] [obsolete]

  「{,m}」表記の場合と「{n,m}」の n,m が数字でない場合に警告を出力するようになりました。((<ruby-dev:22626>))

  文字「}」がエスケープされていない場合に警告を出力するようになりました。 ((<ruby-dev:22627>))

=== 2004-01-08
: OpenSSL::PKey::DH#to_der [lib] [new]
: OpenSSL::PKey::DSA#to_der [lib] [new]
: OpenSSL::PKey::RSA#to_der [lib] [new]


=== 2003-12-31
: ARGF.each_byte [ruby] [compat]
  nil ではなく ARGF を返すようになりました。((<ruby-dev:22465>))

=== 2003-12-27
: ruby -i.bak [ruby] [compat]
  inplace edit mode で標準入力から読み込んだ時常に警告を
  出力するようになりました。

=== 2003-12-26
: ARGF.read(nil)
  引数に nil を許すようになりました。((<ruby-dev:22433>))
