###nonref

= 1.6.8から1.8.0への変更点(まとめ)

* ((<1.6.8から1.8.0への変更点(まとめ)/インタプリタの変更>))
* ((<1.6.8から1.8.0への変更点(まとめ)/追加されたクラス／モジュール>))
* ((<1.6.8から1.8.0への変更点(まとめ)/追加されたメソッド>))
* ((<1.6.8から1.8.0への変更点(まとめ)/追加された定数>))
* ((<1.6.8から1.8.0への変更点(まとめ)/拡張されたクラス／メソッド(互換性のある変更)>))
* ((<1.6.8から1.8.0への変更点(まとめ)/変更されたクラス／メソッド(互換性のない変更)>))
* ((<1.6.8から1.8.0への変更点(まとめ)/文法の変更>))
* ((<1.6.8から1.8.0への変更点(まとめ)/正規表現>))
* ((<1.6.8から1.8.0への変更点(まとめ)/Marshal>))
* ((<1.6.8から1.8.0への変更点(まとめ)/Windows 対応>))
* ((<1.6.8から1.8.0への変更点(まとめ)/廃止された(される予定の)機能>))
* ((<1.6.8から1.8.0への変更点(まとめ)/ライブラリ>))
* ((<1.6.8から1.8.0への変更点(まとめ)/拡張ライブラリAPI>))
* ((<1.6.8から1.8.0への変更点(まとめ)/バグ修正>))
* ((<1.6.8から1.8.0への変更点(まとめ)/サポートプラットフォームの追加>))

== インタプリタの変更

: ((<組み込み変数/$defout>)) [obsolete]
: ((<組み込み変数/$deferr>)) [obsolete]
: ((<組み込み変数/$stdout>)) [change]
: ((<組み込み変数/$stderr>)) [change]
: ((<組み込み変数/$stdin>))  [change]

  $stdout, $stderr は、$defout, $deferr の別名になり
  $defout, $deferr は ((<obsolete>)) になりました

  $stdin は、普通のグローバル変数となりました(STDINをリダイレクトする
  動作はなくなりました)

  $defout や $deferr に代入を行うと警告がでます。
  (注：1.6 に $deferr はありません)
  ((<ruby-dev:20961>))

  $stdin にオブジェクトを代入すると標準入力からの入力メソッド(gets 等)
  はそのオブジェクトにメソッドを投げます。
  (リダイレクトしなくなった点を除けば、1.6 とそれほど違いはないようです)

: ((<組み込み変数/$VERBOSE>))

  三段階のレベルを持つようになりました。
  * nil: 警告を出力しない   (-W0 新しい警告レベル)
  * false: 重要な警告のみ出力  (-W1 デフォルト)
  * true: すべての警告を出力する (-W2 or -W or -v or -w or --verbose)

  追加された -W オプションは $VERBOSE = nil の指定(-W0)を可能にします。

: ruby interpreter [ruby] [change]

  クラスの特異クラスの特異クラスは特異クラス自身であると定義されました
  ((<ruby-bugs-ja:313>))。なんだかよくわかりません(^^;

        class << Object
          p [self.id, self]
          class << self
            p [self.id, self]
          end
        end
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           [537771634, Class]
           [537742484, Class]
        => ruby 1.7.3 (2002-09-05) [i586-linux]
           [537771634, #<Class:Object>]
           [537771634, #<Class:Object>]

  さらに、オブジェクトの特異クラスのスーパークラスの特異クラスと
  オブジェクトの特異クラスの特異クラスのスーパークラスは同じなのだそうです
  ((<ruby-bugs-ja:324>))。さあっぱりわかりません(^^;;

        class << Object.new
          class << self.superclass
            p [self.id, self]
          end
          class << self
            p [self.superclass.id, self.superclass]
          end
        end
        => ruby 1.6.7 (2002-03-01) [i586-linux]
           [537771634, Class]
           [537771644, Class]
        => ruby 1.7.3 (2002-09-05) [i586-linux]
           [537771634, #<Class:Object>]
           [537771634, #<Class:Object>]

  ((<ruby-bugs-ja:336>)) のあたりでまた少し変わったかもしれません
  (2002-09-21 の ChangeLog 参照。まじめにおっかけるのに疲れたらしい
  ^^;;)

: ((<Proc/Proc.new>)) [change]
: ((<組み込み関数/lambda>))   [change]
: ((<組み込み関数/proc>))     [change]

  以下のように変更されました。((<ruby-dev:20358>))

      * Proc.new およびブロック引数で与えられる Proc は
        引数チェックがゆるい。break が例外になる。

            Proc.new {|a,b,c| p [a,b,c]}.call(1,2)
                => -:1: wrong # of arguments (2 for 3) (ArgumentError)
                        from -:1:in `call'
                        from -:1
                   ruby 1.6.8 (2002-12-24) [i586-linux]
                => ruby 1.8.0 (2003-06-21) [i586-linux]
                   [1, 2, nil]

            Proc.new { break }.call

                => ruby 1.6.8 (2002-12-24) [i586-linux]

                => -:1:in `call': break from proc-closure (LocalJumpError)
                        from -:1
                   ruby 1.8.0 (2003-06-21) [i586-linux]

      * lambda および proc が返す Proc は引数チェックが厳しい。
        break は実行を中断する。

            lambda {|a,b,c| p [a,b,c]}.call(1,2)
                => -:1: wrong # of arguments (2 for 3) (ArgumentError)
                        from -:1:in `call'
                        from -:1
                   ruby 1.6.8 (2002-12-24) [i586-linux]
                => -:1: wrong number of arguments (2 for 3) (ArgumentError)
                        from -:1:in `call'
                        from -:1
                   ruby 1.8.0 (2003-06-21) [i586-linux]

            lambda { break }.call
                => ruby 1.6.8 (2002-12-24) [i586-linux]
                => ruby 1.8.0 (2003-06-21) [i586-linux]


  以下のようにイテレータブロックと、Procをブロックとして引数で渡したと
  きの挙動が同じになっています。

        def foo
          yield 1,2,3,4
        end

        foo {|a,b,c| p [a,b,c]; break }

        foo( &proc {|a,b,c| p [a,b,c]; break } )

        foo( &Proc.new {|a,b,c| p [a,b,c]; break } )

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           [1, 2, 3]
           [1, 2, 3]
           -:2: break from proc-closure (LocalJumpError)
        => ruby 1.8.0 (2003-06-21) [i586-linux]
           [1, 2, 3]
           [1, 2, 3]
           [1, 2, 3]

: ((<yield|メソッド呼び出し/yield>))

  ブロックパラメータの数が一つの場合、ブロックに複数の値を渡すと警告が
  出るようになりました。

  以前は |var| は一つの引数を受けるときと、複数の引数を受けるときの両
  方で利用されていましたが、将来は「一つの引数を受ける」ことを意味する
  ようになります。((<ruby-dev:20358>))

: defined? [compat]

  属性代入、配列要素への代入に対して "method" でなく "assignment" を返
  すようになりました。

: ((<リテラル/数値リテラル>)) [compat]

  10進((*整数*))リテラルの prefix として 0d が追加されました。
  8進リテラルの prefix として 0 以外に 0o が追加されました。

  Integer(), String#to_i、String#oct もこの prefix を認識します。

: ((<メソッド引数の & 修飾|メソッド呼び出し/イテレータ>)) [compat]
: ((<Proc#to_proc|Proc/to_proc>)) [new]

  メソッドに渡す引数に & を修飾した場合、渡すオブジェクトが to_proc を
  持っていればそれを実行し、その結果をブロックとして渡すようになりまし
  た。以前は、& 修飾できるのは Proc, Method オブジェクト限定でした。
  これに伴い Proc#to_proc が追加されました。

: 終了ステータス [compat]

  raise SystemExit したときに終了ステータス 1 で終了するようになりました。
  ((<ruby-dev:16776>))

: ((<"rescue/ensure on begin .. end while"|制御構造/while 修飾子>)) [compat]

  rescue/ensure を持つ begin 式も while/until 修飾できるようになりまし
  た。

  以前は、rescue/ensure を持つ while/until 修飾式は、通常の begin 式に
  while/until 修飾していると見なされ本体が必ず最初に実行されるという振
  るまい(C の do ... while 構文と同じ)をしていませんでした。
  ((<ruby-list:34618>))

: ((<"rescue/ensure on class/module"|クラス／メソッドの定義/クラス定義>)) [compat]

  メソッド定義のほかにもクラス定義やモジュール定義にもrescue/ensureを
  つけられるようになりました。

: [ruby] [compat]

  内部のハッシュテーブルを使用することにより定数参照の速度を改善したそうです。
  (ChangeLogの
        Tue Jun  5 16:15:58 2001  Yukihiro Matsumoto  <matz@ruby-lang.org>
  に該当するようです)

: break and next        [compat]

  break, next は、引数を指定することでイテレータや yield の値を返す
  ことができるようになりました。(この機能はまだ実験です)

  break [n] はイテレータを終了させ、n がそのイテレータの戻り値になります。
  next [n] はブロックを抜け、n が yield の戻り値になります。

: to_str        [compat]

  to_str を定義したオブジェクトはより広範囲にStringとして振舞うように
  なりました。

  文字列を引数に取るほとんどの組み込みメソッドは、to_str による暗黙の
  型変換を試みます。

: 範囲演算子式中のリテラル [ruby] [change]
  範囲演算子式中の単独の数値リテラルが (({$.})) と比較されるのは
  -e オプションによる1行スクリプトの中だけになりました。

: rescue 節の例外クラスと発生した例外オブジェクトの比較 [ruby] [change]

  発生した例外 $! と rescue 節の例外クラスとは ((<Module#===|Module/===>))
  を使って比較するようになりました。

  以前は kind_of? による比較なので基本的な動作に変わりはありませんが、
  SystemCallError.=== は特別に errno が一致する例外を同じと見なすよう
  に再定義されました。これにより、例えば Errno::EWOULDBLOCK と 
  Errno::EAGAIN が同じ意味(同じerrno)の場合にどちらを指定しても rescue 
  できるようになりました。

  その後、errno が一致する Errno::XXX オブジェクトは同一のオブジェクト
  になったのでこの変更の効果はなくなってますが、変更自体は残ってます。
  (ユーザで例外クラスを定義するのに使えるかもしれません)
  ((<ruby-dev:19589>))

: while, until, class, module, def の値         [ruby] [change]

  while, until, class, module, def が式として値を返すようになりました。

  class/module は最後に評価した式の結果を返します。def は nil を返し
  ます。while/until は、通常 nil を返しますが、break の引数により任意
  の値を返すことができます。

: 多重代入 [change]

  多重代入の規則を見直しました。

# # derived from sample/test.rb
# a = *[]; p a                            # special case
# def f;  yield; end; f {|a| p a}         # add   (warning)
# def r; return; end; a = r(); p a
#           a = nil; p a
# def f;  yield nil; end; f {|a| p a}
# def r; return nil; end; a = r(); p a
#           a = 1; p a
# def f;  yield 1; end; f {|a| p a}
# def r; return 1; end; a = r(); p a
#           a = []; p a
# def f;  yield []; end; f {|a| p a}
# def r; return []; end; a = r(); p a
#           a = [1]; p a
# def f;  yield [1]; end; f {|a| p a}
# def r; return [1]; end; a = r(); p a
#           a = [nil]; p a
# def f;  yield [nil]; end; f {|a| p a}
# def r; return [nil]; end; a = r(); p a
#           a = [[]]; p a
# def f;  yield [[]]; end; f {|a| p a}
# def r; return [[]]; end; a = r(); p a
#           a = [1,2]; p a
#           a = [*[]]; p a
# def f;  yield [*[]]; end; f {|a| p a}
# def r; return [*[]]; end; a = r(); p a
#           a = [*[1]]; p a
# def f;  yield [*[1]]; end; f {|a| p a}
# def r; return [*[1]]; end; a = r(); p a
#           a = [*[1,2]]; p a
# def f;  yield [*[1,2]]; end; f {|a| p a}
# def r; return [*[1,2]]; end; a = r(); p a
# 
#           a = *nil; p a
# def f;  yield *nil; end; f {|a| p a}
# def r; return *nil; end; a = r(); p a
#           a = *1; p a
# def f;  yield *1; end; f {|a| p a}
# def r; return *1; end; a = r(); p a
#           a = *[]; p a
# def f;  yield *[]; end; f {|a| p a}                 # add (warning)
# def r; return *[]; end; a = r(); p a
#           a = *[1]; p a
# def f;  yield *[1]; end; f {|a| p a}
# def r; return *[1]; end; a = r(); p a
#           a = *[nil]; p a
# def f;  yield *[nil]; end; f {|a| p a}
# def r; return *[nil]; end; a = r(); p a
#           a = *[[]]; p a
# def f;  yield *[[]]; end; f {|a| p a}
# def r; return *[[]]; end; a = r(); p a
#           a = *[1,2]; p a
# def f;  yield *[1,2]; end; f {|a| p a}            # add
# def r; return *[1,2]; end; a = r(); p a         # add
#           a = *[*[]]; p a
# def f;  yield *[*[]]; end; f {|a| p a}            # add(warning)
# def r; return *[*[]]; end; a = r(); p a
#           a = *[*[1]]; p a
# def f;  yield *[*[1]]; end; f {|a| p a}
# def r; return *[*[1]]; end; a = r(); p a
#           a = *[*[1,2]]; p a
# def r; return *[*[1,2]]; end; a = r(); p a
# 
# *a = *[]; p a                          # special case
# def f;  yield; end; f {|*a| p a}
# def r; return; end; *a = r(); p a
#          *a = nil; p a
# def f;  yield nil; end; f {|*a| p a}
# def r; return nil; end; *a = r(); p a
#          *a = 1; p a
# def f;  yield 1; end; f {|*a| p a}
# def r; return 1; end; *a = r(); p a
#          *a = []; p a
# def f;  yield []; end; f {|*a| p a}
# def r; return []; end; *a = r(); p a
#          *a = [1]; p a
# def f;  yield [1]; end; f {|*a| p a}
# def r; return [1]; end; *a = r(); p a
#          *a = [nil]; p a
# def f;  yield [nil]; end; f {|*a| p a}
# def r; return [nil]; end; *a = r(); p a
#          *a = [[]]; p a
# def f;  yield [[]]; end; f {|*a| p a}
# def r; return [[]]; end; *a = r(); p a
#          *a = [1,2]; p a
# def f;  yield [1,2]; end; f {|*a| p a}
# def r; return [1,2]; end; *a = r(); p a
#          *a = [*[]]; p a
# def f;  yield [*[]]; end; f {|*a| p a}
# def r; return [*[]]; end; *a = r(); p a
#          *a = [*[1]]; p a
# def f;  yield [*[1]]; end; f {|*a| p a}
# def r; return [*[1]]; end; *a = r(); p a
#          *a = [*[1,2]]; p a
# def f;  yield [*[1,2]]; end; f {|*a| p a}
# def r; return [*[1,2]]; end; *a = r(); p a
# 
#          *a = *nil; p a
# def f;  yield *nil; end; f {|*a| p a}
# def r; return *nil; end; *a = r(); p a
#          *a = *1; p a
# def f;  yield *1; end; f {|*a| p a}
# def r; return *1; end; *a = r(); p a
#          *a = *[]; p a
# def f;  yield *[]; end; f {|*a| p a}
# def r; return *[]; end; *a = r(); p a
#          *a = *[1]; p a
# def f;  yield *[1]; end; f {|*a| p a}
# def r; return *[1]; end; *a = r(); p a
#          *a = *[nil]; p a
# def f;  yield *[nil]; end; f {|*a| p a}
# def r; return *[nil]; end; *a = r(); p a
#          *a = *[[]]; p a
# def f;  yield *[[]]; end; f {|*a| p a}
# def r; return *[[]]; end; *a = r(); p a
#          *a = *[1,2]; p a
# def f;  yield *[1,2]; end; f {|*a| p a}         # add
# def r; return *[1,2]; end; *a = r(); p a
#          *a = *[*[]]; p a
# def f;  yield *[*[]]; end; f {|*a| p a}
# def r; return *[*[]]; end; *a = r(); p a
#          *a = *[*[1]]; p a
# def f;  yield *[*[1]]; end; f {|*a| p a}
# def r; return *[*[1]]; end; *a = r(); p a
#          *a = *[*[1,2]]; p a
# def f;  yield *[*[1,2]]; end; f {|*a| p a}
# def r; return *[*[1,2]]; end; *a = r(); p a
# 
# a,b,*c = *[]; p [a,b,c]                          # special case
# def f;  yield; end; f {|a,b,*c| p [a,b,c]}
# def r; return; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = nil; p [a,b,c]
# def f;  yield nil; end; f {|a,b,*c| p [a,b,c]}
# def r; return nil; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = 1; p [a,b,c]
# def f;  yield 1; end; f {|a,b,*c| p [a,b,c]}
# def r; return 1; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = []; p [a,b,c]
# def f;  yield []; end; f {|a,b,*c| p [a,b,c]}
# def r; return []; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [1]; p [a,b,c]
# def f;  yield [1]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [1]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [nil]; p [a,b,c]
# def f;  yield [nil]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [nil]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [[]]; p [a,b,c]
# def f;  yield [[]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [[]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [1,2]; p [a,b,c]
# def f;  yield [1,2]; end; f {|a,b,*c| p [a,b,c]}        # add
# def r; return [1,2]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [*[]]; p [a,b,c]
# def f;  yield [*[]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [*[]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [*[1]]; p [a,b,c]
# def f;  yield [*[1]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [*[1]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = [*[1,2]]; p [a,b,c]
# def f;  yield [*[1,2]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return [*[1,2]]; end; a,b,*c = r(); p [a,b,c]
# 
#      a,b,*c = *nil; p [a,b,c]
# def f;  yield *nil; end; f {|a,b,*c| p [a,b,c]}
# def r; return *nil; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *1; p [a,b,c]
# def f;  yield *1; end; f {|a,b,*c| p [a,b,c]}
# def r; return *1; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[]; p [a,b,c]
# def f;  yield *[]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[1]; p [a,b,c]
# def f;  yield *[1]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[1]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[nil]; p [a,b,c]
# def f;  yield *[nil]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[nil]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[[]]; p [a,b,c]
# def f;  yield *[[]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[[]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[1,2]; p [a,b,c]
# def f;  yield *[1,2]; end; f {|a,b,*c| p [a,b,c]}       # add
# def r; return *[1,2]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[*[]]; p [a,b,c]
# def f;  yield *[*[]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[*[]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[*[1]]; p [a,b,c]
# def f;  yield *[*[1]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[*[1]]; end; a,b,*c = r(); p [a,b,c]
#      a,b,*c = *[*[1,2]]; p [a,b,c]
# def f;  yield *[*[1,2]]; end; f {|a,b,*c| p [a,b,c]}
# def r; return *[*[1,2]]; end; a,b,*c = r(); p [a,b,c]

: 配列展開 [change]

  以下の挙動を修正しました。
  現在は、1要素の配列も正常に展開されます。

    a = *[1]
    p a #=> [1]

    => ruby 1.6.8 (2002-12-24) [i586-linux]
       [1]
    => ruby 1.7.1 (2001-06-05) [i586-linux]
       1

== 追加されたクラス／モジュール
: ((<Process::UID>))  [new]
: ((<Process::GID>))  [new]
: ((<Process::Sys>))  [new]
: ((<Signal>)) モジュール       [new]
: ((<Process::Status>))         [new]
: ((<NoMethodError>))   [new]

  ((<Process::Status>)) の追加により、(({$?})) の値も整数からこのクラ
  スのインスタンスになりました。

=== クラス階層

: ((<File::Constants>))

  File::Constants は、File クラスでなく IO クラスが include するように
  なりました。((<ruby-dev:20964>))

: ((<UnboundMethod>)) [compat]

  UnboundMethod クラスは Method クラスのサブクラスではなくなりました。
  UnboundMethod#call, UnboundMethod#unbind はなくなりました。
  ((<ruby-core:00927>))


: ((<NameError>)) & ((<NoMethodError>)) [change]

  NameError を StandardError のサブクラスに戻しました。
  クラス階層は以下のようになりました。

    NoMethodError < NameError < StandardError.

: ((<Interrupt>))                       [change]
  Interrupt は、((<SignalException>))のサブクラスになりました。
  (1.6以前はExceptionのサブクラス)

== 追加されたメソッド
=== 組み込み関数

: ((<組み込み関数/warn>))  [new]
: ((<組み込み変数/$deferr>)) [new]

  追加

  以前は、ruby インタプリタが出力する error/warning メッセージは STDERR
  固定でしたが、$stderr に変更されました。($deferr はすぐに obsolete に
  なりました。$stderr を使ってください)

=== ARGF

: ((<ARGF/ARGF.path>)) [new]

  追加 (ARGF.filename の別名) ((<ruby-dev:20197>))

=== Array

: ((<Array#transpose|Array/transpose>)) [new]

  追加

: ((<Array#zip|Enumerable/zip>)) [new]
: ((<Enumerable#zip|Enumerable/zip>)) [new]

  追加

: ((<Array#fetch|Array/fetch>))     [new]

  追加

: ((<Array#insert|Array/insert>))     [new]

  追加 ((<ruby-talk:14289>))

  (({ary[n,0] = [other,...]})) と同じ(ただし self を返す)

=== Class

: ((<Class#allocate|Class/allocate>))    [new]

    allocate と initialize の二つのメソッドでオブジェクトを
    生成するようになりました。((<ruby-dev:14847>))
    rb_define_alloc_func() も参照。

=== Dir

: ((<Dir#path|Dir/path>))       [new]

  追加

=== ENV

: ((<ENV/ENV.clear>)) [new]
: ((<ENV/ENV.shift>)) [new]
: ((<ENV/ENV.invert>)) [new]
: ((<ENV/ENV.replace>)) [new]
: ((<ENV/ENV.update>)) [new]

  ((<Hash>)) との互換性のために定義されました。

=== Enumerable

: ((<Enumerable#partition|Enumerable/partition>)) [new]

  追加

: ((<Enumerable#sort_by|Enumerable/sort_by>))      [new]

  追加。((<ruby-dev:8986>))以降で提案された Schwartzian transform
  を行うための sort です。

: ((<Enumerable#all?|Enumerable/all?>))         [new]
: ((<Enumerable#any?|Enumerable/any?>))         [new]
: ((<Enumerable#inject|Enumerable/inject>))       [new]
  追加

=== File

: ((<File/File.extname>)) [new]

  追加。ファイル名の拡張子を返します。((<ruby-talk:37617>))

: ((<File/File.fnmatch>))     [new]
: ((<File/File.fnmatch?>))    [new]
  追加

  このメソッドで使用するフラグ FNM_NOESCAPE, FNM_PATHNAME, FNM_PERIOD,
  FNM_CASEFOLD も((<File::Constants>)) モジュールに定義されました。

: ((<File/File.lchmod>))     [new]
: ((<File/File.lchown>))     [new]
  追加

=== File::Stat

: ((<File::Stat#rdev_major|File::Stat/rdev_major>)) [new]
: ((<File::Stat#rdev_minor|File::Stat/rdev_minor>)) [new]

  追加

=== Float

: ((<Numeric#to_int|Numeric/to_int>)) [new]
: ((<Float#to_int|Numeric/to_int>)) [new]

  追加。

=== Hash

: ((<Hash#merge|Hash/merge>)) [new]
: ((<Hash#merge!|Hash/merge!>)) [new]

  追加。Hash#merge は、hash.dup.update と同じ。
  Hash#merge! は、Hash#update の別名 ((<ruby-talk:59777>)), ((<ruby-dev:19463>))

: ((<Hash#default_proc|Hash/default_proc>)) [new]

  追加 ((<ruby-dev:17966>))

=== IO

: ((<IO/IO.sysopen>)) [new]
: ((<Socket#sysaccept|Socket/sysaccept>)) [new]
: ((<TCPServer#sysaccept|TCPServer/sysaccept>)) [new]
: ((<UNIXServer#sysaccept|UNIXServer/sysaccept>)) [new]

  追加

: ((<IO#sysseek|IO/sysseek>))  [new]

  追加 ((<ruby-talk:21612>)), ((<ruby-talk:36703>))

: ((<IO#fsync|IO/fsync>))     [new]

  追加

: ((<IO/IO.open>))  [new]

  追加

: ((<IO/IO.for_fd>))       [new]
  追加

: ((<IO/IO.read>))         [new]

  追加。((<ruby-talk:9460>))が実装に至った経緯だと思う

=== LocalJumpError

: ((<LocalJumpError#exit_value|LocalJumpError/exit_value>)) [new]
: ((<LocalJumpError#reason|LocalJumpError/reason>)) [new]

  追加

=== Marshal

: ((<Marshal/Object#marshal_load>))  [new]
: ((<Marshal/Object#marshal_dump>))  [new]

  追加 ((<ruby-dev:21016>))

=== MatchData

: ((<MatchData#captures|MatchData/captures>)) [new]

  追加。((<RCR#139>))

: ((<MatchData#select|MatchData/select>)) [new]

  ((<MatchData>)) は、Enumerable ではありませんが、Enumerable#select
  と同じメソッドが定義されました。

=== Math

: ((<Math/Math.erf>)) [new]
: ((<Math/Math.erfc>)) [new]

  追加 ((<ruby-list:37753>))

: ((<Math/Math.acos>))          [new]
: ((<Math/Math.asin>))          [new]
: ((<Math/Math.atan>))          [new]
: ((<Math/Math.cosh>))          [new]
: ((<Math/Math.sinh>))          [new]
: ((<Math/Math.tanh>))          [new]
: ((<Math/Math.hypot>))         [new]
    追加

=== Method

: ((<Method#==|Method/==>)) [new]

  追加

=== Module

: ((<組み込み関数/autoload>))  [change]
: ((<組み込み関数/autoload?>))  [new]
: ((<Module#autoload|Module/autoload>))  [new]
: ((<Module#autoload?|Module/autoload>))  [new]

  ネストしたクラス/モジュールに対する autoload 指定が可能になりました。
  ((<ruby-dev:16159>)), ((<ruby-dev:16165>)) ((<ruby-dev:18103>)),
  ((<ruby-dev:19686>))

: ((<Module#const_missing|Module/const_missing>))  [new]

   定義されていない定数を使用したときに const_missing という名のメソッドを
   呼ぶようになりました。デフォルトでは NameError 例外を発生させます。
   ((<ruby-core:00441>))

: ((<Module#private_method_defined?|Module/private_method_defined?>)) [new]
: ((<Module#protected_method_defined?|Module/protected_method_defined?>)) [new]

: ((<Module#public_method_defined?|Module/public_method_defined?>)) [new]
: ((<Object#methods|Object/methods>)) [change]
: ((<Module#instance_methods|Module/instance_methods>)) [change]

  追加。変更(仕様の統一)

: ((<Module#include?|Module/include?>)) [new]

  Added. ((<ruby-dev:13941>))

: ((<Module#included|Module/included>))         [new]

  追加。Module#append_feature の後に呼ばれるhook

: ((<Module#method_removed|Module/method_removed>))   [new]
: ((<Module#method_undefined|Module/method_undefined>)) [new]

  追加

=== NameError

: ((<NameError#name|NameError/name>))                [new]

  追加

=== NilClass

: ((<NilClass#to_f|NilClass/to_f>)) [new]

  追加

=== Numeric

: ((<Numeric#div|Numeric/div>)) [new]
: ((<Numeric#quo|Numeric/quo>)) [new]

  追加  ((<ruby-dev:19423>))

  ((<ruby-dev:20962>))

      * div    - 整除(divmodの第一要素)
      * /      - その数型でもっとも自然な商(異論はあるだろうけど)
      * quo    - もっとも正確に近い商
      * divmod - 整除と剰余

=== NoMethodError

: ((<NoMethodError#args|NoMethodError/args>))        [new]

  追加

=== Object

: ((<Object#initialize_copy|Object/initialize_copy>)) [change]

  追加

  このメソッドは initialize と同様、自動的に private method になります。

: ((<Object#instance_variable_get|Object/instance_variable_get>)) [new]
: ((<Object#instance_variable_set|Object/instance_variable_set>)) [new]

  追加

: ((<Object#object_id|Object/object_id>)) [new]

  追加 (Object#id は、obsolete)

: ((<Object#singleton_method_removed|Object/singleton_method_removed>)) [new]
: ((<Object#singleton_method_undefined|Object/singleton_method_undefined>)) [new]

  追加

=== Proc

: ((<Proc#binding|Proc/binding>)) [new]

  追加

: ((<Proc#to_proc|Proc/to_proc>)) [new]

  追加

# : ((<Precision>)).included      [new]
# 
#   追加(((<Module#included|Module>)) の再定義)

=== Process

: ((<Process/Process.initgroups>))  [new]
  追加

: ((<Process/Process.groups>)) [new]
: ((<Process/Process.groups=>)) [new]
: ((<Process/Process.maxgroups>)) [new]
: ((<Process/Process.maxgroups=>)) [new]

  追加
: ((<Process/Process.detach>)) [new]

  追加

: ((<Process/Process.abort>)) [new]
: ((<Process/Process.exit>)) [new]

  追加。関数 abort, exit と同じ。

: ((<Process/Process.waitall>))         [new]
  追加

: ((<Process::Status#pid|Process::Status/pid>)) [new]

  追加

=== Range

: ((<Range#step|Range/step>))     [new]

  追加。step ごとの要素で繰り返します。

: ((<Range#include?|Range/include?>))          [new]
: ((<Range#member?|Range/member?>))           [new]
  追加

=== Regexp

: ((<Regexp#to_s|Regexp/to_s>)) [new]

  追加。((<ruby-dev:16909>))

  これにより、
      re1 = /hogehoge/i
      re2 = /fugafuga/
      re3 = / #{re1} | #{re2} /x
  などと正規表現オブジェクトを正規表現に埋め込めるようになりました。

: ((<Regexp#options|Regexp/options>))          [new]
  追加

=== Socket

: ((<Socket/Socket.pack_sockaddr_in>))          [new]
: ((<Socket/Socket.unpack_sockaddr_in>))        [new]

  追加。ソケットアドレス構造体(INET domain)のpack/unpack。

: ((<Socket/Socket.pack_sockaddr_un>))      [new]
: ((<Socket/Socket.unpack_sockaddr_un>))    [new]

  追加。ソケットアドレス構造体(UNIX domain)のpack/unpack。

: ((<UNIXSocket/UNIXSocket.pair>))              [new]
: ((<UNIXSocket/UNIXSocket.socketpair>))        [new]
: ((<UNIXSocket#recv_io|UNIXSocket/recv_io>))   [new]
: ((<UNIXSocket#send_io|UNIXSocket/send_io>))   [new]

  追加

: ((<UNIXServer#listen|UNIXServer/listen>))     [new]
: ((<TCPServer#listen|TCPServer/listen>))       [new]

  追加。Socket#((<Socket/listen>))と同じ。

=== String

: ((<String#match|String/match>))      [new]

  追加 re.match(str) と同じ。

: ((<String#lstrip|String/lstrip>))     [new]
: ((<String#rstrip|String/rstrip>))     [new]
: ((<String#lstrip!|String/lstrip!>))     [new]
: ((<String#rstrip!|String/rstrip!>))     [new]

  追加。左端あるいは右端の空白類を取り除きます。
  rstrip は、右側の "\0" も取り除きます。

: ((<String#casecmp|String/casecmp>))   [new]
: ((<String#eql?|String/eql?>))         [change]

  casecmp 追加。アルファベットの大小を無視した文字列比較。

  eql? は、((<$=|組み込み変数>)) の値に関らず常にアルファベットの大小
  を区別するようになりました。

: ((<String#insert|String/insert>)) [new]

  追加

  (({str[n, 0] = other})) と同じ(ただし self を返す)

=== Struct

: ((<Struct/each_pair>)) [new]

  追加。

=== Symbol

: ((<Symbol/Symbol.all_symbols>))      [new]
  追加 ((<ruby-dev:12921>))

=== SystemCallError

: ((<SystemCallError/SystemCallError.===>))     [new]

  追加 (上記 「rescue 節の...」 を参照のこと)
  ((<ruby-dev:12670>))

: ((<SystemExit#status|SystemExit/status>))       [new]
  追加

=== Thread

: ((<Thread#keys|Thread/keys>))     [new]
  追加。Thread固有データのキーの配列を返します。


: ((<Thread#terminate|Thread/terminate>)) [new]

  追加。Thread#kill と同じ。

: ((<Thread#group|Thread/group>)) [new]
  追加

=== ThreadGroup

: ((<ThreadGroup#enclose|ThreadGroup/enclose>)) [new]
: ((<ThreadGroup#enclosed?|ThreadGroup/enclosed?>)) [new]

  追加 ((<ruby-dev:20655>))

  ThreadGroup への Thread 追加/削除を(freeze せずに)禁止します。

=== Time

: ((<Time#getgm|Time/getgm>))           [new]
: ((<Time#getlocal|Time/getlocal>))     [new]
: ((<Time#getutc|Time/getutc>))         [new]
: ((<Time#gmt_offset|Time/gmt_offset>)) [new]
: ((<Time#gmtoff|Time/gmtoff>))         [new]
: ((<Time#utc_offset|Time/utc_offset>)) [new]

  追加

=== その他

: ((<Array#values_at|Array/values_at>)) [new]
: ((<Hash#values_at|Hash/values_at>)) [new]
: ((<ENV/ENV.values_at>)) [new]
: ((<MatchData#values_at|MatchData/values_at>)) [new]
: ((<aStruct#values_at|Struct/values_at>)) [new]

  ruby 1.6 の ((<indexes|Array/indexes>)) は、values_at というメソッド
  名になりました(ruby 1.7 では block なし ((<select|Array/select>)) が
  indexes の代わりでしたが、こちらも使用すると警告が出ます)。

: ((<Fixnum#to_sym|Fixnum/to_sym>)) [new]
: ((<String#to_sym|String/to_sym>)) [new]

  追加(Symbol#intern はなくなった)

== 追加された定数

: ((<Float::DIG|Float/DIG>)) [new]
: ((<Float::EPSILON|Float/EPSILON>)) [new]
: ((<Float::MANT_DIG|Float/MANT_DIG>)) [new]
: ((<Float::MAX|Float/MAX>)) [new]
: ((<Float::MAX_10_EXP|Float/MAX_10_EXP>)) [new]
: ((<Float::MAX_EXP|Float/MAX_EXP>)) [new]
: ((<Float::MIN|Float/MIN>)) [new]
: ((<Float::MIN_10_EXP|Float/MIN_10_EXP>)) [new]
: ((<Float::MIN_EXP|Float/MIN_EXP>)) [new]
: ((<Float::RADIX|Float/RADIX>)) [new]
: ((<Float::ROUNDS|Float/ROUNDS>)) [new]

  追加 ((<ruby-math:0773>))

: ((<Marshal::MAJOR_VERSION|Marshal/MAJOR_VERSION>))          [new]
: ((<Marshal::MINOR_VERSION|Marshal/MINOR_VERSION>))          [new]
  追加。Marshal が出力するダンプフォーマットのバージョン番号です。
  ((<ruby-dev:14172>))

== 拡張されたクラス／メソッド(互換性のある変更)

=== 組み込み関数

: ((<組み込み関数/sprintf>)) [new]

  "%p" が追加されました。inspect の結果が利用されます。((<RCR#69>))

: ((<組み込み関数/trap>)) [compat]

  あるシグナルに対して、SIG_DFL や SIG_IGN が割り当てられていた場合、
  文字列 "DEFAULT" や "IGNORE" を返すようになりました(以前は、nil を返
  していました) ((<ruby-talk:67860>))

: ((<組み込み関数/system>)) [compat]
: ((<組み込み関数/exec>)) [compat]

  第一引数が配列の場合、その一つ目の要素のファイルを環境変数PATHから
  検索するようになりました。

  また、msdosdjgpp・mswin32・mingw32・bccwin32でも、他のプラットフォームと
  同様に、引数として配列が与えられた場合はシェルを経由しないようになりました。
  以前は常にシェルを経由していました(win32系portは2003-01-04に変更)。
  ((<ruby-dev:19107>))

: ((<組み込み関数/rand>)) [compat]

  乱数生成のアルゴリズムに
  ((<Mersenne Twister|URL:http://www.math.keio.ac.jp/~matumoto/mt.html>))
  を使用するようになりました。

: ((<組み込み関数/sprintf>))('%u') [compat]

  sprintf の '%u' で、最上位ビットの繰り返しをあらわす ".."  は、付加
  されないようになりました。((<ruby-dev:16522>))

: ((<組み込み関数/abort>)) [compat]

  終了メッセージを指定できるようになりました。

=== Array

: ((<Array#first|Array/first>)) [compat]
: ((<Array#last|Array/last>)) [compat]

  省略可能な引数を追加

: ((<Array#push|Array/push>)) [compat]
: ((<Array#unshift|Array/unshift>)) [compat]
: ((<Array#insert|Array/insert>)) [compat]

  引数が指定されない場合に、ArgumentError 例外が発生しなくなりました。
  (何もせずに self を返すだけです)

: ((<Array#[]|Array/[]>)) [compat]
: ((<Array#[]=|Array/[]=>)) [compat]

  配列のインデックスとして Symbol を指定した場合、Symbol#to_int を呼ば
  す、例外 ((<TypeError>)) が発生するようになりました。
  ((<ruby-list:37217>))

: ((<Array/Array.new>))         [compat]
: ((<Array#fill|Array/fill>))   [compat]

  ブロックの評価結果を fill する値として指定できるようになりました。ブ
  ロックは要素毎に評価されるので、下のような例では "val" が毎回生成さ
  れます。

: ((<Array/Array.new>))       [compat]

  Array.new の引数に配列を渡すとそのコピーを生成するようになりました。

: ((<Array#pack|Array/pack>))         [compat]
: ((<String#unpack|String/unpack>))   [compat]

  pack/unpack のテンプレートにコメントを記述できるようになりました。

: ((<Array#pack|Array/pack>))         [new]
: ((<String#unpack|String/unpack>))   [new]

  64 bit 整数のテンプレート文字 Q/q が追加されました(Quad の意)。
  Q は unsigned、q は、signed です。

: ((<Array#pack|Array/pack>))      [change]
: ((<String#unpack|String/unpack>))   [change]

    Array#pack, String#unpack のテンプレート文字 "p", "P" は、nil と
    NULLポインタの相互変換を行うようになりました((<ruby-dev:13017>))。

=== Class

: ((<Class#inherited|Class/inherited>)) [change]

  inherited メソッドはクラス定義式の終りに呼び出されるようになりました。
  ((<ruby-bugs-ja:342>))

=== Dir

: ((<Dir/Dir.glob>)) [compat]

  Dir.glob に第2引数(マッチの挙動を変更するフラグ)を指定できるようにな
  りました。Dir[] にはこのフラグは指定できません。

  関連して定数 File::FNM_DOTMATCH (FNM_PERIOD の逆の意味)が追加されて
  います。

: ((<Dir/Dir.chdir>))       [compat]
  ブロックを指定できるようになりました。

=== ENV

: ((<ENV>)) [change]

  ENV が生成する文字列はすべて ((<Object/freeze>)) されるようになりました。
  ((<ruby-talk:72732>))

        ENV['environ'] = 'value'
        ENV['environ'].sub!(/value/, 'VALUE')
        p ENV['environ']

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           "value"

  この例のように sub! のような破壊的メソッドの効果がないため混乱すると
  いうのが理由です(ENVが返す文字列を変更しても環境変数自体に影響がない)。

        => -:2:in `sub!': can't modify frozen string (TypeError)
                from -:2
           ruby 1.8.0 (2003-06-09) [i586-linux]

=== Hash

: ((<Hash#update|Hash/update>)) [compat]

  ブロックを指定できるようになりました。重複したキーに対する振舞いを制
  御できます。

: ((<Hash/Hash.new>))   [compat]

  ハッシュのデフォルト値としてブロックを指定できるようになり
  ました。ブロックを指定すると空のハッシュ要素の参照に対して
  その都度ブロックを実行し、その結果を返します。
  ブロックにはハッシュ自身と、ハッシュを参照したときのキーが渡されます

=== IO

: ((<IO/IO.new>)) [compat]

  ((<File/File.open>)) と同様に mode を数値(つまり、
  ((<File::Constants>)) の定数) で指定できるようになりました。

: ((<IO#reopen|IO/reopen>)) [compat]

  第二引数を省略したときレシーバのモードをそのまま引き継ぐようになりま
  した。以前は、第二引数のデフォルト値は "r" 固定でした。

: ((<IO#read|IO/read>)) [compat]
: ((<IO#sysread|IO/sysread>)) [compat]

  IO#read, IO#sysread に第二引数追加(あらかじめ割り当てた読み込み用バッ
  ファの指定)

=== Method

: ((<Method#inspect|Method/inspect>))   [compat]

  特異メソッドに対する出力形式がより意味のあるものになりました。
  ((<ruby-bugs-ja:PR#193>))

=== Module

: ((<Module#undef_method|Module/undef_method>)) [compat]
: ((<Module#remove_method|Module/remove_method>)) [compat]

  一度に複数のメソッドを指定できるようになりました。((<RCR#146>))

: ((<Module#method_added|Module/method_added>)) [compat]
: ((<Module#singleton_method_added|Module/singleton_method_added>)) [compat]

  拡張ライブラリからメソッドが定義されたときも呼ばれるようになりました。
  ((<ruby-talk:70471>))

: ((<Module/Module.new>))       [compat]
: ((<Class/Class.new>))         [compat]

    Module.new, Class.new でブロックが与えられた場合、生成した
    モジュール/クラスのコンテキストでブロックを実行するように
    なりました。

=== Numeric

: ((<Numeric#step|Numeric/step>)) [compat]

  ((<Fixnum>)), ((<Integer>)) から移動しました。

=== Object

: ((<Object#singleton_methods|Object/singleton_methods>))         [compat]
  省略可能な引数 all が追加されました。

: ((<Object#methods|Object/methods>)) [compat]
: ((<Object#public_methods|Object/public_methods>)) [compat]
: ((<Object#private_methods|Object/private_methods>)) [compat]
: ((<Object#protected_methods|Object/protected_methods>)) [compat]

  スーパークラスのメソッドも探索するかどうかを引数で指定できるようにな
  りました。((<Module#instance_methods|Module/instance_methods>)) など
  と同じですが、過去との互換性のため引数のデフォルト値が Module のもの
  とは逆です。(Module#instance_methods などのデフォルト値は将来(1.8.1)
  変更される予定のようです)

  ((<Object#methods|Object/methods>)) は引数が false の場合にそのオブ
  ジェクトの特異メソッドのリストを返します。つまり、
  ((<Object#singleton_methods(false)|Object/singleton_methods>)) と同
  じです。

  1.7 の変更点も含めて仕様をまとめると

        Object#methods,           Module#instance_methods,
        Object#public_methods,    Module#public_instance_methods,
        Object#private_methods,   Module#private_instance_methods,
        Object#protected_methods, Module#protected_instance_methods
        Object#singleton_methods

  * 引数が true の場合は、モジュールやスーパークラスを探索する。

  * public_xxx, private_xxx, protected_xxx はそれぞれpublic, private,
    protected メソッドのみを返す。public_, private_, protected_ がつか
    ない、methods, instance_methods は、public メソッドと protected
    メソッドを返す。

  * Object#methods(false) は Object#singleton_methods(false) と同じ。

  * 将来これらのメソッドの引数のデフォルト値は true になる予定だが、
    Module#xxx_instance_methods と Object#singleton_methods は現状デフォ
    ルト値が false(過去との互換のため。なお、省略したままだと警告が出る)。
    デフォルトに頼らないようにするべき、1.6 で使用していたスクリプトを
    書き換える場合は、false を明示的に指定する。

=== Proc

: ((<Proc#to_s|Proc/to_s>)) [compat]

  Proc#to_s の結果にスクリプトのソースファイル名と行番号が付加されまし
  た。((<ruby-dev:17968>))

=== Regexp

: ((<Regexp#===|Regexp/===>)) [compat]

  真偽値を返すようになりました。

: ((<Regexp/Regexp.last_match>))    [compat]
  optional な引数が追加されました。

=== String

: ((<String/String.new>))      [compat]

  String.new の引数を省略できるようになりました。

: ((<String/strip>))     [compat]
: ((<String/strip!>))    [compat]
: ((<String/rstrip>))    [compat]
: ((<String/rstrip!>))   [compat]

  空白類だけでなく "\0" も strip するようになりました。((<ruby-talk:76659>))

: ((<String#scan|String/scan>)) [change]
: ((<String#split|String/split>)) [change]
: ((<String#sub|String/sub>)), ((<String#sub!|String/sub!>)) [change]
: ((<String#gsub|String/gsub>)), ((<String#gsub!|String/gsub!>)) [change]
: ((<String#~|String/~>)) [obsolete]
: ((<String#=~|String/=~>)) [obsolete]
: ((<組み込み変数/$;>))   [compat]
: ((<組み込み変数/$-F>))  [compat]
: ((<Rubyの起動/-F((*regexp*))>))    [compat]

  pattern として正規表現でなく文字列を指定したとき、それを正規表現にコ
  ンパイルせず文字列そのものをパターンとして扱うようになりました。(よ
  り正確には、Regexp.compile(arg) でなく
  Regexp.compile(Regexp.quote(arg)) するようになりました)

  ((<String#~|String/~>)), ((<String#=~|String/=~>)) は、obsolete にな
  りました。(String#~ はここにあげた変更が反映された上で obsolete)

#   str =~ arg だけは、arg が文字列のとき、
#   Regexp.compile(Regexp.quote(arg)) =~ str と等価な str.index(arg) が
#   実行されます(したがって、$~ は設定されません)。

  $; の指定に正規表現が許されるようになりました。これに伴い、文字列以
  外を設定しても例外 ((<TypeError>)) は発生しないようになりました。
  ((<ruby-talk:77381>))

: ((<String#center|String/center>)) [compat]
: ((<String#ljust|String/ljust>)) [compat]
: ((<String#rjust|String/rjust>)) [compat]

  空白の代わりに詰め込む文字列を第二引数で指定できるようになりました。

: ((<String#[]|String/[]>))     [change]
: ((<String#[]=|String/[]=>))   [change]

  第一引数が正規表現を渡す形式で、オプションの第二引数 idx が追加されました。
  str[/re/, 0] は、str[/re/] と同じです。

=== Struct

: ((<Struct>)) [compat]

   Struct が適切なハッシュ値を持つよう Struct#hash, Struct#eql? が定義
   されました。((<ruby-bugs:PR#758>))

: ((<aStruct#inspect|Struct>)) [compat]

  出力形式が少しだけ変わりました。

=== Socket

: ((<TCPSocket/TCPSocket.new>))   [compat]
: ((<TCPSocket/TCPSocket.open>))  [compat]
  ローカル側アドレスを省略可能な第3,4引数で指定できるようになりました。

=== Thread

: ((<Thread#join|Thread/join>))  [compat]

  スレッドを待ち合わせる時間を limit で指定できるようになりました。

: ((<Thread/Thread.list>)) [compat]
: ((<ThreadGroup#list|ThreadGroup/list>)) [compat]
  終了中(aborting)のスレッドもリストに含まれるようになりました。
  ((<rubyist:1282>))

=== Time

: ((<Time>))            [compat]
  負の time_t を扱えるようになりました(OSがサポートしている場合に限る)
    p Time.at(-1)
    => Thu Jan 01 08:59:59 JST 1970

=== UnboundMethod

: ((<UnboundMethod#bind|UnboundMethod/bind>)) [compat]

  UnboundMethod オブジェクトをそれが定義されたクラスのサブクラスへ
  bind しても良いことになりました。

=== その他

: ((<NameError/NameError.new>))(msg[, name])            [compat]
: ((<NoMethodError/NoMethodError.new>))(msg, name, args)    [compat]
: ((<SystemCallError/SystemCallError.new>))(msg, err)         [compat]
: ((<Errno::EXXX>)).new(msg)                   [compat]

  内部の実装でインスタンス変数を初期化していなかったために warning が
  出ていたのを修正しました。そして、new のパラメータでその値を指定でき
  るように変更されました。

: ((<SystemExit#initialize|SystemExit/SystemExit.new>)) [compat]

  引数が追加されました。

: ((<String#to_i|String/to_i>)) [compat]
: ((<Integer#to_s|Integer/to_s>)) [compat]

  引数に基数(2,8,10,16)を指定できるようになりました。
  (2002-01-26: 引数が 0 のときは prefix で基数を判定する)

  基数変換で、2, 8, 10, 16 進だけでなく、2 .. 36進数までの任意の基数へ
  の変換をサポートしました。((<ruby-dev:20021>))

# 別に影響ない変更なのでコメント
# : ((<Class/Class.inherited>)) [compat]
# 
#   (注: Class#inherited ではありません)
# 
#   以前は、クラスのサブクラスの定義を禁止するために定義されていましたが、
#   (((<TypeError>))例外を発生させるメソッドとして定義されていました) こ
#   の役割は Class.new が担保するようになりました。そのため、
#   Class.inherited メソッドの定義はなくなりました。
# 
#     class SubClass < Class
#     end
# 
#     #=> -:1:in `inherited': can't make subclass of Class (TypeError)
#                 from -:1
#         ruby 1.7.1 (2001-06-12) [i586-linux]
# 
#     #=> -:1: can't make subclass of Class (TypeError)
#         ruby 1.7.1 (2001-07-31) [i586-linux]

== 変更されたクラス／メソッド(互換性のない変更)

=== 組み込み関数

: ((<組み込み関数/Integer>))() [change]

  数値や文字列以外のオブジェクトを整数に変換するときに to_i ではなく 
  to_int を使用するようになりました。

: ((<組み込み関数/Float>))() [change]

  Float() は、引数に nil を受け付けなくなりました。

        p Float(nil)

        => ruby 1.6.7 (2002-03-01) [i586-linux]
           0.0
        => -:1:in `Float': cannot convert nil into Float (TypeError)
                from -:1
           ruby 1.7.3 (2002-09-02) [i586-linux]

=== ARGF

: ((<ARGF#to_s|ARGF/to_s>)) [change]

  結果は "ARGF" 固定になりました。ファイル名は ARGF.path で取得します。

=== ARGV

: ((<組み込み定数/ARGV>)) [change]

  ARGV の各要素は freeze されるようになりました。

        ruby -v -e 'p ARGV.collect {|v| v.frozen?}' a b c

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           [false, false, false]
        => ruby 1.8.0 (2003-08-11) [i586-linux]
           [true, true, true]

=== Array

: ((<Array#sort!|Array/sort!>))     [change]

  常にself返すようになりました。

  将来にわたってこのことが保証されるわけではないそうです ((<ruby-dev:12506>))。

: ((<Array#reverse!|Array/reverse!>)) [change]

  サイズが 1 以下の配列に対して以前は nil を返していましたが、self を
  返すようになりました。((<String#reverse!|String/reverse!>)) の挙動と
  同じです。((<ruby-dev:20135>))

: ((<Array#-|Array/->)) [change]

  差を求めるときに重複した値は取り除かなくなりました。

=== Comparable

: ((<Comparable>)) [change]

  obj#<=> が nil を返すような引数に対して、>, >=, <, <= が例外
  ((<ArgumentError>)) を起こすようになりました。また、== は、nil を返
  すようになりました。

: ((<Module/Module#>>)) [change]
: ((<Module/Module#<>)) [change]
: ((<Module/Module#<=>)) [change]

  継承関係にないクラス同士の比較で nil を返すようになりました。
  ((<ruby-dev:20190>))

#   ((<Module/Module#<=>)) は、1.7 で nil を返すように変更されていました
#   が、その後、-1 に、その後再度 nil におさまりました。

: ((<String#<=>|String/<=>>)) [change]
: ((<Comparable>)) [change]

  string <=> other は、((|other|)) が文字列でない場合、
  ((|other|)).to_str と ((|other|)).<=> が定義されていれば (({0 -
  (other <=> string)})) の結果を返します。そうでなければ nil を返します。
  ((<ruby-dev:19625>))

        class Foo
          def to_str
            "foo"
          end
          def <=>(o)
            p "<=> called"
            self.to_str <=> o
          end
        end

        p "foo" <=> Foo.new
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           0
        => ruby 1.8.0 (2003-05-02) [i586-linux]
           "<=> called"
           0

: ((<String#==|String/==>))    [change]
: ((<Numeric#==|Numeric/==>))  [change]

  Comparable の変更と合わせて <=> が nil を返すとき == が nil を返すよ
  うになりました。((<ruby-dev:20759>))

=== Dir

: ((<Dir/Dir.open>))        [change]
  ブロックを伴う場合((<File>)).openと同様に、ブロックの結果がメソッドの
  戻り値になりました。(1.6以前は (({nil})) 固定)

: ((<Dir/Dir.glob>))        [change]
  先行するバックスラッシュにより、ワイルドカードをエスケープ
  できるようになりました。
  また、空白類に特殊な意味はなくなりました('\0'の効果は残っています)。

=== Enumerable

: ((<Enumerable#find|Enumerable/find>)) [change]

  引数に文字列を指定できなくなりました。

  また、要素が見つからなかった場合は、ifnone の結果を返すようになりました。

=== File

: ((<File/File.basename>)) [CHANGE]
: ((<File/File.dirname>)) [CHANGE]

  File.dirname と File.basename の動作が ((<SUSv3|URL:http://www.unix-systems.org/version3/online.html>)) に従うようになりました。

  ((<ruby-dev:19548>)) [PATCH] file.c for ((<ruby-bugs-ja:PR#389>))
  and ((<ruby-bugs-ja:PR#390>))

        p File.dirname("foo/bar/")
        p File.dirname("foo//bar")
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           "foo/bar"
           "foo/"
        => ruby 1.8.0 (2003-05-02) [i586-linux]
           "foo"
           "foo"

        p File.basename("foo/bar/")
        p File.basename("foo//bar")
        ruby 1.6.7 (2002-03-19) [i386-linux]
        ""
        "bar"
        ruby 1.8.1 (2003-12-27) [i686-linux]
        "bar"
        "bar"

=== Float

: ((<Float#to_s|Float/to_s>)) [change]

  最大の精度を示すためのフォーマットが "%.10g" から "%.16g" に変わりま
  した。(2003-03-20: その後、"%.15g" になりました ((<ruby-bugs-ja:PR#406>)))

=== Module

: ((<Module#include|Module/include>)) [change]

  トップレベルの include は、第二引数に true を指定した load でロード
  されるスクリプトのもとではモジュールの機能を self に 
  ((<Object/extend>)) するように変更されました。

: ((<Module#include|Module/include>)) [change], [experimental]

  wrapper モジュールで評価される file (load(file, true)) 中で、トップ
  レベルの include を行ったとき、Module を include する対象が Object で
  なく、wrapper モジュールになりました。
  つまり、load(file, true) で、file をロードしたときに file 中で
  include を実行していても呼び出し元に影響しなくなりました。

  ((*これは実験的な変更です*))

: ((<Module#include|Module/include>)) [change]
: ((<Object#extend|Object/extend>))  [change]

  複数のモジュールを渡したときにインクルードされる順序が変更されました。
  ((<ruby-dev:16035>))
  extend も同様だそうです。((<ruby-dev:16183>))

  一つ一つ include した場合とは逆順になります。

=== Object

: ((<Object#clone|Object/clone>)) [change]

  Numeric など immutable なオブジェクトは clone できなくなりました。
  ((<ruby-bugs-ja:PR#94>)), ((<rubyist:0831>))

=== Range

: ((<Range#max|Range/max>)) [change]
: ((<Range#min|Range/min>)) [change]
: ((<Range#include?|Range/include?>)) [change]
: ((<Range#member?|Range/member?>)) [change]

  Range#max, Range#min, Range#include? が <=> メソッドによる範囲演算で
  求められるようになりました。((<ruby-list:35253>)), ((<ruby-dev:17228>))
  (2003-03-18: min, max は元に戻りました。((<ruby-dev:19837>)))

  Range#member? は each を利用して全要素を参照し、実際にメンバが存在するか
  確認します。(Enumerable#member? と同じ)

  1.6 までは、max, min, member? include? は、Enumerable のメソッドで、
  === は、Range のメソッドです。1.7 では、max, min, member?, include?,
  === はすべて Range のメソッドで、include? は === の別名になっていま
  す。(1.8 では、max, min は、Enumerable のメソッドに戻っています)

: ((<Range#each|Range/each>)) [change]

  Range#each は各要素の succ メソッドを使用してイテレーションするよう
  になりました。

=== Regexp

: ((<Regexp/Regexp.new>)) [change]

  第一引数に正規表現を与えた時に引数のオプションを無視し、元のオプショ
  ンを保持した複製を返すようになりました。

        p Regexp.new(//is, Regexp::EXTENDED, "e")

        => ruby 1.6.8 (2003-08-03) [i586-linux]
           //xe
        => -:1: warning: flags and encoding ignored
           ruby 1.8.0 (2003-02-16) [i586-linux]
           //is

=== String

: ((<String#chomp|String/chomp>))       [change]
: ((<String#chomp!|String/chomp!>))     [change]
: ((<組み込み関数/chomp>))              [change]
: ((<組み込み関数/chomp!>))             [change]

  $/ が "\n" (デフォルト)のとき、どの行末形式("\r\n", "\r",
  "\n" のいずれでも)でもそれらを取り除くようになりました。

=== ThreadGroup

: ((<ThreadGroup#freeze|ThreadGroup/freeze>)) [change]

  freeze された ThreadGroup に Thread を追加/削除できなくなりました。

=== Time

: ((<Process/Process.times>))           [change]
  ((<Time/Time.times>)) から移動しました。
  (Time.times も残っていますが、warningが出ます)

: ((<Time#to_a|Time/to_a>))       [change]
: ((<Time#zone|Time/zone>))       [change]
  gmtime なタイムゾーンに対して"UTC"を返すようになりました
  (以前は環境依存。大抵の場合"GMT")

== 文法の変更

: parser [compat]

  数字で始まるグローバル変数は特殊変数 $1, $2, ... 以外に許されなくな
  りました。

: [parser], [change]

  `*' による配列展開が、多重代入の右辺で行われた場合、to_ary だけでな
  く、to_a も配列展開のための配列化に利用されるようになりました(ただし、
  Object#to_a は対象外。Object#to_a は将来削除される予定です)。

: [parser]

  スコープ演算子 `::' を伴う定数代入を許すようになりました。
        p Object::Foo = 1
  また、"class Foo::Bar; end" という定義も可能になりました。

: [parser]

  (({.<digit>}))はFloatのリテラルではなくなりました。

: [parser] [experimental]

  実験的な修正のようです。

      a = 1
      p a / 5
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           0
        => ruby 1.8.0 (2003-03-12) [i586-linux]
           0

      a = 1
      p a /5
        => -:2: warning: ambiguous first argument; make sure
           -:2: unterminated regexp meets end of file
           ruby 1.6.8 (2002-12-24) [i586-linux]
        => ruby 1.8.0 (2003-03-12) [i586-linux]
           0

: [parser] [new]

  シンボルの拡張表記法が採用されました。((<ruby-dev:18537>))

        p :"foo#{"bar"}"
        p :'foo#{"bar"}'
        p %s{foo#{"bar"}}

        => ruby 1.7.3 (2002-11-14) [i586-linux]
           :foobar
           :"foo\#{\"bar\"}"
           :"foo\#{\"bar\"}"

: rescue修飾式 [parser] [change]

  rescue 修飾式の優先度が変わりました。これは、実験的なもののようです。
  (1.8 リリースで残っているので正式採用のようです)

        a = b rescue c

  は、

        (a = b) rescue c

  でなく

        a = (b rescue c)

  と評価されます。

: [parser] [compat]

  メソッド定義の外での return の呼び出しはコンパイル時でなく実行時に
  エラーになるようになりました。

        p :doing
        return
        => -:2: return appeared outside of method
           ruby 1.6.7 (2002-03-01) [i586-linux]
        => ruby 1.7.3 (2002-10-04) [i586-linux]
           :doing
           -:2: unexpected return

: [parser] [compat]

  ネストしたメソッド定義が許されるようになりました。

  メソッド定義中での alias, undef も許可されました。

  メソッド定義の外での super の呼び出しはコンパイル時でなく実行時に
  エラーになるようになりました。

  おそらく、((<ruby-dev:16969>)) あたりが変更の理由なのではないかと思
  います。((<ruby-dev:17882>))

: ((<%W()|リテラル/%記法>)) [parser]

  %W(...) 配列リテラルが追加されました。%w() と異なりバックスラッシュ
  記法や式展開が有効です。((<ruby-dev:15988>))

: ((<リテラル/式展開>)) [parser]

  #{ ... } の式展開中に文字列のデリミタを含めて任意の ruby プログラム
  をそのまま書けるようになりました。以前も同じでしたが、よりルールが明
  確になっているようです。つまり、式展開の中も外も同じ規則で、ruby プ
  ログラムはパースされます。((<ruby-dev:17422>))

: [parser] [compat]

  文字列リテラル中の行頭の __END__ は、スクリプトの終りとみなさなくな
  りました。((<ruby-dev:17513>))

        # p "
        #__END__
        #"
        p eval(%Q(p "\n__END__\n"))

: ((<?<whitespace>|リテラル/数値リテラル>)) [parser] [change]

  ?スペース、?改行、?TAB 等はリテラルとして無効になりました。必要なら 
  ?\s, ?\n, ?\t 等を使用してください。(以下の例は前者がダブルクォート
  を使用していることに注意) ((<ruby-bugs-ja:PR#261>)), ((<ruby-dev:17446>))

: [parser] [change]
: ((<String#to_f|String/to_f>)) [change]
: ((<組み込み関数/Float>))() [change]

  文字列を浮動小数点数に変換する内部処理で、ライブラリ関数 strtod(3) 
  に依存しなくなりました。ロケールやライブラリの独自拡張により動作が変
  わることはなくなりました。

: メソッド呼び出し      [parser] [change]

  メソッド名と括弧の間に空白があるとその括弧は引数を括る括弧ではなく
  式の括弧と解釈するようになりました。
  (ただし、p (1, 2) とすると空白があっても引数を括る括弧になる。
  つまり、(おそらく)意図通りに動作する)

    p (1+2)*3

: 条件式中の正規表現リテラル    [parser] [change]

  条件式中の正規表現リテラルは警告が出るようになりました。

  $_ との正規表現マッチは、明示的に ~/re/ (単項の ((<Regexp/~>)) メソッ
  ド)などとすることが推奨されます。

== 正規表現

: ((<正規表現>)) [regexp]

  正規表現 $ が改行の前だけでなく、常に文字列の末尾にもマッチするよう
  になりました。これは、perl や python と同じ挙動です。((<ruby-dev:20104>))

: ((<正規表現>)) [regexp]

  ((<ruby 1.8 feature/2003-05-01>)) の $ の変更と同様に、正規表現 \Z
  が改行の前だけでなく、常に文字列の末尾にもマッチするようになりました。
  これは、perl や python と同じ挙動です。((<ruby-dev:20187>))

: ((<正規表現>)) [regexp]

  文字クラス [] 内の [, ], - をエスケープなしで使用すると warning が出
  るようになりました。((<ruby-dev:19868>))

== Marshal

: ((<Marshal/Marshal.dump>)) [marshal] [change]

4.7->4.8
: ((<Marshal>))         [marshal] [change]
  無名モジュールを include したオブジェクトがダンプできなくなりました。
  ((<ruby-dev:18186>))

  名前付きモジュールを include したオブジェクトはダンプでき、include 
  したモジュールの情報をダンプフォーマットに保持するようになりました。

  名前付きモジュールを include したオブジェクトはダンプでき、include
  したモジュールの情報をダンプフォーマットに保持するようになりました。

4.6->4.7
: ((<Marshal>))         [marshal] [change]

  Float のダンプが、sprintf(3) に依存しなくなりました。フォーマッ
  トバージョンが 4.6 から 4.7 に上がっています。
  (この後、strtod(3) の組み込みにより、読み込み時もシステムの strtod(3)
  に依存しなくなっています)

: ((<Marshal>))       [bug]

  構造体クラスのサブクラスをダンプしたものがロードできませんでした。
  ((<ruby-bugs-ja:PR#104>))

        S = Struct.new("S", :a)
        class C < S
        end
        p Marshal.load(Marshal.dump(C.new))

        => -:4: warning: instance variable __member__ not initialized
           -:4:in `dump': uninitialized struct (TypeError)
                from -:4
           ruby 1.6.5 (2001-09-19) [i586-linux]

        => ruby 1.7.1 (2001-10-19) [i586-linux]
           #<C a=nil>

== Windows 対応

: ((<File/File.link>)) [new]

  Win32(Win2k以降のみ)でNTFS上でのハードリンクの作成(CreateHardLink)に
  対応しました。

: ((<File/File.utime>)) [new]

  Win32(NT系のみ)でディレクトリに対するutimeが出来るようになりました。

* DOSISHなプラットフォームでのドライブレター対応が強化されました。
* ((<Process/Process.pid>)) (win)

  ((<mswin32>))版 ruby と ((<MinGW>))版 ruby で拡張ライブラリのバイナ
  リ互換を保つようになりました。Config::CONFIG['RUBY_SO_NAME'] が
  msvcrt-ruby((|XX|)) に(DLL 名になります)、Config::CONFIG['sitearch'] (拡張
  ライブラリの置き場所のパス要素)が "i386-msvcrt" に変更されました。
  ((<ruby-dev:17144>)), ((<ruby-dev:18047>))

  Win32用の双方向パイプサポートのパッチが取り込まれたのだそうです
  ((<ruby-win32:185>))

: ((<Process/Process.kill>)) [compat]

  ChangeLog によると win32 でも、シグナル 0 がサポートされたそうです。
  多くの Unix で、シグナル 0 の送信は、プロセスの存在チェックに使用で
  きますので、それと同じ動作をするのだと思います。

: ruby interpreter (win32, MinGW) [ruby] [change]

  ((<mswin32>))版 ruby と ((<MinGW>))版 ruby で拡張ライブラリのバイナ
  リ互換を保つようになりました。Config::CONFIG['RUBY_SO_NAME'] が 
  msvcrt-ruby((|XX|)) に(DLL 名になります)、Config::CONFIG['sitearch'] (拡張
  ライブラリの置き場所のパス要素)が "i386-msvcrt" に変更されました。
  ((<ruby-dev:17144>)), ((<ruby-dev:18047>))

  sitearch は、今回の件で新規追加されました(他の環境では 
  CONFIG['arch'] と同じ)

  ((<Win32ネイティブ版>)) の脚注も参照

: ENV["PATH"]    [ruby], [bug?]

  Windows などのプラットフォームで環境変数名 PATH (セキュリティチェッ
  ク時などに判断)の大文字と小文字を区別しないようになりました。
  ((<ruby-dev:20374>))

: 双方向パイプ (win) [compat]

  Win32用の双方向パイプサポートのパッチが取り込まれたのだそうです 
  ((<ruby-win32:185>))

: ((<Process/Process.kill>))    [compat]

  ((<mswin32>)), ((<mingw32>)) でも、Process.kill(9, pid) でプロセスを
  強制終了(TerminateProcess) できます。(Process.kill("KILL", pid) とは
  できないようです・・・2002-08-28 その後 "KILL" で指定できるようになっ
  たようです)

: win32: map OS error to errno. [change]

: cygwin

  cygwinでは常にバイナリモードになりました(((<ruby-dev:19583>)))

: ((<File/File.dirname>)) [CHANGE]
: ((<File/File.expand_path>)) [CHANGE]
: ((<File/File.join>)) [CHANGE]

  DOSISHなプラットフォームでのドライブレター対応が強化されました。
  ((<DOSISH 対応>))を参照。

: ((<Process/Process.pid>)) (win) [change]

  mswin32 版と mingw32 版で、ruby 内部はプロセスIDを常に正の値に変換して
  扱うようになりました。
  NT系のOSでは従来と違いはありませんが、Win9x系のOSでは、OSの保持する
  プロセスIDが負値なので、符号変換して扱うようになります。((<ruby-dev:18263>))

== 廃止された(される予定の)機能

: ((<組み込み変数/$defout>)) [obsolete]
: ((<組み込み変数/$deferr>)) [obsolete]

  $stdout, $stderr を使用してください。

: ((<String#=~|String/=~>)) [obsolete]
: ((<String#~|String/~>))  [obsolete]
  string =~ string に対して警告が出るようになりました。明示的に string
  =~ regexp あるいは regexp =~ string を使うことが推奨されます。
  (1.8.1 以降使用できなくなるかもしれません) ((<ruby-list:37662>))

  String#=~ の変更と同様にString#~ で警告が出るようになりました。
  (1.8.1 以降使用できなくなるかもしれません)

: ((<Object#id|Object/id>))
: ((<Object#type|Object/type>)) [obsolete]

  使うと警告が出るようになりました。代わりに Object#object_id,
  Object#class を使用してください。

: ((<Object#to_a|Object/to_a>)) [obsolete]

  警告メッセージが出るようになりました。(((<obsolete>)) になるのだそうです)

: ((<Range#size|Range/size>))     [obsolete]
: ((<Range#length|Range/length>)) [obsolete]

  このメソッドはなくなりました。
  ((<ruby-talk:64479>)), ((<ruby-talk:72133>))

  Range の要素数を得るには

        p(("a".."z").to_a.size)

  などとする必要があります。

: ((<Array/indexes>))
: ((<Array/indicies>))

  (((<Array>)), ((<Hash>)), ((<ENV>))) のメソッド、indexes, indicies 
  は values_at という名前に変わりました。

: ((<Array#filter|Array/filter>))

  なくなりました。

: Time.times

  ((<Process/Process.times>)) に移動しました。

: NotImplementError             [obsolete]

  旧称は削除されました。((<NotImplementedError>))を使ってください

: ((<Proc#yield|Proc/yield>))

  なくなりました。((<ruby-dev:20180>))

== ライブラリ

: ((<tmpdir>)) [new]

  テンポラリディレクトリを取得するためのライブラリが追加されました。
  Windows などで利用されるライブラリは、/tmp をハードコードせずに(ま
  た 環境変数 TEMP などを参照せずに)このライブラリを使用するべきです。
  (tempfile などが tmpdir を使用するようになりました。
  ((*tmp*))dir と ((*temp*))file というのがまたなんとも・・・)


: ((<Timeout/Timeout.timeout>)) [lib] [new]
: ((<Timeout::Error|Timeout/Error>)) [lib] [new]

  timeout に Timeout モジュールが定義されました。((<RCR#121>))

  関数 ((<timeout/timeout>)) は、モジュール関数 Timeout.timeout の別名に、
  例外 ((<TimeoutError>)) は Timout::Error の別名になりました。

: ((<erb>))           [lib] [new]

  追加

: ((<"io/wait">))     [lib] [new]

  追加

: ((<mkmf>)) [lib] [new]

  新しい判定メソッド have_type(), check_sizeof() が追加されました。

: ((<pathname>))        [lib] [new]

  追加

: ((<resolv>))       [lib] [compat]

  Win32 に対応しました。

: ((<webrick>))      [lib] [new]

  追加

: ((<openssl>))      [lib] [new]

  追加

: ((<win32ole|WIN32OLE>)) [lib] [new]

  追加

: ((<un>)) [lib] [new]

  追加

: ((<csv>)) [lib], [new]

  追加。

: ((<tk|tk>)) [lib], [change]

  Ruby/Tk に多数の修正が入りました。((<ruby-list:37798>))

: ((<drb>)) [lib] [new]

  dRuby 追加。((<ruby-dev:20363>))

: ((<rexml>)) [lib],[new]

  追加

: ((<yaml|YAML>)) [new]

  追加。YAML は、YAML Ain't Markup Language だそうです。
  ((<URL:http://yaml4r.sourceforge.net/>))
  ((<URL:http://yaml.org/>))

: ((<zlib>)) [lib] [new]

  追加

: ((<bigdecimal>)) [lib] [new]

  追加

: ((<"test/unit"|Test::Unit>)) [new]

  Test::Unit 追加

: ((<"win32/registry">)) [new]
  Win32でレジストリにアクセスするためのライブラリが追加されました。

: ((<profiler>)) [lib] [new]

  追加。((<profile>)) の実体として分離されました。

: ((<open-uri>)) [lib] [new]

  追加

: ((<set>)) [lib] [new]

  追加

: ((<"net/ftp">)) [new]

  メソッド set_socket 追加

: ((<dl>)) [lib] [new]

  追加

: 添付ライブラリ [lib] [new]

  以下のライブラリが新たに追加されました。
  ((<iconv>)), ((<tsort>)), ((<StringIO>)), ((<strscan>)),
  ((<fileutils>)), racc/*

: ((<benchmark>)) [new]
  added

: Curses        [lib] [compat]

  Updated.  New methods and constants for using the mouse, character
  attributes, colors and key codes have been added.

: Complex#to_i          [lib] [obsolete]
: Complex#to_f          [lib] [obsolete]
: Complex#to_r          [lib] [obsolete]

  Complex#to_i, #to_f, #to_r はなくなりました。
  ((<ruby-bugs-ja:PR#102>)), ((<rubyist:0879>))

: ((<gdbm>))    [lib] [change]
: ((<dbm>))     [lib] [change]
: ((<sdbm>))    [lib] [change]

  ((*ドキュメント未反映*))
  ((<ruby-dev:16126>))

: ((<mkmf>)), extmk [lib] [compat]

  extmk と mkmf をマージする作業が開始されました。extmk は 
  mkmf を利用するようになりました。mkmf もこれに伴い変更が行われ
  ています。((<ruby-dev:18109>))

: ((<"net/ftp">)) [compat]

  getbinaryfile() の第二引数(ローカルファイル名)が省略可能になりました。
  メソッド get(), put(), binary(), binary = 追加

: ((<"net/http">)) [compat]
  Net::HTTP のクラスメソッドで ((<URI>)) オブジェクトが使えるようになった。

      Net::HTTP.get_print(URI.parse('http://www.ruby-lang.org/ja/'))

  インスタンスメソッドでは使えないので注意。

: ((<readline>))                [change]

  Readline.readline 実行中に Ctrl-C により中断した後でも、端末状態を
  復帰するようにしました。((<ruby-dev:14574>))

== 拡張ライブラリAPI
: rb_define_alloc_func() [api] [new]
: rb_undef_alloc_func() [api] [new]

  追加。((<Class/allocate>)) メソッドの定義に使用します。
  ((<ruby-dev:19116>))

: rb_enable_super() [api]
: rb_disable_super() [api]

  ChangeLog によると、これらの関数は必要なくなったようです。

  (rb_enable_super() を呼ぶと warning が出ます)。以前は、拡張ライブラ
  リのレベルで、rb_call_super() (Ruby の super にあたる) を呼ぶメソッ
  ドは rb_enable_super() しておかなければなりませんでした。

: STR2CSTR() [api] [new]

    拡張ライブラリの API である STR2CSTR() は、与えられたオブジェクト
    が文字列でなくかつ to_str メソッドを持つ場合、内部で to_str を呼び
    出して暗黙の型変換を行います。この場合、変換結果が保持する文字列ポ
    インタを返しますが、このAPIでは暗黙の型変換結果のオブジェクトがど
    こからも参照されないため、型変換結果が GC される可能性があります。
    ((<ruby-dev:12731>))

    version 1.7 以降では代わりに StringValuePtr() を使用します。こちら
    は、引数の参照先が暗黙の型変換の結果に置き換わるため変換結果が GC 
    されません。(version 1.7 では、STR2CSTR() は、obsolete です)

    もう一つ新しく StringValue() という API が用意されています。こちら
    は、引数が to_str による暗黙の型変換を期待する場合に使用します。
    引数が文字列なら何もしません。
    文字列を受け取るメソッドの最初の方で読んでおくと便利です。

    なお、今のところ str2cstr() (Cポインタと文字列長を返す)の代わりに
    なる安全な API は用意されていません。(((<ruby-dev:15644>))で提案は
    ありました)

== バグ修正

: ((<組み込み関数/load>)) [bug]

  ((<組み込み関数/load>)) がスレッドセーフになりました。((<ruby-dev:20490>))

: ((<組み込み関数/syscall>)) [bug]

  第二引数以降に文字列か Fixnum しか受け付けないために、long の範囲の
  数値を指定することができませんでした。((<ruby-talk:72257>))

        syscall(1, 2**30)

        => -:1:in `syscall': wrong argument type Bignum (expected String) (TypeError)
                from -:1
           ruby 1.6.8 (2002-12-24) [i586-linux]


: ((<組み込み関数/trap>))       [bug]
: ((<組み込み関数/trace_var>))  [bug]

  第二引数に汚染された文字列を渡すと例外 ((<SecurityError>)) が
  起こるようになりました。1.6 では、汚染された文字列をセーフレ
  ベル4で評価するようになっていました。
  ((<ruby-list:32215>))

: ((<Array#collect|Array/collect>))   [bug]
: ((<Array#map|Array/map>))       [bug]

  Array#collect がブロックを伴わない場合に self.dup を返していました。
  そのため、Array 以外を返すことがありました((<ruby-list:30480>))。

    Foo = Class.new Array

    a = Foo.new
    p a.map.class
    p a.collect.class

    => ruby 1.7.1 (2001-06-12) [i586-linux]
       Array
       Foo

    => ruby 1.7.1 (2001-07-31) [i586-linux]
       Array
       Array

: ((<Bignum>)) [bug]

  -2147483648 より小さい数値の2進、8進、16進の表記がおかしくなっていました
  ((<ruby-list:34828>))

    p "%b" % -2147483648
    p "%b" % -2147483649
    p "%b" % -2147483650

    => ruby 1.6.7 (2002-03-01) [i586-linux]
       "..10000000000000000000000000000000"
       "..1"
       "..10"

    => ruby 1.7.2 (2002-04-11) [i586-linux]
       "..10000000000000000000000000000000"
       "..101111111111111111111111111111111"
       "..101111111111111111111111111111110"

: ((<File/File.open>))       [bug]

  第2引数を数値(File::RDONLY|File::CREATとか)で指定した場合に限り、第3
  引数を用いていましたが、第3引数が与えられれば常に有効にするように
  しました。
  ((<ruby-bugs-ja:PR#54>))

: ((<IO>)) (win32) [bug]

  mswin32・mingw32で、更新モード(w+,r+)でオープンされたファイルに対する
  読み書きの切り替えがうまくいっていなかった問題が修正されました。
  bccwin32にも同様の問題がありますが、こちらは未修正です。
  ((<ruby-dev:19299>))

: ((<IO#putc|IO/putc>)) [bug]

  出力メソッドのうち putc だけが write メソッドを使用していませんでした。
  ((<ruby-dev:18038>))

: IO#read, gets ..., etc. [bug]

  File::NONBLOCK を指定した IO の読み込みで EWOULDBLOCK が発生すると、
  途中まで読んだデータが失われることがありました。
  ((<ruby-dev:17855>))

  Thread を使ったプログラムで、ファイルからデータを読み込んでソケットに
  書き出していると、ごく稀に Socket#write が Errno::EINTR になってしまう
  ことがありました。((<ruby-dev:17878>)), ((<ruby-core:00444>))


: ((<Proc>)) [bug]

  $SAFE が、1 or 2 のとき
  汚染された Proc は、ブロックにできなくなりました ((<ruby-dev:15682>))
  ((-あらい 2003-08-06: できてる・・・？-))

        $SAFE = 1
        proc = proc {}
        proc.taint
        p proc.tainted?
        def foo(&b)
          p b.tainted?
        end
        foo(&proc)

        => ruby 1.6.8 (2003-08-03) [i586-linux]
           true
           true
        => ruby 1.8.0 (2003-08-04) [i586-linux]
           true
           true

: ((<String#split|String/split>))    [bug]

  空文字列に対する split が空文字列を要素に持つ配列を返していました。

        p "".split(//)
        p "".split(//, 0)
        p "".split(//, 1)
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           []
           []
           [""]
        => ruby 1.8.0 (2003-07-25) [i586-linux]
           []
           []
           []

: ((<String#split|String/split>)) [bug]

  以下の例のように、第一引数に ' ' (awk split)を指定してかつ、第二引数
  を指定した場合に最後の要素の先頭に余分な空白が残っていました。

        p "a  b  c".split(' ',3)
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           ["a", "b", " c"]
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           ["a", "b", "c"]

: ((<String#split|String/split>)) [bug]

  String#split で第2引数が -1 のとき、空文字列に対して空文字列を要素と
  する配列を返すバグが修正されました。((<ruby-bugs-ja:PR#426>))

        p "".split(//)
        p "".split(//, -1)

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           []
           [""]
        => ruby 1.8.0 (2003-04-25) [i586-linux]
           []
           []

: ((<String#rindex|String/rindex>)) [bug]

  文字コード \0 が文字列末尾にマッチしていました。

        p "abc".rindex(0)
        p "abc".index(0)
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           3
           nil
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           nil
           nil

: ((<String#upto|String/upto>)) [bug]

  String#upto の範囲チェックが辞書順だったバグが修正されました。
  現在は、((<String/succ>)) の動作と一致します。

        p(('a'..'aa').to_a)
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           ["a"]
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           ["a", "b", "c", ..., "y", "z", "aa"]

        'a'.upto('aa') {|c| p c}
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           "a"
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           "a"
           "b"
           "c"
            :
           "y"
           "z"
           "aa"

  以前の実装では以下が 'aa' を含まないとか

        'a'.upto('b') {|c| p c}
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           "a"
           "b"
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           "a"
           "b"

  以下の結果と順序関係が一致していませんでした。

        p(('a'..'zz').to_a)
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           ["a", "b", "c", ..., "x", "y", "z", "aa", ..., "zx", "zy", "zz"]
        => ruby 1.8.0 (2003-07-03) [i586-linux]
           ["a", "b", "c", ..., "x", "y", "z", "aa", ..., "zx", "zy", "zz"]

  なお、<=> の順序は辞書順であることに注意する必要があります。
        p 'a' < 'b'    # => true
        p 'aa' < 'b'   # => true

: ((<Thread#wakeup|Thread/wakeup>)) [bug]
: ((<Thread#run|Thread/run>)) [bug]
  終了中(aborting)のスレッドに対して実行するとスレッドが生き返る
  バグが修正されました。
  ((<rubyist:1282>))

: [bug]

  ((<ruby-talk:73481>))

        p 'mike stok' =~ /^(?i-mx:mike) (?i-mx:stok)$/
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           nil
        => ruby 1.8.0 (2003-06-16) [i586-linux]
           0

  ((<ruby-talk:73549>))

        p "Mike" =~ /(?-i)[Mm]ike/
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           nil
        => ruby 1.8.0 (2003-06-16) [i586-linux]
           0

: ((<セキュリティモデル>)), ((<組み込み変数/$SAFE>)) [bug], [change]

  ((<終了処理>))直前に $SAFE が 0 になるように変更されました。
  ((<ruby-core:01119>))

        $SAFE = 1
        END { p $SAFE }
        => ruby 1.6.8 (2002-12-24) [i586-linux]
           1
        => ruby 1.8.0 (2003-06-09) [i586-linux]
           0

: ruby interpreter [bug]

  以下のバグが修正されました((<ruby-list:37677>))
  (イテレータの中で block を他のメソッドに & で渡した時のそのメソッド
  の引数のコンテキストの扱い？)

        def foo
          p(block_given?)
          p(block_given?,&proc)
          p(yield,&proc)
        end

        foo { }

        => ruby 1.6.8 (2002-12-24) [i586-linux]
           true
           false
           -:4: [BUG] Segmentation fault
           ruby 1.6.8 (2002-12-24) [i586-linux]

        => ruby 1.6.8 (2003-05-15) [i586-linux]
           true
           false
           -:4:in `foo': no block given (LocalJumpError)
                from -:7

        => ruby 1.8.0 (2003-05-17) [i586-linux]
           true
           true
           nil

: ((<"||="|演算子式>)) [bug]

  未定義の変数に対して ||= で値を代入したときに、グローバル変数で警告
  が出ていました。また、クラス変数はエラーになっていました。
  ((<ruby-dev:18278>))

        local ||= 1
        @instance ||= 1
        $global ||= 1
        @@class ||= 1

        => -:3: warning: global variable `$global' not initialized
           -:4: uninitialized class variable @@class in Object (NameError)
           ruby 1.6.7 (2002-03-01) [i586-linux]
        => ruby 1.7.3 (2002-09-13) [i586-linux]

: large file [bug]

  large file(サイズが 4G bytes 以上のファイル)を正しく扱うようになりま
  した(？)
  ((<ruby-talk:35316>)), ((<ruby-talk:35470>))

: alias         [bug]

  グローバル変数のエイリアスが効いていませんでした。
  ((<ruby-dev:14922>))

        $g2 = 1
        alias $g1 $g2
        p [$g1, $g2]
        $g2 = 2
        p [$g1, $g2]
        => ruby 1.6.5 (2001-09-19) [i586-linux]
           [1, 1]
           [1, 2]

        => ruby 1.7.1 (2001-10-19) [i586-linux]
           [1, 1]
           [2, 2]

=== サポートプラットフォームの追加

: WindowsCE [platform]

  ((<WindowsCE>)) のサポートパッチが取り込まれました。

: Borland C++ サポート [platform]

  bcc で ruby インタプリタをコンパイルするためのパッチがマージされまし
  た。

: ((<VMS>)) support [platform]

  ((<VMS>)) のサポートパッチが取り込まれました。
