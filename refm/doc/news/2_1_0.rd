#@since 2.1.0
= NEWS for Ruby 2.1.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.0.0 以降の変更

=== 言語仕様の変更

  * キーワード引数のデフォルト値が省略可能になりました。これらの「必須キーワード引数」は呼び出し時に明示的に与えなければなりません。

  * 整数や小数のリテラルの末尾に'r','i','ri'という接尾辞を付けられるようになりました
//emlist{
    # r を付けると有理数になる
    42r  # => Rational(42, 1)
    3.14 # => 3.14.rationalize
    6.022e+23r # 指数形式と一緒には使えない

    # i を付けると複素数の虚部になる
    42i  # => Complex(0, 42)
    3.14i # => Complex(0, 3.14)

    # ri を付けると複素数の虚部が有理数になる
    42ri   # => Complex(0, 42r)
    3.14ri # => Complex(0, 3.14r)
//}

  * def によるメソッド定義式は nil の代わりにメソッド名をシンボルで返します

=== 組み込みクラスの更新

  * [[c:Array]]
    * 追加: [[m:Array#to_h]] キーと値のペアの配列をハッシュに変換します。

  * [[c:Binding]]
    * 追加: [[m:Binding#local_variable_get]]
    * 追加: [[m:Binding#local_variable_set]]
    * 追加: [[m:Binding#local_variable_defined?]]

  * [[c:Enumerable]]
    * 追加: [[m:Enumerable#to_h]] キーと値のペアのリストをハッシュに変換します。

  * [[c:Exception]]
    * 追加: [[m:Exception#cause]] 一つ前の例外を新しい例外を返します。
      例外を rescue して raise しなおしたときに元の例外が一つ前の例外としてセットされています。

  * [[c:GC]]
    * 改良: RGenGC として知られている世代別GCが導入しました
    * 追加した環境変数
      * RUBY_GC_HEAP_INIT_SLOTS
      * RUBY_GC_HEAP_FREE_SLOTS
      * RUBY_GC_HEAP_GROWTH_FACTOR
      * RUBY_GC_HEAP_GROWTH_MAX_SLOTS
      * RUBY_GC_MALLOC_LIMIT_MAX
      * RUBY_GC_MALLOC_LIMIT_GROWTH_FACTOR
      * RUBY_GC_OLDMALLOC_LIMIT
      * RUBY_GC_OLDMALLOC_LIMIT_MAX
      * RUBY_GC_OLDMALLOC_LIMIT_GROWTH_FACTOR
    * 廃止した環境変数
      * RUBY_FREE_MIN (RUBY_GC_HEAP_FREE_SLOTS を代わりに使います)
      * RUBY_HEAP_MIN_SLOTS (RUBY_GC_HEAP_INIT_SLOTS を代わりに使います)

  * [[c:Integer]]
    * 追加: [[m:Fixnum#bit_length]]
    * 追加: [[m:Bignum#bit_length]]
    * [[c:Bignum]] の性能向上
      * GMP をいくつかの操作で使えるときは使います。
        乗算、除算、基数変換、GCD

  * [[c:IO]]
    * 拡張: [[m:IO#seek]] SEEK_DATA と SEEK_HOLE を whence としてサポートしました？？
    * 拡張: [[m:IO#seek]] 第2引数としてシンボルを受け付けるようになりました (:CUR, :END, :SET, :DATA, :HOLE)
    * 拡張: [[m:IO#read_nonblock]] シンボルを返すためにキーワード引数 `exception: false` を受け付けるようになりました
    * 拡張: [[m:IO#write_nonblock]] シンボルを返すためにキーワード引数 `exception: false` を受け付けるようになりました

  * [[c:Kernel]]
    * 追加: [[m:Kernel#singleton_method]]

  * [[c:Module]]
    * 追加: [[m:Module#using]], which activates refinements of the specified module only
      in the current class or module definition.
    * 追加: [[m:Module#singleton_class?]] レシーバーが特異クラスであれば true を返します。
      レシーバーが通常のクラスやモジュールであれば false を返します。
    * 拡張: [[m:Module#refine]] はもはや実験的な機能でなくなりました
    * 拡張: [[m:Module#include]] と [[m:Module#prepend]] はパブリックメソッドになりました

  * [[c:Mutex]]
    * [[m:Mutex#owned?]] はもはや実験的な機能ではありません。

  * [[c:Numeric]]
    * 拡張: [[m:Numeric#step]] limit が省略可能になり無限数列を作れるようになりました。
      キーワード引数の to と by を使いやすさのために導入しました。
      by に 0 を指定すると無限に同じ数値を生成することができます。

  * [[c:Process]]
    * 追加: [[m:Process.#argv0]] オリジナルの $0 の値を返します。
    * 追加: [[m:Process.#setproctitle]] $0 に影響を与えずにプロセス名をセットできます。
    * 追加: [[m:Process.#clock_gettime]]
    * 追加: [[m:Process.#clock_getres]]

  * [[c:String]]
    * "literal".freeze は同じオブジェクトを返すように最適化されました。
    * 追加: [[m:String#scrub]], [[m:String#scrub!]] 不正なバイト列を検証して修正します。
      古いバージョンのRubyと一緒に使いたいときは string-scrub gem を使います。

  * [[c:Symbol]]
    * 全てのシンボルは freeze されるようになりました

  * pack/unpack (Array/String)
    * プラットフォームが対応していれば Q! と q! は long long 型を表します

  * toplevel
    * main.using はもはや実験的な機能ではありません。
      The method activates refinements in the ancestors of the argument module to
      support refinement inheritance by [[m:Module#include]]

=== 組み込みクラスの互換性 (機能追加とバグ修正を除く)

  * [[c:Hash]]
   * 非互換: [[m:Hash#reject]] は将来のバージョンでは単なるハッシュオブジェクトを返すようにする予定です。
     サブクラス、インスタンス変数、デフォルト値、汚染フラグはコピーされなくなります。
     そのようなハッシュに対してこのメソッドを呼び出すと警告するようになりました。

  * [[c:IO]]
    * 非互換: [[m:IO.open]] は外部エンコーディングが ASCII-8BIT のとき内部エンコーディングを無視します。

  * [[m:Kernel.#eval]], [[m:Kernel.#instance_eval]], [[m:Module#module_eval]]
    元の環境のスコープ情報をコピーするようになりました。これは、引数なしの
    private, protected, public, module_function を文字列として eval しても
    その外側には影響を与えないという意味です。
    以下のコードは Foo#foo をプライベートにしません。
//emlist{
    class Foo
      eval "private"
      def foo
      end
    end
//}

  * [[m:Object#untrusted?]],[[m:Object#untrust]],[[m:Object#trust]]
    * これらのメソッドは非推奨になりました。$VERBOSE が true のときは警告を表示します。
      [[m:Object#tainted?]],[[m:Object#taint]],[[m:Object#untaint]] とそれぞれ同じ動作です。

  * [[m:Module#ancestors]]
    * 特異クラスの祖先はそれ自身を含みます。
      The ancestors of a singleton class now include singleton classes,
      in particular itself.

  * [[m:Module#define_method]] [[m:Object#define_singleton_method]]
    * 定義したメソッドの名前をシンボルで返すようになりました。メソッドオブジェクトではありません。

  * [[m:Numeric#quo]]
    * レシーバーが to_r メソッドを持たないとき [[c:ArgumentError]] ではなく [[c:TypeError]] を発生させるようになりました。

  * [[c:Proc]]
    * Returning from lambda proc now always exits from the Proc, not from the
      method where the lambda is created.  Returning from non-lambda proc exits
      from the method, same as the former behavior.

  * [[c:String]]
    * 以下のコードでレシーバーのエンコーディングと変換後のエンコーディングが同一でも
      不正なバイト列を置き換えるようになりました。
//emlist{
    include_invalid_byte_string.encode("UTF-8", invalid: :replace)
//}

=== 標準添付ライブラリの更新 (優れたもののみ)

  * [[lib:cgi/util]]
    * 全てのクラスメソッドをモジュールに移動しました

  * [[lib:digest]]
    * 拡張: [[m:Digest::Class.file]] コンストラクタのためにオプショナル引数を取れるようになりました

  * [[lib:matrix]]
    * 追加: [[m:Vector#cross_product]]

  * [[lib:net/smtp]]
    * 追加: [[m:Net::SMTP#rset]] RSET コマンドに対応している

  * [[lib:objspace]]
    * 追加: [[m:ObjectSpace.trace_object_allocations]]
    * 追加: [[m:ObjectSpace.trace_object_allocations_start]]
    * 追加: [[m:ObjectSpace.trace_object_allocations_stop]]
    * 追加: [[m:ObjectSpace.trace_object_allocations_clear]]
    * 追加: [[m:ObjectSpace.allocation_sourcefile]]
    * 追加: [[m:ObjectSpace.allocation_sourceline]]
    * 追加: [[m:ObjectSpace.allocation_class_path]]
    * 追加: [[m:ObjectSpace.allocation_method_id]]
    * 追加: [[m:ObjectSpace.allocation_generation]]
    * 追加: [[m:ObjectSpace.reachable_objects_from_root]]
    * 追加: [[m:ObjectSpace.dump]]
    * 追加: [[m:ObjectSpace.dump_all]]

  * OpenSSL::BN
    * 拡張: [[m:OpenSSL::BN.new]] Fixnum や Bignum を引数として取れるようになりました。

  * [[lib:open-uri]]
    * 複数フィールドに同じ名前を使うことをサポートしました (Set-Cookieのように)

  * [[c:Pathname]]
    * 追加: [[m:Pathname#write]]
    * 追加: [[m:Pathname#binwrite]]

  * [[lib:rake]]
    * 10.1.0 に更新しました。古い名前空間を削除しました。また、古い rake の機能も削除しました。
      [[url:http://rake.rubyforge.org/doc/release_notes/rake-10_1_0_rdoc.html]]
      [[url:http://rake.rubyforge.org/doc/release_notes/rake-10_0_3_rdoc.html]]

  * [[lib:rbconfig]]
    * 追加: [[m:RbConfig::SIZEOF]] C の型のサイズを提供するために追加しました。

  * [[lib:rdoc]]
    * 4.1.0 に更新。主にデフォルトのテンプレートとアクセシビリティを改善しました。
      [[url:https://github.com/rdoc/rdoc/blob/v4.1.0.preview.1/History.rdoc]]

  * [[lib:resolv]]
    * 追加: [[m:Resolv::DNS.fetch_resource]]
    * One-shot multicast DNS support
    * Support LOC resources

  * [[lib:rexml]]
    * REXML::Parsers::SAX2Parser
      * entitydecl イベントの引数が間違っている問題を修正しました。
        ドキュメントにはエンティティ定義の配列を渡すと書いてあるのに、
        実装は2つ以上の引数を渡すようになっていた。これは実装のバグだったが、
        修正したことで後方互換性が壊れました。
    * REXML::Parsers::StreamParser
      * entityイベントをサポート
    * REXML::Text
      * [[m:REXML::Text#<<]] 'text << "XXX" << "YYY"' のようなメソッドチェインをサポート
      * [[m:REXML::Text#<<]] "raw" でないモードをサポート

  * [[lib:rinda]]
    * [[c:Rinda::RingServer]], [[c:Rinda::RingFinger]]
      * マルチキャストソケットをサポート

  * [[lib:rubygems]]
    * 2.2.0 に更新。  Notable new features include:
      * Gemfile or gem.deps.rb support including Gem.file.lock (experimental)
      * Improved, iterative resolver (compared to RubyGems 2.1 and earlier)
      * Support for a sharing a GEM_HOME across ruby platforms and versions
      * [[lib:https://github.com/rubygems/rubygems/tree/master/History.txt]]

  * [[lib:set]]
    * 追加: [[m:Set#intersect?]]
    * 追加: [[m:Set#disjoint?]]

  * [[lib:socket]]
    * 追加: [[m:Socket.getifaddrs]]

  * [[lib:strscan]]
    * [[m:StringScanner#[] ]] 名前付きキャプチャをサポートしました

  * [[lib:syslog/logger]]
    * ファイリティを追加

  * [[lib:tempfile]]
    * 追加: [[m:Tempfile.create]]

  * [[lib:timeout]]
    * 明示的に例外クラスを指定しない限り、ブロックを抜けるための例外はブロック内部で rescue されなくなりました。

  * [[lib:tsort]]
    * 追加: [[m:TSort#tsort]]
    * 追加: [[m:TSort#tsort_each]]
    * 追加: [[m:TSort#strongly_connected_components]]
    * 追加: [[m:TSort#each_strongly_connected_component]]
    * 追加: [[m:TSort#each_strongly_connected_component_from]]

  * [[lib:webrick]]
    * レスポンスボディは readpartial や read をサポートする StringIO か他の IO のようなオブジェクトになりました。

  * [[lib:xmlrpc]]
    * [[c:XMLRPC::Client]]
      * 追加: [[m:XMLRPC::Client#http]] クライアントのために [[c:Net::HTTP]] のインスタンスを返します。
        通常、それは必要ありません。HTTP クライアントのオプションを少し変更したいときに便利です。
        HTTPクライアントの主要なオプションを変更するときは [[c:XMLRPC::Client]] のメソッドを使うべきです。

=== 標準添付ライブラリの互換性 (機能追加とバグ修正を除く)

  * [[lib:set]]
    * 非互換: [[m:Set#to_set]] はコピーを生成して返す代わりに self を返すようになりました

  * [[lib:uri]]
    * 非互換: [[m:URI.decode_www_form]] は現在の WHATWG による URL 標準に従います。
      文字列エンコーディングを指定するために、エンコーディング引数を取ります。
      いい加減なパーセントエンコードされた文字列を受け入れますが、セパレータにセミコロンは拒否します。
    * 非互換: [[m:URI.decode_www_form]] は現在の WHATWG による URL 標準に従います。
      パーセントエンコードする前に、エンコーディング引数を取ります。
      デフォルトでは、パーセントエンコードする前にUTF-16文字列をUTF-8に変換しません。

  * curses
    * 削除。curses は gem になりました。
      [[url:https://rubygems.org/gems/curses]]

=== 組込みのグローバル変数の互換性に影響のある変更

  * $SAFE
    * $SAFE=4 は廃止されました。$SAFE に4以上の値をセットすると [[c:ArgumentError]] が発生します。

=== C API の更新

  * 非推奨: rb_gc_set_params() Ruby内部でのみ使います。

  * 追加: rb_gc_count() GCが発生した回数を返します。

  * 追加: rb_gc_stat() [[m:GC.stat]] が返す値にオーバーヘッドなしにアクセスできます。

  * 追加: rb_gc_latest_gc_info() [[m:GC.latest_gc_info]] にアクセスできます。

  * 追加: rb_postponed_job_register()  VMが一貫性のある状態になったときに呼ぶコールバック関数を引数に取ります。
    例えば、Cのシグナルハンドラから実行するために使います。

  * 追加: rb_profile_frames() コールスタックのプロファイルのために現在のRubyのスタックに
    低コストでアクセスする機能を提供します。

  * rb_tracepoint_new() C言語からアクセス可能な新しい内部的なイベントをサポートしました:
    * RUBY_INTERNAL_EVENT_NEWOBJ
    * RUBY_INTERNAL_EVENT_FREEOBJ
    * RUBY_INTERNAL_EVENT_GC_START
    * RUBY_INTERNAL_EVENT_GC_END_MARK
    * RUBY_INTERNAL_EVENT_GC_END_SWEEP
    * 内部的なイベントを通常のイベントと同時に使うことはできません。
      (例: RUBY_EVENT_CALL と RUBY_EVENT_RETURN)
#@end
