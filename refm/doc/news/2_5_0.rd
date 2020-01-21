#@since 2.5.0
= NEWS for Ruby 2.5.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.4.0 以降の変更

=== 言語仕様の変更

  * トップレベルの定数参照を削除しました  [[feature:11547]]
  * do/end ブロック内部で rescue/else/ensure を書けるようになりました [[feature:12906]]
  * 文字列の式展開内部の暗黙の to_s 呼び出しにも refinements が影響するようになりました [[feature:13812]]

=== 組み込みクラスの更新

  * [[c:Array]]
    * [[m:Array#append]] を追加 [[feature:12746]]
    * [[m:Array#prepend]] を追加 [[feature:12746]]

  * [[c:Data]]
    * 非推奨になりました。C拡張のベースクラスでしたが、Rubyレベルに公開するのをやめました。[[feature:3072]]

  * [[c:Exception]]
    * [[m:Exception#full_message]] を追加 [[feature:14141]] [実験的]
      例外の文字列表現を取得します。その文字列は捕捉されない例外をRubyが表示しているのと同じ方法でフォーマットされます。

  * [[c:Dir]]
    * [[m:Dir.glob]] :base というキーワード引数を追加しました [[feature:13056]]
    * [[m:Dir.chdir]] (ブロックなしで呼び出した場合), [[m:Dir.open]], [[m:Dir.new]], [[m:Dir.mkdir]], [[m:Dir.rmdir]],
      [[m:Dir.empty?]] はGVLを解放するようになりました
    * [[m:Dir.children]] を追加  [[feature:11302]]
    * [[m:Dir.each_child]] を追加 [[feature:11302]]

  * [[c:Enumerable]]
    * [[m:Enumerable#any?]], [[m:Enumerable#all?]], [[m:Enumerable#none?]], [[m:Enumerable#one?]]
      がブロックを省略して1つの引数を受け取ることができるようになりました [[feature:11286]]

  * [[c:File]]
    * [[m:File.open]] :newline オプションを指定するとテキストモードになります [[bug:13350]]
    * [[m:File#path]] は[[m:File::Constants::TMPFILE]]付きで開いたファイルに対して IOError を発生させます
      [[feature:13568]]
    * [[m:File.stat]], [[m:File.exist?]] など rb_stat() を使用しているメソッドではGVLを解放するようになりました
      [[bug:13941]]
    * [[m:File.rename]] GVL を解放するようになりました [[feature:13951]]
    * [[m:File::Stat#atime]], [[m:File::Stat#mtime]], [[m:File::Stat#ctime]]
      Windows 8 以降でタイムスタンプの分数表現をサポートしました [[feature:13726]]
    * [[m:File::Stat#ino]], [[m:File.indentical?]]
      Windows 8.1 以降で、ReFSの128bitのinoをサポートしました [[feature:13731]]
    * [[m:File.readable?]], [[m:File.readable_real?]], [[m:File.writable?]], [[m:File.writable_real?]],
      [[m:File.executable?]], [[m:File.executable_real?]], [[m:File.mkfifo]], [[m:File.readlink]],
      [[m:File.truncate]], [[m:File#truncate]], [[m:File.chmod]], [[m:File.lchmod]], [[m:File.chown]],
      [[m:File.lchown]], [[m:File.unlink]], [[m:File.utime]], [[m:File.lstat]] はGVLを解放するようになりました
    * [[m:File.lutime]] を追加  [[feature:4052]]

  * [[c:Hash]]
    * [[m:Hash#transform_keys]] を追加 [[feature:13583]]
    * [[m:Hash#transform_keys!]] を追加 [[feature:13583]]
    * [[m:Hash#slice]] を追加 [[feature:8499]]

  * [[c:IO]]
    * [[m:IO.copy_stream]] は [[man:copy_file_range(2)]] を使うようになりました。また、その実装が使えない場合は他の実装へフォールバックするようにしました [[feature:13867]]
    * [[m:IO#pread]] を追加 [[feature:4532]]
    * [[m:IO#pwrite]] を追加 [[feature:4532]]
    * [[m:IO#write]] 複数の引数を受け取れるようになりました [[feature:9323]]

  * [[c:IOError]]
    * [[m:IO#close]] 以前は"stream closed"というメッセージの例外が発生していましたが、"stream closed in another thread"というメッセージに改良しました。
      このメッセージはユーザーにとってわかりやすいでしょう。 [[bug:13405]]

  * [[c:Integer]]
    * [[m:Integer#round]], [[m:Integer#floor]], [[m:Integer#ceil]], [[m:Integer#truncate]] は常に [[c:Integer]] を返すようになりました
      [[bug:13420]]
    * [[m:Integer#pow]] を追加 [[feature:12508]] [[feature:11003]]
    * [[m:Integer#allbits?]], [[m:Integer#anybits?]], [[m:Integer#nobits?]] を追加 [[feature:12753]]
    * [[m:Integer.sqrt]] を追加 [[feature:13219]]

  * [[c:Kernel]]
    * [[m:Object#yield_self]] を追加  [[feature:6721]]
    * [[m:Kernel.#pp]] をrequireなしで使えるようにしました  [[feature:14123]]
    * [[m:Kernel.#warn]] :uplevel というキーワード引数を追加しました  [[feature:12882]]

  * [[c:Method]]
    * [[m:Method#===]] は [[m:Proc#===]]と同じように[[m:Method#call]]を呼び出します [[feature:14142]]

  * [[c:Module]]
    * [[m:Module#attr]], [[m:Module#attr_accessor]], [[m:Module#attr_reader]], [[m:Module#attr_writer]] はパブリックメソッドになりました [[feature:14132]]
    * [[m:Module#define_method]], [[m:Module#alias_method]], [[m:Module#undef_method]], [[m:Module#remove_method]] はパブリックメソッドになりました [[feature:14133]]

  * [[c:Numeric]]
    * [[m:Numeric#step]] は > で0と比較できない引数が与えられたときcoerce内部で発生したエラーを隠蔽しないようになりました。
      [[feature:7688]]
    * 数値の比較メソッド(<,<=,>=,>)は、coerceメソッドで発生した例外を隠蔽しなくなりました。
      coerceがnilを返す場合、変換は不可能です。[[feature:7688]]

  * [[c:Process]]
    * [[man:getrusage(2)]] が存在する場合 [[m:Process.#times]] の精度を改良しました [[feature:11952]]
    * [[m:Process.last_status]] を追加。[[m:$?]] と同じです [[feature:14043]]

  * [[c:Range]]
    * [[m:Range.new]] no longer hides exceptions when comparing begin and
      end with #<=> and raise a "bad value for range" ArgumentError
      but instead lets the exception from the #<=> call go through.
      [[feature:7688]]

  * [[c:Regexp]]
    *  Onigmo 6.1.3-669ac9997619954c298da971fcfacccf36909d05 に更新
      * 非包含オペレータ(absence operator)をサポート [[url:https://github.com/k-takata/Onigmo/issues/82]]
      * Support new 5 emoji-related Unicode character properties

  * [[c:RubyVM::InstructionSequence]]
    * [[m:RubyVM::InstructionSequence#each_child]] を追加
    * [[m:RubyVM::InstructionSequence#trace_points]] を追加

  * [[c:String]]
    * [[m:String#-@]] はフリーズされていない文字列の重複を排除します。
      互換性のため、既にフリーズされている文字列には何もしません。  [[feature:13077]]
    * -"literal" ([[m:String#-@]]) は同じオブジェクトを返すように最適化しました。
      (Ruby 2.1以降の "literal".freeze と同じです) [[feature:13295]]
    * [[m:String#casecmp]], [[m:String#casecmp?]] に文字列でない引数を与えた場合、TypeErrorを発生させずにnilを返すようにしました
      [[bug:13312]]
    * [[m:String#start_with?]] は正規表現を受け取れるようになりました [[feature:13712]]
    * [[m:String#delete_prefix]], [[m:String#delete_prefix!]] を追加 [[feature:12694]]
    * [[m:String#delete_suffix]], [[m:String#delete_suffix!]] を追加 [[feature:13665]]
    * [[m:String#each_grapheme_cluster]], [[m:String#grapheme_clusters]] を追加。結合文字を列挙します。
      [[feature:13780]]
    * [[m:String#undump]] を追加。[[m:String#dump]]で出力した文字列を元に戻します。[[feature:12275]]

  * [[c:Struct]]
    * [[m:Struct.new]] は :keyword_init というキーワード引数を受け取り、メンバーをキーワード引数で初期化できるようになりました。
      [[feature:11925]]

  * [[c:Regexp]]/[[c:String]]: Unicodeのバージョンを 9.0.0 から 10.0.0 に更新しました。 [[feature:13685]]

  * [[c:Thread]]
    * [[m:Thread#name=]] で設定した名前が Windows 10 で見えるようになりました
    * [[m:Thread#fetch]] を追加 [[feature:13009]]
    * [[m:Thread.report_on_exception]] のデフォルト値がtrueになりました。
      スレッドの終了時に捕捉していない例外の情報を $stderr に出力します。 [[feature:14143]]

  * [[c:Time]]
    * [[m:Time.at]] は第2引数の精度を指定するための第3引数を指定できるようになりました
      [[feature:13919]]

  * [[c:KeyError]]
    * [[m:KeyError#receiver]] を追加 [[feature:12063]]
    * [[m:KeyError#key]] を追加 [[feature:12063]]

  * [[c:FrozenError]]
    * 新しい例外クラスです [[feature:13224]]

=== 標準添付ライブラリの更新

  * [[lib:bigdecimal]]
    * BigDecimal 1.3.4 に更新
    * BigDecimal::VERSION を追加
    * 非推奨(1.4.0で削除予定)
      * BigDecimal.new
      * BigDecimal.ver
    * BigDecimal#clone と #dup は新しいインスタンスを作らなくなりました。selfを返します。

  * [[lib:coverage]]
    * ブランチカバレッジとメソッドカバレッジの計測をサポートしました [[feature:13901]]
      この新機能と一緒にテストスイートを実行すると、テストによって実行された条件分岐やメソッドについて知ることができます。
      テストスイートのカバレッジをより厳密に評価することができます。
      [[m:Coverage.start]]に与えるオプションによって計測する対象を指定することができます。
#@samplecode
       Coverage.start(lines: true, branches: true, methods: true)
#@end
    * Rubyで書かれたファイルをいくつか読み込んでから、[[m:Coverage.result]]を使って結果を取得することができます。
#@samplecode
        Coverage.result
        #=> { "/path/to/file.rb"=>
        #     { :lines => [1, 2, 0, nil, ...],
        #       :branches =>
        #         { [:if, 0, 2, 1, 6, 4] =>
        #             { [:then, 1, 3, 2, 3, 8] => 0,
        #               [:else, 2, 5, 2, 5, 8] => 2
        #             }
        #         },
        #       :methods => {
        #          [Object, :foo, 1, 0, 7, 3] => 2
        #       }
        #     }
        #   }
#@end
    * ラインカバレッジについての変更はありません。ラインカバレッジの結果はただの数値の配列です。
      数値の入っている要素は実行された行を表し、その数値は実行回数を意味します。
      nilの入った要素はカバレッジに関係のない行を意味します。
    * ブランチカバレッジの結果はこのようになります:
//emlist{
        { (jump base) => { (jump target) => (counter) } }
//}
    * jump base と jump target にはフォーマットがあります:
//emlist{
        [type, unique-id, start lineno, start column, end lineno, end column]
//}
    * 例えば [:if, 0, 2, 1, 6, 4] は、if式が2行目の1桁目から6行目の4桁目まで、と読みます。
      [:then, 1, 3, 2, 3, 8] は、then節が3行目の2桁目から3行目の8桁目まで、と読みます。
      なお、行番号は1から始まり、桁番号は0から始まります。
      よって、上記の例ではifから最初のthen節は実行されておらず、else節は2回実行されています。
    * メソッドカバレッジの場合:
//emlist{
        { (method key) => (counter) }
//}
    * メソッドキーにはフォーマットがあります:
//emlist{
        [class, method-name, start lineno, start column, end lineno, end column]
//}
    * 例えば [Object, :foo, 1, 0, 7, 3] は Object#foo は1行目の0桁目から7行目の3桁目までで定義されている、と読みます。
      上記の例では Object#foo は2回実行されています。
    * Note: 互換性のため、Coverage.startにオプションを与えない場合は、ラインカバレッジのみを計測します。
      また Coverage.result も旧フォーマットを返します。
#@samplecode
        Coverage.result
        #=> { "/path/to/file.rb"=> [1, 2, 0, nil, ...] }
#@end

  * [[lib:drb]]
    * [[m:ACL::ACLEntry.new]] は IPAddr::InvalidPrefixError を抑制しなくなりました

  * [[lib:erb]]
    * [[m:ERB#result_with_hash]] を追加。
      ハッシュで与えられたローカル変数とともにテンプレートを描画します。[[feature:8631]]
    * erbコマンドのテンプレートファイルのエンコーディングのデフォルトは、ASCII-8BITからUTF-8に変更されました。
      [[bug:14095]]
    * トリムモードが指定されているときキャリッジリターンを正しくトリムするようにしました。
      Windowsで重複した改行を削除するようになりました。[[bug:5339]] [[bug:11464]]

  * [[lib:ipaddr]]
    * IPAddr は不正なアドレスマスクを受けいれないようになりました [[bug:13399]]
    * [[m:IPAddr#ipv4_compat]], [[m:IPAddr#ipv4_compat?]] は非推奨になりました [[bug:13769]]
    * [[m:IPAddr#prefix]] を追加
    * [[m:IPAddr#loopback?]] を追加
    * [[m:IPAddr#private?]] を追加 [[feature:11666]]
    * [[m:IPAddr#link_local?]] を追加 [[feature:10912]]

  * [[lib:irb]]
    * バックトレースとエラーメッセージを逆順で表示するようにしました [[feature:8661]] [実験的]
    * binding.irb を実行したときに自動的に irb を読み込みます [[bug:13099]] [実験的]
    * binding.irb を実行したときに周囲のソースコードを表示します [[feature:14124]]

  * [[lib:matrix]]
    * [[m:Matrix.combine]], [[m:Matrix#combine]] を追加 [[feature:10903]]
    * [[m:Matrix#hadamard_product]], [[m:Matrix#entrywise_product]] を追加

  * [[lib:net/http]]
    * [[m:Net::HTTP.new]] が no_proxy パラメータをサポートしました [[feature:11195]]
    * [[m:Net::HTTP#min_version]] [[m:Net::HTTP#max_version]] を追加 [[feature:9450]]
    * HTTP status を表すクラスをいくつか追加しました
    * [[m:Net::HTTP::STATUS_CODES]] を追加。HTTPのステータスコードから文字列表現へのハッシュです。 [[misc:12935]]
    * [[m:Net::HTTP#proxy_user]], [[m:Net::HTTP#proxy_pass]] は 環境変数 http_proxy を反映するようになりました。
      ただし、システムの環境変数がマルチユーザーセーフである場合のみ。[[bug:12921]]

  * [[lib:open-uri]]
    * [[m:URI.open]] を open-uri の Kernel.open の別名として追加しました。
      将来 open-uri の Kernel.open は非推奨になります。

  * [[lib:openssl]]
    * Ruby/OpenSSLのバージョンを2.0から2.1に更新しました。変更内容はext/openssl/History.mdの"Version 2.1.0"セクションにあります。

  * [[lib:pathname]]
    * [[m:Pathname#glob]] を追加 [[feature:7360]]

  * Psych
    * Psych 3.0.2 に更新しました
      * Convert fallback option to a keyword argument
        [[url:https://github.com/ruby/psych/pull/342]]
      * Add :symbolize_names option to Psych.load, Psych.safe_load like JSON.parse
        [[url:https://github.com/ruby/psych/pull/333]], [[url:https://github.com/ruby/psych/pull/337]]
      * Add Psych::Handler#event_location
        [[url:https://github.com/ruby/psych/pull/326]]
      * Make frozen string literal = true
        [[url:https://github.com/ruby/psych/pull/320]]
      * Preserve time zone offset when deserializing times
        [[url:https://github.com/ruby/psych/pull/316]]
      * Remove deprecated method aliases for syck gem
        [[url:https://github.com/ruby/psych/pull/312]]

  * [[lib:rbconfig]]
    * [[m:RbConfig::LIMITS]] is added to provide the limits of C types.
      This is available when rbconfig/sizeof is loaded.

  * [[lib:ripper]]
    * [[m:Ripper::EXPR_BEG]] and so on for [[m:Ripper#state]].
    * [[m:Ripper#state]] を追加。スキャナーの状態を伝えるためです。[[feature:13686]]

  * [[lib:rdoc]]
    * RDoc 6.0.1 に更新
      * Replace IRB based lexer with Ripper.
        * [[url:https://github.com/ruby/rdoc/pull/512]]
        * This much improves the speed of generating documents.
        * It also facilitates supporting new syntax in the future.
      * Support many new syntaxes of Ruby from the past few years.
      * Use "frozen_string_literal: true".
        This reduces document generation time by 5%.
      * Support did_you_mean.

  * [[lib:rubygems]]
    * Rubygems 2.7.3 に更新
      * [[url:http://blog.rubygems.org/2017/11/28/2.7.3-released.html]]
      * [[url:http://blog.rubygems.org/2017/11/08/2.7.2-released.html]]
      * [[url:http://blog.rubygems.org/2017/11/03/2.7.1-released.html]]
      * [[url:http://blog.rubygems.org/2017/11/01/2.7.0-released.html]]
      * [[url:http://blog.rubygems.org/2017/10/09/2.6.14-released.html]]
      * [[url:http://blog.rubygems.org/2017/08/27/2.6.13-released.html]]

  * [[lib:securerandom]]
    * [[m:SecureRandom.alphanumeric]] を追加

  * [[lib:set]]
    * [[m:Set#to_s]] を [[m:Set#inspect]] の別名として追加 [[feature:13676]]
    * [[m:Set#===]] を [[m:Set#include?]] の別名として追加 [[feature:13801]]
    * [[m:Set#reset]] [[feature:6589]]

  * [[lib:stringio]]
    * [[m:StringIO#write]] は複数の引数を受け取れるようになりました

  * [[lib:strscan]]
    * [[m:StringScanner#size]], [[m:StringScanner#captures]], [[m:StringScanner#values_at]] を追加  [[feature:836]]

  * [[lib:uri]]
    * Relative path operations no longer collapse consecutive slashes to a single slash. [[bug:8352]]

  * [[lib:webrick]]
    * Server Name Indication (SNI) サポートを追加 [[feature:13729]]
    * [[m:WEBrick::HTTPResponse#send_body_proc]] を追加 [[feature:855]]
    * RubyGem としてリリース [[feature:13173]]
    * 意図しない振舞いを避けるため [[m:Kernel.#open]] を使用するのをやめました [[misc:14216]]

  * [[lib:zlip]]
    * [[m:Zlib::GzipWriter#write]] は複数の引数を受け取れるようになりました

=== 互換性 (機能追加とバグ修正以外)

  * [[c:Socket]]
    * [[m:BasicSocket#read_nonblock]] と [[m:BasicSocket#write_nonblock]] で
      副作用として O_NONBLOCK フラグをセットするのをやめました(Linux のみ)
      [[feature:13362]]

  * [[c:Random]]
    * Random.raw_seed は [[m:Random.urandom]] に名前を変更しました。
      シードを必要としない用途で有用です。[[bug:9569]]

  * [[c:Socket]]
    * [[m:Socket::Ifaddr#vhid]] を追加 [[feature:13803]]

  * [[c:ConditionVariable]], [[c:Queue]], [[c:SizedQueue]] を速度向上のため再実装しました。
    これらのクラスはStructのサブクラスではなくなりました。[[feature:13552]]

=== 標準添付ライブラリの互換性(機能追加とバグ修正を除く)

  * Gemification
    * 以下の標準添付ライブラリをdefault gemsに変更しました
      * cmath
      * csv
      * date
      * dbm
      * etc
      * fcntl
      * fiddle
      * fileutils
      * gdbm
      * ipaddr
      * scanf
      * sdbm
      * stringio
      * strscan
      * webrick
      * zlib

  * Logger
    * Logger.new("| command") は意図せず、コマンドを実行していましたが、禁止されました。
      Logger#initialize の引数は仕様としてファイル名としてのみ扱うようになりました。
      [[bug:14212]]

  * Net::HTTP
    * Net::HTTP#start の第3引数のデフォルト値を :ENV にしました。 [[bug:13351]]
      これを避けるには明示的に nil を与えてください。

  * mathn.rb
    * 標準添付ライブラリから削除しました [[feature:10169]]

  * Rubygems
    * "ubygems.rb" というファイルを標準添付ライブラリから削除しました。Ruby 1.9 から不要でした。

=== C APIの更新

=== Supported platform の変更

  * NaClサポートを削除しました
    * [[url:https://bugs.chromium.org/p/chromium/issues/detail?id=239656#c160]]

=== 実装の改善

  * (これは「ユーザーに見える機能の変更」ではないが) Hashクラスのhashメソッドのアルゴリズムを SipHash13 にしました
    [[feature:13017]]

  * SecureRandom が OpenSSL の提供する乱数ソースよりもOSの提供する乱数ソースを優先するようにしました [[bug:9569]]

  * Mutex をより小さくより速く書き直しました [[feature:13517]]

  * lazy Proc allocation というテクニックでブロックをメソッドの引数として渡したときの性能が向上しました
    [[feature:14045]]

  * TracePointのためにtrace命令の変わりに命令の動的書き換えを使用するようにしました
    [[feature:14104]]

  * ERB がテンプレートから生成するコードはRuby 2.4 よりも2倍速くなりました

=== その他の変更

  * $stderrが変更されておらず出力先がttyの場合、バックトレースとエラーの表示される順序を逆順にしました。
    [[feature:14140]] [実験的]

  * $stderrが変更されておらず出力先がttyの場合、エラーメッセージを太字と下線で装飾するようにしました。
    [[feature:14140]] [実験的]

  * configure オプション --with-ext はその引数を強制できるようになりました。
    例えば ./configure --with-ext=openssl,+ を実行すると、openssl は必ずビルドされた状態になることが保証されます。
    その他の拡張ライブラリは、デフォルトの挙動となります。もし、opensslのビルドに失敗した場合は、全体のビルドが失敗します。
    もし ",+" を末尾に付けない場合は、openssl 以外はビルドされません。[[feature:13302]]
#@end
