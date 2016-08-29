= NEWS for Ruby 2.2.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.1.0 以降の変更

=== 言語仕様の変更

  * nil/true/false
    * nil/true/false はフリーズされました [[feature:8923]]

  * Hash リテラル
    * 後ろにコロンのあるシンボルをキーにしたときそれをクオートできるようになりました [[feature:4276]]

  * デフォルト引数
    * オプショナル引数にデフォルト値のセマンティクスでアクセスできないという長年のバグを修正しました。 [[bug:9593]]

=== 組み込みクラスの更新

  * [[c:Binding]]
    * 追加: [[m:Binding#local_variables]]
    * 追加: [[m:Binding#receiver]]

  * [[c:Dir]]
    * 追加: [[m:Dir#fileno]]

  * [[c:Enumerable]]
    * 追加: [[m:Enumerable#slice_after]]
    * 追加: [[m:Enumerable#slice_when]]
    * 拡張: [[m:Enumerable#min]], [[m:Enumerable#min_by]], [[m:Enumerable#max]], [[m:Enumerable#max_by]]
      は複数の値を返すためのオプションをサポートしました


  * [[c:Float]]
    * 追加: [[m:Float#next_float]]
    * 追加: [[m:Float#prev_float]]

  * [[c:File]]
    * 追加: [[m:File.birthtime]]
    * 追加: [[m:File#birthtime]]

  * [[c:File::Stat]]
    * 追加: [[m:File::Stat#birthtime]]

  * [[c:GC]]
    * [[m:GC.latest_gc_info]] は現在のGCのステータスを再現するために :state を返すようになりました。
    * 改善: メジャーGCにインクリメンタルマーキングを導入しました。 [[feature:10137]]

  * [[c:IO]]
    * 改善: Windows上でパイプのための [[m:IO#read_nonblock]], [[m:IO#write_nonblock]] をサポートしました。

  * [[c:Kernel]]
    * 追加: [[m:Kernel#itself]]
    * 改善: [[m:Kernel#throw]] は、対応する catch ブロックがないとき [[c:ArgumentError]] ではなく
      [[c:ArgumentError]] のサブクラスである [[c:UncaughtThrowError]] を発生させるようになりました


  * [[c:Process]]
    * 拡張: [[m:Process.spawn]] のような外部プロセスを起動するメソッドは [:out, :err] からリダイレクト
      されたファイルを書き込みモードで開くようになりました

  * [[c:String]]
    * 追加: [[m:String#unicode_normalize]]
    * 追加: [[m:String#unicode_normalize!]]
    * 追加: [[m:String#unicode_normalized?]]

  * [[c:Symbol]]
    * 改善: [[m:String#to_sym]], [[m:String#intern]] によって返される多くのシンボルがGC可能になりました

  * [[c:Method]]
    * New methods:
      * 追加: [[m:Method#curry]]([arity]) はカリー化された [[c:Proc]] オブジェクトを返します
      * 追加: [[m:Method#super_method]] はスーパクラスの同名のメソッドの [[c:Method]] オブジェクトを返します。

=== 組み込みクラスの互換性 (機能追加とバグ修正を除く)

  * [[c:Enumerable]]
    * [[m:Enumerable#slice_before]] の状態管理は非推奨になりました
    * [[m:Enumerable#chunk]] の状態管理は非推奨になりました

  * [[c:GC]]
    * 非互換: [[m:GC.stat]] のエントリーの名前を変更しました [[feature:9924]]
      [[url:https://docs.google.com/spreadsheets/d/11Ua4uBr6o0k-nORrZLEIIUkHJ9JRzRR0NyZfrhEEnc8/edit?usp=sharing]]

  * [[c:Hash]]
    * 非互換: 重複するキーの上書きに関するポリシーを変更しました [[bug:10315]]
      { **hash1, **hash2 } は重複するキーについては hash2 の値を持ちます

  * [[c:IO]]
    * 非互換: [[m:IO#flush]] を使ったとき、ファイルのメタデータが即時更新されることを仮定できなくなりました。
      いくつかのプラットフォーム(特にWindows)で、メタデータの更新はファイルシステムの負荷が下がるまで遅延されます。
      メタデータが更新されることを保証したい場合は [[m:IO#fsync]] を使ってください。

  * [[c:Math]]
    * 非互換: [[m:Math.#log]] は 基底が 0 より小さいとき NaN を返すかわりに [[c:Math::DomainError]] を発生させます。
      2つの引数に両方とも 0 が指定された場合、負の無限大ではなく NaN を返します。
    * 非互換: [[m:Math.#atan2]] は2の引数の両方に無限大が指定されたとき C99 で期待されるような値を返します。

  * [[c:Proc]]
    * 非互換: [[c:ArgumentError]] は発生しなくなりました。
    * ArgumentError is no longer raised when lambda Proc is passed as a
      block, and the number of yielded arguments does not match the formal
      arguments of the lambda, if just an array is yielded and its length
      matches.

  * [[c:Process]]
    * [[m:Process.spawn]] のようなプロセスを起動するようなメソッドは [:out, :err]
      からリダイレクトされるファイルを書き込みモードで開きます。Ruby 2.2以前は読み込みモードで開いていました。

=== 標準添付ライブラリの更新 (優れたもののみ)

  * [[lib:continuation]]
    * callcc は廃止されました。[[c:Fiber]]を使ってください。

  * [[lib:digest]]
    * [[m:Kernel#Digest]] はスレッドセーフになりました。
      マルチスレッド環境でオンデマンドローディングに関して問題がある場合は、
      "digest/*" を事前にロードしておくか、Daigest::* なクラス参照するかわりにをこのメソッドを呼び出します。
    * 以前通知した通り [[c:Digest::HMAC]] を削除しました。

  * DL
    * DL は標準添付ライブラリから削除されました。[[lib:fiddle]] を使ってください。

  * [[lib:etc]]
    * 追加: [[m:Etc.uname]]
    * 追加: [[m:Etc.sysconf]]
    * 追加: [[m:Etc.confstr]]
    * 追加: [[m:IO#pathconf]]
    * 追加: [[m:Etc.nprocessors]]

  * [[lib:find]], [[lib:pathname]]
    * 拡張: [[m:Find.#find]] は "ignore_error" というキーワード引数を受け付けるようになりました

  * Matrix
    * New methods:
    * 追加: [[m:Matrix#first_minor]]
    * 追加: [[m:Matrix#cofactor]]
    * 追加: [[m:Matrix#adjugate]]
    * 追加: [[m:Matrix#hstack]], [[m:Matrix#vstack]]
    * 追加: [[m:Matrix#laplace_expansion]]
    * 追加: [[m:Vector.basis]]
    * 追加: [[m:Vector#-@]], [[m:Vector#+@]], [[m:Matrix#-@]], [[m:Matrix#+@]]
    * 追加: [[m:Vector#cross_product]]
    * 追加: [[m:Vector#dot]]
    * 追加: [[m:Vector#angle_with]]
    * 追加: [[m:Vector.independent?]], [[m:Vector#independent?]]

  * [[lib:pathname]]
    * [[m:Pathname#/]] は [[m:Pathname#+]] のエイリアスです
    * 追加: [[m:Pathname#birthtime]]

  * [[lib:rake]]
    * Rake 10.4.0 になりました。
      [[url:http://docs.seattlerb.org/rake/History_rdoc.html#label-10.4.0]]

  * [[lib:rubygems]]
    * RubyGems 2.4.2 になりました。リリースノートの全てはリンク先を参照してください。
      [[url:http://docs.seattlerb.org/rubygems/History_txt.html#label-2.4.2+%2F+2014-10-01]]

  * [[lib:tsort]]
    * [[m:TSort.tsort_each]], [[m:TSort.each_strongly_connected_component]],
      [[m:TSort.each_strongly_connected_component_from]] はブロックを省略すると [[c:Enumerator]] を返すようになりました。

  * [[lib:xmlrpc]]
    * LibXMLStreamParser という新しいパーサーを追加しました

=== 標準添付ライブラリの互換性 (機能追加とバグ修正を除く)

  * [[lib:mathn]]
    * 非推奨の警告を表示するようになりました [[feature:10169]]

  * ext/date/lib/date/format.rb
    * 空だったので削除されました

  * [[lib:digest]]
    * Digest::HMAC は削除されました。[[c:OpenSSL::HMAC]] や外部のgemを使ってください。

  * [[lib:time]]
    * [[m:Time.parse]], [[m:Time.strptime]], [[m:Time.rfc2822]], [[m:Time.xmlschema]] may produce
      fixed-offset Time objects.
      It is happen when usual localtime doesn't preserve the offset from UTC.
    * [[m:Time.httpdate]] は常にUTCのTimeオブジェクトを生成します。
    * [[m:Time.strptime]] は引数が日付や時刻の情報を含まない場合、[[c:ArgumentError]]を発生させます。

  * lib/rational.rb
    * 2009年から非推奨だったので削除しました。

  * lib/complex.rb
    * 2009年から非推奨だったので削除しました。

  * [[lib:prettyprint]]
    * PrettyPrint#first? は削除しました。

  * lib/minitest/*.rb
    * mintest 5 と衝突するので削除しました。[[feature:9711]]

  * lib/test/**/*.rb
    * minitest 5 と衝突するので削除しました。minitest 4 の単なるラッパーだった。[[feature:9711]]

  * [[lib:uri]]
    * [[RFC:3986]] をサポートしました。 [[feature:2542]]

  * GServer
    * gserver という gem に切り出しました。メンテナンスしていないコードでした。

  * Logger
    * Logger::Application は logger-application という gem に切り出しました。メンテナンスしていないコードでした。

  * ObjectSpace (after requiring "objspace")
    * [[m:ObjectSpace.#memsize_of]](obj) は sizeof(RVALUE) を含むようになりました。
      [[bug:8984]]

  * [[lib:prime]]
    * 非互換:
      * [[m:Prime.prime?]] は負の数に対して false を返します。
        このメソッドは数が合成数かどうか知るために使うべきではありません。 [[bug:7395]]

  * [[lib:psych]]
    * Psych::EngineManager を削除しました [[bug:8344]]

=== 組込みのグローバル変数の互換性に影響のある変更

なし

=== C API の更新

  * 非推奨のAPIを削除しました  [[feature:9502]]
    * Check_SafeStr -> SafeStringValue
    * rb_check_safe_str -> SafeStringValue
    * rb_quad_pack -> rb_integer_pack
    * rb_quad_unpack -> rb_integer_unpack
    * rb_read_check : access struct FILE internal. no replacement.
    * rb_struct_iv_get : internal function. no replacement.
    * struct rb_blocking_region_buffer : internal type. no replacement.
    * rb_thread_blocking_region_begin -> rb_thread_call_without_gvl family
    * rb_thread_blocking_region_end -> rb_thread_call_without_gvl family
    * TRAP_BEG -> rb_thread_call_without_gvl family
    * TRAP_END -> rb_thread_call_without_gvl family
    * rb_thread_select -> rb_thread_fd_select
    * struct rb_exec_arg : internal type. no replacement.
    * rb_exec : internal function. no replacement.
    * rb_exec_arg_addopt : internal function. no replacement.
    * rb_exec_arg_fixup : internal function. no replacement.
    * rb_exec_arg_init : internal function. no replacement.
    * rb_exec_err : internal function. no replacement.
    * rb_fork : internal function. no replacement.
    * rb_fork_err : internal function. no replacement.
    * rb_proc_exec_n : internal function. no replacement.
    * rb_run_exec_options : internal function. no replacement.
    * rb_run_exec_options_err : internal function. no replacement.
    * rb_thread_blocking_region -> rb_thread_call_without_gvl family
    * rb_thread_polling -> rb_thread_wait_for
    * rb_big2str0 : internal function. no replacement.
    * rb_big2ulong_pack -> rb_integer_pack
    * rb_gc_set_params : internal function. no replacement.
    * rb_io_mode_flags -> rb_io_modestr_fmode
    * rb_io_modenum_flags -> rb_io_oflags_fmode

  * struct RBignum は隠されました [[feature:6083]]
    かわりに rb_integer_pack と rb_integer_unpack を使います

  * struct RRational は隠されました  [[feature:9513]]
    かわりに rb_rational_num と rb_rational_den を使います

  * rb_big_new と rb_big_resize は long のかわりに size_t を受け取ります

  * rb_num2long は SIGNED_VALUE のかわりに long を返します

  * rb_num2ulong は VALUE のかわりに unsigned long を返します

  * st hash table は速度のために2のべき乗のサイズを使います。[[feature:9425]].
    適切はハッシュ関数を使うと探索は10-25%速くなります。
    しかしながら、ハッシュ分散の弱点はもはや素数サイズのテーブルにマスクされていない可能性があります。
    なので、拡張ライブラリは良い分散を確保するためにハッシュ関数を微調整する必要があるかもしれません。

  * rb_sym2str() を追加しました。`rb_id2str(SYM2ID(sym))` と大体同じですが、動的なシンボルを作成しません。

  * rb_str_cat_cstr() を追加しました。`rb_str_cat2()` と同じです。

  * 将来的に `rb_str_substr()` と `rb_str_subseq()` は文字列の真ん中を共有しますが、
    文字列の末尾だけは共有しません。結局、処理された文字列はNULL終端されない可能性があるので、
    NULL終端されたCの文字列を入手したいときは`StringValueCStr()`を呼ぶ必要があります。

  * rb_tracepoint_new() はCからアクセス可能な新しい内部的なイベントをサポートしました。r47528
    * RUBY_INTERNAL_EVENT_GC_ENTER
    * RUBY_INTERNAL_EVENT_GC_EXIT

  * rb_hash_delete() は与えられたブロックを評価しなくなりました。

  * rb_extract_keywords() と rb_get_kwargs() はエクスポートされました。詳細は README.EXT を参照してください。

=== ビルドシステムの更新

  * ./configure のオプション --with-jemalloc を追加しました。
    jemalloc はシステムの malloc が遅かったり、フラグメンテーションする傾向にある場合に適切かもしれません。[[feature:9113]]

=== 実装の変更

  * GC
    * [[m:String#to_sym]] や [[m:String#intern]] によって返されるほとんどのシンボルはGC可能になりました。[[feature:9634]]
    * メジャーGCにインクリメンタルマーキングを導入しました。[[feature:10137]]
    * malloc によって起きた GC で lazy sweep を有効にしました。

  * VM
      * [[m:Hash#[] ]] と [[m:Hash#[]=]] で変更不可能な文字列リテラルを使用するようにしました。
      * キーワード引数が速くなりました [[feature:10440]]
      * 巨大なスプラットされた配列を rest 引数として受け取れるようになりました[[feature:10440]]

  * Process
      * spawn() のようなプロセスを生成するメソッドは [[man:vfork(2)]] システムコールを使うようになりました。
        親プロセスがメモリを多く使用しているとき [[man:vfork(2)]] は [[man:fork(2)]] より速い。
