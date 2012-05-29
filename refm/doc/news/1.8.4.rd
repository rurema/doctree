= ruby 1.8.4 feature

ruby 1.8.4 での ruby 1.8.3 からの変更点です。

掲載方針

*バグ修正の影響も含めて動作が変わるものを収録する。
*単にバグを直しただけのものは収録しない。
*ライブラリへの単なる定数の追加は収録しない。

以下は各変更点に付けるべきタグです。

記号について(特に重要なものは大文字(主観))

# * カテゴリ
#   * [ruby]: ruby インタプリタの変更
#   * [api]: 拡張ライブラリ API
#   * [lib]: ライブラリ
* レベル
  * [bug]: バグ修正
  * [new]: 追加されたクラス／メソッドなど
  * [compat]: 変更されたクラス／メソッドなど
    * 互換性のある変更
    * only backward-compatibility
    * 影響の範囲が小さいと思われる変更もこちら
  * [change]: 変更されたクラス／メソッドなど(互換性のない変更)
  * [obsolete]: 廃止された(される予定の)機能
  * [platform]: 対応プラットフォームの追加

== 目次

* ((<ruby 1.8.4 feature/Ruby本体>))
  * ((<ruby 1.8.4 feature/Symbol [bug]>))
  * ((<ruby 1.8.4 feature/Symbol [bug]>))
  * ((<ruby 1.8.4 feature/super [bug]>))
  * ((<ruby 1.8.4 feature/正規表現 [bug]>))
  * ((<ruby 1.8.4 feature/シグナル [bug]>))
* ((<ruby 1.8.4 feature/組み込みライブラリ>))
  * ((<ruby 1.8.4 feature/UnboundMethod#bind [bug]>))
  * ((<ruby 1.8.4 feature/set_trace_func [bug]>))
  * ((<ruby 1.8.4 feature/set_trace_func [change]>))
  * ((<ruby 1.8.4 feature/printf [bug]>))
  * ((<ruby 1.8.4 feature/Hash [bug]>))
  * ((<ruby 1.8.4 feature/test [bug]>))
  * ((<ruby 1.8.4 feature/File.identical? [new]>))
  * ((<ruby 1.8.4 feature/FileTest.identical? [new]>))
  * ((<ruby 1.8.4 feature/File.split [change]>))
  * ((<ruby 1.8.4 feature/File.basename [change]>))
  * ((<ruby 1.8.4 feature/File.dirname [change]>))
  * ((<ruby 1.8.4 feature/Dir.glob (Win全般) [bug]>))
  * ((<ruby 1.8.4 feature/File.basename (Win全般) [change]>))
  * ((<ruby 1.8.4 feature/File.dirname (Win全般) [bug]>))
  * ((<ruby 1.8.4 feature/File::Stat#pipe? [bug]>))
  * ((<ruby 1.8.4 feature/Array#fill [bug]>))
  * ((<ruby 1.8.4 feature/String#scan [bug]>))
  * ((<ruby 1.8.4 feature/File.join [bug]>))
  * ((<ruby 1.8.4 feature/Thread#pass [bug]>))
  * ((<ruby 1.8.4 feature/Module#const_missing [bug]>))
  * ((<ruby 1.8.4 feature/IO [bug]>))
* ((<ruby 1.8.4 feature/添付ライブラリ>))
  * ((<ruby 1.8.4 feature/"Ruby/Tk">))
  * ((<ruby 1.8.4 feature/REXML [compat]>))
  * ((<ruby 1.8.4 feature/TCPSocket#initialize [bug]>))
  * ((<ruby 1.8.4 feature/TCPServer#initialize [bug]>))
  * ((<ruby 1.8.4 feature/"optparse">))
  * ((<ruby 1.8.4 feature/"find">))
  * ((<ruby 1.8.4 feature/Iconv>))
  * ((<ruby 1.8.4 feature/WEBrick::Config::FileHandler [compat]>))
  * ((<ruby 1.8.4 feature/WEBrick>))
  * ((<ruby 1.8.4 feature/WEBrick::HTTPRequest#query_string= [new]>))
  * ((<ruby 1.8.4 feature/Readline [bug]>))
  * ((<ruby 1.8.4 feature/Syck [bug]>))
  * ((<ruby 1.8.4 feature/irb [bug]>))
  * ((<ruby 1.8.4 feature/RDoc [bug]>))
  * ((<ruby 1.8.4 feature/Win32API [bug]>))
  * ((<ruby 1.8.4 feature/Rinda [bug]>))
  * ((<ruby 1.8.4 feature/Iconv [compat]>))
  * ((<ruby 1.8.4 feature/cgi [bug]>))
  * ((<ruby 1.8.4 feature/DL [bug]>))
  * ((<ruby 1.8.4 feature/fileutils [bug]>))
  * ((<ruby 1.8.4 feature/extmk, mkmf [compat]>))
  * ((<ruby 1.8.4 feature/mkmf: find_executable() [compat]>))
* ((<ruby 1.8.4 feature/拡張ライブラリAPI>))
  * ((<ruby 1.8.4 feature/rb_funcall2() [bug]>))
  * ((<ruby 1.8.4 feature/rb_respond_to() [change]>))
  * ((<ruby 1.8.4 feature/rb_obj_respond_to() [new]>))
* ((<ruby 1.8.4 feature/プラットフォーム固有>))
  * ((<ruby 1.8.4 feature/bccwin32 [bug]>))
  * ((<ruby 1.8.4 feature/cygwin [bug]>))
  * ((<ruby 1.8.4 feature/BeOS [bug]>))
  * ((<ruby 1.8.4 feature/Sun [bug]>))
  * ((<ruby 1.8.4 feature/IA64 [bug]>))

== Ruby本体

: Symbol [bug]

#       * parse.y (dsym): prohibit empty symbol literal by interpolation.
#         fixed: [ruby-talk:166529]

    式展開で空のSymbolを作ることができたバグの修正。 ((<ruby-talk:166529>))

        p :""

        # => ruby 1.8.3 (2005-09-21) [i686-linux]
             -:1: empty symbol literal
        # => ruby 1.8.4 (2005-12-16) [i686-linux]
             -:1: empty symbol literal

        p :"#{""}"

        # => ruby 1.8.3 (2005-09-21) [i686-linux]
             :
        # => ruby 1.8.4 (2005-12-16) [i686-linux]
             -:1: empty symbol literal

: Symbol [bug]

#Sat Oct 22 13:26:57 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * object.c (sym_inspect), parse.y (parser_yylex, rb_symname_p): check
#         if valid as a symbol name more strictly.  [ruby-dev:27478]
#
#       * test/ruby/test_symbol.rb: tests for [ruby-core:03573].

    Symbolに適合する文字列を厳密にした。((<ruby-core:03573>)),((<ruby-dev:27478>))

        1) alias :"foo" :"bar"

            def bar; p "bar"; end
            alias :"foo" :"bar"
            foo

            # => ruby 1.8.4 (2005-12-22) [i686-linux]
                 -:2: syntax error, unexpected tSTRING_CONTENT
                     alias :"foo" :"bar"
                                ^
                 -:2: warning: unused literal ignored
            # => ruby 1.9.0 (2005-12-10) [i686-linux]
                 "bar"


        2) Symbol#inspect sometimes returns invalid symbol representations:

            puts :"!".inspect
            puts :"=".inspect
            puts :"0".inspect
            puts :"$1".inspect
            puts :"@1".inspect
            puts :"@@1".inspect
            puts :"@".inspect
            puts :"@@".inspect

            # => ruby 1.8.3 (2005-09-21) [i686-linux]
                 :!
                 :=
                 :0
                 :$1
                 :@1
                 :@@1
                 :@
                 :@@
            # => ruby 1.8.4 (2005-12-22) [i686-linux]
                 :"!"
                 :"="
                 :"0"
                 :$1
                 :"@1"
                 :"@@1"
                 :"@"
                 :"@@"

        3) Symbol#inspect sometimes returns suboptimal symbol representations:
            puts :foo!.inspect
            puts :bar?.inspect

            # => ruby 1.8.3 (2005-09-21) [i686-linux]
                 :"foo!"
                 :"bar?"
            # => ruby 1.8.4 (2005-12-22) [i686-linux]
                 :foo!
                 :bar?

        4) :$- always treats next character literally:

            p eval(":$-\n") # => :"$-\n"
            p :$-( # => :"$-("
            p :$-  # => :"$- "
            p :$-#.object_id # => 3950350

            # => ruby 1.8.3 (2005-09-21) [i686-linux]
                 :"$-\n"
                 :"$-("
                 :"$- "
                 2631438

            # => ruby 1.8.4 (2005-12-22) [i686-linux]
                 -:2: syntax error, unexpected '(', expecting $end

#Tue Nov  1 14:20:11 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * eval.c (rb_call_super): should call method_missing if super is
#         called from Kernel method.
#
#       * eval.c (exec_under): frame during eval should preserve external
#         information.

: super [bug]

    Kernelのメソッド内でsuperを呼んだ時に、存在しないsuperclass
    にアクセスしようとするバグの修正。

        module Kernel
          def foo
            super
          end
        end

        foo

        # => ruby 1.8.3 (2005-09-21) [i686-linux]
             -:3:in `foo': method `foo' called on terminated object (0xb7e06970) (NotImplementedError)
                from -:7
        # => ruby 1.8.4 (2005-12-22) [i686-linux]
             -:3:in `foo'-:3: warning: too many arguments for format string
             : super: no superclass method `foo' (NoMethodError)
                from -:7

: 正規表現 [bug]

#Wed Oct 19 01:27:07 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * regex.c (re_compile_pattern): numeric literal inside character class
#         disabled succeeding backtrack.  fixed: [ruby-list:41328]

    文字コードの形で正規表現の文字クラスを指定すると、それ以降の
    バックトラックが効かなくなるバグの修正。((<ruby-list:41328>))

        p(/^[a-z]+x[0-9]+$/ =~ "hogex111")
        p(/^[\x61-\x7a]+x[0-9]+$/ =~ "hogex111")

        # => ruby 1.8.3 (2005-09-21) [i686-linux]
             0
             nil
        # => ruby 1.8.4 (2005-12-22) [i686-linux]
             0
             0

: シグナル [bug]

#Sun Oct 16 03:38:07 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * rubysig.h (CHECK_INTS): prevent signal handler to run during
#         critical section.  [ruby-core:04039]

    シグナルハンドラの実行はクリティカルセクションが終了するまで
    遅延されるようになりました。((<ruby-core:04039>))

== 組み込みライブラリ

#Thu Dec  8 02:07:19 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * eval.c (umethod_bind): adjust invoking class for module method.
#         [ruby-dev:27964]

: UnboundMethod#bind [bug]

    UnboundMethod#bindされたモジュールのインスタンスメソッド中で
    superを使えなかったバグを修正しました。((<ruby-dev:27964>))

        module Foo
          def initialize
            super
          end
        end

        class Bar
          include Foo
          def initialize
            Foo.instance_method(:initialize).bind(self).call
          end
        end

        Bar.new

        # => ruby 1.8.3 (2005-09-21) [i686-linux]
             -:3:in `initialize': method `initialize' called on terminated object (0xb7dd2bec) (NotImplementedError)
                from -:10:in `initialize'
                from -:14
        # => ruby 1.8.4 (2005-12-16) [i686-linux]

: set_trace_func [bug]

#Thu Dec  8 00:40:52 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * eval.c (call_trace_func): klass parameter should be a
#         class/module that defines calling method.  [ruby-talk:169307]
#

    クラスメソッドの実行時に、定義されたクラスではなくメタクラスが
    traceに渡されていたバグの修正。((<ruby-talk:169307>))

: set_trace_func [change]

#Mon Sep 26 22:32:13 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * eval.c (set_trace_func): add rb_secure(4) to prevent adding
#         tracing function.

    $SAFE=4でtrace_funcの追加を禁止。

: printf [bug]

#Wed Dec  7 15:31:35 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * sprintf.c (rb_str_format): integer overflow check added.
#
#       * sprintf.c (GETASTER): ditto.

    printfのフォーマット指定子にinteger overflowのバグがありました。
    perl のそれとは違い、セキュリティバグはないそうです。
    ((<URL:http://www.rubyist.net/~matz/20051207.html#p01>))

        # ruby 1.8.4 (2005-12-01) [i686-linux]

        # ArgumentError
        printf("%2147483648$d\n")       # -e:1:in `printf': invalid index - -2147483648$ (ArgumentError)
        printf("%2147483649$d\n")       # -e:1:in `printf': invalid index - -2147483647$ (ArgumentError)
        printf("%4294967296$d\n")       # -e:1:in `printf': invalid index - 0$ (ArgumentError)

        # overflow
        printf("%4294967297$d\n", 1)    # 1
        printf("%4294967298$d\n", 1, 2) # 2

        # 1.8.4 では、上記例はすべて以下のエラーになります。
        # %xx$ に指定できる最大値は 2147483647 です。
        # -e:1:in `printf': width too big (ArgumentError)

: Hash [bug]

#Wed Nov 23 03:40:49 2005  Guy Decoux  <ts@moulon.inra.fr>
#
#       * re.c (KR_REHASH): should cast to unsigned for 64bit CPU.
#         [ruby-core:06721]

    sizeof(long) > sizeof(int) な環境で、ハッシュ関数のオーバー
    フローのためにStringをキーとしたHashの検索が失敗していたバグの修正。
    ((<ruby-core:06721>))

: test [bug]

#Wed Nov 23 01:22:57 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * file.c (test_identical): test if two files are identical.
#
#       * file.c (rb_f_test): support DOSISH systems where st_ino is not
#         reliable.  fixed: [ruby-core:06672]
#
#       * win32.h, win32.c (rb_w32_osid): check the running platform.

    i-nodeを持たないシステム(Windows等)でtest(?-, ...)が常にtrueを返し
    ていたバグを修正。((<ruby-core:06672>))

: File.identical? [new]
: FileTest.identical? [new]

    test(?-, ...) の代替メソッドとして追加。

: File.split [change]
: File.basename [change]
: File.dirname [change]

#Tue Nov 22 14:46:57 2005  NAKAMURA Usaku  <usa@ruby-lang.org>
#
#       * file.c (rb_file_s_basename): skip slashes just after UNC top slashes.
#
#       * test/ruby/test_path.rb (test_dirname, test_basename): follow new
#         spec. and add new tests.

    UNCパスに対するFile.dirname・File.basename・File.splitの仕様
    を変更した(UNCをサポートするプラットフォームのみ)。

      File.split("//aaa")      #=> old: ["//", "aaa"]  new:["//aaa", "/"]
      File.split("//aaa/")     #=> old: ["//", "aaa"]  new:["//aaa", "/"]
      File.split("//aaa/bbb")  #=> old:["//aaa", "bbb"]  new:["//aaa/bbb", "/"]
      File.split("//aaa/bbb/") #=> old:["//aaa", "bbb"]  new:["//aaa/bbb", "/"]
      File.split("///aaa")     #=> old:["//", "aaa"]  new:["//aaa", "/"]

: Dir.glob (Win全般) [bug]

#Tue Nov 22 13:18:32 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * win32/win32.c (rb_w32_stat): Dir.chdir('//server/shared');
#         p Dir.glob('*') should work on WinNT. (implemented our own
#         stat(2) on WinNT) [ruby-list:41552] [ruby-dev:27711]
#

    共有フォルダの共有名に対する Dir.glob が失敗していたのを修正。（こ
    れはWinNT における、ランタイムライブラリの stat のバグだと思う）自
    前で stat を実装することで回避した。((<ruby-list:41552>)),((<ruby-dev:27711>))

: File.basename (Win全般) [change]

#Tue Nov 22 01:45:21 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * file.c (rb_file_s_basename): DOSISH_UNC is defined on cygwin but
#         DOSISH is not.  fixed: [ruby-dev:27797]

    不完全なUNCを分割しないようにした。((<ruby-dev:27797>))

: File.dirname (Win全般) [bug]

#Fri Nov 18 17:26:06 2005  NAKAMURA Usaku  <usa@ruby-lang.org>
#
#       * file.c (rb_file_s_dirname): added checks for some patterns with drive
#         letter. fixed: [ruby-dev:27738]
#
#       * test/ruby/test_path.rb (test_dirname): added tests for above
#         patterns.

    ドライブレターを含むパスに対するFile.dirnameの問題を修正した
    (ドライブレターをサポートするプラットフォームのみ)。((<ruby-dev:27738>))

      File.dirname("C:a/b")  #=> old: "C:a."  new: "C:a"
      File.dirname("C:a///") #=> old: "C:a///"  new: "C:a"

: File::Stat#pipe? [bug]

#Fri Nov 18 12:18:02 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * win32/win32.h (S_IFIFO): r,w = IO.pipe; r.stat.pipe? now
#         returns true on VisualC++6.

    VisualC++ 6 では S_IFIFO がなく _S_IFIFO しか定義されていないため、
    パイプに対する stat.pipe? が false を返していたのを修正。

: Array#fill [bug]

#Tue Nov 15 14:39:16 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * array.c (rb_ary_fill): should adjust array length correctly when
#         an array is expanded in the fill process.  [ruby-core:06625]

    Arrayに対してfillとpopを繰り返すとSEGVするバグを修正しました。((<ruby-core:06625>))

: String#scan [bug]

#Thu Oct 27 16:45:31 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * string.c (scan_once): wrong condition to use mbclen2().
#         [ruby-dev:27535]

    String#scanで、全角文字に「*」(0回以上の繰り返し)を付けると、空
    文字列にマッチしたときの次の文字が多バイト文字のときにマッチの
    開始位置がずれることがあるバグの修正。((<ruby-dev:27535>))
# であってるのかな?

: File.join [bug]

#Wed Oct 19 08:28:32 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * file.c (rb_file_join): elements may contain null pointer strings.
#         report and fixed by Lloyd Zusman (hippoman): [ruby-core:06326]

    NULLポインタを持つStringを渡すとFile.joinがSEGVすることがあった
    バグの修正。((<ruby-core:06326>))

: Thread#pass [bug]

#Sun Oct 16 03:38:07 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * eval.c (load_wait): need not to call rb_thread_schedule()
#         explicitly.  [ruby-core:04039]
#
#       * eval.c (rb_thread_schedule): clear rb_thread_critical.
#         [ruby-core:04039]

    Thread#passを呼ぶとThread.criticalがクリアされるようになりました。
    ((<ruby-core:04039>))

: Module#const_missing [bug]

#Thu Sep 29 00:57:35 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * eval.c (ev_const_get), variable.c (rb_const_get_0): retry only when
#         autoload succeeded.
#
#       * variable.c (rb_autoload_load): now return true if autoload
#         succeeded.  fixed: [ruby-dev:27331]

    const_missingが再定義されていて実行を継続した場合にSEGVする可能性
    があったバグの修正。((<ruby-dev:27331>))

: IO [bug]

#Wed Sep 28 08:12:18 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * io.c (read_buffered_data): check if reached EOF.  fixed: [ruby-dev:27334]

    Solaris(64bit?)などでEOF後にゴミを読み出すことがあったバグを修正。
    ((<ruby-dev:27334>))

== 添付ライブラリ

: Ruby/Tk

    * 対応バージョン

       Tcl7.6/Tk4.2, Tcl/Tk8.0 〜 8.4.12, Tcl/Tk8.5a1 〜 a3

       Tcl/Tk 拡張ライブラリについては

          ActiveTcl8.4.12.0 またはそれ以前
          ( beta 版 は ActiveTcl8.5.0.0b4 またはそれ以前 )

       に含まれるものに対応しています．

       対応している Tcl/Tk 拡張の種類とバージョンとは
          ext/tk/lib/tkextlib/SUPPPORT_STATUS
            または
          <installed lib dir>/tkextlib/SUPPORT_STATUS
       を参照してください．

       ただし，Tcl/Tk 拡張のバージョンの記述は，対応を行った最新の
       ものを示していますので，記述された以前のバージョンであっても，
       極端に古くない限りは対応できているはずです．

       各ライブラリへの対応のための変更履歴は
          ext/tk/ChangeLog.tkextlib
       を参照してください．

    * サンプルスクリプト

       : ext/tk/sample/scrollframe.rb [new]

          配置したウィジェットの表示範囲をスクロールすることが
          できるようなスクロールバー付きフレームウィジェットク
          ラスのサンプル兼ライブラリ

#Wed Dec  7 01:02:04 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tk/README.macosx-aqua: [new document] tips to avoid the known
#         bug on platform specific dialogs of Tcl/Tk Aqua on MacOS X.

    MacOS X 上で Aqua 版の Tcl/Tk を用いた際，Aqua 特有のダイアログ表示で
    フリーズしてしまうという known bug の回避策を記載したドキュメント
    (ext/tk/README.macosx-aqua) が追加されました．

#Wed Dec  7 01:02:04 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tk/tcltklib.c: fix bug on switching threads and waiting on the
#         deleted interpreter on vwait and tkwait command.

    削除された Tk インタープリタに対して vwait や tkwait での処理待ちを
    終了せずに待ち続けてしまう可能性があるというバグを修正しました．

#
#       * ext/tk/lib/multi-tk.rb: kill the meaningless loop for the deleted Tk
#         interpreter.

    MultiTkIp で生成した Tk インタープリタを削除した後も，
    不要となったはずのスレッドが動き続けるバグを修正しました．

#Wed Nov 23 20:59:01 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tk/lib/tk.rb: add Tk.pkgconfig_list and Tk.pkgconfig_get
#         [Tk8.5 feature].
#
#       * ext/tk/lib/tk/text.rb: supports new indices modifires on a Text
#         widget [Tk8.5 feature].
#

    Tcl/Tk8.5a3 への対応のため，Tk.pkgconfig_list および Tk.pkgconfig_get
    が追加されました．
    同様に Tcl/Tk8.5a3 への対応のため，テキストウィジェット上のインデック
    ス指定における新しい modifier である indices に対応しました．

#       * ext/tk/lib/tk/virtevent.rb: add TkNamedVirtualEvent.
#

    Tcl/Tk 上で名前が規定されている仮想イベントの指定した仮想イベントオブ
    ジェクトの生成を少し容易にするため，TkNamedVirtualEvent が別名として
    定義されました．

#       * ext/tk/lib/tk/event.rb: add :data key for virtual events [Tk8.5
#         feature].
#

    Tcl/Tk8.5 への対応のため，仮想イベントのイベント情報の一つである data
    キーの情報を :data で指定できるようになりました．

#Fri Nov 18 17:35:09 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tk/lib/multi-tk.rb: add restriction to access the entried
#         command table and manipulate other IPs (for reason of security).
#         Now, a IP object can be controlled by only its master IP or the
#         default IP.
#
#       * ext/tk/lib/remote-tk.rb: add restriction to manipulate.
#
#       * ext/tk/tcltklib.c (ip_is_slave_of_p): add TclTkIp#slave_of?(ip)
#         to check manipulability.
#

    セキュリティ上の問題を回避するため，MultiTkIp において IP オブジェクト
    上での操作が許可されるのは，その操作を呼び出した環境 (スレッド) の IP 
    オブジェクトがデフォルトの IP オブジェクト (デフォルトのスレッドグルー
    プに属するもの．require 'multi-tk' の際に生成される) であるか，操作し
    ようとしている IP オブジェクトが自らの直接の slave IP であるかの場合に
    限られるようになりました．

    この修正により，IP オブジェクトの入手に成功することで，ある IP が権限
    を持たないはずの他の IP を操作できてしまう危険を減少させます．ただし，
    ObjectSpace にアクセスし，直接に TclTkIp オブジェクトを取り出して操作
    されることは回避できませんので，ご注意ください。

#       * ext/tk/lib/tk.rb: bug fix on handling of Tcl's namespaces.
#
#       * ext/tk/lib/tk/namespace.rb: ditto.
#

    Tcl/Tk 上の namespace の扱いが正常に行えないというバグを修正しました．

#Wed Nov  2 20:14:53 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tcltklib: merge into ext/tk and remove.
#

    Ruby のソース上で tcltklib と tk とを Ruby 1.9 系と同様に一体化しました． 
    これにより，tcltklib の生成に失敗した環境で，動くはずのない tk のライ
    ブラリファイル群がインストールされてしまうことが避けられます．
    今後はソースに含まれる tcltklib 関連のドキュメントを参照する場合には
    ext/tk ディレクトリの下を見てください．

#Wed Nov  2 19:03:06 2005  Hidetoshi NAGAI  <nagai@ai.kyutech.ac.jp>
#
#       * ext/tcltklib/tcltklib.c (ip_rbUpdateObjCmd,
#         ip_rb_threadUpdateObjCmd): passed improper flags to DoOneEvent().
#
#       * ext/tk/tkutil.c: use rb_obj_respond_to() instead of rb_respond_to().
#

    update 処理が不適切であるために，一部の環境で menubar のメニュー項目に
    登録した処理が実行されない場合があるというバグ (ruby-1.8.3 で enbug し
    ていたもの) を修正しました．

#       * ext/tk/lib/tk.rb, ext/tk/lib/tk/canvas.rb, ext/tk/lib/tk/entry.rb,
#         ext/tk/lib/tk/frame.rb, ext/tk/lib/tk/image.rb,
#         ext/tk/lib/tk/itemconfig.rb, ext/tk/lib/tk/labelframe.rb,
#         ext/tk/lib/tk/listbox.rb, ext/tk/lib/tk/menu.rb,
#         ext/tk/lib/tk/radiobutton.rb, ext/tk/lib/tk/scale.rb,
#         ext/tk/lib/tk/spinbox.rb, ext/tk/lib/tk/text.rb,
#         ext/tk/lib/tk/toplevel.rb: improve conversion of option values.
#
#       * ext/tk/lib/tkextlib/*: ditto.
#

    ウィジェットオブジェクトの属性参照をした場合に属性値として返すオブジェ
    クトをより適切なものにするように改善しました．その方がより便利であろう
    と思いますが，一部の属性において，返されるのが文字列であることを期待し
    てスクリプトを書いている場合には修正が必要になる場合があります．

    例えば bool 値を返す属性については true または false を返すようになり
    ます．よって，戻り値が "1", "0" の文字列，あるいは 1, 0 の数値であるこ
    とを期待している場合には修正が必要となります．本来，Tcl/Tk の真偽値は
    他にも "true", "false", "yes", "no" などもありますので，値の真偽判定は
    TkComm.bool (TkUtil.bool) メソッドを使って判定することを推奨します．

    また，Tcl/Tk 上の変数が割り当てられている属性において，属性値として
    Tcl/Tk 上の変数名の文字列ではなく TkVariable オブジェクトが返されるよ
    うになります．返された値を別のウィジェットの属性値とするなどでそのまま
    Tk インタープリタに渡している場合や TkVarAccess.new(val) で TkVariable
    オブジェクト化している場合 (val である TkVariable オブジェクトがそのま
    ま返されます) には互換性が保たれますが，返された値をそのまま文字列と比
    較しているような場合には非互換となります．

: REXML [compat]

#Fri Dec  9 23:31:02 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * lib/rexml/encoding.rb (encoding=): give priority to particular
#         conversion to iconv.  [ruby-core:06520]

    日本語のエンコーディング変換にiconvよりもnkfを優先して使用するようにし
    ました。((<ruby-list:41325>)), ((<ruby-core:06520>))

: TCPSocket#initialize [bug]
: TCPServer#initialize [bug]

#Mon Nov 28 18:55:43 2005  NAKAMURA Usaku  <usa@ruby-lang.org>
#
#       * ext/socket/socket.c (init_inetsock_internal): remove setting
#         SO_REUSEADDR option on server socket on Cygwin.
#         fixed: [ruby-core:6765] ([ ruby-Bugs-2872 ])
#

    Cygwinの場合のみ、使用中socketに対する再acceptがErrno::EADDRINUSE 
    例外になっていなかった。((<ruby-core:6765>)),((<ruby-bugs:2872>)),((<ruby-dev:27818>))

: optparse

#Tue Nov 22 23:52:06 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * lib/optparse.rb: match incomplete (in current enconding) multibyte
#         string.  http://inamode6.tokuhirom.dnsalias.org/show/1551

    $KCODEで無効なマルチバイト文字列や、改行を含む文字列を引数に渡
    すと切り捨てられていたバグの修正。

        require "optparse"

        puts "[#{ARGV * ', '}]"
        ARGV.options do |opt|
          opt.on("-n NODE") {|v| puts v }
          opt.parse!
        end

        >ruby -v -Ku a.rb -n 時間
        ruby 1.8.2 (2004-12-25) [i386-mswin32]
        [-n, 時間]
        時

        >ruby -v -Ku a.rb -n 時間
        ruby 1.8.4 (2005-12-16) [i686-linux]
        [-n, 時間]
        時間

: find

#Tue Nov 15 23:46:35 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * lib/find.rb (Find::find): should not ignore symbolic links to
#         non-existing files.  [ruby-talk:165866]

    broken symbolic link(存在しないファイルに対するシンボリックリン
    ク)も返すようになりました。((<ruby-talk:165866>))

: Iconv

#Sun Nov  6 23:39:13 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * ext/iconv/iconv.c (Iconv::BrokenLibrary): exception when detected a
#         bug of underlying library.

    errnoが正しくセットされなかったときの例外を追加(Windowsで
    iconv.dllの使用するMSVC runtime DLLのバージョンが、ruby本体が使
    用するものと一致していない場合も含む)

    これはrubyやext/iconv自身のバグではなくて、実行時の環境に問題が
    ある場合の回避策です。

#: OpenSSL
#Wed Nov 23 07:26:44 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * ext/openssl/extconf.rb: check for X509V3_EXT_nconf_nid.
#
#       * ext/openssl/ossl_x509ext.c (MakeX509ExtFactory): should use
#         OPENSSL_malloc to allocate X509V3_CTX.
#
#       * ext/openssl/ossl_x509ext.c (ossl_x509extfactory_create_ext): use
#         X509V3_EXT_nconf_nid to avoid SEGV (and to build extensions which
#         values are placed in separate section).
#
#       * test/openssl/test_x509ext.rb: new file.
#
# ？

#Tue Nov 01 10:50:17 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * ext/openssl/extconf.rb: should check ERR_peek_last_error().
#         [ruby-dev:27597]
#
#       * ext/openssl/ossl.c (ossl_raise): ditto.
#
# ？

#Mon Oct 31 05:49:23 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * ext/openssl/ossl_cipher.c (ossl_cipher_update): input data must
#         not be empty. [ruby-talk:161220]
#
#       * test/openssl/test_cipher.rb: add test for Cipher#update("").
#
# ？

#Wed Oct 12 12:52:57 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * ext/openssl/ossl.c (Init_openssl): should call
#         OpenSSL_add_ssl_algorithms().
#
# ？

#: WEBrick
#Mon Oct 31 05:37:20 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/webrick/httpservlet/cgihandler.rb
#         (WEBrick::HTTPServlet::CGIHandler#do_GET): the value of Set-Cookie:
#         header field should be splited into each cookie.  [ruby-Bugs:2199]
#
#       * lib/webrick/cookie.rb (WEBrick::Cookie.parse_set_cookie): new method
#         to parse the value of Set-Cookie: header field.
#
#       * test/webrick/test_cookie.rb, test/webrick/test_cgi.rb,
#         test/webrick/webrick.cgi: add some test for cookie.
#
# ？

: WEBrick::Config::FileHandler [compat]

#Fri Oct 14 16:57:32 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/webrick/config.rb (Config::FileHandler): :UserDir should be nil.
#         It is harmful to permit the access to ~/public_html by default.
#         suggested by Hiroyuki Iwatsuki.

    WEBrick::Config::FileHandler[:UserDir]のデフォルト値が 
    "public_html"からnilになり、意図せずにユーザディレクトリ
    (/~user/public_html)以下が公開されることがなくなりました。
    [webrickja:148]

: WEBrick

#Wed Sep 28 15:14:19 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/webrick/cgi.rb (WEBrick::CGI#start): req.query_string should
#         refer the value of QUERY_STRING. [ruby-list:41186]

    WEBrick::CGI#startでreq.query_stringがオリジナルの
    QUERY_STRINGを指すように。

: WEBrick::HTTPRequest#query_string= [new]

#Wed Sep 28 15:14:19 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/webrick/httprequest.rb (WEBrick::HTTPRequest#query_string=):
#         add new method.

    メソッド追加。

: Readline [bug]

#Mon Oct 31 03:19:36 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * ext/readline/readline.c (readline_readline): type check.
#         [ruby-core:6089]

    IO以外を$stdoutにセットするとreadlineでSEGVしていたバグの修正。((<ruby-core:6089>))

: Syck [bug]

#Tue Dec 20 13:11:59 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * ext/syck/rubyext.c: fixed GC problem (backported HEAD 1.55 - 1.62)
#         [ruby-dev:27839]
#
#       * ext/syck/syck.h (S_FREE): small hack. no need to check if pointer is
#         NULL or not before S_FREE.
#
#       * st.c: uses malloc instead of xmalloc to avoid GC. syck uses st_insert
#         in gram.c to insert node from rb_syck_bad_anchor_handler into
#         SyckParser's hash table. if GC occurs in st_insert, it's not under
#         SyckParser's mark system yet. so RString can be released wrongly.
#         [ruby-dev:28057]

#Wed Oct 26 09:27:27 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * ext/syck/implicit.c (syck_type_id_to_uri): should return
#         newly allocated memory. otherwise, type_id will be freed
#         twice. [ruby-dev:27384] [ruby-core:6385]

    syck のメモリバグを修正。((<ruby-dev:27384>)), ((<ruby-core:6385>)) ((<ruby-dev:27839>))

: irb [bug]

#Tue Oct 25 15:32:00 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * lib/irb.rb (IRB::Irb::eval_input): handle prompts with newlines
#         in irb auto-indentation mode.  [ruby-core:06358]

    irbのプロンプトに改行文字が含まれているときにオートインデントが
    ずれるバグの修正。((<ruby-core:06358>))

: RDoc [bug]

#Tue Oct 25 02:12:08 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * lib/rdoc/markup/simple_markup.rb (SM::SimpleMarkup::LABEL_LIST_RE):
#         reduce redundant backtrack.  [ruby-talk:161771]

    正規表現のバックトラックが深くなりすぎて失敗することがあったバグを修正。
    ((<ruby-talk:161771>))

: Win32API [bug]

#Mon Oct 24 20:49:45 2005  NAKAMURA Usaku  <usa@ruby-lang.org>
#
#       * ext/Win32API/lib/win32/resolv.rb (get_info): support multiple DNS.
#         fixed: [ruby-list:40058], [ruby-dev:27479]
#

    DNSを手動で複数設定した場合に正しく動作していなかったバグを修正。
    ((<ruby-list:40058>)), ((<ruby-dev:27496>))

: Rinda [bug]

#Sun Oct 16 14:30:05 2005  Masatoshi SEKI  <m_seki@mva.biglobe.ne.jp>
#
#       * lib/rinda/rinda.rb (Rinda::Tuple#initialize): check remote hash
#         tuple. fixed: [ruby-list:41227]
#
#       * test/rinda/test_rinda.rb: test it.

    Hash全体がdumpできないオブジェクトとして扱われていました。
    ((<ruby-list:41227>))

: Iconv [compat]

#Sat Oct  8 20:04:40 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * ext/iconv/charset_alias.rb: parse config.charset_alias file directly.

    iconv/charset_alias において、Windows上でもencoding名の別名テー
    ブルを生成するようにした。

    iconv/charset_alias は、エンコーディング名のプラットフォームに
    よる違いを吸収するためのユーティリティです。詳細は、((<iconv>)) 参照。

: cgi [bug]

#Fri Oct  7 09:54:00 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * lib/cgi.rb (CGI::Cookie::parse): Cookies from Nokia devices may
#         not be parsed correctly.  A patch from August Z. Flatby
#         (augustzf) in [ruby-Patches-2595].  [ruby-core:06183]

    NOKIAの携帯(?)からのCookieを正しくパースできなかった問題の修正。
    ((<ruby-Patches:2595>)), ((<ruby-core:06183>))

# : xmlrpc

#Wed Oct 05 04:42:38 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/xmlrpc/server.rb (XMLRPC::Server#initialize): should mount the
#         servlet on "/".
#
# ？

#Wed Oct 05 03:59:09 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/xmlrpc/server.rb (XMLRPC::Server#serve): delete wrong call
#         of "join".
#
# ？

: DL [bug]

#Thu Sep 29 10:26:18 2005  Tanaka Akira  <akr@m17n.org>
#
#       * ext/dl/dl.c (rb_io_to_ptr): abolish sizeof(FILE).
#         [ruby-dev:27317]

    FILEが不完全型としてしか定義されない環境に対応。((<ruby-dev:27317>))

: fileutils [bug]

#Sat Sep 24 08:38:07 2005  Minero Aoki  <aamine@loveruby.net>
#
#       * lib/fileutils.rb: fix visibility of FileUtils::NoWrite, Verbose,
#         DryRun (backported from trunk, rev 1.66). [ruby-core:05954]
#
#       * test/fileutils/test_nowrite.rb: test it.
#
#       * test/fileutils/test_dryrun.rb: new file.
#
#       * test/fileutils/test_verbose.rb: new file.

    FileUtils::NoWrite, Verbose, DryRun のメソッドが呼べなくなっていた
    のを修正しました。((<ruby-core:05954>))

: extmk, mkmf [compat]

#Sat Oct 22 23:54:07 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * ext/extmk.rb, lib/mkmf.rb (with_config): support --with-extension
#         options.  [ruby-dev:27449]
#

    --with-extention オプション追加。((<ruby-dev:27449>))

: mkmf: find_executable() [compat]

#Thu Sep 22 23:36:24 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * lib/mkmf.rb (find_executable0): default path if environment is not
#         set.  [ruby-dev:27281]

  実行ファイルを探索するときに環境変数 PATH がセットされてい
  ない場合を考慮しました。((<ruby-dev:27281>))

  PATH がセットされていない場合は、
    /usr/local/bin:/usr/ucb:/usr/bin:/bin
  をPATHの代わりに利用してここからコマンドを探索します。

== 拡張ライブラリAPI

: rb_funcall2() [bug]

#Thu Dec  1 00:50:33 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * eval.c (rb_funcall2): allow to call protected methods.
#         fixed: [ruby-dev:27890]

    拡張ライブラリ(C言語)からRubyメソッドを呼ぶ関数
    rb_funcall2() が (private メソッドを呼べるのに) protected メソッド
    を呼べない不具合を修正しました。((<ruby-dev:27890>))

: rb_respond_to() [change]

#Tue Oct 11 21:41:58 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * eval.c (rb_obj_respond_to): check if obj responds to the given
#         method with the given visibility.  [ruby-dev:27408]
#
#       * eval.c (rb_respond_to): conform to Object#respond_to?.  [ruby-dev:27411]

    rb_respond_to()をObject#respond_to?のデフォルトの動作と同じ(public 
    メソッドにしか反応しない)にした。((<ruby-dev:27411>))

: rb_obj_respond_to() [new]

    追加。rb_respond_to() と異なり可視性を指定できる。((<ruby-dev:27408>))

== プラットフォーム固有

: bccwin32 [bug]

#Mon Nov 28 13:08:54 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * win32/win32.c (rb_w32_strerror): remove all CR and LF. (avoid broken
#         error message on bccwin32 + winsock)

    bccwin32 で winsock のエラーを表示するとき、strerror の返すエラー
    メッセージの途中に改行が入るために、ruby の出力するエラーメッセー
    ジが壊れていたのを修正。

: cygwin [bug]

#Sat Nov 26 19:57:45 2005  WATANABE Hirofumi  <eban@ruby-lang.org>
#
#       * dln.c (conv_to_posix_path): should initialize posix.

    cygwin環境で、RUBYLIB環境変数が空だと、$LOAD_PATHにゴミが入る。
    ((<ruby-dev:27830>))

: BeOS [bug]

#Fri Nov 11 07:44:18 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * configure.in: undef HAVE_LINK on BeOS. (link(2) always returns
#         EINVAL, and this causes error in test/fileutils.)
#
#       * file.c: overwride chown(2) and fchown(2) on BeOS. (these functions
#         should not change user/group id if -1 is passed as corresponding
#         argument, and this causes error in test/fileutils too)
#         [ruby-dev:27672]
#
#       * file.c (rb_file_s_link): checks HAVE_LINK.

    BeOS でのいくつかのテスト失敗に対処。link(2) が定義されていながら
    常に失敗するので test/fileutils が誤動作していたのに対処。BeOS に
    は link(2) は存在しないと見なすようにした。chown、fchown に id と
    して -1 を渡した場合は、POSIX 的には id を変更すべきでないが、BeOS 
    では (unsigned) -1 に変更してしまっていた。これに対処。((<ruby-dev:27672>))

: Sun [bug]

#Mon Oct 31 17:34:46 2005  Yukihiro Matsumoto  <matz@ruby-lang.org>
#
#       * configure.in: use proper option for Sun linker. A patch from
#         Shinya Kuwamura <kuwa@labs.fujitsu.com>.  [ruby-dev:27603]
#

    Sunのコンパイラで拡張ライブラリをリンクできなかった問題の修正。((<ruby-dev:27603>))

: IA64 [bug]

#Wed Oct 26 09:04:51 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * ruby.h (Qfalse, Qtrue, Qnil, Qundef): make sure these immediate
#         values have VALUE type. there is an environment where sizeof(VALUE)
#         != sizeof(int) like IA64. if 32bit integer (Qtrue) is passed to ANYARGS
#         and received by 64bit integer (VALUE), upper bits may have garbage value.
#         [ruby-dev:27513]

    IA64 で、Qtrue Qfalse Qnil が 64bit 整数でなく 32bit 整数として定
    義されていたため、ANYARGS を通して Qtrue を渡し、VALUE で受けると、
    サイズの違いから値が壊れることのあった問題を修正。((<ruby-dev:27513>))

# == 不要
#
#Mon Nov 28 09:21:49 2005  Hirokazu Yamamoto  <ocean@m2.ccsnet.ne.jp>
#
#       * lib/mkmf.rb (create_makefile): should not change sodir with
#         dir.gsub!. (bccwin32 failed to install third party exntesions)
#         [ruby-dev:27834]
#
#なんとなく不要かな？
#
#    EXTOUT を使わず、extconf.rb で外部拡張ライブラリをインストールする
#    時に、make ターゲット名が意図せず改変されていたため、bccwin32 で拡
#    張ライブラリがインストールできなくなっていたのを修正。

#Sun Nov 27 00:56:13 2005  NAKAMURA, Hiroshi  <nahi@ruby-lang.org>
#
#       * lib/wsdl/xmlSchema/complexContent.rb: missing
#         ComplexContent#elementformdefault method.
#
# ？

#Tue Nov  8 15:32:27 2005  GOTOU Yuuzou  <gotoyuzo@notwork.org>
#
#       * lib/drb/ssl.rb (DRb::SSLConfig#accept): fixed typo.
#         [ruby-dev:27560] [ruby-core:4627]
#
# ？

#Sat Oct  8 20:04:40 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * eval.c (Init_Binding): add Binding#dup method.  [yarv-dev:666]
#
# メソッドの追加。不要。

#Sat Oct  8 20:04:40 2005  Nobuyoshi Nakada  <nobu@ruby-lang.org>
#
#       * parse.y (rb_parser_malloc, rb_parser_free): manage parser stack on
#         heap.  [ruby-list:41199]
#
# Bison 2.0対応
