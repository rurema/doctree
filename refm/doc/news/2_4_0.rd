#@since 2.4.0
= NEWS for Ruby 2.4.0

このドキュメントは前回リリース以降のバグ修正を除くユーザーに影響のある機能の変更のリストです。

それぞれのエントリーは参照情報があるため短いです。
十分な情報と共に書かれた全ての変更のリストは ChangeLog ファイルか bugs.ruby-lang.org の issue を参照してください。

== 2.3.0 以降の変更

=== 言語仕様の変更

  * 条件式での多重代入ができるようになりました [[feature:10617]]
  * [[m:Symbol#to_proc]] でメソッド呼び出し元での Refinements が有効になりました [[feature:9451]]
  * [[m:Kernel#send]] や [[m:BasicObject#__send__]] でメソッドを呼び出したときに Refinements が有効になりました [[feature:11476]]
  * 後置 rescue をメソッドの引数内に書けるようになりました [[feature:12686]]
  * トップレベルで return を書けるようになりました [[feature:4840]]

=== 組み込みクラスの更新

  * [[c:Array]]
    * [[m:Array#concat]] [[feature:12333]]
      複数の引数を取れるようになりました。
    * [[m:Array#max]], [[m:Array#min]] [[feature:12172]]
      この変更は小さな非互換の原因となります:
      [[m:Enumerable#max]] だけを再定義しているとき、max を配列に対して呼び出しても無視されます。
      このようなときは [[m:Array#max]] も再定義してください。
    * [[m:Array#pack]] [[feature:12754]]
      既にアロケートされているバッファを再利用するためにオプションキーワード引数 buffer: を取るようになりました。
    * [[m:Array#sum]] [[feature:12217]]
      [[m:Enumerable#sum]] と違って each メソッドに依存しません。

  * [[c:Comparable]]
    * [[m:Comparable#clamp]] を追加 [[feature:10594]]

  * [[c:Dir]]
    * [[m:Dir.empty?]] を追加 [[feature:10121]]

  * [[c:Enumerable]]
    * [[m:Enumerable#chunk]] ブロックを省略した場合 [[c:Enumerator]] を返すようになりました。[[feature:2172]]
    * [[m:Enumerable#sum]] を追加 [[feature:12217]]
    * [[m:Enumerable#uniq]] を追加 [[feature:11090]]

  * [[c:Enumerator::Lazy]]
    * [[m:Enumerator::Lazy#chunk_while]] を追加 [[url:https://github.com/ruby/ruby/pull/1186]]
    * [[m:Enumerator::Lazy#uniq]] を追加 [[feature:11090]]

  * [[c:File]]
    * [[m:File.empty?]] を追加 [[feature:9969]]

  * [[c:Float]]
    * [[m:Float#ceil]], [[m:Float#floor]], [[m:Float#truncate]] は
      [[m:Float#round]]と同じように省略可能な桁を指定する引数を受け付けるようになりました。[[feature:12245]]
    * [[m:Float#round]] は half というキーワード引数を受け付けるようになりました。
      half には :even, :up, :down が指定可能です。 [[bug:12548]] [[bug:12958]] [[feature:12953]]

  * [[c:Hash]]
    * [[m:Hash#compact]], [[m:Hash#compact!]] を追加 [[feature:11818]]
    * [[m:Hash#transform_values]] [[m:Hash#transform_values!]] を追加 [[feature:12512]]

  * [[c:Integer]]
    * Fixnum と Bignum は Integer に統合されました [[feature:12005]]
    * [[m:Integer#ceil]], [[m:Integer#floor]], [[m:Integer#truncate]] は
      [[m:Integer#round]] と同じように省略可能な桁を指定する引数を受け付けるようになりました [[feature:12245]]
    * [[m:Integer#digits]] を追加。 [[feature:12447]]
      位置記法のために各桁を展開するためのメソッドです。
    * [[m:Integer#round]] は half というキーワード引数を受け付けるようになりました。
      half には :even, :up, :down が指定可能です。 [[bug:12548]] [[bug:12958]] [[feature:12953]]

  * [[c:IO]]
    * [[m:IO#gets]], [[m:IO#readline]], [[m:IO#each_line]], [[m:IO#readlines]], [[m:IO.foreach]] は
      chomp というキーワード引数を受け付けるようになりました。[[feature:12553]]

  * [[c:Kernel]]
    * [[m:Kernel#clone]] は freeze というキーワード引数を受け付けるようになりました。
      [[feature:12300]]

  * [[c:MatchData]]
    * [[m:MatchData#named_captures]] を追加 [[feature:11999]]
    * [[m:MatchData#values_at]] は named captures をサポートするようになりました [[feature:9179]]

  * [[c:Module]]
    * [[m:Module#refine]] 引数としてモジュールを許可するようになりました [[feature:12534]]
    * [[m:Module.used_modules]] を追加 [[feature:7418]]

  * [[c:Numeric]]
    * [[m:Numeric#finite?]], [[m:Numeric#infinite?]] を追加 [[feature:12039]]

  * [[c:Process]]
    * macOS 10.12 から導入された CLOCK_MONOTONIC_RAW_APPROX, CLOCK_UPTIME_RAW,
      CLOCK_UPTIME_RAW_APPROX をサポートしました

  * [[c:Rational]]
    * [[m:Rational#round]] は half というキーワード引数を受け付けるようになりました。[[bug:12548]] [[bug:12958]]
      half には :even, :up, :down が指定可能です。[[feature:12953]]

  * [[c:Regexp]]
    * meta character \X matches Unicode 9.0 characters with some workarounds
      for UTR #51 Unicode Emoji, Version 4.0 emoji zwj sequences.
    * [[m:Regexp#match?]] を追加 [[feature:8110]]
      true/false を返し、バックリファレンスを生成しません。
    * Onigmo 6.0.0 に更新 (Ruby 2.4.0)
    * Onigmo 6.1.1 に更新 (Ruby 2.4.1)
      * 非包含オペレータをサポートしました [[url:https://github.com/k-takata/Onigmo/issues/82]]

  * [[c:Regexp]]/[[c:String]]: Unicodeのバージョンを8.0.0から9.0.0に更新しました [[feature:12513]]

  * RubyVM::Env
    * 削除しました

  * [[c:String]]
    * [[m:String#casecmp?]] を追加 [[feature:12786]]
    * [[m:String#concat]], [[m:String#prepend]] 複数の引数を受け付けるようになりました [[feature:12333]]
    * [[m:String#each_line]], [[m:String#lines]] 省略可能なキーワード引数 chomp を受け付けるようになりました [[feature:12553]]
    * [[m:String#match?]] を追加 [[feature:12898]]
    * [[m:String#unpack1]] を追加 [[feature:12752]]
    * [[m:String#upcase]], [[m:String#downcase]], [[m:String#capitalize]], [[m:String#swapcase]],
      [[m:String#upcase!]], [[m:String#downcase!]], [[m:String#capitalize!]], [[m:String#swapcase!]]
      は全てのUnicodeに対して動作するようになりました。もはやASCIIのみに限定されていません。
      UTF-8, UTF-16BE/LE, UTF-32BE/LE, ISO-8859-1~16 をサポートしています。
      Variations are available with options. [[feature:10085]]
    * String.new(capacity: size) [[feature:12024]]

  * [[c:StringIO]]
    * [[m:StringIO#gets]], [[m:StringIO#readline]], [[m:StringIO#each_line]], [[m:StringIO#readlines]]
      省略可能なキーワード引数 chomp を受け付けるようになりました [[feature:12553]]

  * [[c:Symbol]]
    * [[m:Symbol#casecmp?]] を追加 [[feature:12786]]
    * [[m:Symbol#match]] は [[c:MatchData]] を返すようになりました [[bug:11991]]
    * [[m:Symbol#match?]] を追加 [[feature:12898]]
    * [[m:Symbol#upcase]], [[m:Symbol#downcase]], [[m:Symbol#capitalize]], [[m:Symbol#swapcase]] は
      全ての Unicode に対して動作するようになりました。[[feature:10085]]

  * [[c:Thread]]
    * [[m:Thread#report_on_exception]], [[m:Thread.report_on_exception]] を追加 [[feature:6647]]

  * [[c:TracePoint]]
    * [[m:TracePoint#callee_id]] を追加 [[feature:12747]]

  * [[c:Warning]]
  * Warningという名前のモジュールを導入しました。
    デフォルトでは [[m:Warning.#warn]] という特異メソッドだけ定義されているモジュールです。
    サードパーティのライブラリが警告を扱う方法を制御できるようになります。
    [[feature:12299]]

=== 標準添付ライブラリの更新 (優れたもののみ)

  * [[lib:cgi]]
    * "," をクッキーの区切り文字として許可しなくなりました [[bug:12791]]

  * [[lib:csv]]
    * liberal_parsing オプションを追加 [[feature:11839]]

  * [[lib:ipaddr]]
    * [[m:IPAddr#==]], [[m:IPAddr#<=>]] で引数のオブジェクトを IPAddr に変換する処理に失敗しても例外が発生しなくなりました
      [[bug:12799]]

  * [[lib:irb]]
    * [[m:Binding#irb]] binding.pryと同じようにREPLのセッションを開始します。r56624.

  * [[lib:logger]]
    * [[m:Logger.new]] のキーワード引数に level, progname, datetime_format, formatter を追加し、
      Loggerインスタンス生成時に属性をセットできるようにしました。 [[feature:12224]]
    * [[m:Logger.new]] のキーワード引数に shift_period_suffix を追加 [[feature:10772]]

  * [[lib:net/http]]
    * [[m:Net::HTTP.post]] を追加 [[feature:12375]]

  * [[lib:net/ftp]]
    * TLSをサポート [[rfc:4217]]
    * [[m:Net::FTP.new]] の引数をキーワード引数に対応しました
    * Add a new optional argument pathname to [[m:Net::FTP#status]] に省略可能なキーワード引数 pathname を追加
      solebox による貢献。[[url:https://github.com/ruby/ruby/pull/1478]] [[feature:12965]]

  * [[lib:openssl]]
    * Ruby/OpenSSL 2.0
      OpenSSL は [[url:https://github.com/ruby/openssl]] に分離されましたが、デフォルトGemとして残っています。

  * [[lib:optparse]]
    * [[m:OptionParser#parse]]や[[m:OptionParser#order]]にキーワード引数 into を追加 [[feature:11191]]

  * [[lib:pathname]]
    * [[m:Pathname#empty?]] を追加 [[feature:12596]]

  * [[lib:readline]]
    * [[m:Readline.quoting_detection_proc]], [[m:Readline.quoting_detection_proc=]] を追加
      [[feature:12659]]

  * [[lib:rexml]]
    * [[m:REXML::Element#[] ]]: If String or Symbol is specified, attribute
      value is returned. Otherwise, Nth child is returned. This is
      backward compatible change.

  * [[lib:set]]
    * [[m:Set#compare_by_identity]], [[m:Set#compare_by_identity?]] を追加
      [[feature:12210]]

  * [[lib:webrick]]
    * "," をクッキーの区切り文字として許可しなくなりました [[bug:12791]]

=== 互換性 (機能追加とバグ修正を除く)

  * [[m:Array#sum]] と [[m:Enumerable#sum]] を追加しました。 [[feature:12217]]
    Ruby2.4以前ではArray#sumはなかったのでRuby自身には互換性の問題はありません。
    しかし、多くのサードパーティ製のGem(activesupport, facets, simple_stats, etc)で
    sumメソッドを定義しています。それらの実装はほとんど互換ですが、微妙な違いがあります。
    Rubyのsumメソッドは概ね互換であるべきですが、全てのサードパーティ製の実装と完全に互換性を保つことは不可能です。

  * FixnumとBignumはIntegerに統合されました。[[feature:12005]]
    FixnumクラスとBignumクラスは削除されました。
    Integerクラスは抽象クラスから具象クラスに変更されました。
    Cレベルの定数 rb_cFixnumとrb_cBignumは削除されました。これらを使用している場合、
    コンパイルエラーになります。
//emlist{
        # 0のクラスはInteger
        0.class # => Integer
        Fixnum  # => Integer
        Bignum  # => Integer

        # 以下の2つは同じ
        obj.kind_of?(Fixnum)
        obj.kind_of?(Integer)

        /* Cレベルでは以下の2つを使ってFixnumとBignumを区別すべき */
        FIXNUM_P(obj)
        RB_TYPE_P(obj, T_BIGNUM)

        /* Cレベルではこの機能を検出するために以下の定数を使います */
        RUBY_INTEGER_UNIFICATION

        # Rubyレベルでは以下のコードでこの機能を検出できます
        0.class == Integer
//}

  * String/Symbol#upcase/downcase/swapcase/capitalize(!) はASCIIだけでなく全てのUnicodeに対して動作するようになりました。[[feature:10085]]
    No change is needed if the data is in ASCII anyway or if the limitation
    to ASCII was only tolerated while waiting for a more extensive implementation.
    :asciiオプションを使うようにする変更が必要なのは、Unicodeのデータを処理するときに、
    ASCIIのみ変換したい場合です。国際化ドメイン名の処理はよい例です。

  * TRUE / FALSE / NIL
    これらは廃止されました。[[feature:12574]]
    true / false / nil を使用してください。

=== 標準添付ライブラリの互換性(機能追加とバグ修正を除く)

  * DateTime
    * [[m:DateTime#to_time]] はタイムゾーンを保つようになりました [[bug:12189]]

  * PSych
    * Psych 2.2.2 に更新

  * RDoc
    * RDoc 5.0.0 に更新

  * RubyGems
    * RubyGems 2.6.8 に更新

  * shellwords
    * [[m:Shellwords.shellwords]] (shellsplit) はダブルクオートの中で
      後続の文字が次の文字の時だけバックスラッシュをエスケープとして
      扱います:
      $ ` " \ <newline>
      [[bug:10055]]
      [[url:http://pubs.opengroup.org/onlinepubs/9699919799/utilities/contents.html]]

  * Time
    * [[m:Time#to_time]] はタイムゾーンを保つようになりました [[bug:12271]]

  * thread
    * the extension library is removed.  Till 2.0 it was a pure ruby script
      "thread.rb", which has precedence over "thread.so", and has been provided
      in $LOADED_FEATURES since 2.1.

  * Tk
    * 標準添付ライブラリから削除されました [[feature:8539]]
      [[url:https://github.com/ruby/tk]] が新しいリポジトリです。

  * XMLRPC
    * 標準添付ライブラリから削除されてbundled Gem になりました [[feature:12160]][[ruby-core:74239]]
      [[url:https://github.com/ruby/xmlrpc]]が新しいリポジトリです。

  * Zlib
    * [[m:Zlib.gzip]], [[m:Zlib.gunzip]] を追加 [[feature:13020]]

=== C API の更新

  * ruby_show_version() will no longer exits the process, if
    RUBY_SHOW_COPYRIGHT_TO_DIE is set to 0.  This will be the default in
    the future.

  * rb_gc_adjust_memory_usage() [Feature #12690]

=== サポートするプラットフォームの変更

  * FreeBSD < 4 はもうサポートしていません

=== 実装の改善

  * いくつかの条件で [x,y].max と [x,y].min が一時的な配列を生成しないよう最適化されました。
    Math.max(x, y) と書くようなほとんどのカジュアルで実際にありそうなユースケースで効果があります。
    具体的な条件は実装の詳細ですが以下の通りです:
    * 配列リテラルに splat が含まれないこと
    * must have at least one expression but literal
    * 配列の長さが0x100(256)以下であること
    * Array#max や Array#min が再定義されていないこと

  * スレッドのデッドロックを検知するとバックトレースと依存関係を出力します [[feature:8214]]

  * st_table (st.c) 内部のデータ構造が改善されました [[feature:12142]]

  * Rational は大幅に最適化されました [[feature:12484]]

=== その他の変更

  * ChangeLogファイルはリポジトリから削除されました。
    Subversion にあるコミットメッセージから make dist によって生成されます。
    人々はGitスタイルのコミットメッセージに従うべきです。
    以下を参照してください。[[url:https://git-scm.com/book/ch5-2.html]]
    [[feature:12283]]
#@end
