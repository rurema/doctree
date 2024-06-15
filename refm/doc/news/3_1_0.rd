#@since 3.1
= NEWS for Ruby 3.1.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストはリンク先を参照してください。

== 言語仕様の変更

  * ブロックが他のメソッドに渡されるだけの場合は、ブロックの引数を無名にできるようになりました。 [[feature:11256]]

//emlist{
def foo(&)
  bar(&)
end
//}

  * ピン演算子に式を書けるようになりました。 [[feature:17411]]

//emlist{
Prime.each_cons(2).lazy.find_all{_1 in [n, ^(n + 2)]}.take(3).to_a
#=> [[3, 5], [5, 7], [11, 13]]
//}

  * ピン演算子がインスタンス変数、クラス変数、グローバル変数をサポートしました。 [[feature:17724]]

//emlist{
@n = 5
Prime.each_cons(2).lazy.find{_1 in [n, ^@n]}
#=> [3, 5]
//}

  * 1行パターンマッチが実験的な機能ではなくなりました。

  * 1行パターンマッチが括弧を省略できるようになりました。 [[feature:16182]]

//emlist{
[0, 1] => _, x
{y: 2} => y:
x #=> 1
y #=> 2
//}

  * 多重代入の評価順序が、単一代入の評価順序と一致するようになりました。単一代入では、Rubyは左から右への評価順序を使用します。このコードでは、

#@samplecode
foo[0] = bar
#@end

  * 次の評価順序になります。

//emlist{
  1. `foo`
  2. `bar`
  3. `[]=` called on the result of `foo`
//}

  * Ruby 3.1.0より前は、多重代入の評価順序が上記のようではありませんでした。このコードでは、

#@samplecode
foo[0], bar.baz = a, b
#@end

  * 次の評価順序になります。

//emlist{
  1. `a`
  2. `b`
  3. `foo`
  4. `[]=` called on the result of `foo`
  5. `bar`
  6. `baz=` called on the result of `bar`
//}

  * Ruby 3.1.0から単一代入と評価順序が一致するようになり、左が右より先に評価されます。

//emlist{
  1. `foo`
  2. `bar`
  3. `a`
  4. `b`
  5. `[]=` called on the result of `foo`
  6. `baz=` called on the result of `bar`
//}

  * [[bug:4443]]

  * ハッシュリテラルやキーワード引数の値が省略可能になりました。 [[feature:14579]]

    * {x:, y:} は {x: x, y: y} の糖衣構文です。
    * foo(x:, y:) は foo(x: x, y: y) の糖衣構文です。

  * 定数名、ローカル変数名、メソッド名をキー名に使用することができます。予約語はselfのような疑似変数名であっても、ローカル変数やメソッド名とみなされることに注意してください。

  * クラスやモジュールのインスタンス変数がshareableなオブジェクトを代入している場合、メイン以外のRactorが参照できるようになりました。 [[feature:17592]]

  * 1行のメソッド定義が括弧なしで書けるようになりました。例として def foo = puts "Hello" と記述できるようになりました。 private def foo = puts "Hello" はパースされないことに注意してください。 [[feature:17398]]

== コマンドラインオプション

  * --disable-gems は"デバッグ専用"として明示的に宣言されました。デバッグ専用以外のコードでは使用しないでください。 [[feature:17684]]

== 組み込みクラスの更新(注目すべきもののみ)

  * [[c:Array]]
    * 新規メソッド
      * [[m:Array#intersect?]]が追加されました。 [[feature:15198]]

  * [[c:Class]]
    * 新規メソッド
      * [[m:Class#subclasses]]はレシーバを継承した子クラスを要素に持つ配列(シングルトンクラスを含まない)を返します。

#@samplecode Class#subclasses
class A; end
class B < A; end
class C < B; end
class D < A; end
A.subclasses    #=> [D, B]
B.subclasses    #=> [C]
C.subclasses    #=> []
#@end

  * [[c:Enumerable]]
    * 新規メソッド
      * [[m:Enumerable#compact]]が追加されました。 [[feature:17312]]
      * [[m:Enumerable#tally]]がカウント集計用のハッシュオブジェクトを任意で渡せるようになりました。 [[feature:17744]]
      * [[m:Enumerable#each_cons]]と[[m:Enumerable#each_slice]]がレシーバを返すようになりました。 [[url:https://github.com/ruby/ruby/pull/1509]]

#@samplecode Enumerable#each_cons Enumerable#each_slice
[1, 2, 3].each_cons(2){}
# 3.0 => nil
# 3.1 => [1, 2, 3]

[1, 2, 3].each_slice(2){}
# 3.0 => nil
# 3.1 => [1, 2, 3]
#@end

  * [[c:Enumerator::Lazy]]
    * 新規メソッド
      * [[m:Enumerator::Lazy#compact]] が追加されました。 [[feature:17312]]

  * [[c:File]]
    * 変更されたメソッド
      * [[m:File.dirname]] がパスの階層を取り除く任意の引数を渡せるようになりました。 [[feature:12194]]

  * [[c:GC]]
    * 新規メソッド
      * GC.measure_total_time = true でGCの計測を有効にします。計測によってオーバーヘッドが発生する可能性があります。デフォルトで有効になっています。 GC.measure_total_time は現在の設定を返します。 GC.stat[:time] または GC.stat(:time) は、測定された時間をミリ秒で返します。 [[feature:10917]]
      * GC.total_time が計測された時間をナノ秒で返します。 [[feature:10917]]

  * [[c:Integer]]
    * 新規メソッド
      * [[m:Integer.try_convert]] が追加されました。 [[feature:15211]]

  * [[c:Kernel]]
    * 変更されたメソッド
      * Kernel#load が第2引数にモジュールを渡せるようになり、渡されたモジュールをトップレベルのモジュールとしてファイルを読み込むようになりました。 [[feature:6210]]

  * [[c:Marshal]]
    * 変更されたメソッド
      * Marshal.load が freeze: true オプションを渡せるようになりました。返されるオブジェクトはクラスやモジュールのオブジェクトを除き、すべてfreezeされます。文字列は重複排除されます。 [[feature:18148]]

  * [[c:MatchData]]
    * 新規メソッド
      * MatchData#match が追加されました。 [[feature:18172]]
      * MatchData#match_length が追加されました。 [[feature:18172]]

  * [[c:Method]] / [[c:UnboundMethod]]
    * 新規メソッド
      * [[m:Method#public?]], [[m:Method#private?]], [[m:Method#protected?]], [[m:UnboundMethod#public?]], [[m:UnboundMethod#private?]], [[m:UnboundMethod#protected?]] が追加されました。 [[feature:11689]]

  * [[c:Module]]
    * 変更されたメソッド
      * [[m:Module#prepend]] はレシーバが既に引数をincludeしている場合、継承ツリーを変更するようになりました。レシーバが既に引数をprependしている場合、継承ツリーを変更しません。 [[bug:17423]]
      * [[m:Module#private]], [[m:Module#public]], [[m:Module#protected]], [[m:Module#module_function]]が引数を返すようになりました。引数が1つでも渡されている場合、それが返されます。引数なしの場合、nilが返されます。複数の引数を渡した場合、それらを要素に持つ配列が返されます。 [[feature:12495]]

  * [[c:Process]]
    * 新規メソッド
      * Process._forkが追加されました。これは [[man:fork(2)]] のコアメソッドです。このメソッドを直接呼び出さないでください。既存のforkメソッド([[m:Kernel.#fork]]、[[m:Process.fork]]、IO.popen("-"))によって呼び出されます。アプリケーションモニタリングライブラリは、このメソッドを上書きしてforkイベントをフックすることができます。 [[feature:17795]]

  * [[c:Struct]]
    * 新規メソッド
      * StructClass#keyword_init? が追加されました。 [[feature:18008]]
    * 変更されたメソッド
      * Struct#initialize はキーワード引数のみを渡すと警告されるようになりました。ハッシュを最初のメンバにするには、ハッシュリテラルを使用する必要があります。 [[feature:16806]]

  * [[c:String]]
    * Unicodeと絵文字のバージョンが13.0.0に更新されました。 [[feature:17750]] [[feature:18029]]
    * [[m:String#unpack]] と [[m:String#unpack1]] が任意のバイト数をスキップした後にアンパックを開始するための offset: キーワード引数を渡せるようになりました。 offset が文字列の範囲外の場合、 [[c:ArgumentError]] 例外が発生します。 [[feature:18254]]

  * [[c:Thread]]
    * 新規メソッド
      * Thread#native_thread_id が追加されました。 [[feature:17853]]

  * Thread::Backtrace
    * 新規メソッド
      * --backtrace-limit コマンドラインオプションで設定したバックトレースの長さを制限する値を返す Thread::Backtrace.limit が追加されました。 [[feature:17479]]

  * [[c:Thread::Queue]]
    * 変更されたメソッド
      * [[m:Thread::Queue.new]] が、初期値のEnumerableオブジェクトを渡せるようになりました。 [[feature:17327]]

  * [[c:Time]]
    * 変更されたメソッド
      * [[m:Time.new]] は、Time.at や Time.now と同じようにタイムゾーンの in: キーワード引数を任意で渡せるようになりました。これにより Time.new の細かい引数を省略できるようになりました。 [[feature:17485]]

#@samplecode Time.new
Time.new(2021, 12, 25, in: "+07:00")
#=> 2021-12-25 00:00:00 +0700
#@end

      * 同時に、時刻の要素の文字列がより厳密に整数に変換されるようになりました。

#@samplecode Time.new
Time.new(2021, 12, 25, "+07:30")
#=> invalid value for Integer(): "+07:30" (ArgumentError)
#@end

      * Ruby 3.0 以前では、予期しない結果の 2021-12-25 07:00:00 が返されました。 2021-12-25 07:30:00 や 2021-12-25 00:00:00 +07:30 でもありません。

      * [[m:Time#strftime]] がRFC 3339 UTCのunknown offset local timeに対応しました。 -0000 を \%-z としてサポートします。 [[feature:17544]]

  * [[c:TracePoint]]
    * 新規メソッド
      * TracePoint のコールバック中に再入を許す TracePoint.allow_reentry が追加されました。 [[feature:15912]]

  * [[m:$LOAD_PATH]]
    * 変更されたメソッド
      * $LOAD_PATH.resolve_feature_path が失敗時に例外を発生させなくなりました。 [[feature:16043]]

  * Fiber Scheduler
    * 変更されたメソッド
      * [[m:Addrinfo.getaddrinfo]] がaddress_resolveフックをサポートしました。 [[feature:17370]]
      * ブロックなしの Timeout.timeout に timeout_after フックが導入されました。 [[feature:17470]]
      * 新しいSchedulerのフックのio_readとio_writeが導入され、zero-copy read/writeのための低レベルのIO::Bufferが導入されました。 [[feature:18020]]
      * IOフックのio_wait、io_read、io_writeは、可能ならばオリジナルのIOオブジェクトを受け取るようになりました。 [[bug:18003]]
      * MonitorがFiberセーフになりました。 [[bug:17827]]
      * コピーコルーチンをpthread実装に置き換えました。 [[feature:18015]]

  * [[c:Refinement]]
    * [[m:Module#refine]]で作成されたモジュールを表す新しいクラス。includeとprependは非推奨になり、代わりにimport_methodsが追加されました。

== 標準添付ライブラリの更新(機能追加とバグ修正を除く)

  * 以下のdefault gemsが更新されました。
    * RubyGems 3.3.3
    * base64 0.1.1
    * benchmark 0.2.0
    * bigdecimal 3.1.1
    * bundler 2.3.3
    * cgi 0.3.1
    * csv 3.2.2
    * date 3.2.2
    * did_you_mean 1.6.1
    * digest 3.1.0
    * drb 2.1.0
    * erb 2.2.3
    * error_highlight 0.3.0
    * etc 1.3.0
    * fcntl 1.0.1
    * fiddle 1.1.0
    * fileutils 1.6.0
    * find 0.1.1
    * io-console 0.5.10
    * io-wait 0.2.1
    * ipaddr 1.2.3
    * irb 1.4.1
    * json 2.6.1
    * logger 1.5.0
    * net-http 0.2.0
    * net-protocol 0.1.2
    * nkf 0.1.1
    * open-uri 0.2.0
    * openssl 3.0.0
    * optparse 0.2.0
    * ostruct 0.5.2
    * pathname 0.2.0
    * pp 0.3.0
    * prettyprint 0.1.1
    * psych 4.0.3
    * racc 1.6.0
    * rdoc 6.4.0
    * readline 0.0.3
    * readline-ext 0.1.4
    * reline 0.3.0
    * resolv 0.2.1
    * rinda 0.1.1
    * ruby2_keywords 0.0.5
    * securerandom 0.1.1
    * set 1.0.2
    * stringio 3.0.1
    * strscan 3.0.1
    * tempfile 0.1.2
    * time 0.2.0
    * timeout 0.2.0
    * tmpdir 0.1.2
    * un 0.2.0
    * uri 0.11.0
    * yaml 0.2.0
    * zlib 2.1.1
  * 以下のbundled gemsが更新されました。
    * minitest 5.15.0
    * power_assert 2.0.1
    * rake 13.0.6
    * test-unit 3.5.3
    * rexml 3.2.5
    * rbs 2.0.0
    * typeprof 0.21.1
  * 以下のdefault gemsがbundled gemsに変更されました。
    * net-ftp 0.1.3
    * net-imap 0.2.2
    * net-pop 0.1.1
    * net-smtp 0.3.1
    * matrix 0.4.2
    * prime 0.1.2
    * debug 1.4.0
  * 以下が標準添付ライブラリから削除されました。
    * dbm
    * gdbm
    * tracer

  * Coverageの計測が一時停止をサポートされるようになりました。 Coverage.suspendで計測を一時停止し、Coverage.resumeで再開することができます。詳細は [[feature:18176]] を参照してください。
  * Random::Formatterは random/formatter.rb に移動され、SecureRandomを使わずに Random#hex や Random#base64 などが使用できるようになりました。 [[feature:18190]]

== 互換性 (機能追加とバグ修正を除く)

  * rb_io_wait_readable、 rb_io_wait_writable、 rb_wait_for_single_fd は非推奨で、それぞれ rb_io_maybe_wait_readable、 rb_io_maybe_wait_writable、 rb_io_maybe_wait に置き換えられます。 rb_thread_wait_fd と rb_thread_fd_writable は非推奨になりました。 [[bug:18003]]

== 標準添付ライブラリの互換性

  * ERB#initializeが-wオプションなしでもsafe_level以降の引数に警告されるようになりました。 [[feature:14256]]
  * lib/debug.rb が debug.gem に置き換えられました。
  * lib/pp.rb の Kernel#pp がデフォルトで [[m:IO#winsize]] の幅を使用するようになりました。出力幅が端末サイズに応じて自動的に変更されることを意味します。 [[feature:12913]]
  * Psych 4.0では、デフォルトで [[m:Psych.load]] が [[m:Psych.safe_load]] に変更されました。この動作に移行するにはPsych 3.3.2を使用する必要があるかもしれません。 [[bug:17866]]

== C API の更新

  * ドキュメント化されました。 [[url:https://github.com/ruby/ruby/pull/4815]]
  * rb_gc_force_recycleは非推奨で、no-op関数に変更されました。 [[feature:18290]]

== 実装の改善

  * クラス変数の読み込みにインラインキャッシュが導入されました。 [[feature:17763]]
  * instance_eval と instance_exec は、必要な時だけシングルトンクラスを割り当てるようになり、余分なオブジェクトの生成を回避してパフォーマンスを向上させるようになりました。 [[url:https://github.com/ruby/ruby/pull/5146]]
  * [[c:Struct]]のアクセサが高速化されました。 [[url:https://github.com/ruby/ruby/pull/5131]]
  * 組み込みメソッドのパフォーマンス向上のために、特殊な組み込みメソッドの mandatory_only? が追加されました。 [[url:https://github.com/ruby/ruby/pull/5112]]
  * 実験的な機能のガベージコレクタのVariable Width Allocationはデフォルトでオフになっており、USE_RVARGC=1フラグをセットしてRubyをコンパイルすることで有効にできるようになりました。 [[feature:18045]] [[feature:18239]]

== JIT

  * Ruby 3.0の --jit が --mjit にリネームされ、 --jit がWindows以外のx86-64プラットフォームでは --yjit に、その他のプラットフォームでは --mjit に変更されました。

=== MJIT

  * --mjit-max-cache のデフォルト値が100から10000に変更されました。
  * クラスイベントでTracePointが有効になっている場合にJITコンパイルされたコードをキャンセルしなくなりました。
  * JITコンパイラは、1000命令列長より長いメソッドのコンパイルをスキップしなくなりました。
  * --mjit-verbose や --mjit-warning は、TracePoint または GC.compact が使用されており、JITコンパイルされたコードが無効になった時に "JIT cancel" と出力されるようになりました。

=== YJIT

新しいJITコンパイラが実験的な機能として利用可能です。 [[feature:18229]]

詳細はブログ([[url:https://shopify.engineering/yjit-just-in-time-compiler-cruby]])を参照してください。

  * --yjit コマンドラインオプションでYJITを有効(デフォルトは無効)にできるようになりました。
  * 実世界のソフトウェアに基づくベンチマークでrailsbenchで最大22%、liquid-renderで最大39%の性能向上が実現されました。
  * ウォームアップタイムが高速。
  * 現時点では、Unixライクなx86-64プラットフォームに限定されています。

== 静的解析

=== RBS

  * ジェネリクスの型パラメータに制約を与えることができるようになりました。 [[url:https://github.com/ruby/rbs/pull/844]]

//emlist{
# `T` must be compatible with the `_Output` interface.
# `PrettyPrint[String]` is ok, but `PrettyPrint[Integer]` is a type error.
class PrettyPrint[T < _Output]
  interface _Output
    def <<: (String) -> void
  end

  attr_reader output: T

  def initialize: (T output) -> void
end
//}

  * ジェネリックな型エイリアスが定義できるようになりました。 [[url:https://github.com/ruby/rbs/pull/823]]

//emlist{
# Defines a generic type `list`.
type list[T] = [ T, list[T] ]
             | nil

type str_list = list[String]
type int_list = list[Integer]
//}

  * gemsのRBSを管理するためのrbs collectionコマンド([[url:https://github.com/ruby/rbs/blob/cdd6a3a896001e25bd1feda3eab7f470bae935c1/docs/collection.md]])が導入されました。
  * いろいろな組み込みクラスの型定義が追加、更新されました。
  * 多数のバグ修正と性能の改善が含まれています。

詳細はCHANGELOG.md([[url:https://github.com/ruby/rbs/blob/cdd6a3a896001e25bd1feda3eab7f470bae935c1/CHANGELOG.md]])を参照してください。

=== TypeProf

  * 実験的なIDEサポート([[url:https://github.com/ruby/typeprof/blob/ca15c5dae9bd62668463165f8409bd66ce7de223/doc/ide.md]])が実装されました。
  * Ruby 3.0.0以降、多くのバグ修正とパフォーマンス向上がなされています。

== Debugger

  * 新しいデバッガのdebug.gem([[url:https://github.com/ruby/debug]])がbundled gemsに追加されました。高速なデバッガの実装で、リモートデバッグの多数の機能を提供、カラフルなREPL、IDE(VSCode)インテグレーション、など。標準ライブラリの lib/debug.rb は debug.gem で置き換えられました。
  * デバッグ実行の開始・管理用のrdbgコマンドがbin/ディレクトリにインストールされました。

== error_highlight

error_highlightが組み込みgemに導入されました。
バックトレースで詳細なエラー位置を表示します。

#@samplecode 例
title = json[:article][:title]
#@end

jsonがnilの時、

//emlist{
$ ruby test.rb
test.rb:2:in `<main>': undefined method `[]' for nil:NilClass (NoMethodError)

title = json[:article][:title]
            ^^^^^^^^^^
//}

json[:article] が返す時、

//emlist{
$ ruby test.rb
test.rb:2:in `<main>': undefined method `[]' for nil:NilClass (NoMethodError)

title = json[:article][:title]
                      ^^^^^^^^
//}

この機能はデフォルトで有効になっています。
--disable-error_highlight コマンドラインオプションを指定することで無効化できます。
詳細はリポジトリ([[url:https://github.com/ruby/error_highlight]])を参照してください。

== IRBのオートコンプリートとドキュメント表示

IRBにオートコンプリート機能が実装され、コードを入力するだけで補完候補ダイアログが表示されるようになりました。TabやShift+Tabで上下に移動できます。

また、補完候補を選択している時に、ドキュメントがインストールされている場合、補完候補ダイアログの横にドキュメントダイアログが表示され、内容の一部が表示されます。Alt+dを押すことでドキュメント全文を読むことができます。

== その他の変更

  * lib/objspace/trace.rb が追加されました。オブジェクトのアロケーションをトレースするためのツールです。このファイルを読み込むだけで、トレースが即座に開始されます。 Kernel#p だけで、オブジェクトがどこで作られたかを調べることができます。 このファイルを読み込むだけで、パフォーマンスに大きなオーバーヘッドが発生することに注意してください。これはあくまでもデバッグのためのものです。実運用では使用しないでください。 [[feature:17762]]

  * ファイナライザで発生した例外は、$VERBOSEがnilでない限り、STDERRに出力されるようになりました。 [[feature:17798]]

  * ruby -run -e httpd はアクセスされた時にURLを出力するようになりました。 [[feature:17847]]

  * IRB::Color.colorize_code を使ってRubyのコードをカラー化するために ruby -run -e colorize が追加されました。

#@end
