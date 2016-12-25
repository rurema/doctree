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
    * [[m:Integer#ceil]], [[m:Integer#floor]], [[m:Integer#truncate]] はnow take an optional
      [[m:Integer#round]] と同じように省略可能な桁を指定する引数を受け付けるようになりました [[feature:12245]]
    * [[m:Integer#digits]] を追加。 [[feature:12447]]
      位置記法のために各桁を展開するためのメソッドです。
    * [[m:Integer#round]] は half というキーワード引数を受け付けるようになりました。
      half には :even, :up, :down が指定可能です。 [[bug:12548]] [[bug:12958]] [[feature:12953]]

  * [[c:IO]]
    * [[m:IO#gets]], [[m:IO#readline]], [[m:IO#each_line]], [[m:IO#readlines]], [[m:IO.foreach]] は
      chopm というキーワード引数を受け付けるようになりました。[[feature:12553]]

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
    * Support CLOCK_MONOTONIC_RAW_APPROX, CLOCK_UPTIME_RAW, and
      CLOCK_UPTIME_RAW_APPROX which are introduced by macOS 10.12.

* Rational

  * Rational#round now takes an optional keyword argument, half option, and
    the default behavior is round-up now.  [Bug #12548] [Bug #12958]
    half option can be one of :even, :up, and :down.  [Feature #12953]

* Regexp

  * meta character \X matches Unicode 9.0 characters with some workarounds
    for UTR #51 Unicode Emoji, Version 4.0 emoji zwj sequences.

  * Regexp#match? [Feature #8110]
    This returns bool and doesn't save backref.

  * Update Onigmo 6.0.0.

* Regexp/String: Updated Unicode version from 8.0.0 to 9.0.0 [Feature #12513]

* RubyVM::Env

  * RubyVM::Env was removed.

* String

  * String#casecmp? [Feature #12786]

  * String#concat, String#prepend [Feature #12333]
    Now takes multiple arguments.

  * String#each_line, String#lines now takes an optional keyword argument,
    chomp flag.  [Feature #12553]

  * String#match? [Feature #12898]

  * String#unpack1 [Feature #12752]

  * String#upcase, String#downcase, String#capitalize, String#swapcase and
    their bang variants work for all of Unicode, and are no longer limited
    to ASCII. Supported encodings are UTF-8, UTF-16BE/LE, UTF-32BE/LE, and
    ISO-8859-1~16. Variations are available with options. See the documentation
    of String#downcase for details. [Feature #10085]

  * String.new(capacity: size) [Feature #12024]

* StringIO

  * StringIO#gets, StringIO#readline, StringIO#each_line, StringIO#readlines now takes
    an optional keyword argument, chomp flag.  [Feature #12553]

* Symbol

  * Symbol#casecmp? [Feature #12786]

  * Symbol#match now returns MatchData.  [Bug #11991]

  * Symbol#match? [Feature #12898]

  * Symbol#upcase, Symbol#downcase, Symbol#capitalize, and Symbol#swapcase now
    work for all of Unicode. See the documentation of String#downcase
    for details. [Feature #10085]

* Thread

  * Thread#report_on_exception and Thread.report_on_exception
    [Feature #6647]

* TracePoint

  * TracePoint#callee_id [Feature #12747]

* Warning

  * New module named Warning is introduced.  By default it has only
    one singleton method, named warn.  This makes it possible for
    3rd-party libraries to control the way warnings are handled.
    [Feature #12299]

=== Stdlib updates (outstanding ones only)

* CGI

  * Don't allow , as a separator [Bug #12791]

* CSV

  * Add a liberal_parsing option. [Feature #11839]

* IPAddr

  * IPAddr#== and IPAddr#<=> no longer raise an exception if coercion fails.
    [Bug #12799]

* IRB

  * Binding#irb: Start a REPL session like `binding.pry` at r56624.

* Logger

  * Allow specifying logger parameters in constructor such
    as level, progname, datetime_format, formatter. [Feature #12224]
  * Add shift_period_suffix option. [Feature #10772]

* Net::HTTP

  * New method: Net::HTTP.post [Feature #12375]

* Net::FTP

  * Support TLS (RFC 4217).
  * Support hash style options for Net::FTP.new.
  * Add a new optional argument pathname to Net::FTP#status.
    Contributed by soleboxy. [GH-1478] [Feature #12965]

* OpenSSL

  * Includes Ruby/OpenSSL 2.0. OpenSSL has been extracted as a Gem and is
    maintained at a separate repository now: https://github.com/ruby/openssl.
    It still remains as a 'default gem'.  [Feature #9612]
    Refer to ext/openssl/History.md for the full release note.

* optparse

  * Add an into option. [Feature #11191]

* pathname

  * New method: Pathname#empty? [Feature #12596]

* Readline

  * Readline.quoting_detection_proc and Readline.quoting_detection_proc=
    [Feature #12659]

* REXML

  * REXML::Element#[]: If String or Symbol is specified, attribute
    value is returned. Otherwise, Nth child is returned. This is
    backward compatible change.

* set

  * New methods: Set#compare_by_identity and Set#compare_by_identity?.
    [Feature #12210]

* WEBrick

  * Don't allow , as a separator [Bug #12791]

=== Compatibility issues (excluding feature bug fixes)

* Array#sum and Enumerable#sum are implemented.  [Feature #12217]
  Ruby itself has no compatibility problem because Ruby didn't have sum method
  for arrays before Ruby 2.4.
  However many third party gems, activesupport, facets, simple_stats, etc,
  defines sum method.  These implementations are mostly compatible but
  there are subtle differences.
  Ruby's sum method should be mostly compatible but it is impossible to
  be perfectly compatible with all of them.

* Fixnum and Bignum are unified into Integer  [Feature #12005]
  Fixnum class and Bignum class is removed.
  Integer class is changed from abstract class to concrete class.
  For example, 0 is an instance of Integer: 0.class returns Integer.
  The constants Fixnum and Bignum is bound to Integer.
  So obj.kind_of?(Fixnum) works as obj.kind_of?(Integer).
  At C-level, Fixnum object and Bignum object should be distinguished by
  FIXNUM_P(obj) and RB_TYPE_P(obj, T_BIGNUM).
  RUBY_INTEGER_UNIFICATION can be used to detect this feature at C-level.
  0.class == Integer can be used to detect this feature at Ruby-level.
  The C-level constants, rb_cFixnum and rb_cBignum, are removed.
  They can cause compilation failure.

* String/Symbol#upcase/downcase/swapcase/capitalize(!) now work for all of
  Unicode, not only for ASCII. [Feature #10085]
  No change is needed if the data is in ASCII anyway or if the limitation
  to ASCII was only tolerated while waiting for a more extensive implementation.
  A change (using the :ascii option) is needed in cases where Unicode data
  is processed, but the operation has to be limited to ASCII only.
  A good example of this are internationalized domain names.

* TRUE / FALSE / NIL
  These constants are now obsoleted. [Feature #12574]
  Use true / false / nil resp. instead.

=== Stdlib compatibility issues (excluding feature bug fixes)

* DateTime

  * DateTime#to_time now preserves timezone.  [Bug #12189]

* PSych

  * Update Psych 2.2.2

* RDoc

  * Update RDoc 5.0.0

* RubyGems

  * Update RubyGems 2.6.8

* shellwords

  * Shellwords.shellwords (shellsplit) treats the backslash as escape
    character only when followed by one of the following characters:
    $ ` " \ <newline>
    [Bug #10055]

* Time

  * Time#to_time now preserves timezone.  [Bug #12271]

* thread

  * the extension library is removed.  Till 2.0 it was a pure ruby script
    "thread.rb", which has precedence over "thread.so", and has been provided
    in $LOADED_FEATURES since 2.1.

* Tk

  * Tk is removed from stdlib.  [Feature #8539]
    https://github.com/ruby/tk is the new upstream.

* XMLRPC

  * XMLRPC is removed from stdlib, and bundled as gem. [Feature #12160][ruby-core:74239]
    https://github.com/ruby/xmlrpc is the new upstream.

* Zlib

  * Zlib.gzip and Zlib.gunzip [Feature #13020]

=== C API updates

* ruby_show_version() will no longer exits the process, if
  RUBY_SHOW_COPYRIGHT_TO_DIE is set to 0.  This will be the default in
  the future.

* rb_gc_adjust_memory_usage() [Feature #12690]

=== Supported platform changes

* FreeBSD < 4 is no longer supported

=== Implementation improvements

* In some condition, `[x, y].max` and `[x, y].min` are optimized
  so that a temporal array is not created.  The concrete condition is
  an implementation detail: currently, the array literal must have no
  splat, must have at least one expression but literal, the length must
  be <= 0x100, and Array#max and min must not be redefined.  It will work
  in most casual and real-life use case where it is written with intent
  to `Math.max(x, y)`.

* Thread deadlock detection now shows their backtrace and dependency. [Feature #8214]

* st_table (st.c) internal data structure is improved. [Feature #12142]

* Rational is extensively optimized. [Feature #12484]

=== Miscellaneous changes

* ChangeLog is removed from the repository.
  It is generated from commit messages in Subversion by `make dist`.
  Also note that now people should follow Git style commit message.
  The template is written at
  [Short (50 chars or less) summary of changes](https://git-scm.com/book/ch5-2.html).
  [Feature #12283]
#@end
