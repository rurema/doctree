= ruby 1.6 feature

ruby version 1.6 は安定版です。この版での変更はバグ修正がメイン
になります。

((<stable-snapshot|URL:ftp://ftp.netlab.co.jp/pub/lang/ruby/stable-snapshot.tar.gz>)) は、日々更新される安定版の最新ソースです。

== 1.6.8 (2002-12-24) -> stable-snapshot

: 2003-01-22: errno

    EAGAIN と EWOULDBLOCK が同じ値のシステムで、EWOULDBLOCK がなくなっ
    ていました。現在は、このようなシステムでは、EWOULDBLOCK は、EAGAIN 
    として定義されています。(これは 1.6.7 とは異なる挙動です)

        p Errno::EAGAIN
        p Errno::EWOULDBLOCK

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           Errno::EAGAIN
           Errno::EWOULDBLOCK

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           Errno::EAGAIN
           -:2: uninitialized constant EWOULDBLOCK at Errno (NameError)

        => ruby 1.6.8 (2003-02-13) [i586-linux]
           Errno::EAGAIN
           Errno::EAGAIN

== 1.6.7 (2002-03-01) -> 1.6.8 (2002-12-24)

: 2002-10-02: Thread (cygwin)

  Cygwin で、Thread の切替えが行われないことがありました。
  ((<ruby-list:36058>)), ((<ruby-list:24637>))

: 2002-10-01: Socket (win)

  Windows でのソケットの問題が1つ解決されたようです。(どのような問題かは
  大本のメールがわかりませんでしたが、selectで読み込み可能になったのに
  空配列が返されるという問題なのだそうです) ((<ruby-talk:40015>)),
  ((<ruby-win32:366>))

: 2002-09-12: Thread.status (?)

  シグナルを trap でトラップしたときにスレッドの状態を保持していなかっ
  たためシグナルに割り込まれたスレッドの状態がおかしくなることがありま
  した((<ruby-talk:40337>)), ((<ruby-core:00019>))

: 2002-09-11: Queue#((<Queue/pop>))

  Queue#pop に競合状態の問題がありました ((<ruby-dev:17223>))

: 2002-09-11: SizedQueue.new

  引数に 0 以下を受けつけるバグが修正されました。

: 2002-09-05: ((<リテラル/式展開>))

  stable snapshot で、一時期、式展開中のクォートは、バックスラッシュエ
  スケープが必要になっていましたが、この変更は元に戻りました。

        p "#{ "" }"

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           ""

        => -:1: warning: bad substitution in string
           ruby 1.6.7 (2002-09-12) [i586-linux]
           "#{  }"

        => ruby 1.6.7 (2002-09-25) [i586-linux]
           ""

  これは1.7からのバックポートではありません。コメントの扱いなどは、1.7 
  とは異なります。(((<ruby 1.7 feature>)) の 2002-06-24 も参照)

        p "#{ "" # comment }"
        => ruby 1.6.8 (2002-10-04) [i586-linux]
           ""
        => -:1: parse error
           ruby 1.7.3 (2002-10-04) [i586-linux]

: SizedQueue#deq, #shift
: SizedQueue#enq

  追加(push, pop の別名)。これらが定義されていなかったため、enq などを
  呼び出したときスーパークラス Queue の enq が実行されていました。

: 2002-09-11: ((<tempfile/Tempfile#size>))

  追加 ((<ruby-dev:17221>))

: 2002-09-09

  mswin32 版と mingw32 版の ruby で、1.6.6の頃から ruby の子プロセスに環境変数が渡らない
  バグがありました。((<ruby-dev:18236>))

: 2002-09-03

  Bison を使用してコンパイルした Ruby で、複数回のライブラリロードを行
  うときの速度が向上しました。(Bison を使用しない場合、ロードの都度明
  示的に GC が実行されるためライブラリロードの実行速度が低下するのだそ
  うです) ((<ruby-dev:18145>))

: 2002-08-20 File.expand_path

  Cygwin 1.3.x ((<ruby-bugs-ja:PR#299>))

        p File.expand_path('file', 'c:/')

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           /tmp/c:/file
        => ruby 1.6.7 (2002-08-21) [i586-linux]
           c:/file

: 2002-08-19 Thread (win)

  Ruby のスレッドと Win32 の構造化例外（Win32 API からのコールバッ
  クを含む）を同時に使うと落ちてしまう不具合が修正されたのだそうです。
  ((<ruby-win32:273>))

: 2002-08-12 Hash#==

  Hash オブジェクトはデフォルト値 (((<Hash/default>))) も == で等しい
  ときに等しいとみなされるようになりました。

        p Hash.new("foo") == Hash.new("bar")

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           true
        => ruby 1.6.7 (2002-08-21) [i586-linux]
           false

# : 2002-08-01 IO#read, gets ..., etc.
# 
#    File::NONBLOCK を指定した IO の読み込みで EWOULDBLOCK が発生すると、
#    途中まで読んだデータが失われることがありました。
#    ((<ruby-dev:17855>))
#    ((-これはまだマージされてません。1.6に入るかも不明です。-))

: 2002-07-11 String#slice!

  範囲外の文字列を指定したときに例外を返す場合がありましたが、常に nil 
  を返すようになりました。(String#[]やString#slice と同じ結果を返すと
  いうことです)

        p "foo".slice!("bar")   # <- 以前からこちらは nil を返していた
        p "foo".slice!(5,10)

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           nil
           -:2:in `slice!': index 5 out of string (IndexError)
                from -:2
        => ruby 1.6.7 (2002-08-01) [i586-linux]
           nil
           nil

: 2002-07-05 String#split

  最初の引数に nil を指定できるようになりました。((<ruby-talk:43513>)) 
  この場合、$; を分割文字列として使用します。以前までは $; が有効にな
  るのは引数省略時だけでした。

    $; = ":"
    p "a:b:c".split(nil)
    => -:2:in `split': bad separator (ArgumentError)
            from -:2
       ruby 1.6.7 (2002-03-01) [i586-linux]

    => ruby 1.6.7 (2002-07-30) [i586-linux]
       ["a", "b", "c"]

: 2002-06-15 Dir.glob

  リンクの切れたシンボリックリンクに対して、Dir.glob がマッチしません
  でした。

        File.symlink("foo", "bar")
        p Dir.glob("bar")
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           []
        => ruby 1.6.7 (2002-08-01) [i586-linux]
           ["bar"]

: 2002-06-13 Hash[]

  Hash[] で、キーとなる文字列を dup & freeze していませんでした。

        a = "key"
        h = Hash[a,"val"]
        h.keys[0].upcase!
        p a
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           "KEY"
        => -:3:in `upcase!': can't modify frozen string (TypeError)
                from -:3
           ruby 1.6.7 (2002-08-01) [i586-linux]

: 2002-06-10 Fixnum#>>, <<

  負の数に対して右シフトすると 0 になることがありました。
  ((<ruby-bugs-ja:PR#247>))

  負の数を引数にした左シフト(つまり右シフト)も同様におかしな挙動をして
  いました。((<ruby-bugs-ja:PR#248>))

        p(-1 >> 31)
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           0
        => ruby 1.6.7 (2002-08-01) [i586-linux]
           -1

        p(-1 << -1)
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           -2147483649
        => ruby 1.6.7 (2002-08-01) [i586-linux]
           -1

: 2002-06-05
: ((<Math/Math.acosh>))
: ((<Math/Math.asinh>))
: ((<Math/Math.atanh>))

  追加。

: 2002-06-03
: String#[]=

  インデックスとして指定した文字列がレシーバに含まれない場合に、何もせ
  ず右辺を返していました。

    foo = "foo"
    p foo["bar"] = "baz"
    p foo

    => ruby 1.6.7 (2002-03-01) [i586-linux]
       "baz"
       "foo"
    => -:2:in `[]=': string not matched (IndexError)
            from -:2
       ruby 1.6.7 (2002-07-30) [i586-linux]

: 2002-06-03 sprintf()

  "%d" で引数を整数にするときに、((<組み込み関数/Integer>)) と同じ規則を
  使用するようになりました。

        p sprintf("%d", nil)

        => -:1:in `sprintf': no implicit conversion from nil (TypeError)
                from -:1
           ruby 1.6.7 (2002-03-01) [i586-linux]

        => ruby 1.6.7 (2002-07-30) [i586-linux]
           "0"

: 2002-05-23 -* オプション(?)

  以前まで、

    #! ruby -*- mode: ruby -*-

  のような Emacs の '-*-' 指定を使用したスクリプトのために -* 以降を無
  視する(何もしないオプションとして認識)するようになっていましたが、こ
  の特別扱いはなくなりました。Emacs の '-*-' 指定は、2行目に書くように
  するべきです。((<ruby-dev:17193>))

        ruby '-*' -v
        => ruby 1.6.7 (2002-03-01) [i586-linux]

        => ruby: invalid option -*  (-h will show valid options)

: 2002-05-22 parsedate

  バージョンアップ((<ruby-dev:17171>))

: 2002-05-22 -T オプション

  ruby のコマンドラインオプション -T の後に空白を置かずに他のオプショ
  ンを続けると、-T以降のオプションが無効になっていました。-T の後は数
  字以外が続いた場合、オプションとみなすようになりました(-0 オプション
  と同じ) ((<ruby-dev:17179>))

        ruby -Tv  # -v が無効 (ruby 1.6.7 (2002-03-01) [i586-linux])

        => ruby: No program input from stdin allowed in tainted mode (SecurityError)

        => ruby 1.6.7 (2002-07-30) [i586-linux]

: 2002-05-20 IO#close

  双方向のパイプの dup を close_write するとエラーになっていました。
  ((<ruby-dev:17155>))

    open("|-","r+") {|f|
      if f
        f.dup.close_write
      else
         sleep 1
      end
    }

    => ruby 1.6.7 (2002-03-01) [i586-linux]
       -:3:in `close_write': closing non-duplex IO for writing (IOError)
            from -:3
            from -:1:in `open'
            from -:1


    => ruby 1.6.7 (2002-07-30) [i586-linux]

: 2002-05-02 Regexp.quote

  # はバックスラッシュクォートするようになりました。これは、quote した
  正規表現を //x に正しく埋め込めるようにするためです。
  ((<ruby-bugs-ja:PR#231>))

        p Regexp.quote("#")

        p /a#{Regexp.quote("#")}b/x =~ "ab"

        => -:3: warning: ambiguous first argument; make sure
           ruby 1.6.7 (2002-03-01) [i586-linux]
           "#"
           0

        => -:3: warning: ambiguous first argument; make sure
           ruby 1.6.7 (2002-07-30) [i586-linux]
           "\\#"
           nil

: 2002-04-29: rb_find_file()

  $SAFE >= 4 で、絶対パス指定でない場合、SecurityError 例外が発生する
  ようになりました。

: 2002-04-26: Regexp.quote

  ((<ruby-bugs-ja:PR#231>))

        p Regexp.quote("\t")

        p /a#{Regexp.quote("\t")}b/x =~ "ab"

        => -:3: warning: ambiguous first argument; make sure
           ruby 1.6.7 (2002-03-01) [i586-linux]
           "\t"
           0

        => -:3: warning: ambiguous first argument; make sure
           ruby 1.6.7 (2002-05-04) [i586-linux]
           "\\t"
           nil

: 2002-04-20: Regexp#inspect

  /x フラグ付きの正規表現オブジェクトの inspect が改行を \n に変換して
  いました。((<ruby-bugs-ja:PR#225>))

        p /a
                b/x

        => -:1: warning: ambiguous first argument; make sure
           ruby 1.6.7 (2002-03-01) [i586-linux]
           /a\n                b/x

        => -:1: warning: ambiguous first argument; make sure
           ruby 1.7.2 (2002-04-24) [i586-linux]
           /a
                           b/x
: 2002-04-19: 終了処理

  以下のスクリプトで 2 回シグナルを送らないと終了しない不具合が修正さ
  れました。((<ruby-bugs-ja:PR#223>))

    trap(:TERM, "EXIT")

    END{
      puts "exit"
    }

    Thread.start { Thread.stop }
    sleep

: 2002-04-17: Regexp#inspect

  ((<ruby-bugs-ja:PR#222>))

    p %r{\/}

    => ruby 1.6.7 (2002-03-01) [i586-linux]
       /\\//

    => ruby 1.6.7 (2002-05-04) [i586-linux]
       /\//

: 2002-04-15: pack('U')

  pack('U') を unpack('U') すると元に戻らないバグが修正されました。
  (unpack は、バイト単位でなく文字単位の処理になりました)
  ((<ruby-bugs-ja:PR#220>))

    p [128].pack("U")
    p [128].pack("U").unpack("U")

    => ruby 1.6.7 (2002-03-01) [i586-linux]
       "\302\200"
       [0]

    => ruby 1.6.7 (2002-05-04) [i586-linux]
       "\302\200"
       [128]

: 2002-04-11: IO#write

  ソケットやパイプに対する EPIPE の検出に失敗することがありました。
  ((<ruby-dev:16849>))

: 2002-04-11: ((<"cgi/session">))    (*ドキュメント未反映*)

  support for multipart form.

: 2002-04-10: Object#((<Object/remove_instance_variable>))

  指定したインスタンス変数が定義されていない場合例外 NameError を起こ
  すようになりました。((<ruby-bugs-ja:PR#216>))

        Object.new.instance_eval {
          p remove_instance_variable :@foo
        }
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           nil

        => -:2:in `remove_instance_variable': instance variable @foo not defined (NameError)
           ruby 1.6.7 (2002-04-10) [i586-linux]

: 2002-04-04: Integer#((<Integer/step>))

  第二引数が 1 よりも小さい場合に 0 を指定したと見なされエラーになって
  いました。

    1.step(2, 0.1) {|f| p f }

    => -:1:in `step': step cannot be 0 (ArgumentError)
            from -:1
       ruby 1.6.7 (2002-03-01) [i586-linux]

    => ruby 1.6.7 (2002-04-10) [i586-linux]
       1
       1.1
        :
       1.9

: 2002-04-01: ((<組み込み変数/$~>))

  $~ に nil を代入できないバグが修正されました。((<ruby-dev:16697>))

    /foo/ =~ "foo"
    p $~
    $~ = nil
    p $~
    => ruby 1.6.7 (2002-03-01) [i586-linux]
       #<MatchData:0x401b1be4>
       -:3: wrong argument type nil (expected Match) (TypeError)
                                              ^^^^^ MatchData の間違い
    => ruby 1.6.7 (2002-04-04) [i586-linux]
       #<MatchData:0x401b1c98>
       nil

: 2002-03-25 ((<BasicSocket/BasicSocket.do_not_reverse_lookup>))

  $SAFE > 3 で値を設定できなくなりました。
  ((<ruby-dev:16554>))

: 2002-03-23 IO#((<IO/read>))

  サイズが 0 で中身のあるファイル(Linux の /proc ファイルシステムでこ
  のような場合があります)が File#read などで読めないバグが修正されまし
  た。

        p File.open("/proc/#$$/cmdline").read

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           ""

        => ruby 1.6.7 (2002-03-29) [i586-linux]
           "ruby-1.6\000-v\000-"

: 2002-03-22 ((<Module/module_eval>))

  ((<Module/module_eval>)) のブロック内で定数やクラス変数のスコープが
  変わることはなくなりました。((<ruby-dev:17876>))

        class Foo
          FOO = 1
          @@foo = 1
        end

        FOO = 2
        @@foo = 2

        Foo.module_eval { p FOO, @@foo }

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           1
           1

        => ruby 1.6.7 (2002-03-29) [i586-linux]
           2
           2

: 2002-03-22 ((<"net/http">))

  Net::HTTP.new がブロックなしのときに nil を返していました。
  ((<ruby-bugs-ja:PR#214>))

  net/protocol は削除される方向にあるようで、その準備時に
  エンバグしたそうです。

: 2002-03-20 ((<File/File.expand_path>))

  メモリの解放洩れがありました。((<ruby-bugs:PR#276>))

: 2002-03-18 文字列リテラル

  漢字コードの扱いが #{..} の中などで不完全な部分がありました。
  ((<ruby-list:34478>))

        #! ruby -Ks
        p a = "#{"表"}"
        => -:1: compile error in string expansion (SyntaxError)
           -:1: unterminated string meets end of file
           ruby 1.6.7 (2002-03-15) [i586-linux]
        => ruby 1.6.7 (2002-03-19) [i586-linux]
           "表"

        #! ruby -Ks
        p %[評価]
        => -:2: parse error
                   p %[評価]
                           ^
           ruby 1.6.7 (2002-03-15) [i586-linux]

        => ruby 1.6.7 (2002-03-19) [i586-linux]
           "評価"

: 2002-03-16 $~

  正規表現マッチのメソッドが実際には内部でマッチを実行しない場合に 
  $~ の状態をクリアしていませんでした。
  ((<ruby-bugs-ja:PR#208>))

        /foo/ =~ "foo"
        /foo/ =~ nil
        p $~

        /foo/ =~ "foo"
        $_ = nil; ~"foo"
        p $~

        /foo/ =~ "foo"
        "foo".index(/bar/, 4)
        p $~

        /foo/ =~ "foo"
        "foo".rindex(/bar/, -4)
        p $~

        => ruby 1.6.7 (2002-03-06) [i586-linux]
           #<MatchData:0x401b1be4>
           #<MatchData:0x401b198c>
           #<MatchData:0x401b1644>
           #<MatchData:0x401b1414>
        => ruby 1.6.7 (2002-03-19) [i586-linux]
           nil
           nil
           nil
           nil

: 2002-03-14 拡張ライブラリの autoload

  拡張ライブラリに対して autoload が効いていませんでした。((<ruby-dev:16379>))

    autoload :Fcntl, "fcntl"
    require "fcntl"

    => -:2:in `require': uninitialized constant Fcntl (NameError)
            from -:2
       ruby 1.6.7 (2002-03-01) [i586-linux]

    => ruby 1.6.7 (2002-03-15) [i586-linux]

: 2002-03-13 ((<getopts>))

  refine. ((<ruby-dev:16193>)), ((<ruby-dev:16213>))

: 2002-03-11 正規表現中の 8 進コード

  正規表現中の \nnn による 8 進記法で先頭が 0 の場合だけ、4桁を許して
  いました。((<ruby-bugs-ja:PR#207>))

    p /\0001/ =~ "\0001"   # equivalent to "\0" + "1"
    => -:1: warning: ambiguous first argument; make sure
       ruby 1.6.7 (2002-03-01) [i586-linux]
       nil
    => -:1: warning: ambiguous first argument; make sure
       ruby 1.6.7 (2002-03-15) [i586-linux]
       0

: 2002-03-11 trap

  ((<ruby-bugs-ja:PR#206>))

    trap('EXIT','Foo')
    => -:1: [BUG] Segmentation fault
       ruby 1.6.7 (2002-03-01) [i586-linux]
    => ruby 1.6.7 (2002-03-15) [i586-linux]

: 2002-03-10 メソッドの戻り値

  以下のメソッドの戻り値が正しくなりました。((<ruby-bugs-ja:PR#205>))

  * ((<Enumerable/each_with_index>)) が self を返すようになった(以前は nil)
  * ((<Process/Process.setpgrp>)) が返す値が不定だった。
  * ((<String/ljust>)), ((<String/rjust>)), ((<String/center>)) の結果に
    変化がなくても常に dup した文字列を返すようになった

: 2002-03-08 class variable

  ((<ruby-talk:35122>))

    class C
      class << self
        def test
          @@cv = 5
          p @@cv
        end
      end

      test
    end
    => -:5:in `test': uninitialized class variable @@cv in C (NameError)
            from -:9
       ruby 1.6.7 (2002-03-01) [i586-linux]

    => ruby 1.6.6 (2001-12-26) [i586-linux]
       5

: 2002-03-03 ((<Marshal/Marshal.load>))

  Marshal.load が 1.7 のメソッド Proc#yield を呼んでいました。
  ((<ruby-dev:16178>))

    Marshal.load(Marshal.dump('foo'), proc {|o| p o})
    => -:1:in `load': undefined method `yield' for #<Proc:0x401b1b30> (NameError)
            from -:1
       ruby 1.6.7 (2002-03-01) [i586-linux]

    => ruby 1.6.6 (2001-12-26) [i586-linux]
       "foo"

== 1.6.6 (2001-12-26) -> 1.6.7 (2002-03-01)

: 2002-02-20 true/false/nil の特異メソッド定義

  これら疑似変数に特異クラス定義形式で特異メソッドを定義できるようにな
  りました。

        class <<true
          def foo
           "foo"
          end
        end
        p true.foo
        => -:1: no virtual class for true (TypeError)
           ruby 1.6.6 (2001-12-26) [i586-linux]

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           "foo"

: ((<time>)), URI

  追加されました。

: Ruby/Tk

  バグ修正、機能追加 ((<ruby-dev:16139>)),((<ruby-dev:16153>))。

: 数値リテラルの `_'

  `_' を置ける場所の規則が見直され、String#hex などの数値変換メソッド
  の挙動と共に規則が統一されました。((<rubyist:1018>)), ((<ruby-dev:15684>)),
  ((<ruby-dev:15757>))

: ((<Module/include>))

  モジュールが再帰的に include されないようになりました。

    module Foo; end
    module Bar; include Foo; end
    module Foo; include Bar; end

    p Foo.ancestors

    => ruby 1.6.6 (2001-12-26) [i586-linux]
       [Foo, Bar, Foo]

    => -:3:in `append_features': cyclic include detected (ArgumentError)
            from -:3:in `include'
            from -:3
       ruby 1.6.6 (2002-01-28) [i586-linux]

: メソッドの戻り値

  以下のメソッドの戻り値が正しくなりました。
  ((<ruby-bugs-ja:PR#182>)), ((<rubyist:1016>))

  * Hash#default= が右辺を返すようになった(以前は self を返していた)。

  * Dir#pos= が右辺を返すようになった(以前は self を返していた)。
    (Dir#seek は、変わらず self を返します)

  * Dir.glob がブロックを伴うとき nil を返すようになった(以前は false)

  * IO#close がクローズ済みな IO に対して IOError を起こすようになった。

  * IO#each_byte が self を返すようになった(以前は nil)

: rb_define_module_under()

  C 関数 rb_define_module_under() でモジュールを定義するときに同名の定
  数が既に定義されていると失敗していました。((<ruby-talk:30203>))

        Constants = 1
        require 'syslog'
        p Syslog::Constants

        => -:2:in `require': Syslog::Fixnum is not a module (TypeError)
                from -:2
           ruby 1.6.6 (2001-12-26) [i586-linux]

        => ruby 1.6.6 (2002-01-07) [i586-linux]
           Syslog::Constants

  このバグにより 1.6.7 が近いうちにリリースされるかもしれません
  ((<ruby-talk:30387>))(やっぱそんなことはなかったようです。
  これを見て、1.6.6 の stable-snapshot を使用している方は、2002/1/30 
  の以下の変更(ChangeLog)

        * re.c (rb_reg_search): should set regs.allocated.

  で、メモリリークが起こるようになってることに注意してください。
  2002/2/13 以降の修正版で直ってます。っと一度ハマッたので書いておきま
  す)。

== 1.6.5 (2001-09-19) -> 1.6.6 (2001-09-19)

: ((<Syslog>))

  追加されました。

: CGI

  Netscape(バージョンは？) のバグに対処しました
  ((<ruby-list:32089>))

: Time#localtime
: Time#gmtime

  フリーズした Time オブジェクトに対して一度だけ呼び出しを許しました。

        t = Time.new.freeze
        p t.gmtime
        p t.localtime

        => -:2:in `gmtime': can't modify frozen Time (TypeError)
                from -:2
           ruby 1.6.5 (2001-09-19) [i586-linux]

        => ruby 1.6.5 (2001-11-01) [i586-linux]
           Mon Nov 05 18:08:34 UTC 2001
           -:3:in `localtime': can't modify frozen Time (TypeError)
                from -:3

: File::SEPARATOR
: File::ALT_SEPARATOR
: File::PATH_SEPARATOR
: RUBY_PLATFORM
: RUBY_RELEASE_DATE
: RUBY_VERSION

  これらは、freeze された文字列になりました。

        p File::SEPARATOR.frozen?
        p File::ALT_SEPARATOR.frozen?
        p File::PATH_SEPARATOR.frozen?

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           false
           false
           false

        => ruby 1.6.5 (2001-11-01) [i586-linux]
           true
           false  # ここでは実行環境がLinuxなので ALT_SEPARATOR は nil
           true

: Integer[nth]

  大きな値のインデックスに対して例外が発生していました。
  ((<ruby-bugs-ja:PR#114>))

        p(-1[10000000000])

        => -:1:in `[]': bignum too big to convert into `int' (RangeError)
                from -:1
           ruby 1.6.5 (2001-09-19) [i586-linux]

        => ruby 1.6.5 (2001-11-01) [i586-linux]
           1

  整数の負のインデックスに対して 0 を返すようにな・・・ってません。あれ？
  ((<ruby-bugs-ja:PR#122>))

        p(-1[-1])

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           1
        => ruby 1.6.5 (2001-11-01) [i586-linux]
           1

: Numeric#remainder

  ((<ruby-bugs-ja:PR#110>))

        p( 3.remainder(-3))
        p(-3.remainder(3))

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           3
           -3
        => ruby 1.6.5 (2001-11-01) [i586-linux]
           0
           0

: END { ... }

  END ブロックの中の END ブロックが実行されていませんでした。
  ((<ruby-bugs-ja:PR#107>))

        END {
          p 1
          END { p 2 }
        }

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           1

        => ruby 1.6.5 (2001-11-01) [i586-linux]
           1
           2

: String#succ

((<ruby-talk:22557>))

        p "***".succ
        p "*".succ
        p sprintf("%c", 255).succ
        p sprintf("*%c", 255).succ
        p sprintf("**%c", 255).succ

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           "**+"
           "\001+"
           "\001\000"
           "\001+\000"
           "*+\000"

        => ruby 1.6.5 (2001-11-01) [i586-linux]
           "**+"
           "+"
           "\001\000"
           "+\000"
           "*+\000"

: method_missing

  以下が Segmentation Fault していました。((<ruby-dev:14942>))

        Module.constants.each {|c|
          c = eval c
          if c.instance_of?(Class)
            p c
            c.instance_methods.each {|m|
              c.module_eval "undef #{m};"
            }
            c.module_eval {undef initialize}
          end
        }

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           NotImplementedError
           MatchData
           Exception
           Numeric
           MatchData
           Segmentation fault

        => ruby 1.6.5 (2001-10-15) [i586-linux]
           MatchData
           NotImplementedError
           FloatDomainError
           LoadError
           Float
           Binding
           SignalException
           Module
           -:6:in `method_missing': stack level too deep (SystemStackError)

: %q(...)

  % 記法によるリテラル表記でその区切り文字として英数字を指定
  できなくなりました。

     p %q1..1

    => ruby 1.6.5 (2001-10-10) [i586-linux]
       ".."
    => -:1: unknown type of %string
            p %q1..1
                 ^
       ruby 1.6.5 (2001-10-15) [i586-linux]

: String#=~

  String#=~ の呼出で両辺ともリテラルであったときに速度重視のためにメソッ
  ドコールを行わなくなりました。(実際は、前からこのようにしようとして
  いたがバグによりメソッドが呼び出されていた(しかもString#=~ でなく 
  Regexp#=~))

    class String
      def =~(arg)
        ["String#=~", self, arg]
      end
    end

    class Regexp
      def =~(arg)
        ["Regexp#=~", self, arg]
      end
    end

    p "foo" =~ /foo/
    p "foo" =~ Regexp.new("foo")

    => -:2: warning: discarding old =~
       -:8: warning: discarding old =~
       ruby 1.6.5 (2001-09-19) [i586-linux]
       ["Regexp#=~", /foo/, "foo"]
       ["String#=~", "foo", /foo/]

    => -:2: warning: discarding old =~
       -:8: warning: discarding old =~
       ruby 1.6.5 (2001-10-10) [i586-linux]
       0
       ["String#=~", "foo", /foo/]

  (((*組み込みのメソッドはこのような最適化が行われることがあるのでメソッ
  ドの再定義の効果が及ばないことがある点に注意*))というか、メソッドが
  再定義されたかどうかで、最適化の on/off をしてほしいなあ)

: class 定義

  既にクラスが定義されていて、そのクラスと異なるスーパークラスを明示的
  に指定して再定義したとき、指定したスーパークラスが反映されていません
  でした。((<ruby-bugs-ja:PR#87>))

    class A
      p self.id
    end
    class A < String
      p self.id
      p self.superclass
    end

    => ruby 1.6.5 (2001-09-19) [i586-linux]
       537760880
       -:4: warning: already initialized constant A
       537757180
       Object
    => ruby 1.6.5 (2001-10-10) [i586-linux]
       537760960
       -:4: warning: already initialized constant A
       537757200
       String

: %w(...)

  配列リテラル %w(...) が構文解析器により文字列リテラルとして判断されて
  いたため、以下のようなコードで異常な状態になっていました。
  ((<ruby-bugs-ja:PR#91>))

    %w!a! "b" 
    => -:1: tried to allocate too big memory (NoMemoryError)
       ruby 1.6.5 (2001-09-19) [i586-linux]

    => -:1: parse error
           %w!a! "b" 
                    ^
       ruby 1.6.5 (2001-10-10) [i586-linux]

: Thread

  Thread#status が aborting 状態に対して "run" を返していたバグが修正
  されました。また、Thread#priority = val が val でなく self を返して
  いました。((<rubyist:0820>)), ((<ruby-dev:14903>))

: ((<Marshal>))

  無名のクラス／モジュールは dump できないようになりました。

    p Marshal.dump(Class.new)

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       "\004\005c\031#<Class 0lx401a6b44>"

    => -:1:in `dump': can't dump anonymous class #<Class 0lx401ab980> (ArgumentError)
            from -:1
       ruby 1.6.5 (2001-10-05) [i586-linux]

: UNIXSocket#addr

  UNIXSocket#addr がゴミを返していました(BSD の場合？)。
  ((<ruby-bugs-ja:PR#85>))

        # server
        require 'socket'
        File.unlink("/tmp/sss")
        sock = UNIXServer.new("/tmp/sss").accept

        # client
        require 'socket'
        sock = UNIXSocket.new("/tmp/sss").addr

        => ["AF_UNIX", "\031((\306\031(\010"]

        => ["AF_UNIX", ""]

: ???
        ((<ruby-talk:21722>))

        class Ptr
                def initialize(obj) @obj = obj end
                def []=() @obj = obj end
                def []() @obj end
        end
        module Kernel
                def _ptr() Ptr.new(self) end
        end

        def foo(int)
                int[] += 1
        end
        x = 1._ptr
        foo(x)
        puts x[]

        => -:11: [BUG] Segmentation fault
           ruby 1.6.5 (2001-09-19) [i586-linux]

        => -:11:in `[]=': wrong # of arguments(1 for 0) (ArgumentError)
                   from -:11:in `foo'
                   from -:14
           ruby 1.6.5 (2001-10-05) [i586-linux]

: Subclass of String and Array

  String, Array のサブクラスで特定のメソッドを呼ぶと、String, Array
  になっていました。

        class Foo < String
        end
        p Foo.new("").class
        p Foo.new("foo")[0,0].class              # String ???
        p Foo.new("foo")[1,1].class
        p Foo.new("foo").succ.class
        p Foo.new("foo").reverse.class
        p((Foo.new("foo") * 5).class)
        p Foo.new("foo").gsub(/foo/, "bar").class
        p Foo.new("foo").sub(/foo/, "bar").class
        p Foo.new("foo").ljust(10).class
        p Foo.new("foo").rjust(10).class
        p Foo.new("foo").center(10).class

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           Foo
           String
           String
           String
           String
           String
           String
           Foo
           String
           String
           String

        => ruby 1.6.5 (2001-10-05) [i586-linux]
           Foo
           String
           Foo
           Foo
           Foo
           Foo
           Foo
           Foo
           Foo
           Foo
           Foo

        class Bar < Array
        end
        bar = Bar.new
        p bar.class
        p bar.push(1,2,3)
        p bar.class
        p bar[0,0].class            # => Array ???
        p bar[0,1].class
        p ((bar * 5).class)

        => -:9: warning: p (...) interpreted as method call
           ruby 1.6.5 (2001-09-19) [i586-linux]
           Bar
           [1, 2, 3]
           Bar
           Array
           Array
           Array
        => -:9: warning: p (...) interpreted as method call
           ruby 1.6.5 (2001-10-05) [i586-linux]
           Bar
           [1, 2, 3]
           Bar
           Array
           Bar
           Bar

== 1.6.4 (2001-06-04) -> 1.6.5 (2001-09-19)

: $_, $~, if a..b

  関数の中からThread#runを使うと、そのスレッドとスコープを共有する親スレッ
  ドの$_, $~が、子スレッドのもので上書きされてしまっていました。
  ((<ruby-dev:14743>))

        def foo(t)
          t.run
        end

        t = Thread.start do
          t = $_= "sub"
          loop{Thread.stop;puts "sub:#$_"}
        end

        $_ = "main"
        t.run                   # => sub:sub
        puts "main:#$_"         # => main:main
        foo(t)                  # => sub:sub
        puts "main:#$_"         # => main:sub
        => ruby 1.6.4 (2001-06-04) [i586-linux]
           sub:sub
           main:main
           sub:sub
           main:sub
        => ruby 1.6.5 (2001-09-19) [i586-linux]
           sub:sub
           main:main
           sub:sub
           main:main

: net/telnet

  Net::Telnet が特定のホストへ接続後、動かない事がありました。
  ((<ruby-list:31303>))

: CGI#header

  以下のようなスクリプトでTEXT_PLAINが"text/plain; charset=iso-8859-1"
  のように書き換えられていました。
  ((<ruby-dev:14716>))

        require 'cgi'

        TEXT_PLAIN = "text/plain"

        cgi = CGI.new
        print cgi.header("type" => TEXT_PLAIN,
                         "charset" => "iso-8859-1")
        printf("TEXT_PLAIN: %s\n", TEXT_PLAIN)

        => ruby 1.6.4 (2001-06-04) [i586-linux]
           Content-Type: text/plain; charset=iso-8859-1
           ^M
           TEXT_PLAIN: text/plain; charset=iso-8859-1
           TEXT_PLAIN: text/plain

        => ruby 1.6.5 (2001-09-19) [i586-linux]
           Content-Type: text/plain; charset=iso-8859-1
           ^M
           TEXT_PLAIN: text/plain

: Dir.chdir

        環境変数 HOME, LOGDIR のいずれも定義されていないとき引数なしの 
        Dir.chdir で ArgumentError 例外を起こすようになりました

        ENV['HOME'] = nil
        ENV['LOGDIR'] = nil
        Dir.chdir
        => -:3:in `chdir': Bad address (Errno::EFAULT)
                from -:3
           ruby 1.6.4 (2001-08-26) [i586-linux]
        => -:3:in `chdir': HOME/LOGDIR not set (ArgumentError)
                from -:3
           ruby 1.6.5 (2001-09-19) [i586-linux]

: Dir.glob

  以下のコードが無限ループになっていました。

        Dir.mkdir("test?") rescue nil
        p Dir.glob("test?/*")
        => ruby 1.6.5 (2001-09-19) [i586-linux]
           []

: jcode
  バグがいくつか修正されました。((<ruby-list:31238>))


〜この間、空白期間〜

: ((<Dir>)).glob

  Dir.glob("*/**/*")がサブディレクトリのファイルを二度返していました。
  ((<ruby-dev:14576>))

    Dir.mkdir('foo') rescue nil
    Dir.mkdir('foo/bar') rescue nil
    p Dir.glob('*/**/*')

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       ["foo/bar", "foo/bar"]

    => ruby 1.6.4 (2001-08-26) [i586-linux]
       ["foo/bar"]

: ((<UnboundMethod>))#bind

  モジュールの UnboundMethod オブジェクトを bind することができませんでした。
  ((<rubyist:0728>))

    module Foo
      def foo
        :foo
      end
    end

    class Bar
      include Foo
    end

    m = Foo.instance_method :foo
    p m.bind(Bar.new).call

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       -:12:in `bind': first argument must be an instance of Foo (TypeError)
            from -:12

    => ruby 1.6.4 (2001-08-23) [i586-linux]
       :foo

: 組み込みクラスの置き換え

  組み込みクラス／モジュール(を代入した定数)への代入を行ったときに警告を
  出すようになりました。

    Array = nil
    p Array
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       nil

    => -:1: warning: already initialized constant Array
       ruby 1.6.4 (2001-08-23) [i586-linux]
       nil

: ((<Regexp>))

  括弧の数より大きな数のバックリファレンスが何にでもマッチしていました。
  ((<ruby-list:30975>))

    p /(foo)\2/ =~ "foobar"
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       0
    => ruby 1.6.4 (2001-08-23) [i586-linux]
       nil

: ((<TCPSocket>)).open

  ((<Cygwin>)) で ((<TCPSocket>)).open がタイミングによってエラー(Errno::EINVAL,
  EALREADY)になることがある問題に対処しました。(1.6.4 20010712以降)
  ((<ruby-talk:9939>)), ((<ruby-talk:16632>)),
  ((<ruby-list:24702>)), ((<ruby-list:27805>)), ((<ruby-list:30512>)) 等など

: resolv, resolv-replace

  追加。rubyで実装したリゾルバ(DNSの名前解決) とSocket関連のクラスでこ
  のライブラリを使用するためのライブラリです。

  rubyで実装したリゾルバは、timeout の制御が効きます(つまり、名前解
  決中にThreadが切替え可能ということです)

    require 'resolv'
    p Resolv.new.getaddress("www.ruby-lang.org").to_s

    => /usr/local/lib/ruby/1.6/resolv.rb:160: warning: timeout (...) interpreted as method call
       /usr/local/lib/ruby/1.6/resolv.rb:55: warning: instance variable @initialized not initialized
       /usr/local/lib/ruby/1.6/resolv.rb:113: warning: instance variable @initialized not initialized
       /usr/local/lib/ruby/1.6/resolv.rb:392: warning: instance variable @initialized not initialized
       ruby 1.6.4 (2001-08-23) [i586-linux]
       "210.251.121.214"

: ((<Digest|digest>)) モジュール

  SHA1, MD5 は Digest::SHA1, Digest::MD5 に置き換えられました。
  Digest::SHA256, Digest::SHA384,  Digest::SHA512, Digest::RMD160
  も新たに追加されました。

    require 'digest/md5'
    include Digest

    md = MD5.new
    md << "abc"
    puts md

    puts MD5.hexdigest("123")

: ((<Struct>))

  フリーズされた構造体オブジェクトが変更できていました。また、$SAFE =
  4 のときの変更を禁止するようにしました。((<ruby-talk:19167>))

    cat = Struct.new("Cat", :name, :age, :life)
    a = cat.new("cat", 12, 7).freeze
    a.name = "dog"
    p a
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       #<Struct::Cat name="dog", age=12, life=7>
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       -:4:in `name=': can't modify frozen Struct (TypeError)
            from -:4

    cat = Struct.new("Cat", :name, :age, :life)
    a = cat.new("cat", 12, 7)
    Thread.new do
       abort_on_exception = true
       $SAFE = 4
       a.life -= 1
    end.join
    p a.life
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       6
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       -:6:in `life=': Insecure: can't modify Struct (SecurityError)
            from -:3:in `join'
            from -:3

: ((<String>))#rindex

  rindex に正規表現を渡したときの動作にバグがありました。((<ruby-dev:13843>))
  (1.6.4 リリース後のバグです)

    p "foobar".rindex(/b/)
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       3

    => ruby 1.6.4 (2001-06-19) [i386-freebsd5.0]
       nil

    => ruby 1.6.4 (2001-08-06) [i586-linux]
       3

: ((<require|組み込み関数>))

  requireに ~ で始まるファイル名を指定したとき、拡張子がついてな
  いとロードできなくなっていました。((<ruby-dev:13756>))

    $ echo p __FILE__ > ~/a.rb
    $ ruby17 -v -r~/a -e0
    ruby 1.7.1 (2001-07-03) [i686-linux]
    0: No such file to load -- ~/a (LoadError)
    $ ruby16 -v -r~/a -e0
    ruby 1.6.4 (2001-07-02) [i686-linux]
    0: No such file to load -- ~/a (LoadError)
    $ ruby14 -v -r~/a -e0
    ruby 1.4.6 (2000-08-16) [i686-linux]
    "/home/nobu/a.rb"

: ((<String>))#each_line

  正しく汚染が伝搬していませんでした。((<ruby-dev:13755>))

    "foo\nbar\n".taint.each_line {|v| p v.tainted?}
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       false
       true
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       true
       true

: ((<NKF|nkf>)).nkf

  正しく汚染が伝搬していませんでした。((<ruby-dev:13754>))

    require 'nkf'
    p NKF.nkf("-j", "a".taint).tainted?

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       false
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       true

: ruby -x

  オプション ((<Rubyの起動/-x[directory]>)) を指定したときにスクリ
  プトを実行せずに終了することがありました。((<ruby-dev:13752>))

: attr_*

  アクセサに余計な引数を渡してもエラーになりませんでした。
  ((<ruby-dev:13748>))

    class C
      def initialize
        @message = 'ok'
      end
      attr_reader :message
    end
    puts C.new.message(1,2,3)

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       ok
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       -:7:in `message': wrong # of arguments(3 for 0) (ArgumentError)
            from -:7

: ((<Readline|readline>)).completion_append_character
: ((<Readline|readline>)).completion_append_character=

  追加。GNU Readline ライブラリの変数 (({rl_completion_append_character}))
  のアクセサ。(この変数は GNU readline 2.1 以降で使えます)
  ((<ruby-ext:01760>))

: ((<Socket::Constants>))

  ソケット関連の定数のうち以下が新規に追加されました(システムに定義さ
  れている場合に限る)。

    SO_PASSCRED
    SO_PEERCRED
    SO_RCVLOWAT
    SO_SNDLOWAT
    SO_RCVTIMEO
    SO_SNDTIMEO
    SO_SECURITY_AUTHENTICATION
    SO_SECURITY_ENCRYPTION_TRANSPORT
    SO_SECURITY_ENCRYPTION_NETWORK
    SO_BINDTODEVICE
    SO_ATTACH_FILTER
    SO_DETACH_FILTER
    SO_PEERNAME
    SO_TIMESTAMP

: ((<require|組み込み関数>)) / $LOAD_PATH

  Changed to use a new algorithm to locate a library.

  Now when requiring "foo", the following directories are searched for
  the library in the order listed.

    $prefix/lib/ruby/site_ruby/$ver/foo.rb
    $prefix/lib/ruby/site_ruby/$ver/foo.so
    $prefix/lib/ruby/site_ruby/$ver/$arch/foo.rb
    $prefix/lib/ruby/site_ruby/$ver/$arch/foo.so
    $prefix/lib/ruby/site_ruby/foo.rb
    $prefix/lib/ruby/site_ruby/foo.so
    $prefix/lib/ruby/$ver/foo.rb
    $prefix/lib/ruby/$ver/foo.so
    $prefix/lib/ruby/$ver/$arch/foo.rb
    $prefix/lib/ruby/$ver/$arch/foo.so
    ./foo.rb
    ./foo.so

  The previous behavior had a potential security risk because a
  foo.rb (if exists) in the current directory is located prior to a
  foo.so in $prefix/lib/ruby/site_ruby/$ver/$arch.

  ((<ruby-bugs:PR#140>)), ((<ruby-ext:01778>)), ((<ruby-dev:13659>))

: sync
: mutex_m

  Fixed for obj.extend(Sync_m) and obj.extend(Mutex_m).((<ruby-dev:13463>))

    $ ruby -v -rsocket -rmutex_m -e 's=TCPSocket.new("localhost",25); s.extend(Mutex_m)'
    ruby 1.6.4 (2001-06-04) [i386-linux]
    /usr/lib/ruby/1.6/mutex_m.rb:104:in `initialize': wrong # of arguments (0 for 1) (ArgumentError)
            from /usr/lib/ruby/1.6/mutex_m.rb:104:in `initialize'
            from /usr/lib/ruby/1.6/mutex_m.rb:50:in `mu_extended'
            from /usr/lib/ruby/1.6/mutex_m.rb:34:in `extend_object'
            from -e:1:in `extend'
            from -e:1

: $SAFE / ((<load|組み込み関数>))

  1 <= $SAFE <= 3 で、第二引数が true のとき汚染されたファイル名を
  指定しても load() できてしまうバグが修正されました。((<ruby-dev:13481>))

    $SAFE = 1
    filename = "foo"
    filename.taint
    p load(filename, true)

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       true

    => ruby 1.6.4 (2001-08-06) [i586-linux]
       -:4:in `load': Insecure operation - load (SecurityError)
            from -:4

: ((<Regexp>))

  以下で、前者がマッチしませんでした。((<ruby-talk:16233>))

    puts "OK 1" if /(.|a)bd/ =~ "cxbd"
    puts "OK 2" if /(a|.)bd/ =~ "cxbd"

    => ruby 1.6.4 (2001-06-04) [i586-linux]
       OK 2
    => ruby 1.6.4 (2001-08-06) [i586-linux]
       OK 1
       OK 2

: ((<Marshal>))

  モジュールのロードの型チェックに誤りがありました。この変更によりdump
  フォーマットのマイナーバージョンが1あがりました

    p Marshal.dump(Object.new).unpack("CC").join(".")
        => ruby 1.6.4 (2001-06-04) [i586-linux]
           "4.5"
    p Marshal.dump(Object.new).unpack("CC").join(".")
        => ruby 1.6.4 (2001-06-11) [i586-linux]
           "4.6"

: $SAFE / ((<クラス／メソッドの定義/def>))

  doc/NEWS には

    Fixed so defining a new method is allowed under $SAFE == 4, which
    previously wasn't.

  とあるけど実際にはできません。

    $SAFE = 4; def a; end

    => -:1: Insecure operation `(null)' at level 4 (SecurityError)
       ruby 1.6.4 (2001-06-04) [i586-linux]

    => -:1: Insecure: can't define method (SecurityError)
       ruby 1.6.4 (2001-08-06) [i586-linux]

  対応するChangeLogは以下のようです。

    Tue Jun  5 15:16:06 2001  Yukihiro Matsumoto  <matz@ruby-lang.org>

            * eval.c (rb_add_method): should not call rb_secure(), for
              last_func may not be set.

  差分は以下のようです。

    @@ -227,10 +227,7 @@ rb_add_method(klass, mid, node, noex)
         NODE *body;

         if (NIL_P(klass)) klass = rb_cObject;
    -    if (klass == rb_cObject) {
    -       rb_secure(4);
    -    }
    -    if (rb_safe_level() >= 4 && !OBJ_TAINTED(klass)) {
    +    if (rb_safe_level() >= 4 && (klass == rb_cObject || !OBJ_TAINTED(klass))) {
            rb_raise(rb_eSecurityError, "Insecure: can't define method");
         }
         if (OBJ_FROZEN(klass)) rb_error_frozen("class/module");

  また今度調べ直します。

: ((<IO>))#ioctl

  第二引数に Bignum も受け付けるようになりました(long int の範囲をカバー
  するため)

== 1.6.3 (2001-03-19) -> 1.6.4 (2001-06-04)

: ((<Hash>))#replace

  ハッシュのイテレート中に、そのハッシュのある要素を削除して、
  他のハッシュへreplaceするとAbortしていました。((<ruby-dev:13432>))

    h  = { 10 => 100, 20 => 200 }
    h2 = { }

    h.each { |k, v|
      if (k == 10)
        h.delete(10)
        h2.replace(h)  # => Abort core dumped
      end
    }

: $SAFE / ((<File>)).unlink

  File.unlink は引数が汚染されてなくても $SAFE >= 2 の環境下では
  禁止するようになりました。((<ruby-dev:13426>))

    touch foo
    ruby -v -e '$SAFE=2;File.unlink("foo")'

    => ruby 1.6.3 (2001-03-19) [i586-linux]
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       -e:1:in `unlink': Insecure operation `unlink' at level 2 (SecurityError)
               from -e:1

: ((<Object>))#untaint

  凍結したオブジェクトに対してuntaintできないようにしました。((<ruby-dev:13409>))

    a = Object.new
    a.taint
    a.freeze
    a.untaint

    => ruby 1.6.3 (2001-03-19) [i586-linux]
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       -:4:in `untaint': can't modify frozen object (TypeError)
               from -:4

: ruby -T4

  オプション ((<-T4|Rubyの起動/-T[level]>)) を指定したとき、ARGV を
  変更できないためプログラムの実行ができませんでした。
  ((<ruby-dev:13401>))

    touch foo
    ruby-1.6.3 -v -T4 foo
    => ruby 1.6.3 (2001-03-19) [i586-linux]
       foo: Insecure: can't modify array (SecurityError)

: ((<Regexp>))

  正規表現中の \1 .. \9 は常にバックリファレンスとして解釈されるように
  なりました(以前は対応する括弧があればバックリファレンス、なければ8進
  の文字コードとして解釈されていました)。

  正規表現で8進文字コードを指定するには \001 のように3桁で指定します。

  また、対応する括弧のないバックリファレンスや対応する括弧が自身を含む
  バックリファレンスは常にマッチに失敗するようになりました。

    p /(foo)\2/ =~ "foo\002"
    => ruby 1.6.3 (2001-03-19) [i586-linux]
       0
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       0
    => ruby 1.6.4 (2001-08-23) [i586-linux]
       nil

  (上記の通り 1.6.4 にはまだバグがありました 2001-08-23 あたりで修正さ
  れています ((<ruby-list:30975>)))

    p /(foo\1)/ =~ "foo"
    => ruby 1.6.3 (2001-03-19) [i586-linux]
       0
    => ruby 1.6.4 (2001-06-04) [i586-linux]
       nil

: 汚染文字列の伝搬

  以下は、すべて true を返すようになりました。((<ruby-dev:13340>))

    # []=
    s1 = "abc"
    s2 = "cde".taint
    s1[0]= s2
    p s1.tainted?             # => false

    # crypt
    s = "abc".taint
    p s.crypt("cd").tainted?  # => false

    # ljust
    s = "abc".taint
    p s.ljust(10).tainted?    # => false

    # rjust
    s = "abc".taint
    p s.rjust(10).tainted?    # => false

    # center
    s = "abc".taint
    p s.center(10).tainted?   # => false

: rb_yield_0()

  C API から yield されたとき 1 つの引数が 1 要素の配列として渡されていました。
  ((<ruby-dev:13299>))

    class X
      include Enumerable

      def each(&block)
        block.call(1,2)
        block.call(2,3)
        block.call(3,4)
      end
    end

    x = X.new
    p x.to_a #=> [[1], [2], [3]]

    # => ruby 1.6.3 (2001-03-19) [i586-linux]
         [[1], [2], [3]]

    # => ruby 1.6.4 (2001-06-04) [i586-linux]
         [1, 2, 3]

: $SAFE / alias

  $SAFE = 4 のときグローバル変数のエイリアスを許さないようにしました。
  ((<ruby-dev:13287>))

: ((<open3/Open3.popen3>))

  終了したプロセスが at_exit を呼ばないようにしました。
  (exit を exit! に修正) ((<ruby-dev:13170>))

: ((<SizedQueue>))#pop

  以下のコードでデッドロックが起こらないようにしました。((<ruby-dev:13169>))

    ruby -r thread -e 'q = SizedQueue.new(1); q.push(1);'\
                   -e 'Thread.new{sleep 1; q.pop}; q.push(1);'

: ((<SizedQueue>))#max=

  maxが現在値より大きい時にその差の分だけ待ちスレッドを起こす処理
  の判定に誤りがありました。((<ruby-dev:13170>))

: ((<Queue>))
: ((<SizedQueue>))

  ((<Thread>))#run を呼ぶ直前にスレッドが死んでいた場合に ((<ThreadError>))
  が発生する問題に対処しました。((<ruby-dev:13194>))

: Ctrl-C (Interrupt)が効かなくなる

  ((<ruby-dev:13195>))

    th1 = Thread.start {
      begin
        Thread.stop
      ensure
        Thread.pass
        Thread.stop
      end
    }
    sleep 1

  (確認できる限りでは ruby-1.7.0 (2001-05-17) 以降で治ってますが、
  1.6 には取り込まれていません)

: ((<Array>))#&
: ((<Array>))#|
: ((<Array>))#uniq

  結果の配列の要素が freeze され変更不可になっていました。((<ruby-list:29665>))

    (%w(foo bar) & %w(foo baz))[0].upcase!
    => -:1:in `upcase!': can't modify frozen string (TypeError)

    %w(foo bar bar baz).uniq[0].upcase!
    => -:1:in `upcase!': can't modify frozen string (TypeError)

: ((<shell>))

    shell 0.6 が標準ライブラリとして新規に追加されました。
    (ドキュメントが doc ディレクトリにあります)

: ((<forwardable>))

    forwardable 1.1 が標準ライブラリとして新規に追加されました。
    (ドキュメントが doc ディレクトリにあります)

: ((<irb>)) & irb-tools

    irb と irb-tools がそれぞれ 0.7.4 と 0.7.1 にバージョンアップしました。

: 夏時間

  夏時間の考慮に不備がありました(？) ((<ruby-bugs-ja:PR#46>))

    env TZ=America/Managua ruby -e 'p Time.local(1998,12,1,0,59,59)'
    => Mon Nov 30 01:59:59 EST 1998
    env TZ=America/Managua ruby -e 'p Time.local(1998,12,1,0,59,59).tv_sec'   
    => 912409199

: SIGINFO

  4.4BSD のシグナル SIGINFO に対応しました。((<ruby-bugs-ja:PR#45>))

: ((<Thread>)).stop で SEGV

  ((<Thread>)).stop で SEGV することがありました。((<ruby-dev:13189>))

: rescue 修飾

  以下が 1.6.3 で parse error になっていたバグが修正されました。
  ((<ruby-dev:13073>)), ((<ruby-dev:13292>))

    raise "" rescue []
    raise "" rescue (p "foo"; true)
    raise "" rescue -1
    raise "" rescue (-1)

: ((<Thread>))

  以下は dead lock にならなくなりました。

    Thread.start { Thread.stop }
    sleep

    => deadlock 0x40199b58: 2:0  - -:1
       deadlock 0x401a2528: 2:4 (main) - -:2
       -:2:in `sleep': Thread: deadlock (fatal)
               from -:2
       ruby 1.6.3 (2001-03-19) [i586-linux]

: ((<Module>))#const_defined?
: ((<Module>))#const_get
: ((<Module>))#const_set

  これらのメソッドが定数以外にアクセス可能になっていたバグが修正されました
  ((<ruby-dev:13019>))

: ((<Marshal>)).dump

  ((<Float>)) を dump するときの精度が "%.12g" から "%.16g" になりました。
  ((<ruby-list:29349>))

: ((<Fixnum>))#[]

  sizeof(long) > sizeof(int) なシステムでのバグが修正されたようです。

: 正規表現

  まれなバグが2件修正されました ((<ruby-talk:13658>)), ((<ruby-talk:13744>))

: retry

  以下が 1.6.3 で正常に機能しませんでした((<ruby-talk:13957>))

        def WHILE(cond)
          return if not cond
          yield
          retry
        end

        i=0
        WHILE(i<3) {
          print i
          i+=1
        }

        ruby 1.6.2 (2000-12-25) [i586-linux]
        => 012

        ruby 1.6.3 (2001-03-19) [i586-linux]
        => 0

        ruby 1.6.4 (2001-05-02) [i586-linux]
        => 012

: ((<File::Stat>))#size

  1G byte 以上のファイルに対して正しくファイルサイズを返していませんでした。

        File.open("/tmp/1GB", "w") {|f|
          f.seek(2**30-1, 0)
          f.puts
          f.flush
          p f.stat.size
        }

        # => ruby 1.6.3 (2001-04-03) [i586-linux]
             -1073741824
        # => ruby 1.6.4 (2001-04-19) [i586-linux]
             1073741824

: ((<Float>))#modulo, ((<Float>))#divmod

  なんか修正されたみたいです ((<ruby-dev:12718>))

: ((<ObjectSpace>))#_id2ref

  不正に例外を返す場合がありました。

: malloc の再帰呼び出し問題

  stdio が内部で malloc() を呼び出す場合、Thread と相性が悪かったことに対
  処しました。(setvbuf() を使用することで malloc() が呼ばれるのを避けた)
  ((<ruby-dev:12795>))

: ((<File>))#flock

  File#flock がロック済みの場合に false を返さず Errno::EACCES 例外を
  あげる場合がありました(flock()がないシステムの場合)

: ((<File::Stat>)).new(filename)

  追加 ((<ruby-dev:12803>))

: ((<Bignum>))#% の計算誤り

  % の計算に誤りが出ることがあるバグが(再度)修正されました

        a = 677330545177305025495135714080
        b = 14269972710765292560
        p a % b  #=> 0
        p -a % b #=> 

        => ruby 1.6.3 (2001-04-02) [i386-cygwin]
           0
           14269972710765292560

        => ruby 1.6.4 (2001-04-19) [i586-linux]
           0
           0

: ((<Marshal>))
  Bignum を dump -> load した結果が元の値と異なる場合がありました。

  これに関連する修正が 1.6.3 リリース後、3回ほど行われています。
  stable-snapshot の
    ruby 1.6.3 (2001-03-22)
  以降を使用してください。

: Universal Naming Convention(UNC) のサポート(win32)
  UNC 形式のパス名 (//host/share) がサポートされました。
  バックスラッシュ(`(({\}))')ではなくスラッシュ(`(({/}))')を使います。
  (元もとサポートされてたのがバグ修正された？？)

: ((<Dir>)).glob (win32)
  カレントディレクトリ(./)に対するglobが失敗していました。
        p Dir["./*.c"]
        => []

== 1.6.2 -> 1.6.3 (2001-03-19)

: do .. end と { .. }
  結合強度の違いがなくなっていたバグが修正されました。

  1.6.0 から 1.6.2 までのバージョンでは、
     method v { .. }
     method v do .. end
  の両者に違いがありませんでした。本来の挙動は((<メソッド呼び出し/イテレータ>))
  に書かれた通りです。

: ((<Bignum>))#% の計算誤り
  % の計算に誤りが出ることがあるバグが修正されました

    ruby-1.6.2 -ve 'p 6800000000%4000000000'
    => ruby 1.6.2 (2000-12-25) [i586-linux]
       -1494967296

    ruby-1.6.3 -ve 'p 6800000000%4000000000'
    => ruby 1.6.3 (2001-03-10) [i586-linux]
       2800000000

: 特異メソッド定義
  通常のメソッド定義と同様に rescue, ensure 節の指定が可能になりました

    obj = Object.new
    def obj.foo
    rescue
    ensure
    end

: ((<String>))#count
: ((<String>))#delete
: ((<String>))#squeeze
: ((<String>))#tr
: ((<String>))#tr_s
  '\-' で '-' を指定可能になりました(tr! 等、bang method も同様)。
  以前は、文字列の先頭または末尾の'-'だけを'-'と見なしていました。

    p "-".tr("a-z",  "+")  # => "-"
    p "-".tr("-az",  "+")  # => "+"
    p "-".tr("az-",  "+")  # => "+"
    p "-".tr('a\-z', "+")  # => "+" # シングルクォート文字列であることに注意
    p "-".tr("a\\-z", "+") # => "+" # "" では二重に\が必要

: ((<Regexp>))#==
  すべてのオプションも同じならば同じと判断するようになりました。
  以前は、漢字コード指定と /i (case-insensitive) の指定が同じで
  あれば同じと判断していました。

: %q(), %w()
  リテラルの終了文字(`)'など)をバックスラッシュエスケープ可能になりました。

: ((<Dir>)).glob
  "**/" がシンボリックリンクを辿らなくなりました。

: ((<String>))#[]
  "a"[1,2] が "" を返すようになりました。

    p "a"[1,2]
    => ""

  これは本来の挙動です。過去のバージョン(1.4.6など)もこの値を返していました。
  1.6.0 以降 1.6.2 までは上記は (({nil})) になります。

  (({p "a"[2,1]})) は、(({nil})) を返します。

: ((<Object>))#taint
  ((<freeze|Object>)) したオブジェクトに対して (({taint})) できなくなりました

    obj = Object.new.freeze
    obj.taint
    => -:2:in `taint': can't modify frozen object (TypeError)
               from -:2
