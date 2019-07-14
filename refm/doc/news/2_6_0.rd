#@since 2.6.0
= NEWS for Ruby 2.6.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.5.0 以降の変更

=== 言語仕様の変更

* $SAFE はプロセスグローバルで扱われることになると共に、0以外を設定した後に0に戻せるようになりました。 [[feature:14250]]

* Refinements がブロック引数にも反映されるようになりました。  [[feature:14223]]

* Refinements が [[m:Kernel#public_send]] にも反映されるようになりました。  [[feature:15326]]

* Refinements が [[m:Kernel#respond_to?]] にも反映されるようになりました。  [[feature:15327]]

* rescue 節なしの else 節がシンタックスエラーを発生するようになりました。 [実験的] [[feature:14606]]

* 定数名の先頭の文字に ASCII 以外の大文字も使えるようになりました。 [[feature:13770]]

* 終端なし [[c:Range]] が導入されました。 終端なし [[c:Range]] は (0..) や <code>(0...) のように使うことができます。  [[feature:12912]]

  典型的なユースケースは以下の通りです:

      ary[1..]                              # ary[1..-1] と同じ
      (1...).each {|index| block }          # index が 1 から始まる無限ループ
      ary.zip(1..) {|elem, index| block }   # ary.each.with_index(1) { }

* キーワード引数のハッシュに Symbol 以外のキーが含まれると例外が発生するようになりました。

* "shadowing outer local variable" という警告が削除されました。  [[feature:12490]]

  以下のようなコードを警告なしに書くことができます:

      user = users.find {|user| cond(user) }

* 例外が捕捉されず、バックトレースとエラーメッセージが表示されるときに、
  例外の [[m:Exception#cause]] も表示されるようになりました。 [[feature:8257]]

* フリップフロップが非推奨になりました。 [[feature:5400]]

=== 組み込みクラスの更新

* [[c:Array]]

  * 新規メソッド

    * [[m:Array#union]] と [[m:Array#difference]] [[feature:14097]]

  * 変更されたメソッド

    * [[m:Array#to_h]] はブロックを受け取りキーと値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

  * 別名

    * [[m:Array#filter]] が [[m:Array#select]] の別名として追加されました。 [[feature:13784]]
    * [[m:Array#filter!]] が [[m:Array#select!]] の別名として追加されました。 [[feature:13784]]

* [[c:Binding]]

  * 新規メソッド

    * [[m:Binding#source_location]] 追加 [[feature:14230]]


      bindingのソースコード上の位置を __FILE__ と __LINE__ の二要素配列として返します。
      従来でも eval("[__FILE__, __LINE__]", binding) とすることでこれらの情報は得られましたが、
      将来的に [[m:Kernel#eval]] は binding のソースコード行を無視する変更を予定しているため [[bug:4352]]、
      この新しいメソッドを用いることが今後は推奨されます。

* [[c:Dir]]

  * 新規メソッド

    * [[m:Dir#each_child]] と [[m:Dir#children]] 追加 [[feature:13969]]

* [[c:Enumerable]]

  * 新規メソッド

    * [[m:Enumerable#chain]] はレシーバと引数のそれぞれの要素を順番にイテレートする
      [[c:Enumerator::Chain]] オブジェクトを返します。 [[feature:15144]]

  * 変更されたメソッド

    * [[m:Enumerable#to_h]] はブロックを受け取りキーと値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

  * 別名

    * [[m:Enumerable#filter]] が [[m:Enumerable#select]] の別名として追加されました。 [[feature:13784]]

* [[c:Enumerator::ArithmeticSequence]]

  * 等差数列(隣接する項が共通の差(公差)を持つ数列)のジェネレーターを表現する新しいクラスです。
    Python のスライスのようなものを表現するために使えます。
    このクラスのインスタンスは [[m:Numeric#step]] や [[m:Range#step]] で得られます。

* [[c:Enumerator::Chain]]

  * 1個の Enumerator で複数の Enumerable の連鎖を表現する新しいクラスです。
    [[m:Enumerable#chain]] や [[m:Enumerator#+]] で生成されます。

* [[c:Enumerator::Lazy]]

  * 別名

    * [[m:Enumerator::Lazy#filter]] が [[m:Enumerator::Lazy#select]] の別名として追加されました。 [[feature:13784]]

* [[c:Enumerator]]

  * 新規メソッド

    * [[m:Enumerator#+]] はレシーバの要素とオペランドの要素を順番にイテレートする
      Enumerator オブジェクトを返します。 [[feature:15144]]

* [[c:ENV]]

  * 変更されたメソッド

    * [[m:ENV.to_h]] はブロックを受け取り、環境変数名と値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

* [[c:Exception]]

  * 新規オプション

    * [[m:Exception#full_message]] が :highlight と :order を受け付けるようになりました。 [[bug:14324]]

* [[c:Hash]]

  * 変更されたメソッド

    * [[m:Hash#merge]], [[m:Hash#merge!]], [[m:Hash#update]] が引数を複数受け付けるようになりました。 [[feature:15111]]

    * [[m:Hash#to_h]] はブロックを受け取りキーと値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

  * 別名

    * [[m:Hash#filter]] が [[m:Hash#select]] の別名として追加されました。 [[feature:13784]]

    * [[m:Hash#filter!]] が [[m:Hash#select!]] の別名として追加されました。 [[feature:13784]]

* [[c:IO]]

  * 新規オプション

    * 排他的ファイルオープンを表すモード文字 'x' が追加されました。 [[feature:11258]]

* [[c:Kernel]]

  * 別名

    * [[m:Kernel#then]] が [[m:Kernel#yield_self]] の別名として追加されました。 [[feature:14594]]

  * 新規オプション

    * [[m:Kernel.#Complex]], [[m:Kernel.#Float]], [[m:Kernel.#Integer]],
      [[m:Kernel.#Rational]] にエラー処理方法を指定する :exception オプションが
      追加されました。 [[feature:12732]]

    * [[m:Kernel#system]] に失敗時に例外を発生する :exception オプションが
      追加されました。 [[feature:14386]]

  * 非互換な変更

    * [[m:Kernel#system]] と [[m:Kernel#exec]] が非標準にファイルディスクリプタを閉じなくなりました。
      (:close_others オプションのデフォルトが false になりまりました。
      しかし、引き続き Ruby 自体が作成するディスクリプタに FD_CLOEXEC フラグは設定されます。) [[misc:14907]]

* [[c:KeyError]]

  * 新規オプション

    * [[m:KeyError.new]] に :receiver と :key にオプションが追加されて
      Ruby コードからも設定できるようになりました。 [[feature:14313]]

* [[c:Method]]

  * 新規メソッド

    * 関数合成用に [[m:Method#<<]] と [[m:Method#>>]] が追加されました。 [[feature:6284]]

* [[c:Module]]

  * 変更されたメソッド

    * [[m:Module#method_defined?]], [[m:Module#private_method_defined?]],
      [[m:Module#protected_method_defined?]] が省略可能な第2引数を受け取るように
      なりました。 true (デフォルト値) のとき、祖先のモジュールやクラスもチェックします。
      それ以外の場合はそのクラス自身のみチェックします。 [[feature:14944]]

* [[c:NameError]]

  * 新規オプション

    * [[m:NameError.new]] に :receiver オプションが追加されて
      Ruby コードからも設定できるようになりました。 [[feature:14313]]

* [[c:NilClass]]

  * 新規メソッド

    * 互換性のため、[[m:NilClass#=~]] が追加されました。 [[feature:15231]]

* [[c:NoMethodError]]

  * 新規オプション

    * [[m:NoMethodError.new]] に :receiver オプションが追加されて
      Ruby コードからも設定できるようになりました。 [[feature:14313]]

* [[c:Numeric]]

  * 非互換な変更

    * [[m:Numeric#step]] が [[c:Enumerator]] クラスのインスタンスではなく
      [[c:Enumerator::ArithmeticSequence]] クラスのインスタンスを返すようになりました。

* [[c:OpenStruct]]

  * 変更されたメソッド

    * [[m:OpenStruct#to_h]] はブロックを受け取りキーと値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

* [[c:Proc]]

  * 新規メソッド

    * 関数合成用に [[m:Proc#<<]] と [[m:Proc#>>]] が追加されました。 [[feature:6284]]

  * 非互換な変更

    * [[m:Proc#call]] が [[m:$SAFE]] を変更しなくなりました。 [[feature:14250]]

* [[c:Random]]

  * 新規メソッド

    * [[m:Random.bytes]] が追加されました。 [[feature:4938]]

* [[c:Range]]

  * 新規メソッド

    * [[m:Range#%]] が追加されました。 [[feature:14697]]

  * 非互換な変更

    * [[m:Range#===]] が [[m:Range#include?]] メソッドではなく [[m:Range#cover?]] メソッドを使うようになりました。 [[feature:14575]]
    * [[m:Range#cover?]] が [[c:Range]] オブジェクトを受け付けるようになりました。 [[feature:14473]]
    * [[m:Range#step]] が [[c:Enumerator]] クラスのインスタンスではなく
      [[c:Enumerator::ArithmeticSequence]] クラスのインスタンスを返すようになりました。

* [[c:Regexp]]/[[c:String]]

    * Unicode のバージョンを 10.0.0 から 11.0.0 に更新しました。 [[feature:14802]]

      これは書記素クラスタ (/\X/) アルゴリズムの書き換えと [[m:String#downcase]] での
      Georgian MTAVRULI の special-casing を含みます。

    * Update Emoji version from 5.0 to 11.0.0 [[feature:14802]]

* [[c:RubyVM::AbstractSyntaxTree]]

  * 新規メソッド

    * [[m:RubyVM::AbstractSyntaxTree.parse]] は文字列をパースして AST ノードを返します。 [実験的]

    * [[m:RubyVM::AbstractSyntaxTree.parse_file]] はファイルをパースして AST ノードを返します。 [実験的]

    * [[m:RubyVM::AbstractSyntaxTree.of]] は proc やメソッドに対応する AST ノードを返します。 [実験的]

* [[c:RubyVM]]

  * 新規メソッド

    * [[m:RubyVM.resolve_feature_path]] は "require(feature)" で読み込むファイルを
      特定します。 [実験的] [[feature:15230]]

* [[c:String]]

  * [[m:String#crypt]] は非推奨になりました。 [[feature:14915]]

  * 新機能

    * [[m:String#split]] はブロックが渡されていたら部分文字列ごとに呼び出すようになりました。 [[feature:4780]]

* [[c:Struct]]

  * 変更されたメソッド

    * [[m:Struct#to_h]] はブロックを受け取りキーと値のペアを新しいキーと値に変換できるようになりました。 [[feature:15143]]

  * 別名

    * [[m:Struct#filter]] が [[m:Struct#select]] の別名として追加されました。 [[feature:13784]]

* [[c:Time]]

  * 新機能

    * [[m:Time.new]] と [[m:Time#getlocal]] が UTC オフセット文字列と同様に
      タイムゾーンオブジェクトを受け付けるようになりました。[[m:Time#+]],
      [[m:Time#-]], [[m:Time#succ]] もタイムゾーンを維持します。 [[feature:14850]]

* [[c:TracePoint]]

  * 新機能

    * "script_compiled" イベントがサポートされました。 [[feature:15287]]

  * 新規メソッド

    * [[m:TracePoint#parameters]] [[feature:14694]]

    * [[m:TracePoint#instruction_sequence]] [[feature:15287]]

    * [[m:TracePoint#eval_script]] [[feature:15287]]

  * 変更されたメソッド

    * [[m:TracePoint#enable]] がキーワード引数 "target:" と "target_line:" を
      受け付けるようになりました。 [[feature:15289]]

=== 標準添付ライブラリの更新

* [[c:BigDecimal]]

  バージョン 1.4.0 に更新されました。
  このバージョンは様々な非互換な点を含んでいます。
  詳細は下の互換性についてのセクションを参照してください。

  * 変更されたメソッド

    * [[m:Kernel.#BigDecimal]]() は [[m:Kernel.#Float]]() のように
      キーワード引数 "exception:" を受け付けるようになりました。

  * 最近のバージョンでの変更点に関する注意事項

    以下の情報を元に適切な bigdecimal のバージョンを選んでください。

    * 1.3.5 の [[m:BigDecimal.new]] は "exception:" キーワードをサポートしていません。
      "-w" オプションをつけた時に [[m:BigDecimal.new]] は非推奨警告を表示します。

    * 1.4.0 の [[m:BigDecimal.new]] は "exception:" キーワードをサポートしてます。
      [[m:BigDecimal.new]] は常に非推奨警告を表示します。
      [[m:Object#to_d]] メソッドは [[m:Kernel.#BigDecimal]]() や
      [[m:BigDecimal.new]] とは違いがあります。

    * 2.0.0 は Ruby 2.6.0 のリリース後すぐにリリースされる予定です。
      このバージョンは [[m:BigDecimal.new]] メソッドを含みません。

* [[c:Bundler]]

  * Bundler が標準添付ライブラリに追加されました。 [[feature:12733]]

  * 最新安定版の 1.17.2 が使われます。

* [[c:Coverage]]

  oneshot_lines モードが追加されました。 [[feature:15022]]

  このモードは「各行が何回実行されたか」の代わりに
  「各行が少なくとも1回実行されたかどうか」をチェックします。
  行ごとのフックは少なくとも1回実行されて、実行後はフックフラグが削除されます。
  言い換えるとオーバーヘッドがなくなります。

  * 新規オプション

    * :oneshot_lines キーワード引数が [[m:Coverage.start]] に追加されました。

    * :stop と :clear キーワード引数が [[m:Coverage.result]] に追加されました。
      clear が真の時、カウンターが0クリアされます。
      stop が真の時、カバレッジ計測を停止します。

  * 新規メソッド

    * [[m:Coverage.line_stub]] はソースコードからラインカバレッジ用のスタブを
      作成するシンプルなヘルパー関数です。

* [[c:CSV]]

  * 3.0.2 に更新されました。
    特に書き出しの高速化を含んでいます。
    書き出しは約2倍高速化しています。
    [[url:https://github.com/ruby/csv/blob/master/NEWS.md]] を参照してください。

* [[c:ERB]]

  * 新規オプション

    * :trim_mode と :eoutvar キーワード引数が [[m:ERB.new]] に追加されました。
      最初の引数以外のキーワード引数ではない引数はやんわりと非推奨になり、
      Ruby 2.5 が EOL になった時に削除される予定です。 [[feature:14256]]

    * erb コマンドの -S オプションは非推奨になりました。次のバージョンで削除予定です。

* [[c:FileUtils]]

  * 新規メソッド

    * [[m:FileUtils#cp_lr]] [[feature:4189]]

* [[c:Matrix]]

  * 新規メソッド

    * [[m:Matrix#antisymmetric?]], [[m:Matrix#skew_symmetric?]]

    * [[m:Matrix#map!]], [[m:Matrix#collect!]] [[feature:14151]]

    * [[m:Matrix#[]=]]

    * [[m:Vector#map!]], [[m:Vector#collect!]]

    * [[m:Vector#[]=]]

* [[c:Net::HTTP]]

  * 新規オプション

    * :write_timeout キーワード引数が [[m:Net::HTTP.new]] に追加されました。 [[feature:13396]]

  * 新規メソッド

    * [[m:Net::HTTP#write_timeout]] と [[m:Net::HTTP#write_timeout=]] が追加されました。 [[feature:13396]]

  * 新規定数

    * [[c:Net::HTTPClientException]] が追加されて [[c:Net::HTTPServerException]] が非推奨になりました。
      誤解を招く名称だったため。 [[bug:14688]]

* [[c:NKF]]

  * nkf v2.1.5 に更新されました。

* [[c:Psych]]

  * Psych 3.1.0 に更新されました。

* [[c:RDoc]]

  * 約2倍高速化されました。

  * ファイル生成に SOURCE_DATE_EPOCH を使うようになりました。

  * メソッドの行番号がずれていたのを修正しました。

  * 無視されていた --width, --exclude, --line-numbers を有効にしました。

  * デフォルトのマークアップ記法で ">>>" による引用をサポートしました。

  * TomDoc 記法で "Raises" 行をサポートしました。

  * シンタックスエラー出力を修正しました。

  * 多数のパース中のバグを修正しました。

* [[c:REXML]]

  * REXML 3.1.9 に更新されました。
    [[url:https://github.com/ruby/rexml/blob/master/NEWS.md]] を参照してください。

  いくつかの XPath 実装を改善:

    * concat() 関数: 結合前に全ての引数を文字列化

    * string() 関数: コンテキストノードをサポート

    * string() 関数: 処理命令 (PI) ノードをサポート

    * XPath 2.0 で"*:#{ELEMENT_NAME}" 記法をサポート

  いくつかの XPath 実装を修正:

    * "//#{ELEMENT_NAME}[#{POSITION}]" の問題

    * string() 関数: function(document) がルート要素の外のノードを返すのを修正

    * "/ #{ELEMENT_NAME} " の問題

    * "/ #{ELEMENT_NAME} [ #{PREDICATE} ]" の問題

    * "/ #{AXIS}::#{ELEMENT_NAME}" の問題

    * "#{N}-#{M}" の問題: 1個以上の空白が "-" の前に必要でした

    * "/child::node()" の問題

    * "#{FUNCTION}()/#{PATH}" の問題

    * "@#{ATTRIBUTE}/parent::" の問題

    * "name(#{NODE_SET})" の問題

* [[c:RSS]]

  * 新規オプション

    * [[m:RSS::Parser.parse]] が [[c:Hash]] としてオプションを受け付けるようになりました。
      :validate, :ignore_unknown_element, :parser_class オプションが利用可能です。

* RubyGems

  * RubyGems 3.0.1 に更新されました。

  * [[url:https://blog.rubygems.org/2018/12/19/3.0.0-released.html]]

  * [[url:https://blog.rubygems.org/2018/12/23/3.0.1-released.html]]

* [[c:Set]]

  * 別名

    * [[m:Set#filter!]] が [[m:Set#select!]] の別名として追加されました。 [[feature:13784]]

* [[c:URI]]

  * 新規定数

    * [[c:URI::File]] が file URI スキームを扱うために追加されました。 [[feature:14035]]

=== 互換性 (機能追加とバグ修正を除く)

* [[c:Dir]]

  * [[m:Dir.glob]] に '\0'区切りのパターンリストを渡すのは非推奨になる予定で、
    今は警告が出ます。 [[feature:14643]]

* [[c:File]]

  * [[m:File.read]], [[m:File.binread]], [[m:File.write]], [[m:File.binwrite]],
    [[m:File.foreach]], [[m:File.readlines]] はパスがパイプ文字 '|' で始まっていても
    外部コマンドを実行しなくなりました。 [[feature:14245]]

* [[c:Object]]

  * [[m:Object#=~]] は非推奨になりました。 [[feature:15231]]

=== 標準添付ライブラリの互換性 (機能追加とバグ修正を除く)

* 以下の標準添付ライブラリがデフォルト gem になりました。

  * e2mmap
  * forwardable
  * irb
  * logger
  * matrix
  * mutex_m
  * ostruct
  * prime
  * rexml
  * rss
  * shell
  * sync
  * thwait
  * tracer

* [[c:BigDecimal]]

  * 以下のメソッドが削除されました。

    * BigDecimal.allocate
    * BigDecimal.ver

  * 全ての BigDecimal オブジェクトが frozen になりました。 [[feature:13984]]

  * [[m:Kernel.#BigDecimal]]() が文字列を [[m:Kernel.#Float]]() のように
    パースするようになりました。

  * [[m:String#to_d]] がレシーバの文字列を [[m:String#to_f]] のように
    パースするようになりました。

  * [[m:BigDecimal.new]] はバージョン 2.0 で削除予定です。

* [[c:Pathname]]

  * [[m:Pathname#read]], [[m:Pathname#binread]], [[m:Pathname#write]],
    [[m:Pathname#binwrite]], [[m:Pathname#each_line]], [[m:Pathname#readlines]] は
    パスがパイプ文字 '|' で始まっていても外部コマンドを実行しなくなりました。
    これは [[feature:14245]] の続きです。

=== 実装の改善

* [[m:Proc#call]] が高速化しました。
  もう [[m:$SAFE]] を気にしなくてもよくなったためです。 [[feature:14318]]

  [[m:Proc#call]] を何度も使っている lc_fizzbuzz ベンチマークで1.4倍の改善を
  計測できています。 [[bug:10212]]

* ブロックパラメーターとして渡された block に対する block.call が高速化されました。 [[feature:14330]]

  Ruby 2.5 ではブロック渡しのパフォーマンスを改善されました。 [[feature:14045]]

  さらに Ruby 2.6 では渡されたブロックの呼び出しのパフォーマンスが改善されました。

* JIT (Just-in-time) コンパイラの初期実装が導入されました。 [[feature:14235]] [実験的]

  * JIT を有効化する --jit コマンドラインオプションが追加されました。
    「--jit-verbose=1」が調査に有用です。
    他のオプションは「ruby --help」を参照してください。
  * 機械語を生成するため、この JIT コンパイラはインタプリタをビルドするのに使用した C コンパイラを使用します。
    現在は GCC, Clang, Microsoft Visual C++ をサポートしています。
  * configure に「--disable-mjit-support」オプションが追加されました。
    これは JIT デバッグのために追加されましたが、JIT 用のヘッダファイルのビルドでエラーが発生した場合、
    回避策としてこのオプションを使うとビルドをスキップできます。
  * JIT で作成されたプロセスとの互換性を維持するために Unix 系のプラットフォームで
    rb_waitpid が再実装されました。 [[bug:14867]]

* 生成される VM をより最適化できるようにするために VM 生成スクリプトが一新されました。
  [[url:https://github.com/ruby/ruby/pull/1779]]

* pthread プラットフォームでスレッドキャッシュを有効にしました。
  ([[m:Thread.new]] と [[m:Thread.start]]) [[feature:14757]]

* POSIX タイマーのあるプラットフォームでタイマースレッドが取り除かれました。 [[misc:14937]]

* Transient Heap (theap) がサポートされました。 [[bug:14858]] [[feature:14989]]

#@# memory objects は malloc されたメモリブロックのこと
  theap は短命なメモリオブジェクトのための管理されたヒープです。
  例えば小さくて短命の Hash オブジェクトは2倍高速化されました。
  rdoc ベンチマークでは 6から7%のパフォーマンスの改善を計測できました。

* コルーチンのネイティブ実装(arm32, arm64, ppc64le, win32, win64, x86, amd64) により
  Fiber のパフォーマンスを大きく改善 [[feature:14739]]

=== その他の変更

* macOS で共有ライブラリの名前に Ruby のフルバージョンを含めなくなりました。
  この変更によって macOS プラットフォームのユーザが teeny リリース毎に全ての
  拡張ライブラリをリビルドする必要がある負担がなくなります。

  変更前:
    * libruby.2.6.0.dylib
    * libruby.2.6.dylib -> libruby.2.6.0.dylib
    * libruby.dylib -> libruby.2.6.0.dylib

  変更後:
    * libruby.2.6.dylib
    * libruby.dylib -> libruby.2.6.dylib

* misc/*.el ファイルが [[url:https://github.com/ruby/elisp]] に分離されました。
