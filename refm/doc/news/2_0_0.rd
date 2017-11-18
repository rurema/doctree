= NEWS for Ruby 2.0.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 1.9.3 以降の変更

=== 言語仕様の変更

  * キーワード引数を追加しました
  * %i, %I をシンボルの配列作成のために追加しました。(%w, %W に似ています)
  * デフォルトのソースエンコーディングを US-ASCII から UTF-8 に変更しました
  * '_' で始まる使用されていない変数は警告しなくなりました

=== 組み込みクラスの更新

  * [[c:ARGF.class]]
    * 追加: [[m:ARGF.class#codepoints]], [[m:ARGF.class#each_codepoint]]
      [[c:IO]] にある同名のメソッドに対応します

  * [[c:Array]]
    * 追加: [[m:Array#bsearch]] 二分探索します
    * 非互換:
      * [[m:Array#shuffle!]] と [[m:Array#sample]] の random パラメータには最大値のみを指定することが可能になりました
      * [[m:Array#values_at]] に [[c:Range]] オブジェクトを与えた場合、配列の範囲外のインデックスについては nil を返します

  * [[c:Enumerable]]
    * 追加: [[m:Enumerable#lazy]] 遅延列挙のためのメソッドです

  * [[c:Enumerator]]
    * 追加: [[m:Enumerator#size]] サイズを遅延評価するためのメソッドです
    * 拡張: [[m:Enumerator.new]] サイズの遅延評価のための引数を一つ受け取るようになりました
    * 新規クラス: [[c:Enumerator::Lazy]] 遅延列挙用のクラス

  * [[c:ENV]]
    * [[m:ENV.to_h]] は [[m:ENV.to_hash]] へのエイリアスです

  * [[c:Fiber]]
    * 非互換: [[m:Fiber#resume]] は [[m:Fiber#transfer]] を呼び出したファイバーを再開できなくなりました

  * [[c:File]]
    * 拡張: [[m:File.fnmatch?]] は File::FNM_EXTGLOB([[m:File::Constants::FNM_EXTGLOB]]) オプションが与えられていればブレースを展開します
        
  * [[c:GC]]
    * 改良:
      * ビットマップマーキングを導入しました。Copy-on-Write を使用してページをコピーするのでメモリ使用量が減少します
      * 非再帰的なマーキングを導入しました。期待しないスタックオーバーフローを避けるためです

  * [[c:GC::Profiler]]
    * 追加: [[m:GC::Profiler.raw_data]] GCの加工していないプロファイルデータを返します

  * [[c:Hash]]
    * 追加: [[m:Hash#to_h]] 明示的に変換するメソッドです。[[m:Array#to_a]] に似ています
    * 拡張: [[m:Hash#default_proc=]] default proc をクリアするために nil を渡せるようになりました

  * [[c:IO]]
    * 非推奨: IO#lines, #bytes, #chars, #codepoints

  * [[c:Kernel]]
    * 追加: [[m:Kernel.#Hash]] という変換メソッド。[[m:Kernel.#Array]], [[m:Kernel.#Float]] に似ています
    * 追加: [[m:Kernel.#__dir__]] 現在のソースファイル(__FILE__)のあるディレクトリ名を正規化された絶対パ スで返します。
    * 追加: [[m:Kernel.#caller_locations]] フレーム情報の配列を返します
    * 拡張: [[m:Kernel.#warn]] [[m:Kernel.#puts]] のように複数の引数を受け付けるようになりました
    * 拡張: [[m:Kernel.#caller]] 第2引数で取得するスタックのサイズを指定できるようになりました
    * 拡張: [[m:Object#to_enum]] [[m:Object#enum_for]] サイズの遅延評価のためにブロックを受け取るようになりました
    * 非互換: [[m:Kernel.#system]], [[m:Kernel.#exec]] は非標準のファイルディスクリプタを閉じます
      :close_others オプションのデフォルト値を true に変更しました
    * 非互換: respond_to? は protected なメソッドに対して false を返します。第2引数に true を指定すると true を返します。
    * 非互換: [[m:Kernel.#__callee__]] はオリジナルの振舞いに戻りました。定義したときの名前ではなく呼び出したときの名前を返します。
    * 非互換: [[m:Object#inspect]] は #to_s を呼び出さなくなりました。再定義された #to_s を呼び出すためです。

  * [[c:LoadError]]
    * 追加: [[m:LoadError#path]] ロードできなかったファイルのパスを返します

  * [[c:Module]]
    * 追加: [[m:Module#prepend]] 指定したモジュールを self の継承チェインの先頭に
      「追加する」ことで self の定数、メソッド、モジュール変数を「上書き」します。 
    * 追加: [[m:Module.prepended]], [[m:Module.prepend_features]] は [[m:Module.included]] と [[m:Module.append_features]] に似ています
    * 追加(実験的): [[m:Module#refine]], スコープを限定してクラスやモジュールを拡張します。
    * 拡張: [[m:Module#define_method]] は [[c:UnboundMethod]] を受け付けるようになりました
    * 拡張: [[m:Module#const_get]] 修飾された定数名の文字列を受け付けるようになりました。
//emlist{
        Object.const_get("Foo::Bar::Baz")
//}

  * [[c:Mutex]]
    * 追加(実験的): [[m:Mutex#owned?]] mutex が現在のスレッドに所持されているかどうかを返します
    * 非互換: 
      * [[m:Mutex#lock]], [[m:Mutex#unlock]], [[m:Mutex#try_lock]], [[m:Mutex#synchronize]], [[m:Mutex#sleep]]
        はトラップハンドラの中では使えなくなりました。そのようなときは ThreadError が発生します
      * [[m:Mutex#sleep]] may spurious wakeup. Check after wakeup.

  * [[c:NilClass]]
    * 追加: [[m:NilClass#to_h]] 空のハッシュを返します

  * [[c:ObjectSpace::WeakMap]]
    * 弱い参照を保持するための低レベルのクラスです。

  * [[c:Proc]]
    * 非互換: Proc#== と #eql? を削除。

  * [[c:Process]]
    * 追加: [[m:Process#getsid]]  session id を取得します(unix のみ)。

  * [[c:Range]]
    * 追加: [[m:Range#size]] サイズの遅延評価
    * 追加: [[m:Range#bsearch]] 二分探索

  * [[c:RubyVM]] (MRI specific)
    * 追加: [[m:RubyVM::InstructionSequence.of]] to get the instruction sequence
      from a method or a block.
    * 追加: [[m:RubyVM::InstructionSequence#path]],
      [[m:RubyVM::InstructionSequence#absolute_path]],
      [[m:RubyVM::InstructionSequence#label]],
      [[m:RubyVM::InstructionSequence#base_label]],
      [[m:RubyVM::InstructionSequence#first_lineno]] to retrieve information from where
      the instruction sequence was defined.
    * スタックの使用量を指定するための環境変数を追加(起動時にチェックします):
      * RUBY_THREAD_VM_STACK_SIZE: vm stack size used at thread creation.
        default: 128KB (32bit CPU) or 256KB (64bit CPU).
      * RUBY_THREAD_MACHINE_STACK_SIZE: machine stack size used at thread
        creation. default: 512KB or 1024KB.
      * RUBY_FIBER_VM_STACK_SIZE: vm stack size used at fiber creation.
        default: 64KB or 128KB.
      * RUBY_FIBER_MACHINE_STACK_SIZE: machine stack size used at fiber
        creation. default: 256KB or 512KB.
    * 追加: [[m:RubyVM::DEFAULT_PARAMS]] という定数を追加しました。RubyVM のデフォルトのパラメータを返します。

  * [[c:Signal]]
    * 追加: [[m:Signal.signame]] シグナルの名前を返します
   
    * 非互換: [[m:Signal.trap]] は :SEGV, :BUS, :ILL, :FPE, :VTALRM が指定されると [[c:ArgumentError]] を発生させます

  * [[c:String]]
    * 追加: [[m:String#b]] エンコーディングを ASCII-8BIT に設定したコピーされた文字列を返します
    * 返り値変更:
      * [[m:String#lines]] Enumerator ではなく Array を返します
      * [[m:String#chars]] Enumerator ではなく Array を返します
      * [[m:String#codepoints]] Enumerator ではなく Array を返します
      * [[m:String#bytes]] Enumerator ではなく Array を返します

  * [[c:Struct]]
    * 追加: [[m:Struct#to_h]] インスタンス変数の名前と値をハッシュのキーと値にしたハッシュを生成して返します

  * [[c:Thread]]
    * 追加: [[m:Thread#thread_variable_get]] スレッドローカルな変数を取得します
      (these are different than Fiber local variables).
    * 追加: [[m:Thread#thread_variable_set]] スレッドローカルな変数をセットします
    * 追加: [[m:Thread#thread_variables]] スレッドローカルな変数の名前のリストを取得します
    * 追加: [[m:Thread#thread_variable?]] 与えられた名前がスレッドローカルな変数であるかどうか返します
    * 追加: [[m:Thread.handle_interrupt]] as well as instance and singleton methods
      [[m:Thread.pending_interrupt?]] for asynchronous handling of exceptions
    * 追加: [[m:Thread#backtrace_locations]] [[m:Kernel#caller_locations]] に似た情報を返します
    * 新規クラス: [[c:Thread::Backtrace::Location]] to hold backtrace location
      information. These are returned by [[m:Thread#backtrace_locations]] and
      [[m:Kernel#caller_locations]]
    * 非互換: [[m:Thread#join]], [[m:Thread#value]] は対象のスレッドがメインスレッドか現在のスレッドである場合、
      [[c:ThreadError]] を発生させます

  * [[c:Time]]
    * 返り値変更:
      * [[m:Time#to_s]] now returns US-ASCII encoding instead of BINARY.

  * [[c:TracePoint]]
    * new class. This class is replacement of set_trace_func.
      Easy to use and efficient implementation.

  * toplevel
    * added method:
      * added main.define_method which defines a global function.
      * added main.using, which imports refinements into the current file or
        eval string. [experimental]

=== 組み込みクラスの互換性 (機能追加とバグ修正を除く)

  * [[m:Array#values_at]]
    上を参照

  * [[m:String#lines]], [[m:String#chars]], [[m:String#codepoints]], [[m:String#bytes]]
    これらのメソッドはもはや [[c:Enumerator]] を返しませんが、ブロックを与えた場合の動作は後方互換性のためまだサポートしています。
//emlist{
    str.lines.with_index(1) {|line, lineno| ... } # str.lines が配列を返すのでもう動かない
    str.each_line.with_index(1) {|line, lineno| ... } # このように each_line に置き換える
//}

  * [[m:IO#lines]], [[m:IO#chars]], [[m:IO#codepoints]], [[m:IO#bytes]], [[m:ARGF#lines]], [[m:ARGF#chars]],
    [[m:ARGF#bytes]], [[m:StringIO#lines]], [[m:StringIO#chars]], [[m:StringIO#codepoints]], [[m:StringIO#bytes]],
    [[m:Zlib::GzipReader#lines]], [[m:Zlib::GzipReader#bytes]]
    * これらのメソッドは非推奨になりました。each_line, each_byte, each_char, each_codepoint を使ってください。

  * Proc#==, m:Proc#eql?
    * 削除されました。2つの Proc オブジェクトは同じオブジェクトである場合のみ等しい。

  * [[c:Fixnum]], [[c:Bignum]], [[c:Float]]
    * フリーズされました。

  * [[m:Signal.trap]]
    * 上を参照

  * Onigmo をマージしました。
    [[url:https://github.com/k-takata/Onigmo]]

  * The :close_others option is true by default for system() and exec().
    Also, the close-on-exec flag is set by default for all new file descriptors.
    This means file descriptors doesn't inherit to spawned process unless
    explicitly requested such as system(..., fd=>fd).

  * Kernel#respond_to? against a protected method now returns false
    unless the second argument is true.

  * [[m:Object#respond_to_missing?]], [[m:Object#initialize_clone]], [[m:Object#initialize_dup]]
    * private になりました

  * [[m:Thread#join]], [[m:Thread#value]]
    * 上を参照

  * [[m:Mutex#lock]], [[m:Mutex#unlock]], [[m:Mutex#try_lock]], [[m:Mutex#synchronize]], [[m:Mutex#sleep]]
    * 上を参照

=== 標準添付ライブラリの更新 (優れたもののみ)

  * [[lib:cgi]]
    * HTML5 用のタグメーカーを追加しました
    * [[m:CGI#header]] は [[m:CGI#http_header]] に名前を変更しました。[[m:CGI#header]] は別名として残っています。
    * HTML5 用のタグメーカーを呼び出すと [[m:CGI#header]] を header 要素を生成するために上書きします。

  * [[lib:csv]]
    * CSV.dump と CSV.load を削除しました。ユーザーを危険なシリアライゼーションに関する脆弱性から保護するためです。

  * iconv
    * 削除しました。[[m:String#encode]] を使ってください。

  * [[lib:io/console]]
    * 追加: [[m:IO#cooked]] which sets the terminal to cooked mode within the given block.
    * 追加: [[m:IO#cooked!]] which sets the terminal to cooked.
    * 拡張: [[m:IO#raw]], [[m:IO#raw!]], [[m:IO#getch]] キーワード引数 :min, :time を受け付けます。

  * [[lib:io/wait]]
    * 追加: [[m:IO#wait_writable]]
    * 追加: [[m:IO#wait_readable]] は [[m:IO#wait]] の別名です。

  * [[lib:json]]
    * 1.7.7 に更新

  * [[lib:net/http]]
    * 新機能
      * Proxies are now automatically detected from the http_proxy environment
        variable.  See [[m:Net::HTTP.new]] for details.
      * gzip and deflate compression are now requested for all requests by
        default.  See Net::HTTP for details.
      * SSL sessions are now reused across connections for a single instance.
        This speeds up connection by using a previously negotiated session.
      * Requests may be created from a URI which sets the request_uri and host
        header of the request (but does not change the host connected to).
      * Responses contain the URI requested which allows easier implementation of
        redirect following.
    * 追加: [[m:Net::HTTP#local_host]]
    * 追加: [[m:Net::HTTP#local_host=]]
    * 追加: [[m:Net::HTTP#local_port]]
    * 追加: [[m:Net::HTTP#local_port=]]
    * 拡張: [[m:Net::HTTP#connect]] uses local_host and local_port if specified.

  * [[lib:net/imap]]
    * 追加: [[m:Net::IMAP.default_port]]
    * 追加: [[m:Net::IMAP.default_imap_port]]
    * 追加: [[m:Net::IMAP.default_tls_port]]
    * 追加: [[m:Net::IMAP.default_ssl_port]]
    * 追加: [[m:Net::IMAP.default_imaps_port]]

  * [[lib:objspace]]
    * 追加: [[m:ObjectSpace.reachable_objects_from]]

  * [[lib:openssl]]
    * Consistently raise an error when trying to encode nil values. All instances
      of OpenSSL::ASN1::Primitive now raise TypeError when calling to_der on an
      instance whose value is nil. All instances of OpenSSL::ASN1::Constructive
      raise NoMethodError in the same case. Constructing such values is still
      permitted.
    * TLS 1.1 & 1.2 support by setting OpenSSL::SSL::SSLContext#ssl_version to
      :TLSv1_2, :TLSv1_2_server, :TLSv1_2_client or :TLSv1_1, :TLSv1_1_server
      :TLSv1_1_client. The version being effectively used can be queried
      with OpenSSL::SSL#ssl_version. Furthermore, it is also possible to
      blacklist the new TLS versions with OpenSSL::SSL:OP_NO_TLSv1_1 and
      OpenSSL::SSL::OP_NO_TLSv1_2.
    * Added OpenSSL::SSL::SSLContext#renegotiation_cb. A user-defined callback
      may be set which gets called whenever a new handshake is negotiated. This
      also allows to programmatically decline (client) renegotiation attempts.
    * Support for "0/n" splitting of records as BEAST mitigation via
      OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS.
    * The default options for OpenSSL::SSL::SSLContext have changed to
      OpenSSL::SSL::OP_ALL & ~OpenSSL::SSL::OP_DONT_INSERT_EMPTY_FRAGMENTS
      instead of OpenSSL::SSL::OP_ALL only. This enables the countermeasure for
      the BEAST attack by default.
    * OpenSSL requires passwords for decrypting PEM-encoded files to be at least
      four characters long. This led to awkward situations where an export with
      a password with fewer than four characters was possible, but accessing the
      file afterwards failed. OpenSSL::PKey::RSA, OpenSSL::PKey::DSA and
      OpenSSL::PKey::EC therefore now enforce the same check when exporting a
      private key to PEM with a password - it has to be at least four characters
      long.
    * SSL/TLS support for the Next Protocol Negotiation extension. Supported
      with OpenSSL 1.0.1 and higher.
    * OpenSSL::OPENSSL_FIPS allows client applications to detect whether OpenSSL
      is FIPS-enabled. OpenSSL.fips_mode= allows turning on and off FIPS mode
      manually in order to adapt to situations where FIPS mode would be an
      explicit requirement.
    * Authenticated Encryption with Associated Data (AEAD) is supported via
      Cipher#auth_data= and Cipher#auth_tag/Cipher#auth_tag=.
      Currently (OpenSSL 1.0.1c), only GCM mode is supported.

  * [[lib:ostruct]]
    * 追加: [[m:OpenStruct#[] ]], [[m:OpenStruct#[]=]]
    * 追加: [[m:OpenStruct#each_pair]]
    * 追加: [[m:OpenStruct#eql?]]
    * 追加: [[m:OpenStruct#hash]]
    * 追加: [[m:OpenStruct#to_h]]
    * 拡張: [[m:OpenStruct.new]] OpenStruct/Struct のインスタンスを受け付けるようになりました

  * [[lib:pathname]]
    * 拡張: [[m:Pathname#find]] ブロックを与えない場合 Enumerator を返すようになりました

  * [[lib:rake]]
    * 0.9.5 に更新
      * This version is backwards-compatible with previous rake versions and
        contains many bug fixes.
      * See [[url:http://rake.rubyforge.org/doc/release_notes/rake-0_9_5_rdoc.html]]

  * [[lib:rdoc]]
    * 4.0 に更新
      * 後方互換性に関する大きな変更がありました。注目すべき最大の変更は ri データベースのフォーマットを変更したことです。
        (riのデータを再生成する必要があります)
        その他のAPIの変更は内部的なものなので、ほとんどのユーザーに影響はないでしょう。
    * 注目すべき変更
      * riがページをサポートしました。これはGemでも動作します。
//emlist{
  # ruby に含まれるページリストを表示する
  $ ri ruby:
  # リテラルに関する文法を表示する
  $ ri ruby:syntax/literals
  # RSpec の README を表示する
  $ ri rspec:README
//}
    * Markdown をサポートしました。[[c:RDoc::Markdown]] を見てください。
    * [[url:https://github.com/rdoc/rdoc/blob/master/History.rdoc]]

  * [[lib:resolv]]
    * 追加: [[m:Resolv::DNS#timeouts=]]
    * 追加: [[m:Resolv::DNS::Config#timeouts=]]

  * [[lib:rexml]]
    * [[m:REXML::Document#write]] はハッシュ引数をサポートしました
    * [[m:REXML::Document#write]] は :encoding オプションをサポートしました。
      XMLドキュメントのエンコーディングを変更します。:encodingオプションなしの場合、XMLの宣言をXMLドキュメントのエンコーディングとして使います。

  * [[lib:rubygems]]
    * 2.0.0に更新。
      * RubyGems 2.0.0 は以下の改良を含みます。
      * Ruby2.0.0以上で導入した default gems のサポートを改良しました
      * 任意のメタデータを持てるようになりました [[m:Gem::Specification#metadata]]
      * `gem search` はデフォルトでリモートの gem を探すようになりました
      * --document オプションを追加して --rdoc, --ri オプションを置き換えました。
        --no-document オプションを使ってドキュメントの生成を無効化することができます。
        --document=rdoc を使うと rdoc だけを生成できます。
      * デフォルトでは ri フォーマットだけを生成します
      * `gem server` はHTMLを生成するために [[c:RDoc::Servlet]] を使います。
      * [[url:https://github.com/rubygems/rubygems/blob/master/History.txt]]

  * [[lib:shellwords]]
    * [[m:Shellwords#shellescape]] 与えられたオブジェクトを to_s で文字列化するようになりました
    * [[m:Shellwords#shelljoin]] 与えられた配列に含まれる文字列でないオブジェクトは to_s で文字列化するようになりました

  * [[lib:stringio]]
    * 非推奨: [[m:StringIO#lines]], [[m:StringIO#bytes]], [[m:StringIO#chars]], [[m:StringIO#codepoints]]

  * [[lib:syslog]]
    * 追加: [[c:Syslog::Logger]] Syslog上に Logger API を提供します
    * 追加: [[c:Syslog::Priority]], [[c:Syslog::Level]], [[c:Syslog::Option]], [[c:Syslog::Macros]]
      システムで定義されている定数を簡単に検知するために導入しました。

  * [[lib:tmpdir]]
    * 非互換: [[m:Dir.mktmpdir]] は [[m:FileUtils.#remove_entry_secure]] ではなく [[m:FileUtils.#remove_entry]] を使うようになりました。
      これはアプリケーションが作成された一時ディレクトリを全ユーザから書き込み可能に変更すべきではないことを意味します。

  * [[lib:yaml]]
    * Syck は削除しました。インストールされている libyaml に依存するようになりました。
    * libyaml がインストールされていない場合のために libyaml を同梱するようになりました。

  * [[lib:zlib]]
    * [[c:Zlib::Inflate]], [[c:Zlib::Deflate]] にストリーミングサポートを追加しました。
      大量のメモリを消費せずに、ストリームを処理できるようになりました。
    * 展開用に新しい戦略を追加しました。[[c:Zlib::RLE]], [[c:Zlib::FIXED]]
    * Zlib のストリームは GVL なしで処理するようになりました。gzip, zlib, deflate のストリームを並列に処理できるようになりました。
    * 非推奨: [[m:Zlib::GzipReader#lines]], [[m:Zlib::GzipReader#bytes]]

=== 標準添付ライブラリの互換性 (機能追加とバグ修正を除く)

  * [[c:OpenStruct]] の新しいメソッドはカスタム属性の名前を衝突するかもしれません。
    "each_pair", "eql?", "hash" or "to_h".

  * [[m:Dir.mktmpdir]] は lib/tmpdir.rb にあります。上を参照してください。
  
=== C API の更新

  * 追加: NUM2SHORT(), NUM2USHORT()
    これは NUM2INT に似ています。

  * 追加: rb_newobj_of(), NEWOBJ_OF()
    与えられたクラスの新しいオブジェクトを作ります

