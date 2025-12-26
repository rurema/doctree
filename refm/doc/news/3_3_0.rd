#@since 3.3
= NEWS for Ruby 3.3.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストはリンク先を参照してください。

== コマンドラインオプション

  * 新しい警告カテゴリ performance が導入されました。この警告は詳細表示モードでもデフォルトでは表示されません。 -W:performance または Warning[:performance] = true で表示を切り替えてください。[[feature:19538]]
  * Rubyのクラッシュレポートをファイルまたはサブコマンドにリダイレクトするための新しい環境変数 RUBY_CRASH_REPORT が導入されました。詳細はrubyのmanページのBUG REPORT ENVIRONMENTセクションをご覧ください。[[feature:19790]]

== 組み込みクラスの更新(注目すべきもののみ)

  * [[c:Array]]
    * 変更されたメソッド
      * [[m:Array#pack]]が不明なディレクティブに対してArgumentErrorを発生するようになりました。 [[bug:19150]]

  * [[c:Dir]]
    * 新規メソッド
      * Dir.for_fd Dir.fchdir Dir#chdir が追加されました。 [[feature:19347]]

  * [[c:Encoding]]
    * 削除されたメソッド
      * 非推奨だった Encoding#replicate が削除されました。[[feature:18949]]

  * [[c:Fiber]]
    * 新規メソッド
      * Fiber#kill が導入されました。[[bug:595]]

//emlist{
fiber = Fiber.new do
  while true
    puts "Yielding..."
    Fiber.yield
  end
ensure
  puts "Exiting..."
end

fiber.resume
# Yielding...
fiber.kill
# Exiting...
//}

  * [[c:MatchData]]
    * 変更されたメソッド
      * MatchData#named_captures が symbolize_names キーワード引数を受け取るようになりました。[[feature:19591]]

  * [[c:Module]]
    * 新規メソッド
      * 無名モジュールや無名クラスに仮の名前を与える Module#set_temporary_name が追加されました。[[feature:19521]]

  * ObjectSpace::WeakKeyMap
    * weak reference を持つコレクションを構築するための新しい組み込みクラス ObjectSpace::WeakKeyMap が導入されました。このクラスは通常のハッシュと同様に equality でキーを検索しますが、キーに対する strong reference は保持しません。[[feature:18498]]

  * [[c:ObjectSpace::WeakMap]]
    * 新規メソッド
      * ObjectSpace::WeakMap#delete が導入されました。[[feature:19561]]

  * [[c:Proc]]
    * 変更されたメソッド
      * Proc#dup と Proc#clone が、それぞれ #initialize_dup と #initialize_clone を呼ぶようになりました。[[feature:19362]]

  * [[c:Process]]
    * 新規メソッド
      * [[c:RubyVM]]にアプリケーションの起動が終了したこと及び、アプリケーションの最適化に適したタイミングであることを通知する Process.warmup が追加されました。このメソッドが行う最適化は実装依存であり、将来予告なく変更される可能性があります。[[feature:18885]]

  * [[c:Process::Status]]
    * 変更されたメソッド
      * [[m:Process::Status#&]] と [[m:Process::Status#>>]] が非推奨になりました。[[bug:19868]]

  * [[c:Range]]
    * 新規メソッド
      * beginless rangeに対しても動作する Range#reverse_each が追加されました。[[feature:18515]]
      * Range#reverse_each は endless range に対しては例外を投げます[[feature:18551]]
      * 2つの範囲が重複しているかどうかを確認する Range#overlap? が追加されました。[[feature:19839]]

  * [[c:Refinement]]
    * 変更されたメソッド
      * Refinement#refined_class が #target に名前変更されました。 Refinement#refined_class は非推奨となり、Ruby 3.4 で削除予定です。[[feature:19714]]

  * [[c:Regexp]]
    * Ruby3.2で導入されたReDos対策のメモ化最適化が先読み・後読みやアトミックグループをサポートするようになり、これらの拡張を含む正規表現も入力文字列の長さに対して線形時間で実行できるようになりました。ただし、これらの拡張にはキャプチャを含めることはできず、ネストもできません。[[feature:19725]]

  * [[c:String]]
    * 変更されたメソッド
      * [[m:String#unpack]]が不明なディレクティブに対して例外を投げるようになりました。[[bug:19150]]
      * [[m:String#bytesplice]]がコピー元の文字列のインデックス/長さまたはrangeを引数に取れるようになりました。これによりコピー元の部分範囲を指定できるようになりました。[[feature:19314]]

  * [[c:Thread::Queue]]
    * 変更されたメソッド
      * [[m:Thread::Queue#freeze]]がTypeErrorを発生するようになりました。 [[bug:17146]]

  * [[c:Thread::SizedQueue]]
    * 変更されたメソッド
      * [[m:Thread::SizedQueue#freeze]]がTypeErrorを発生するようになりました。 [[bug:17146]]

  * [[c:Time]]
    * 変更されたメソッド
      * [[m:Time.new]]の文字列引数がより厳格になりました。 [[bug:19293]]

//emlist{
Time.new('2023-12-20')
#  no time information (ArgumentError)
//}

  * [[c:TracePoint]]
    * rescue イベントが追加され、rescue節を開始するときに発火するフックを入れることができるようになりました。rescue イベントはRubyレベルで記述された rescue のみサポートします。 [[bug:19572]]

== 標準添付ライブラリの更新(機能追加とバグ修正を除く)
  * RubyGems と Bundler は将来リリースされる Ruby で bundled gems となる予定の gem が Gemfile または gemspec に存在しない状態で require された際に警告を行う機能が追加されました。この警告は bootsnap gem を使っている場合には 3.3.0 の時点では機能上の制限により出力されません。そのため、環境変数として DISABLE_BOOTSNAP=1 などを設定して、少なくとも1度はアプリケーションを実行することを推奨します。以下のライブラリが警告の対象となります。[[feature:19351]][[feature:19776]][[feature:19843]]
    * abbrev
    * base64
    * bigdecimal
    * csv
    * drb
    * getoptlong
    * mutex_m
    * nkf
    * observer
    * racc
    * resolv-replace
    * rinda
    * syslog

  * クローズされた Socket に対して Socket#recv と Socket#recv_nonblock は空文字列ではなくnilを返すようになり、Socket#recvmsg と Socket#recvmsg_nonblock は空のパケットではなくnilを返すようになりました。[[bug:19012]]

  * [[m:Socket.getaddrinfo]] [[m:Socket.getnameinfo]] [[m:Addrinfo.getaddrinfo]] などの名前解決を中断できるようになりました。 [[feature:19965]]

  * [[m:Random::Formatter#alphanumeric]] がオプションの chars キーワード引数を受け取るようになりました。[[feature:18183]]

  * 以下がdefault gemsに追加されました。
    * prism 0.19.0

  * 以下のdefault gemsが更新されました。
    * RubyGems 3.5.3
    * abbrev 0.1.2
    * base64 0.2.0
    * benchmark 0.3.0
    * bigdecimal 3.1.5
    * bundler 2.5.3
    * cgi 0.4.1
    * csv 3.2.8
    * date 3.3.4
    * delegate 0.3.1
    * drb 2.2.0
    * english 0.8.0
    * erb 4.0.3
    * error_highlight 0.6.0
    * etc 1.4.3
    * fcntl 1.1.0
    * fiddle 1.1.2
    * fileutils 1.7.2
    * find 0.2.0
    * getoptlong 0.2.1
    * io-console 0.7.1
    * io-nonblock 0.3.0
    * io-wait 0.3.1
    * ipaddr 1.2.6
    * irb 1.11.0
    * json 2.7.1
    * logger 1.6.0
    * mutex_m 0.2.0
    * net-http 0.4.0
    * net-protocol 0.2.2
    * nkf 0.1.3
    * observer 0.1.2
    * open-uri 0.4.1
    * open3 0.2.1
    * openssl 3.2.0
    * optparse 0.4.0
    * ostruct 0.6.0
    * pathname 0.3.0
    * pp 0.5.0
    * prettyprint 0.2.0
    * pstore 0.1.3
    * psych 5.1.2
    * rdoc 6.6.2
    * readline 0.0.4
    * reline 0.4.1
    * resolv 0.3.0
    * rinda 0.2.0
    * securerandom 0.3.1
    * set 1.1.0
    * shellwords 0.2.0
    * singleton 0.2.0
    * stringio 3.1.0
    * strscan 3.0.7
    * syntax_suggest 2.0.0
    * syslog 0.1.2
    * tempfile 0.2.1
    * time 0.3.0
    * timeout 0.4.1
    * tmpdir 0.2.0
    * tsort 0.2.0
    * un 0.3.0
    * uri 0.13.0
    * weakref 0.1.3
    * win32ole 1.8.10
    * yaml 0.3.0
    * zlib 3.1.0

  * 以下の gem が defalut gems から budled gems に変更されました。
    * racc 1.7.3

  * 以下の bundled gemsが更新されました。
    * minitest 5.20.0
    * rake 13.1.0
    * test-unit 3.6.1
    * rexml 3.2.6
    * rss 0.3.0
    * net-ftp 0.3.3
    * net-imap 0.4.9
    * net-smtp 0.4.0
    * rbs 3.4.0
    * typeprof 0.21.9
    * debug 1.9.1

default gems と bundled gems の詳細については Logger の GitHub Releases([[url:https://github.com/ruby/logger/releases]]) のような GitHub releases または changelog ファイルを参照してください。

  * Prism
    * default gemとしてPrismパーサーが導入されました。
      * Prismは、Ruby言語のためのポータブルで、エラートレラントで、保守可能な再帰下降パーサです。
    * Prismは本番環境で使用する準備が整っており、積極的にメンテナンスされています。Ripperの代わりに使用することができます。
      * Prismの使用方法については、詳細なドキュメンテーション([[url:https://ruby.github.io/prism/]])があります。
      * Prismは、CRubyに内部的に使用されるCライブラリと、Rubyコードを解析する必要がある任意のツールに使用できるRuby gemの2つのコンポーネントを持っています。
      * Prism APIの注目すべきメソッドには以下のものがあります。
        * Prism.parse(source) は、パース結果オブジェクトの一部としてASTを返します。
        * Prism.parse_comments(source) はコメントを返します。
        * Prism.parse_success?(source) はエラーがない場合にtrueを返します。
    * Prism開発への貢献に興味がある場合は、Prismリポジトリ([[url:https://github.com/ruby/prism]])に直接Pull RequestやIssueを作成することができます。
    * 今後は ruby --parser=prism または RUBYOPT="--parser=prism" を使用してPrismコンパイラを試すことができます。ただし、このフラグはデバッグ用であることに注意してください。

== 互換性に関する変更
  * 以下のファイルオープンメソッドによるサブプロセスの作成/フォークは非推奨です。[[feature:19630]]
    * [[m:Kernel.#open]]
    * [[m:URI.open]]
    * [[m:IO.binread]]
    * [[m:IO.foreach]]
    * [[m:IO.readlines]]
    * [[m:IO.read]]
    * [[m:IO.write]]
  * [[m:Kernel.#lambda]]が非ラムダ式、非リテラルブロックが与えられた場合、Ruby 3.0 以降では deprecated category の警告を発していましたが、ArgumentError を発生させるようになりました。[[feature:19777]]
  * 環境変数 RUBY_GC_HEAP_INIT_SLOTS は非推奨となり削除されました。代わりに RUBY_GC_HEAP_{0,1,2,3,4}_INIT_SLOTS を利用してください。[[feature:19785]]
  * ブロック内での引数なし it の呼び出しは非推奨となりました。 Ruby 3.4から最初のブロック引数を参照するようになります。 [[feature:18980]]
  * NoMethodError が　#inspect を使ってレシーバーの中身を表示せず、クラス名だけ表示するようになりました。[[feature:18285]]
//emlist{
([1] * 100).nonexisting
# undefined method `nonexisting' for an instance of Array (NoMethodError)
//}
  * ブロック内で匿名のメソッド引数を移譲することが禁止になりました。[[feature:19370]]

== 標準添付ライブラリの互換性に関する変更
  * racc が budled gems となりました。
    * bundler 環境で利用する場合は Gemfile に racc を追記する必要があります。
  * ext/readline の削除
    * 今後は Ruby で書かれた GNU Readline の互換ライブラリである reline をすべての環境で標準で利用し、ext/readline は削除されました。以前の ext/readline が必要なユーザーは gem install readline-ext でインストールすることができます。
    * この変更により、Ruby のインストール時に libreadline や libedit などのライブラリのインストールは不要となります。

== C APIの変更
  * rb_postponed_job が更新されました。
    * 以下のAPIが追加されました。
      * rb_postponed_job_preregister()
      * rb_postponed_job_trigger()
    * 以下のAPIが非推奨となりました。
      * rb_postponed_job_register()
      * rb_postponed_job_register_one()
    * 稀に発生するクラッシュに対処するため、postponed job APIが変更されました。2つの新しいAPIを導入し、既存のAPIを非推奨としました。これらの関数のセマンティクスに若干変更が加えられています。rb_postponed_job_register は同じ関数の複数の呼び出しが関数の単一の実行に結合される可能性があるという点で、once バリアントのように動作するようになりました。 [[feature:20057]]
  * 内部スレッドイベントフックAPIの更新
    * rb_internal_thread_event_data_t が対象 Ruby スレッド（VALUE）を保持し、そのデータがコールバック関数（rb_internal_thread_event_callback）に渡されるようになりました。[[url:https://github.com/ruby/ruby/pull/8885]]
    * 内部スレッドイベントフック API から Ruby スレッドローカルデータを操作するために以下の関数が追加されました (Ruby 3.2 以降で導入されていました) 。[[url:https://github.com/ruby/ruby/pull/8936]]
      * rb_internal_thread_specific_key_create()
      * rb_internal_thread_specific_get()
      * rb_internal_thread_specific_set()
    * rb_profile_thread_frames()
      * 特定のスレッドからフレームを取得するために追加されました。[[feature:10602]]
    * rb_data_define()
      * Dataを定義するために追加されました。[[feature:19757]]
    * rb_ext_resolve_symbol()
      * 拡張ライブラリから関数を検索するために追加されました。[[feature:20005]]
  * IO関連アップデート:
    * rb_io_t の詳細は隠され、各メンバに非推奨の属性が追加されます。 [[feature:19057]]
    * rb_io_path(VALUE io)
      * io のパスを取得するために追加されました。
    * rb_io_closed_p(VALUE io)
      * io の開始または終了を取得します。
    * rb_io_mode(VALUE io)
      * io のモードを取得します。
    * rb_io_open_descriptor()
      * ファイルディスクリプタからIOオブジェクトを作成するために追加されました。

== 実装の改善
=== パーサー
  * Bison から Lrama LALRパーサジェネレータ([[url:https://github.com/ruby/lrama]]) に置き換えられました。[[feature:19637]]
    * 興味がある方は、The future vision of Ruby Parser([[url:https://rubykaigi.org/2023/presentations/spikeolaf.html]])の発表をご覧ください。
    * Lramaの内部パーサは、保守性のためにRaccによって生成されたLRパーサに置き換えられました。
  * パラメータ化ルール (?, *, +) がサポートされ、CRubyのparse.yで使用されます。

=== GC / メモリ管理
  * Ruby 3.2 からの大幅なパフォーマンス向上
    * 古い世代のオブジェクトから参照された新しい世代のオブジェクトの世代変更を少し遅延することにより、 major GC の頻度が下がりました。[[feature:19678]]
    * 環境変数 RUBY_GC_HEAP_REMEMBERED_WB_UNPROTECTED_OBJECTS_LIMIT_RATIO が追加され、 WB unprotected object の数に起因する major GC の回数をチューニングできるようになりました。デフォルトは0.01(1%)に設定されています。これにより、 major GC の頻度が下がりました。[[feature:19571]]
    * ライトバリアが [[c:Time]] [[c:Enumerator]] [[c:MatchData]] [[c:Method]] [[c:File::Stat]] [[c:BigDecimal]] など多くのクラスに実装されました。これにより minor GC の収集時間と major GC の収集頻度が削減されました。
    * [[c:Hash]] [[c:Time]] Thread::Backtrace [[c:Thread::Backtrace::Location]] [[c:File::Stat]] [[c:Method]] などほとんどの組み込みクラスで Variable Width Allocation(VBA) が使用されるようになりました。
  * defined?(@ivar) が Object Shapes を使って最適化されるようになりました。

=== YJIT
  * 大幅なパフォーマンスの改善
    * * を使った引数のサポートが改善されました。
    * 仮想マシンのスタック操作のためにレジスタが使われるようになりました。
    * オプション引数を持つ呼び出しで全ての組合せがコンパイルされます。例外ハンドラもコンパイルされます。
    * サポートされていない呼び出し方や分岐の数の多い呼出しでのインタプリタへのフォールバックが行なわれなくなりました。
    * Railsの #blank? や 特別化された #present? [[url:https://github.com/rails/rails/pull/49909]]などの単純なメソッドがインライン化されます。
    * Integer#*、Integer#!=、String#!=、String#getbyte、Kernel#block_given?、Kernel#is_a?、Kernel#instance_of?、および Module#=== が特別に最適化されます。
    * コンパイル速度はRuby 3.2よりわずかに速くなりました。
    * Optcarrotでは、インタプリタよりも3倍以上速くなりました！
  * メモリ使用量の大幅な改善
    * コンパイルされたコードのメタデータは、はるかに少ないメモリを使用します。
    * アプリケーションが4万個以上のISEQを持つ場合、--yjit-call-threshold は自動的に30から120に上げられます。
    * 呼出しの少ないISEQのコンパイルをスキップするために --yjit-cold-threshold が追加されました。
    * Arm64ではよりコンパクトなコードが生成されます。
  * コードGCはデフォルトで無効になりました
    * --yjit-exec-mem-size は新しいコードのコンパイルが停止するハードリミットとして扱われます。
    * これにより、デフォルトではコードGC実行によるパフォーマンスの急激な低下がなくなりました。Pitchfork([[url:https://github.com/shopify/pitchfork]])を使って定期的にforkするサーバーでのコピーオンライトの挙動が改善されました。
    * 必要に応じて --yjit-code-gc でコードGCを有効にすることもできます。
  * RubyVM::YJIT.enable を追加し、実行時にYJITを有効にできるようにしました
    * コマンドライン引数や環境変数を変更せずにYJITを開始できます。Rails 7.2はこの方法を使用して デフォルトでYJITを有効にします。
    * これはまた、アプリケーションの起動が完了した後にのみYJITを有効にするために使用できます。YJITの他のオプションを使用しながら起動時にYJITを無効にしたい場合は、--yjit-disable を使用できます。
  * デフォルトで利用可能なYJITの統計が増えました
    * yjit_alloc_size およびその他いくつかのメタデータ関連の統計がデフォルトで利用可能になりました。
    * --yjit-stats によって生成される ratio_in_yjit 統計は、リリースビルドで利用可能になりました。特別な統計や開発ビルドは、ほとんどの統計にアクセスするためにはもはや必要ありません。
  * プロファイリング機能を追加
    * Linux perfでのプロファイリングを容易にするために --yjit-perf が追加されました。
    * --yjit-trace-exits は、--yjit-trace-exits-sample-rate=N を使用したサンプリングをサポートします。
  * より網羅的なテストと複数のバグ修正

=== MJIT
  * MJIT は削除されました。
    * --disable-jit-support は削除されました。 代わりに--disable-yjit や --disable-rjit の使用を検討してください。

=== RJIT
  * Rubyで書かれたJITコンパイラであるRJITを導入し、MJITを置き換えました。
    * RJITはUnixプラットフォーム上のx86_64アーキテクチャのみをサポートします。
    * MJITとは異なり、実行時にCコンパイラを必要としません。
  * RJITは実験的な目的のためだけに存在します。
    * 本番環境ではYJITを引き続き使用してください。
  * RubyのJITの開発に興味がある場合は、RubyKaigi 2023のk0kubunの発表([[url:https://rubykaigi.org/2023/presentations/k0kubun.html#day3]])をご覧ください。

=== M:Nスレッドスケジューラ
  * M:N スレッドスケジューラが導入されました。[[feature:19842]]
    * M個のRuby スレッドを、N個のネイティブスレッド（OSスレッド）で管理するので、生成管理のコストを抑えることができるようになりました。
  * C拡張ライブラリの互換性に問題が生じる可能性があるため、メインRactorでのM:Nスレッドスケジューラはデフォルトでは無効にされています。
    * RUBY_MN_THREADS=1 と環境変数を設定することで、メインRactorでM:Nスレッドスケジューラを有効にします。
    * メインRactor以外ではM:Nスレッドスケジューラが常に有効です。
  * RUBY_MAX_CPU=n と環境変数を設定することで、Nの最大数（利用するネイティブスレッドの最大数）を設定できます。デフォルトは8です。
    * 一つの Ractor ではたかだか1つのスレッドしか同時に実行されないので、実際に利用するネイティブスレッド数は、RUBY_MAX_CPUで指定した数か実行中のRactorの数の少ないほうになります。つまり、Ractorの数が1つのアプリケーション（多くのアプリケーション）では1つのネイティブスレッドだけ利用されます。
    * ブロックする処理をサポートするため、N個以上のネイティブスレッドが利用されることがあります。
#@end
