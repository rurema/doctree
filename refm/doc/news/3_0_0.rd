#@since 3.0
= NEWS for Ruby 3.0.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストはリンク先を参照してください。

== 言語仕様の変更

  * キーワード引数が位置引数から分離されるようになります。
    Ruby 2.7 では非推奨の警告を表示していましたが、ArgumentError を出力するか、異なる振る舞いをします。
    [[feature:14183]]
  * 単一の rest 引数とキーワードを受け入れる Proc は、autosplat の対象ではなくなりました。
    これは、単一の rest 引数を受け入れキーワードを受け入れない Proc の振る舞いと一致するようになっています。
    [[feature:16166]]

#@samplecode
pr = proc{|*a, **kw| [a, kw]}

pr.call([1])
# 2.7 => [[1], {}]
# 3.0 => [[[1]], {}]

pr.call([1, {a: 1}])
# 2.7 => [[1], {:a=>1}] # and deprecation warning
# 3.0 => [[[1, {:a=>1}]], {}]
#@end

  * 引数委譲（...）は、先頭の引数をサポートするようになりました。
    [[feature:16378]]

//emlist{
def method_missing(meth, ...)
  send(:"do_#{meth}", ...)
end
//}

    * パターンマッチ（case/in）が正式機能となりました。 [[feature:17260]]
    * 一行パターンマッチが実験的に再設計されました。 [EXPERIMENTAL]
        * => が導入されました。右代入のように使用できます。
          [[feature:17260]]
      * in は true もしくは false を返すように変更されています。 [[feature:17371]]

//emlist{
0 => a
p a #=> 0

{b: 0, c: 1} => {b:}
p b #=> 0
//}

//emlist{
# version 3.0
0 in 1 #=> false

# version 2.7
0 in 1 #=> raise NoMatchingPatternError
//}

  * Find パターンが実験的に導入されています。 [EXPERIMENTAL]
    [[feature:16828]]

//emlist{
case ["a", 1, "b", "c", 2, "d", "e", "f", 3]
in [*pre, String => x, String => y, *post]
  p pre  #=> ["a", 1]
  p x    #=> "b"
  p y    #=> "c"
  p post #=> [2, "d", "e", "f", 3]
end
//}

  * end のないメソッド定義が実験的に導入されました。 [EXPERIMENTAL]
      [[feature:16746]]

//emlist{
def square(x) = x * x
//}

  * # frozen-string-literal: true が使用されている場合、式展開を含む文字列リテラルは freeze されなくなりました。
    [[feature:17104]]
  * 定数を freeze するためのマジックコメント shareable_constant_value が導入されました。
    詳細は [[url:https://docs.ruby-lang.org/ja/3.0/doc/spec=2fm17n.html#magic_comment]] を参照してください。
    [[feature:17273]]
  * 静的解析基盤が導入されました。
      * RBS が導入されました。
        RBS は Ruby プログラムのための型定義言語です。
      * TypeProf が実験的にバンドルされました。
        TypeProf は Ruby プログラムのための型解析ツールです。
  * 非推奨に関する警告がデフォルトで非表示になりました（Ruby 2.7.2 から導入されています）。
    -W:deprecated を指定すると表示されるようになります（もしくは、-w を指定すると異なる警告が表示されます）。
    [[feature:16345]]
  * $SAFE と $KCODE は特別扱いせずただのグローバル変数になりました。
    $SAFE に関係した C API メソッドは削除されました。
    [[feature:16131]] [[feature:17136]]
  * メソッド内のシングルトンクラス定義中の yield は警告ではなく SyntaxError になりました。
    メソッド外のクラス定義中の yield は LocalJumpError ではなく SyntaxError になりました。
    [[feature:15575]]
  * スーパークラス/スーパーモジュールでクラス変数を再定義した場合、RuntimeError を起こすようになりました
    （今までは verbose モードでのみ警告を出していました）。
    さらにトップレベルでクラス変数にアクセスすると RuntimeError になりました。
    [[bug:14541]]
  * Numbered parameter への代入が警告ではなく SyntaxError になりました。

== コマンドラインオプション

=== --help オプション

環境変数 RUBY_PAGER または PAGER が空ではない文字列を指定され、標準入出力が tty である場合、--help オプションはページャーを通してヘルプメッセージを表示するようになりました。
[[feature:16754]]

=== --backtrace-limit オプション

--backtrace-limit オプションはバックトレースの最大行数を指定できるようになりました。
[[feature:8661]]

== 組み込みクラスの更新

注目すべきもののみ記載します。

  * Array
    * 以下のメソッドは、サブクラスインスタンスで呼び出された場合、配列インスタンスを返すようになりました: [[bug:6087]]
      * Array#drop
      * Array#drop_while
      * Array#flatten
      * Array#slice!
      * Array#slice / Array#[]
      * Array#take
      * Array#take_while
      * Array#uniq
      * Array#*
    * Enumerator::ArithmeticSequence でスライスできます。

#@samplecode
dirty_data = ['--', 'data1', '--', 'data2', '--', 'data3']
dirty_data[(1..).step(2)] # take each second element
# => ["data1", "data2", "data3"]
#@end

  * Binding
    * 1 引数で呼び出された Binding#eval は、コード評価時に __FILE__ には "(eval)" を、__LINE__ には 1 を使うようになります。[[bug:4352]] [[bug:17419]]
  * ConditionVariable
    * ConditionVariable#wait はノンブロッキングコンテキストで block/unblock スケジューラーフックを呼び出せるようになりました。[[feature:16786]]
  * Dir
    * Dir.glob および Dir.[] は出力結果をデフォルトでソートするようになりました。[[feature:8709]]
  * ENV
    * ENV.except が導入されました。与えられたキーとそれらの値を除外したハッシュを返すようになりました。[[feature:15822]]
    * Windows: ENV の名前と値を UTF-8 でエンコードされた文字列として読み取ります。[[feature:12650]]
  * Encoding
    * 新しく IBM720 というエンコーディングが導入されました。[[feature:16233]]
    * Windows では Encoding.default_external のデフォルトが UTF-8 になりました。[[feature:16604]]
  * Fiber
    * Fiber.new(blocking: true/false) は、ノンブロッキング実行コンテキストを生成することを許可するようになりました。[[feature:16786]]
    * Fiber#blocking? は fiber がノンブロッキングであるかを返します。[[feature:16786]]
    * Fiber#backtrace および Fiber#backtrace_locations は fiber ごとのバックトレースを提供するようになりました。[[feature:16815]]
    * Fiber#transfer の制限が緩和されました。[[bug:17221]]
  * GC
    * コンパクションが実行されるタイミングを制御するために GC.auto_compact= および GC.auto_compact が導入されました。
      auto_compact= を true に設定すると、メジャー GC 中にコンパクションが発生します。
      現時点では、コンパクションによってメジャー GC にかなりのオーバーヘッドが追加されます。よって、まず最初にテストしてください！
      [[feature:17176]]
  * Hash
    * Hash#transform_keys および Hash#transform_keys! はキーを新しいキーにマッピングするハッシュを受け入れるようになりました。[[feature:16274]]
    * Hash#except が導入されました。与えられたキーとそれらの値を除外したハッシュを返すようになりました。[[feature:15822]]
  * IO
    * IO#nonblock? のデフォルト値が true になりました。[[feature:16786]]
    * IO#wait_readable, IO#wait_writable, IO#read, IO#write およびその他関連するメソッド（例 IO#puts, IO#gets）は、ノンブロッキング実行コンテキストでスケジューラフック #io_wait(io, events, timeout) を呼び出せるようになりました。[[feature:16786]]
  * Kernel
    * キーワード引数 freeze: false で呼び出された Kernel#clone は、キーワード引数 freeze: false で #initialize_clone を呼び出すようになります。[[bug:14266]]
    * キーワード引数 freeze: true で呼び出された Kernel#clone は、キーワード引数 freeze: true で #initialize_clone を呼び出すようになります。そして、Kernel#clone は、レシーバが freeze されていない場合、freeze して複製を返すようになります。[[feature:16175]]
    * 2 引数で呼び出された場合の Kernel#eval は、コード評価時に __FILE__ では "(eval)" を、__LINE__ では 1 を使うようになります。[[bug:4352]]
    * Kernel#lambda は、リテラルブロックなしで呼び出された場合、警告を出すようになりました。[[feature:15973]]
    * Kernel.sleep はノンブロッキング実行コンテキストでスケジューラフック #kernel_sleep(...) を呼び出すようになりました。[[feature:16786]]
  * Module
    * Module#include および Module#prepend はレシーバが include されている、もしくは、prepend されているクラスとモジュールに影響を与えるようになります。そして、他のモジュールやクラスが include される、もしくは、prepend される前に、引数がレシーバー include されるような振る舞いをミラーリングします。[[feature:9573]]
    * Module#public, Module#protected, Module#private, Module#public_class_method, Module#private_class_method, およびトップレベルな "private"/"public" メソッドが、メソッド名一覧で単一の配列引数を受け取れるようになりました。[[feature:17314]]
    * Module#attr_accessor, Module#attr_reader, Module#attr_writer および Module#attr メソッドは、定義されたメソッドのシンボルの配列を返すようになりました。[[feature:17314]]
    * Module#alias_method は、定義されたシンボルのエイリアスを返すようになりました。[[feature:17314]]

#@samplecode
class C; end
module M1; end
module M2; end
C.include M1
M1.include M2
p C.ancestors #=> [C, M1, M2, Object, Kernel, BasicObject]
#@end

  * Mutex
    * Mutex は、Thread ごとではなく Fiber ごとに取得されるようになりました。
      この変更は、基本的に全てのユースケースで互換性がありべきで、スケジューラーを使用する際のブロッキングを回避する必要があります。
      [[feature:16792]]
  * Proc
    * Proc#== and Proc#eql? are now defined and will return true for separate Proc instances if the procs were created from the same block. [[feature:14267]]
    * Proc#== および Proc#eql? は、Proc が同じブロックから作成される場合、Proc インスタンスと分離して true を返すように定義されました。[[feature:14267]]
  * Queue / SizedQueue
    * Queue#pop, SizedQueue#push および関連したメソッドは、ノンブロッキングコンテキストで block/unblock スケジューラーフックを呼び出せるようになりました。[[feature:16786]]
  * Ractor
    * 並列処理を可能にする新しいクラスが追加されました。詳細は [[url:https://docs.ruby-lang.org/en/master/ractor_md.html]] を参照してください。
  * Random
    * Random::DEFAULT は Random インスタンスではなく Random クラスをさすようになりました。よって、Ractor で機能します。[[feature:17322]]
    * Random::DEFAULT は、その値がわかりにくくグローバルではなくなったため、非推奨になりました。Kernel.rand/Random.rand を直接使用するか、代わりに Random.new を使用して Random インスタンスを生成してください。[[feature:17351]]
  * String
    * 以下のメソッドは、サブクラスインスタンスで呼び出された場合、String インスタンスを返すようになりました: [[bug:10845]]
      * String#*
      * String#capitalize
      * String#center
      * String#chomp
      * String#chop
      * String#delete
      * String#delete_prefix
      * String#delete_suffix
      * String#downcase
      * String#dump
      * String#each_char
      * String#each_grapheme_cluster
      * String#each_line
      * String#gsub
      * String#ljust
      * String#lstrip
      * String#partition
      * String#reverse
      * String#rjust
      * String#rpartition
      * String#rstrip
      * String#scrub
      * String#slice!
      * String#slice / String#[]
      * String#split
      * String#squeeze
      * String#strip
      * String#sub
      * String#succ / String#next
      * String#swapcase
      * String#tr
      * String#tr_s
      * String#upcase
  * Symbol
    * Symbol#to_proc は lambda となる Proc を返すようになりました。[[feature:16260]]
    * Symbol#name が導入されました。 シンボルの名前がある場合は、その名前を返します。返された文字列は freeze されています。[[feature:16150]]
  * Fiber
    * ブロッキングオペレーションをインターセプトするための Fiber.set_scheduler、および現在のスケジューラーにアクセスするための Fiber.scheduler が導入されました。
      詳細は {Fiber}[https://docs.ruby-lang.org/ja/latest/class/Fiber.html] のサポートされているオペレーションとスケジューラーフックの実装方法を参照してください。 [[feature:16786]]
    * Fiber.blocking? は、現在の実行コンテキストがブロックされているかどうかを知らせてくれます。[[feature:16786]]
    * Thread#join はノンブロッキングコンテキストで block/unblock スケジューラーフックを呼び出せるようになりました。 [[feature:16786]]
    * デフォルトのデッドロック検出を無効にするために Thread.ignore_deadlock アクセッサが導入されました。
      また、シグナルハンドラーを使用してデッドロックを解除できるようになりました。[[bug:13768]]
  * Warning
    * Warning#warn は category キーワード引数をサポートするようになりました。[[feature:17122]]

== 標準添付ライブラリの更新

注目すべきもののみ記載します。

  * BigDecimal
    * BigDecimal 3.0.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Bundler
    * Bundler 2.2.3 に更新されました。
  * CGI
    * 0.2.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * CSV
    * CSV 3.1.9 に更新されました。
  * Date
    * Date 3.1.1 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Digest
    * Digest 3.0.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Etc
    * Etc 1.2.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Fiddle
    * Fiddle 1.0.5 に更新されました。
  * IRB
    * IRB 1.2.6 に更新されました。
  * JSON
    * JSON 2.5.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Set
    * set 1.0.0 に更新されました。
    * SortedSet は依存関係とパフォーマンス上の理由から削除されました。
    * Set#join が、.to_a.join の省略形として導入されました。
    * Set#<=> が導入されました。
  * Socket
    * TCPSocket.new に :connect_timeout が導入されました。[[feature:17187]]
  * Net::HTTP
    * Net::HTTP#verify_hostname= および Net::HTTP#verify_hostname が、ホスト名の検証をスキップするために導入されました。[[feature:16555]]
    * Net::HTTP.get, Net::HTTP.get_response, および Net::HTTP.get_print は、最初の引数が URI の場合、2 番目の引数でリクエストヘッダーをハッシュとして受け取れるようになりました。[[feature:16686]]
  * Net::SMTP
    * SNI サポートが導入されました。
    * Net::SMTP.start 引数がキーワード引数になりました。
    * TLS はデフォルトでホスト名をチェックしなくなりました。
  * OpenStruct
    * 初期化はもはや lazy ではありません。[[bug:12136]]
    * 組み込みメソッドは安全に上書き可能になりました。[[bug:15409]]
    * 実装では、 ! で終わるメソッドでのみ使用されます。
    * Ractor 互換
    * YAML のサポートが改善されています。[[bug:8382]]
    * 公式には使用を推奨しなくなりました。[[ref:c:OpenStruct#caveats]]を参照してください。
  * Pathname
    * Ractor 互換
  * Psych
    * Psych 3.3.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * Reline
    * Reline 0.1.5 に更新されました。
  * RubyGems
    * RubyGems 3.2.3 に更新されました。
  * StringIO
    * StringIO 3.0.0 に更新されました。
    * このバージョンは Ractor と互換性があります。
  * StringScanner
    * StringScanner 3.0.0 に更新されました。
    * このバージョンは Ractor と互換性があります。

== 互換性

機能追加とバグ修正は除いています。

  * 正規表現リテラルとすべての Range オブジェクトは freeze されるようになりました。[[feature:8948]] [[feature:16377]] [[feature:15504]]

#@samplecode
/foo/.frozen? #=> true
(42...).frozen? # => true
#@end

  * EXPERIMENTAL: Hash#each が常に 2 要素配列を yield するようになりました。[[bug:12706]]
    * { a: 1 }.each(&->(k, v) { }) は lambda のアリティチェックが要因で、ArgumentError を起こすようになりました。
  * パイプがクローズされた後に標準出力へ出力しようとしても、EPIPE 例外を浮揚しないようになりました。[[feature:14413]]
  * TRUE/FALSE/NIL 各定数が定義されないようになりました。
  * Integer#zero? は最適化のために Numeric#zero? をオーバーライドするようになりました。[[misc:16961]]
  * Enumerable#grep および Enumerable#grep_v は、正規表現が渡され、かつ、ブロックがない場合、Regexp.last_match を変更しなくなりました。[[bug:17030]]
  * 'open-uri' を require しても Kernel#open は再定義されなくなりました。代わりに URI.open を直接呼び出すか URI#open を使用してください。[[misc:15893]]
  * 依存関係とパフォーマンス上の理由から、SortedSet が削除されました。

== 標準添付ライブラリの互換性

  * Default gems
    * 以下のライブラリが新たに default gem になりました。
      * English
      * abbrev
      * base64
      * drb
      * debug
      * erb
      * find
      * net-ftp
      * net-http
      * net-imap
      * net-protocol
      * open-uri
      * optparse
      * pp
      * prettyprint
      * resolv-replace
      * resolv
      * rinda
      * set
      * securerandom
      * shellwords
      * tempfile
      * tmpdir
      * time
      * tsort
      * un
      * weakref
    * 以下の拡張ライブラリが新たに default gem になりました。
      * digest
      * io-nonblock
      * io-wait
      * nkf
      * pathname
      * syslog
      * win32ole
  * Bundled gems
    * net-telnet および xmlrpc は、バンドルされた gem から削除されました。
      これらを保守したい場合は、[[url:https://github.com/ruby/xmlrpc]] もしくは [[url:https://github.com/ruby/net-telnet]] にあなたのプランをコメントしてください。
  * SDBM は Ruby 表示ん添付ライブラリから削除されました。[[bug:8446]]
    * sdbm の課題は、[[url:https://github.com/ruby/sdbm]] で処理される予定です。
  * WEBrick は Ruby 標準添付ライブラリから削除されました。[[feature:17303]]
    * WEBrick の課題は、[[url:https://github.com/ruby/webrick] で処理される予定です。

== C API の更新

  * $SAFE に関連する C API 関数は削除されました。[[feature:16131]]
  * ruby/ruby.h は分割されました。[[url:https://github.com/ruby/ruby/pull/2991]]
    これは拡張ライブラリに影響はないはずです。しかし、コンパイルが遅くなる可能性があります。
  * Memory view interface [EXPERIMENTAL]
    * メモリビューインタフェースは、数値配列やビットマップ画像などの生のメモリ領域を、拡張ライブラリ間で交換するための C API セットです。
      拡張ライブラリは、数値配列の次元数や要素型などの性質を記述するメタデータも共有できます。
      これらのメタデータを使用して、拡張ライブラリは多次元配列でさえ適切に共有できます。
      この機能は、Python のバッファプロトコルを参考にして設計されています。
      [[feature:13767]] [[feature:14722]]
  * "include/ruby/ractor.h" に C API 関連の Ractor が実験的に導入されました。

== 実装の改善

  * Ractor のためにメソッドキャッシュが刷新されました。[[feature:16614]]
    * ISeq からポイントされたインラインメソッドキャッシュは、複数の Ractor から並行してアクセスでき、メソッドキャッシュの場合でも同期が必要です。
      しかしながら、このような同期はオーバーヘッドになる可能性があるため、(1) 使い捨てできる (2) クラスごとにキャッシュできる (3) 新規の無効化する機構を新しいインラインキャッシュメソッドに導入しました。
      (1) はアトミックな処理を使用するのみなので、メソッドごとに呼び出す同期を回避できます。
      詳細はチケットを参照してください。
  * メソッド呼び出しでキーワード引数を使用するときに割り当てられるハッシュの数が最大 1 に減り、特定のキーワードを受け取るメソッドにキーワード引数を渡してもハッシュを割り当てなくなりました。
  * super は、refinements, attr_reader, attr_writer ではない場合、前回と同じ型のメソッドが呼び出されたときに最適化されます。

=== JIT

  * JIT-ed コードのパフォーマンス改善
    * マイクロアーキテクチャの最適化
        * 複数のメソッドによって共有されるネイティブ関数は、JIT コンパクションで重複排除されます。
        * いくつかの最適化とコールドパスの分割により、ホットパスのコードサイズを減らしています。
    * インスタンス変数
        * いくつかの冗長なチェックを削除しています。
        * 可能であれば、メソッド内のクラスとオブジェクトの複数回チェックをスキップしています。
        * Hash やそのサブクラスの一部のコアクラスでアクセスを最適化しています。
    * 一部の C メソッドのサポートをインライン化するメソッド
        * Kernel: #class, #frozen?
        * Integer: #-@, #~, #abs, #bit_length, #even?, #integer?, #magnitude, #odd?, #ord, #to_i, #to_int, #zero?
        * Struct: 10 番目以降のメンバー用リーダーメソッド
    * 定数の参照がインライン化されました。
    * レシーバクラスの ==, nil?, および ! には常に適切なコードを生成するようになりました。
    * 分岐やメソッドからのリターンでの PC アクセス回数が削減されました。
    * C メソッド呼び出しが少し最適化されました。
  * コンパイルプロセスの改善
    * /tmp ディレクトリに一時ファイルを保持しなくなりました。
    * GC と JIT-ed なコードのコンパクションが抑制されるようになりました。
    * 必要ではない場合、GC-ing で JIT-ed コードは回避されるようになりました。
    * GC-ing で JIT-ed コードはバックグランドスレッドで実行されるようになりました。
    * Ruby と JIT スレッド間でのロックの回数が削減されました。

== 静的解析

=== RBS

  * RBS は Ruby プログラムのための新しい型定義言語です。
    共用体型、オーバーロード、ジェネリクス、およびダックタイピングのような「インタフェース型」を含む進化した型のクラスやモジュールを記述できるようになりました。
  * Ruby は core/stdlib クラスの型定義を同梱しています。
  * rbs gem は RBS ファイルをロードして処理するためにバンドルされています。

=== TypeProf

  * TypeProf は抽象解釈に基づいた Ruby コード用の型解析ツールです。
    * 型注釈のない Ruby コードを読み取り、その型シグネチャを推測しようと試み、そして RBS フォーマットで分析結果を出力します。
    * まだ Ruby 言語のサブセットしかサポートしていませんが、言語機能のカバレッジ、分析パフォーマンス、およびユーザビリティを継続的に改善する予定です。

#@samplecode
# test.rb
def foo(x)
  if x > 10
    x.to_s
  else
    nil
  end
end

foo(42)
#@end

//emlist{
$ typeprof test.rb
# Classes
class Object
  def foo : (Integer) -> String?
end
//}

== その他の変更

  * ruby2_keywords を使用するメソッドは、空のキーワード引数を保持しなくなります。これらは ruby2_keywords を使用しないメソッドの場合と同様に削除されるようになりました。
  * デフォルトのハンドラーで例外がキャッチされた場合、エラーメッセージとバックトレースが最も深い順に出力されるようになりました。[[feature:8661]]
  * 初期化されていないインスタンス変数にアクセスしても、冗長モードで警告が表示されなくなりました。[[feature:17055]]
#@end
