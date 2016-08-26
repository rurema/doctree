= ruby 1.9 feature

ruby version 1.9.0 は開発版です。
以下にあげる機能は将来削除されたり互換性のない仕様変更がなされるかもしれません。
1.9.1 以降は安定版です。
バグ修正がメインになります。

記号について(特に重要なものは大文字(主観))

* カテゴリ
  * [ruby]: ruby インタプリタの変更
  * [api]: 拡張ライブラリ API
  * [lib]: ライブラリ
  * [parser]: 文法の変更
  * [regexp]: 正規表現の機能拡張
  * [marshal]: Marshal ファイルのフォーマット変更
* レベル
  * [bug]: バグ修正
  * [new]: 追加されたクラス／メソッドなど
  * [compat]: 変更されたクラス／メソッドなど(互換性のある変更) (only backward-compatibility) (影響の範囲が小さいと思われる変更もこちら)
  * [change]: 変更されたクラス／メソッドなど(互換性のない変更)
  * [experimental]: 変更の中でも特に実験的なもの(将来再考して欲しいもの？)
  * [obsolete]: 廃止された(される予定の)機能
  * [platform]: 対応プラットフォームの追加

== 1.9.0

=== 2006-09-16

: Struct#inspect

=== 2006-09-14

: digest.rb
: Digest::Base.file

=== 2006-09-13

: Hash#compare_by_identity
: Hash#compare_by_identity?
: Hash#identical
: Hash#identical?

=== 2006-09-12

: Hash#compare_by_identity
: Hash#compare_by_identity?

=== 2006-09-11

: Hash#identical
: Hash#identical?

=== 2006-08-31

: Array#shuffle
: Array#shuffle!

  追加

=== 2006-07-26

: __send
: __send!

  追加

: invoke_method
: invoke_functional_method

  削除

=== 2006-07-21

: Module#attr

  オプショナル引数の assignable がなくなり、attr_reader 相当になりました
  [RCR#331]

=== 2006-06-22

: Module#name

  無名モジュールに対しては nil を返すようになりました
  [ruby-talk:198440]

=== 2006-06-17

: BasicObject#invoke_method
: BasicObject#invoke_functional_method

  追加
  ((<ruby-talk:197512>))

=== 2006-06-13

: IPsocket
: TCPsocket
: SOCKSsocket
: TCPserver
: UDPsocket
: UNIXsocket
: UNIXserver

  削除

=== 2006-06-11

: __callee__ [new]
: __method__ [new]

  ((<URL:http://www.dm4lab.to/~usa/ruby/d/200606a.html#id20060610_P1_7>))

: Symbol#to_proc

=== 2006-06-10

* 新機能
  : BasicObject が導入されました [new]
  : local という visibility および Module#local, Module#local_methods というメソッドが導入されました [new]
#: VIS_MASK が 16
  : ancestors にモジュールが複数回挿入できるようになりました
  : Math#log2 追加 ((<ruby-talk:191237>)) [new]
  : Math#log にオプショナルな第2引数 base 追加 ((<ruby-talk:191308>)) [compat]
  : Array#flatten, Array#flatten! がオプショナルな level 引数を受け取るようになりました [compat]
  : String#unpack("M") で CRLF を単独の LF と同様に無視するようになりました ((<ruby-dev:28601>)) [compat]

* M17N
  : 以下、ここでいう「1文字」は 1byte のことです
  : String#ord という、１文字の文字列に対し、その文字のコードを返すメソッドが追加されました
  : string[integer] が 1文字の String を返すようになりました
  : string.slice(integer) が 1文字の String を返すようになりました
  : ?c が 1文字の String を返すようになりました
  : sprintf の %c が 1文字の String を受け付けるようになりました
  : String#[]= が右辺の整数を受け付けなくなりました
  : String#chr という先頭の１文字を返すメソッドが追加されました
  : IO#getc が 1文字の String を返すようになりました
#: IO#readchar が 1文字の String を返すようになりました
  : IO#ungetc が 1バイトの String を受け付けるになりました
#: ARGF.getc が 1文字の String を返すようになりました

* 多重代入、引数渡し
  : 多重代入や yield の何かが変わりました
  : Proc#yield が導入されました
  : nil.yield が導入されました。no block given (LocalJumpError) という例外を生成します
  : 仮引数で、* の後にも必須引数をとれるようになりました
  : 実引数にいくつでも * を使えるようになりました
  : [] メソッドの実引数で、通常のメソッド呼び出しの実引数に使える記法が全て使えるようになりました

* obsolete 要素、実験要素除去
  : 実験中だった meth -> { ... } という -> が除去されました (lambda のかわりの -> { ... } は残っています)
  : 実験中だった ;; が除去されました
  : いくらか obsolete な構文が除去されました
  : Values はなくなりました

* その他
  : 文字列のハッシュに FNV-1a hash を使用するようになりました
  : Regexp#initialize でリテラルの正規表現を変更できなくなりました
  : $SAFE=4 では Regexp#initialize で taint でない正規表現を変更できなくなりました
  : Dir で $SAFE のセキュリティ検査を行うようになりました
  : メソッド呼出し時のセキュリティ検査の対象がひろがりました
  : メソッドを alias した場合、メソッドの定義時の $SAFE に加えて現在の $SAFE も加味されるようになりました
  : Bignum#pow で結果が大きすぎる場合にはすぐにエラーが出るようになりました ((<ruby-talk:187984>))
  : set_trace_func のバグが修正されました ((<ruby-core:07928>))
  : エラー表示で、true/false/nil が self の場合の表示が変わりました
  : UnboundMethod#bind で生成したものでも Method#inspect でちゃんとなるようになりました ((<ruby-dev:28636>))
  : 丸めエラー修正 ((<ruby-core:07896>))
  : divmod 修正 ((<ruby-dev:28589>))
  : jcode の String#tr_s 修正 ((<ruby-list:42090>))
  : Solaris 対応修正 ((<ruby-dev:28443>)), ((<ruby-dev:28440>))
  : rubygems がある場合には ri で考慮するようになりました
  : スレッド死亡時のエラーメッセージをちゃんと表示するようスレッドスケジューリングが調整されました
  : Socket.gethostbyname 修正 ((<ruby-core:07691>))
  : strtod 精度改善 ((<ruby-dev:28619>)), ((<ruby-core:07796>))
  : 新しい autoconf 対応
  : RUNIT::Assert 独自の定義を RUNIT::AssertMixin に分離し、RUNIT::TestCase では RUNIT::Assert でなく RUNIT::AssertMixin を使うようになりました
  : constification
  : core dump bug fix ((<ruby-dev:28327>)), ((<ruby-dev:28632>)), ((<ruby-core:07833>)), ((<ruby-dev:28614>)), ((<ruby-dev:28585>)), ((<ruby-dev:28582>)), ((<ruby-talk:185438>)), ((<ruby-core:07414>))

((<URL:http://www.atdot.net/~ko1/w3ml/w3ml.cgi/ruby-cvs/msg/16833>))

((<URL:http://eigenclass.org/hiki.rb?Changes+in+Ruby+1.9+update+4>))

=== 2006-05-22

: accept

  ((<ruby-core:7917>))

=== 2006-03-21

: MatchData#[] [compat]

  名前による参照
  ((<ruby-dev:28446>))

=== 2006-03-03

: FileUtils.cp_r [lib] [compat]

  remove_destination オプションの追加
  ((<ruby-dev:28417>))

=== 2006-02-15

: instance_eval

  ((<ruby-core:7365>))

=== 2006-02-03

: Integer#upto  [compat]
: Integer#downto  [compat]
: Integer#doitems  [compat]

  ブロックがなければ enumerator を返す

: Enumerable#group_by   [new]
: Enumerable#first      [new]

  追加

=== 2006-01-26

: ((<BasicSocket/BasicSocket.do_not_reverse_lookup>))  [compat]

  do_not_reverse_lookup のデフォルトが true になりました。

=== 2006-01-10
: ((<GC/GC.stress>))    [new]
: ((<GC/GC.stress=>))   [new]

  GC.stress = true とすると、GC を行えるすべての機会で GC を行います。

=== 2005-12-15

: sub           [obsolete]
: gsub          [obsolete]
: sub!          [obsolete]
: gsub!         [obsolete]
: chop          [obsolete]
: chop!         [obsolete]
: chomp         [obsolete]
: chomp!        [obsolete]
: split         [obsolete]
: scan          [obsolete]

  削除

=== 2005-10-21
: funcall       [new]

  fcall から改名

: Module#instance_exec  [new]
: Module#module_exec    [new]

  追加

=== 2005-09-16
: ((<Dir/Dir.glob>)) [compat]
: ((<Dir/Dir.[]>))   [compat]

  Dir.glob に配列を渡して複数のパターンを指定できるようになりました。
  また、Dir[] は、複数の引数を渡すことで複数のパターンを指定できるよう
  になりました。((<ruby-dev:27110>))

    p Dir.glob(["f*","b*"])  # => ["foo", "bar"]
    p Dir["b*","b*"]  # => ["foo", "bar"]

  以前のバージョンでも、パターンを "\0" で区切ったり、{} パターンを使
  用することで同様のことはできます。

    p Dir.glob("f*\0b*")   # => ["foo", "bar"]
    p Dir.glob("{f*,b*}")  # => ["foo", "bar"]

=== 2005-09-05
: fcall [new]

  追加

=== 2005-08-30
: Object#send, Object#__send__ [ruby][change]
  レシーバを指定した呼び出しではprivateメソッドを呼び出せなくなりました。

=== 2005-06-09
: ENV.[]= [change]

  ENV[key] = nil で要素を削除する機能は失われ、TypeError になるようになりました。

  ((<ruby-list:40865>))

=== 2005-06-08
: Array#nitems [compat]

  Array#nitems にブロックを渡せるようになり、ブロックが真になる要素の個数を返すように
  なりました。

    [1,2,3].nitems{|i| i % 2 != 0} #=> 2

  ((<ruby-talk:134083>))

=== 2005-06-02
: proc [ruby][parser][experimental]

  以前のローカル変数に括弧を付けると call が呼び出される変更は取り消されて、
  (({(expr)(args...)})) で (({expr.call(args...)})) が呼ばれるようになりました。
  この機能は実験的なものです。

    x = proc {|a| p a}
    (x)(7) # => 7

=== 2005-05-08

: Hash#hash [obsolete]
: Hash#eql? [obsolete]

  削除

  ((<ruby-dev:26132>))

=== 2005-04-02

: ENV.key [new]
: ENV.index [obsolete]

  ((<ruby-dev:25974>))

=== 2005-03-09

: Ruby 2.0 ブロックローカル変数

  ((<URL:http://www.rubyist.net/~matz/20050309.html#p03>))

=== 2005-03-04

: Time.strptime  [lib][new]
: ParseDate.strptime  [lib][new]

  time ライブラリ, parsedate ライブラリに追加  ((<ruby-talk:132815>))

=== 2005-03-04

1.9.0 からメソッドと括弧の間にスペースを入れると常に警告がでるようになっていましたが、
その警告はデバッグモード・冗長モードでしかでなくなりました。

   % ruby -e 'p ("")' 
   ""
   % ruby -de 'p ("")'
   -e:1: warning: (...) interpreted as grouped expression
   ""

=== 2005-03-02
: proc [ruby][experimental]

  {|a| ...} や (do ... end) が proc として解釈されるようになりました。この機能は
  実験的なものです。((<ruby-dev:25780>))

    x = {|a| p a}
    x.call(4) # => 4
    x = (do |a| p a end)
    x.call(9) # => 9

=== 2005-02-04

: RSS Parser/Maker [lib] [new]

  ((<Imageモジュール|URL:http://web.resource.org/rss/1.0/modules/image/>))のサポート

=== 2005-02-03

: RSS::Element#convert(value) [lib] [new]
   valueのエンコーディングを変換するメソッドを公開。
   
   valueのエンコーディングは要素の内部エンコーディングからoutput_encoding=で設定したエンコーディングへ変換されます。

=== 2005-02-02
: ((<ripper/Ripper.slice>)) [ruby] [experimental]
  追加。((<URL:http://i.loveruby.net/d/20050201.html#p02>))

=== 2005-01-15

: RSS::VERSION [lib]

  0.1.2 -> 0.1.3

: RSS::Parser [lib] [bug]

  継承するとエラーになるバグを修正。 ((<ruby-talk:126104>))

=== 2005-01-01

: ARGF.readpartial [new]

  追加 ((<ruby-dev:25381>))

: FileUtils.copy_stream(src, dst) [lib] [compat]

  src として ARGF も受け付けるようになりました。
  ((<ruby-dev:25369>))

=== 2004-12-26

: Net::IMAP::PlainAuthenticator [lib] [new]

=== 2004-12-14

: FileUtils.chown [lib] [new]
: FileUtils.chown_R [lib] [new]

=== 2004-12-07

: IO#read [change]

  read(0) は常に "" を返すようになりました。
  また、nonblocking mode でも動作が変わらなくなりました。
  ((<ruby-dev:25101>))

: Hash#hash [new]

  追加 ((<ruby-talk:122482>))

=== 2004-12-03
: method(:y).to_proc.call{ p :ok }
  Method#to_proc で作った ((<Proc>)) オブジェクトからメソッド y へと
  ブロックが引き渡されるようになりました。((<ruby-dev:25031>))

=== 2004-11-14

: Process.getrlimit(resource) [new]
: Process.setrlimit(resource, cur_limit, max_limit) [new]
: Process::RLIM_INFINITY
: Process::RLIM_SAVED_MAX
: Process::RLIM_SAVED_CUR
: Process::RLIMIT_CORE
: Process::RLIMIT_CPU
: Process::RLIMIT_DATA
: Process::RLIMIT_FSIZE
: Process::RLIMIT_NOFILE
: Process::RLIMIT_STACK
: Process::RLIMIT_AS
: Process::RLIMIT_MEMLOCK
: Process::RLIMIT_NPROC
: Process::RLIMIT_RSS
: Process::RLIMIT_SBSIZE

  追加 ((<ruby-dev:24834>))

  ((<ruby 1.8.5 feature>)): 1.8.5 に backport ((<ruby-dev:28729>))

=== 2004-10-30

: Array#[]= [change]

  a[n,m]=nil は要素の削除ではなくなり、要素の並びを nil に入れ換えるようになりました。
  ((<zw-kdoo(2004-10-24)|URL:http://yowaken.dip.jp/tdiary/20041024.html#c02>))

=== 2004-10-20

: Proc#dup [new]

  追加 ((<ruby-talk:116915>))

: require [change]

  feature が $" に追加されるタイミングが load された後に変わりました。
  ((<ruby-list:40085>))

=== 2004-10-05

: Array#index {|x| ... } [new]
: Array#rindex {|x| ... } [new]

  追加 ((<ruby-talk:113069>))

=== 2004-09-26

: Time#to_time [lib][new]
: Time#to_date [lib][new]
: Time#to_datetime [lib][new]
: Date#to_time [lib][new]
: Date#to_date [lib][new]
: Date#to_datetime [lib][new]
: DateTime#to_time [lib][new]
: DateTime#to_date [lib][new]
: DateTime#to_datetime [lib][new]

  追加 ((<ruby-dev:24250>))

=== 2004-09-22

: KeyError [new]
: Hash#key [new]
: Hash#index [obsolete]

  ((<ruby-talk:113279>))
  ((<URL:http://www.rubyist.net/~matz/20040922.html#p01>))

=== 2004-09-20

: Zlib::GzipReader#readpartial(maxlen[, outbuf])  [lib][new]

  追加 ((<ruby-dev:24070>))

=== 2004-09-13

: ripper [new]

  追加 ((<ruby-dev:24255>))

=== 2004-08-27

: StringIO#readpartial(maxlen[, outbuf])  [lib][new]

  追加。((<ruby-dev:24061>))

=== 2004-08-19

: Binding#eval(expr[, fname[, lineno=1]])       [new]

  追加。((<RCR#251>))

: String#clear  [new]

  追加。((<ruby-dev:24104>))

=== 2004-08-17

: Process.daemon(nochdir=nil,noclose=nil)       [new]

  追加。((<ruby-dev:24030>))

=== 2004-08-12

: IO#readpartial(maxlen[, outbuf])     [new]

  追加。((<ruby-dev:22945>)), ((<ruby-dev:23247>)), ((<ruby-dev:24055>))

=== 2004-07-17

: Regexp#match(str, [pos])      [compat]
: String#match(re, [pos])       [compat]

  省略可能な第二引数 pos が追加されました。マッチの開始位置を指定しま
  す。((<ruby-core:03203>)), ((<ruby-core:03205>))

        p(/(.)/.match("foobar", 4).captures)
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             ["a"]

  マッチ位置は文字列の先頭から数えられます。

        p(/(.)/.match("foobar", 4).offset(0))
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             [4, 5]

=== 2004-07-16

: File::Stat#dev_major [new]
: File::Stat#dev_minor [new]

  追加。((<ruby-core:03195>))

=== 2004-07-14

: Enumerable#max_by     [new]
: Enumerable#min_by     [new]

  ブロックの結果を大小比較し、その最大値、最小値を示す要素を返します。

        p [1,2,3,4,5].max_by {|v| -v}
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             1

        p [1,2,3,4,5].min_by {|v| -v}
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             5

=== 2004-05-25
: allow passing a block to a Proc [ruby] [change]
  ((<ruby-dev:23533>)) ((-よくわからない-))

=== 2004-05-14

: Time [marshal]

  Marshal.dump により、タイムゾーンの情報を保持するようになりました。

=== 2004-04-15

: Dir.glob [bug]
  三重以上入れ子になった { } が動くようになりました。
  ((<ruby-dev:23376>))

       p Dir.glob('{{{ruby}}}')
       #=> ruby 1.8.2 (2004-12-24) [i386-mswin32]
           []
       #=> ruby 1.9.0 (2004-04-25) [i386-mswin32]
           ["ruby"]

: Dir.glob [bug]
  { } の中で '{' や '}' や ',' をエスケープできるようになりました。
  ((<ruby-dev:23376>))

       p Dir.glob('{\,}')
       #=> ruby 1.8.2 (2004-12-24) [i386-mswin32]
           []
       #=> ruby 1.9.0 (2004-04-25) [i386-mswin32]
           [","]

       p Dir.glob('{\{}')
       #=> ruby 1.8.2 (2004-12-24) [i386-mswin32]
           []
       #=> ruby 1.9.0 (2004-04-25) [i386-mswin32]
           ["{"]

=== 2004-04-08
: Iconv.list [lib] [compat]
  ((<ruby-dev:23063>))

=== 2004-04-06
: Kernel#open [ruby] [change]
  可能なら最初の引数に対して to_open を呼ぶようになりました。

: Exception#to_str [ruby] [obsolete]

=== 2004-03-31
: Array#pack [ruby] [change]
  pack("U") 時に、ユニコードとして不適切な値が来ているときは
  RangeError を投げるようになりました。
  ((<ruby-dev:23281>))

=== 2004-03-24
: Module#class_variable_get [ruby] [new]

=== 2004-03-19
: {sym: val} [ruby] [new]
  {:sym => val} を {sym: val} のように書くことができるようになりました。

=== 2004-03-12

: File.fnmatch [change]
  File::FNM_PATHNAME がセットされている場合、**/ が */ の繰り返しとして働くようになりました。
  ((<ruby-dev:22901>))

: File.fnmatch, Dir.glob [change]
  Windows, DJGPP, EMX でも '\' をパスセパレータとして解釈せず、常にエスケープ文字として解釈するようになりました。
  ((<ruby-dev:22974>)) ((<ruby-list:39337>))

: WEBrick::Config::General [lib] [new]
  オプション :DoNotReverseLookup 追加。

=== 2004-03-10

: ((<組み込み変数/$-W>))        [ruby] [new]
  追加

=== 2004-03-07
: Net::HTTPHeader#add_header [lib] [new]
: Net::HTTPHeader#get_fields [lib] [new]
: Net::HTTPHeader#content_length= [lib] [new]
: Net::HTTPHeader#content_type [lib] [new]
: Net::HTTPHeader#main_type [lib] [new]
: Net::HTTPHeader#sub_type [lib] [new]
: Net::HTTPHeader#type_params [lib] [new]
: Net::HTTPHeader#content_type= [lib] [new]
: Net::HTTPHeader#set_content_type [lib] [new]

: Net::HTTPRequest#body(=)        [lib] [new]
: Net::HTTPRequest#body_stream(=) [lib] [new]

=== 2004-03-05
: net/http [lib] [new]
  support WebDAV methods, PROPPATCH, LOCK, UNLOCK, OPTIONS, PROPFIND, 
  DELETE, MOVE, COPY, MKCOL.

: Net::HTTPResponse#response [lib] [obsolete]
: Net::HTTPResponse#header [lib] [obsolete]
: Net::HTTPResponse#read_header [lib] [obsolete]

=== 2004-02-16

: Iconv.list [lib] [new]

: ((<IO/IO.popen>))             [compat]

  ((<組み込み関数/system>)) 等と同様、第一引数に配列でコマンドを指定し
  た場合にシェルを経由せずに子プロセスを実行できるようになりました。
  ((<ruby-dev:22877>))

: ((<組み込み関数/spawn>))       [new]
: ((<Process/Process.spawn>))    [new]

  追加。((<ruby-dev:22877>))

: ((<組み込み関数/system>))     [change]

  コマンドを実行できないときに例外が発生するようになりました。

        p system("hogehoge")

        # => ruby 1.8.2 (2004-07-17) [i586-linux]
             false
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             -:1:in `system': No such file or directory - hogehoge (Errno::ENOENT)
                from -:1

        p system("/tmp")

        # => ruby 1.8.2 (2004-07-17) [i586-linux]
             false
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             -:1:in `system': Permission denied - /tmp (Errno::EACCES)
                from -:1

  シェルを経由する場合は、これまでどおりです。

        p system("hogehoge ''")
        # => ruby 1.9.0 (2004-07-17) [i586-linux]
             sh: line 1: hogehoge: command not found
             false

=== 2004-02-06
: BasicSocket#do_not_reverse_lookup [new]
: BasicSocket#do_not_reverse_lookup= [new]

  個々のソケットごとに逆引きの設定ができるようになりました。
  ((<ruby-core:2346>))

=== 2004-01-29
: File.fnmatch [ruby] [change]
  Windows（のNT系列？）で File::FNM_CASEFOLD が指定された場合、全角英文字の大文字・小文字も区別しなくなりました。

: Dir.glob [ruby] [change]
  Windows, DJGPP, EMX では、常に大文字・小文字を区別しなくなりました。また、File::FNM_CASEFOLD は指定できなくなりました。
  ((<ruby-dev:22761>))

=== 2004-01-23
: Array#pack [ruby] [compat]
  U 以外のサイズのある整数指定子に大きな数を与えた場合 RangeError を
  投げなくなりました。((<ruby-dev:22654>))

    $ ruby -e 'p [2**32].pack("i")'    
    "\000\000\000\000"
    
    $ ruby -e 'p [2**32].pack("U")'
    -e:1:in `pack': bignum too big to convert into `long' (RangeError)
           from -e:1

=== 2004-01-22

: ((<組み込み定数/VERSION>))    [obsolete]
: ((<組み込み定数/RELEASE_DATE>))    [obsolete]
: ((<組み込み定数/PLATFORM>))   [obsolete]

  削除されました。((<ruby-dev:22643>))

=== 2004-01-17
: NameError [ruby] 
  ((<ruby-dev:22604>))

=== 2004-01-14
: SystemStackError [ruby] [change]
  SystemStackError が StandardError ではなく Exception の直下になりました。
  ((<ruby-talk:89782>))

=== 2004-01-13
: Pathname#world_readable?  [lib] [new]
: Pathname#world_writable?  [lib] [new]

: File::Stat#world_readable? [ruby] [new]
: File::Stat#world_writable? [ruby] [new]

=== 2004-01-12
: File.world_readable?  [ruby] [new]
: File.world_writable?  [ruby] [new]

=== 2004-01-10
: Dir#inspect [ruby] [new]

  パスを含む "#<Dir:path>" というような文字列を返します。

  ((<ruby-dev:22562>))

=== 2004-01-06 
: Logger#msg2str [lib] [change]
  to_str を使わなくなりました。

=== 2004-01-05
: Dir.glob [ruby] [change]
  Windowsで **/ がリパースポイントを辿らなくなりました。（シンボリックリンクと同じ扱い）
  ((<ruby-dev:22486>))

=== 2004-01-02
: File.fnmatch, Dir.glob [ruby] [change]
  Windows, DJGPP, EMX でマルチバイト文字に対応しました。
  ((<ruby-dev:22476>))

      p File.fnmatch('?', 'あ')
      #=> ruby 1.8.2 (2004-12-24) [i386-mswin32]
          false
      #=> ruby 1.9.0 (2004-04-25) [i386-mswin32]
          true

      p File.fnmatch('?T', 'サ')
      #=> ruby 1.8.2 (2004-12-24) [i386-mswin32]
          true
      #=> ruby 1.9.0 (2004-04-25) [i386-mswin32]
          false

== 参考

* ((<Changes in Ruby 1.9|URL:http://eigenclass.org/hiki.rb?Changes+in+Ruby+1.9>))

