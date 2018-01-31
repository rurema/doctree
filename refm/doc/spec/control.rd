= 制御構造

条件分岐:
    * [[ref:if]]
    * [[ref:unless]]
    * [[ref:case]]
繰り返し:
    * [[ref:while]]
    * [[ref:until]]
    * [[ref:for]]
    * [[ref:break]]
    * [[ref:next]]
    * [[ref:redo]]
    * [[ref:retry]]
例外処理:
    * [[ref:raise]]
    * [[ref:begin]]
その他:
    * [[ref:return]]
    * [[ref:BEGIN]]
    * [[ref:END]]

Rubyでは(Cなどとは異なり)制御構造は式であって、何らかの値を返すものが
あります(返さないものもあります。値を返さない式を代入式の右辺に置くと
syntax error になります)。

RubyはC言語やPerlから引き継いだ制御構造を持ちますが、
その他に[[ref:d:spec/call#block]]という
制御構造の抽象化を援助する機能があります。ブロック付きメソッド呼び出しは
繰り返しを始めとする制御構造をクラス設計者が定義する事が出来るものです.

=== 条件分岐
====[a:if] if

例:

          if age >= 12 then
            print "adult fee\n"
          else
            print "child fee\n"
          end
          gender = if foo.gender == "male" then "male" else "female" end

文法:

          if 式 [then]
            式 ...
          [elsif 式 [then]
            式 ... ]
          ...
          [else
            式 ... ]
          end

条件式を評価した結果が真である時、then 以下の式を評価します。
if の条件式が偽であれば elsif の条件を評価します。
elsif 節は複数指定でき、全ての if および elsif
の条件式が偽であったとき else 節があればその式が評価されます。

if 式は、条件が成立した節(あるいは else 節)の最後に評価し
た式の結果を返します。else 節がなくいずれの条件も成り立たなけれ
ば nil を返します。

Ruby では false または nil だけが偽で、それ以外は 0 や空文
字列も含め全て真です。

Ruby では if を繋げるのは elsif であり、else if
(C のように)でも elif(sh のように)でもないことに注意してください。

また if の条件式が正規表現のリテラルである時には特別に

          $_ =~ リテラル

であるかのように評価されます。

==== if 修飾子

例:

          print "debug\n" if $DEBUG

文法:

          式 if 式

右辺の条件が成立する時に、左辺の式を評価してその結果を返します。
条件が成立しなければ nil を返します。

====[a:unless] unless

例:

          unless baby?
            feed_meat
          else
            feed_milk
          end

文法:

          unless 式 [then]
            式 ...
          [else
            式 ... ]
          end

unless は if と反対で、条件式が偽の時に then 以下の
式を評価します。unless 式にelsif を指定することはできませ
ん。

==== unless 修飾子

例:

          print "stop\n" unless valid(passwd)

文法:

          式 unless 式

右辺の条件が成立しない時に、左辺の式を評価してその結果を返します。
条件が成立しなければ nil を返します。

====[a:case] case

例:

          case $age
          when 0 .. 2
            "baby"
          when 3 .. 6
            "little child"
          when 7 .. 12
            "child"
          when 13 .. 18
            "youth"
          else
            "adult"
          end

文法:

          case [式]
          [when 式 [, 式] ...[, `*' 式] [then]
            式..]..
          [when `*' 式 [then]
            式..]..
          [else
            式..]
          end

case は一つの式に対する一致判定による分岐を行います。when
節で指定された値と最初の式を評価した結果とを演算子 === を用いて
比較して、一致する場合には when 節の本体を評価します。

つまり、

          case 式0
          when 式1, 式2
            stmt1
          when 式3, 式4
            stmt2
          else
            stmt3
          end

は以下の if 式とほぼ等価です。

          _tmp = 式0
          if 式1 === _tmp or 式2 === _tmp
            stmt1
          elsif 式3 === _tmp or 式4 === _tmp
            stmt2
          else
            stmt3
          end

when 節の評価順序はこの上記 if 文に書き直した場合と同じです。つまり上
から順に(そして左から順に) === が評価されます。また「式0」は1回だけ評
価されます。

when 節の最後の式に `*' を前置すればその式は配列展開されます。

        ary = [1,2,3]

        case v
        when *ary
         ..
        end

は、

        case v
        when 1, 2, 3
         ..
        end

と等価です。

また === がどのような条件で真になるかは、各クラスの === メソッ
ドの動作についてのドキュメントを参照して下さい。

case の「式」を省略した場合、when の条件式が偽でない最初の
式を評価します。

        foo = false
        bar = true
        quu = false

        case
        when foo then puts 'foo is true'
        when bar then puts 'bar is true'
        when quu then puts 'quu is true'
        end
        # "bar is true"と表示される

case は、条件が成立した when 節、(あるいは else 節)
の最後に評価した式の結果を返します。いずれの条件も成り立たなければ
nil を返します。

=== 繰り返し

====[a:while] while

例:

          ary = [0,2,4,8,16,32,64,128,256,512,1024]
          i = 0
          while i < ary.length
            print ary[i]
            i += 1
          end

文法:

          while 式 [do]
             ...
          end

式を評価した値が真の間、本体を繰り返し実行します。

while は nil を返します。また、引数を伴った break により
while 式の戻り値をその値にすることもできます。

==== while 修飾子

例:
          sleep(60) while io_not_ready?

文法:

          式 while 式

右辺の式を評価した値が真の間、左辺を繰り返し実行します。

左辺の式が begin 節である場合にはそれを最初に一回評価してから繰り返します。

例:
        send_request(data)
        begin
          res = get_response()
        end while res == 'Continue'

while 修飾した式は nil を返します。
また、引数を伴った break により while 修飾した式の戻り値を
その値にすることもできます。

====[a:until] until

例:
          until f.eof?
            print f.gets
          end

文法:
          until 式 [do]
             ...
          end

式を評価した値が真になるまで、本体を繰り返して実行します。

until は nil を返します。また、引数を伴った break により
until 式の戻り値をその値にすることもできます。

==== until修飾子

例:
          print(f.gets) until f.eof?

文法:
          式 until 式

右辺の式を評価した値が真になるまで、左辺を繰り返して実行しま
す。

左辺の式が begin 節である場合にはそれを最初に一回評価してから繰り返します。

例:
        send_request(data)
        begin
          res = get_response()
        end until res == 'OK'

until 修飾した式は nil を返します。
また、引数を伴った break により until 修飾した式の戻り値をその値にすることもできます。

====[a:for] for

例:

          for i in [1, 2, 3]
            print i*2, "\n"
          end

文法:

          for lhs ...  in 式 [do]
            式..
          end

式を評価した結果のオブジェクトの各要素に対して本体を繰り返し
て実行します。これは以下の式とほぼ等価です。

          (式).each `{' `|' lhs..`|' 式.. `}'

「ほぼ」というのは、do  ...  endまたは{ }による
ブロックは新しいローカル変数の有効範囲を導入するのに対し、
for文はローカル変数のスコープに影響を及ぼさない点が
異なるからです。

for は、in に指定したオブジェクトの each
メソッドの戻り値を返します。

複数のループ変数指定は以下のような場合に使用します。

        for i,j in [[1,2], [3,4], [5,6]]
          p [i,j]
        end
        => [1, 2]
           [3, 4]
           [5, 6]

for や each で配列要素を複数個ずつ取得しながらループすることは
できません。

        for i,j in [1, 2, 3]
          p [i,j]
        end

        => [1, nil]
           [2, nil]
           [3, nil]

        # [1,2] [3,nil] を期待するかもしれないがそうはならない

代わりにそのようなメソッド(イテレータ)を定義する必要があります。

        class Array
          def each2
            i = 0
            while i < self.size
              yield self[i], self[i+1]
              i += 2
            end
          end
        end

====[a:break] break

例:

          i = 0
          while i < 3
            print i, "\n"
            break
          end

文法:

          break

          break val          

break はもっとも内側のループを脱出します。ループとは

    * while
    * until
    * for
    * イテレータ

のいずれかを指します。C 言語と異なり、break はループを脱出する作
用だけを持ち、case を抜ける作用は持ちません。

break によりループを抜けた for やイテレータは nil
を返します。
ただし、引数を指定した場合はループの戻り値はその引数になります。


====[a:next] next

例:
          # 空行を捨てるcat
          ARGF.each_line do |line|
            next if line.strip.empty?
            print line
          end

文法:

          next

          next val              


nextはもっとも内側のループの次の繰り返しにジャンプします。
イテレータでは、yield 呼び出しの脱出になります。

next により抜けた yield 式は nil を返します。
ただし、引数を指定した場合、yield 式の戻り値はその引数になります。

====[a:redo] redo

例:

          redo

文法:

          redo

ループ条件のチェックを行なわず、現在の繰り返しをやり直します。

====[a:retry] retry

例:

          retry

文法:

          retry

#@since 1.9.1
retry は、rescue 節で begin 式をはじめからもう一度実行するのに使用します。
#@else
イテレータ、ブロックまたはfor文の中で使われた場合には、そのイテレータ
を起動しなおします。イテレータの引数も再評価されます。

          for i in 1..5
            retry if some_condition # i == 1 からやり直し
          end

          # ユーザ定義の "untilループ"
          def UNTIL(cond)
            return if cond
            yield
            retry
          end

retry は、ループ以外に後述の rescue 節でも使えます。この場
合は、begin 式を始めからもう一度実行します。
#@end
retry を使うことである処理が成功するまで処理を繰り返すようなループを作
ることができます。

          begin
            do_something # exception raised
          rescue
            # handles error
            retry  # restart from beginning
          end

#@since 1.9.1
rescue 節以外で retry が用いられた場合には例外 [[c:SyntaxError]] が発生
します。
#@else
rescue 節やイテレータブロック、for 文以外で retry が用いられた場合には
例外 [[c:LocalJumpError]] が発生します。また、トップレベルで用いられた
場合には、警告を表示してインタプリタが終了します。

  retry #=> -:1: retry outside of rescue clause
#@end

イテレータ呼び出しにおける break, next, redo,
retry をまとめると以下のようになります。

        def iter
         (a)
          :
         (b)
         yield
         (c)
          :
         (d)
        end
#@until 1.9.0
        iter { retry }   -> (a) へ飛ぶ
#@end
        iter { redo  }   -> (b) へ飛ぶ
        iter { next  }   -> (c) へ飛ぶ
        iter { break }   -> (d) へ飛ぶ

(a) は、厳密には引数評価から始まります。(b) はブロック実行の直前を指し
ています(yield の引数が再評価されるわけではない)。(d) は、メソッドの終
了です。

        def iter(var = p("(a)"))
          yield
          p "(c)"
        ensure
          p "(d)"
        end
#@until 1.9.0
        iter { p "(b)"; retry }     # -> (a) .. (b)(d)(a) .. (b)(d)(a) ...
#@end
        iter { p "(b)"; redo  }     # -> (a) .. (b)(b)(b)(b) ...
        iter { p "(b)"; next  }     # -> (a) .. (b)(c) .. (d)
        iter { p "(b)"; break }     # -> (a)..(b)(d)

#@until 1.9.1
[注意] ensure は大域脱出を捕捉するため、retry の例では (d) も表示されます。
#@end

=== 例外処理

====[a:raise] raise

例:

          raise "you lose"  # 例外 RuntimeError を発生させる
          # 以下の二つは SyntaxError を発生させる
          raise SyntaxError, "invalid syntax"
          raise SyntaxError.new("invalid syntax")
          raise             # 最後の例外の再発生

文法:

          raise
          raise messageまたはexception
          raise error_type, message
          raise error_type, message, traceback

例外を発生させます。第一の形式では直前の例外を再発生させます。
第二の形式では、引数が文字列であった場合、その文字列をメッセー
ジとする [[c:RuntimeError]] 例外を発生させます。引数が例外
オブジェクトであった場合にはその例外を発生させます。第三の形式
では第一引数で指定された例外を、第二引数をメッセージとして発生さ
せます。第四の形式の第三引数は
[[m:$@]]または
[[m:Kernel.#caller]]で得られる
スタック情報で、例外が発生した場所を示します。

発生した例外は後述の begin 式の rescue 節で捕らえることができます。
その場合 rescue error_type => var の形式を使えば
例外オブジェクトを得られます。このオブジェクトは組み込み
変数 [[m:$!]] でも得られます。また例外が
発生したソースコード上の位置は変数 [[m:$@]] に格納されます。

[[m:Kernel.#raise]] は Ruby の予約語ではなく、[[c:Kernel]] モジュールで
定義されている関数的メソッドです。

====[a:begin] begin

例:

          begin
            do_something
          rescue
            recover
          ensure
            must_to_do
          end

文法:

          begin
            式..
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end

本体の実行中に例外が発生した場合、rescue 節(複数指定できます)が
与えられていれば例外を捕捉できます。発生した例外と一致する
rescue 節が存在する時には rescue 節の本体が実行されます。
発生した例外は [[m:$!]] を使って参照することができます。また、
指定されていれば変数 evar にも $! と同様に発生した例外が格
納されます。

        begin
          raise "error message"
        rescue => evar
          p $!
          p evar
        end
        # => #<RuntimeError: error message>
             #<RuntimeError: error message>

例外の一致判定は，発生した例外が rescue 節で指定した
クラスのインスタンスであるかどうかで行われます。 

error_type が省略された時は [[c:StandardError]] のサブクラスであ
る全ての例外を捕捉します。Rubyの組み込み例外は([[c:SystemExit]] や
[[c:Interrupt]] のような脱出を目的としたものを除いて)
[[c:StandardError]] のサブクラスです。

例外クラスのクラス階層については
[[unknown:組み込みクラス／モジュール／例外クラス/例外クラス]]
を参照してください。

rescue では error_type は通常の引数と同じように評価され、
そのいずれかが一致すれば本体が実行されます。error_type を評価し
た値がクラスやモジュールでない場合には例外 [[c:TypeError]] が発生しま
す。

省略可能な else 節は、本体の実行によって例外が発生しなかった場合
に評価されます。

ensure 節が存在する時は begin 式を終了する直前に必ず
ensure 節の本体を評価します。

begin式全体の評価値は、本体／rescue節／else節のうち
最後に評価された文の値です。また各節において文が存在しなかったときの値
はnilです。いずれにしてもensure節の値は無視されます。

[[ref:d:spec/def#class]]、[[ref:d:spec/def#module]]、[[ref:d:spec/def#method]]
などの定義文では、それぞれ
begin なしで rescue, ensure 節を定義でき、これにより例外を処理することが
できます。

==== rescue修飾子

例:
          open("nonexistent file") rescue STDERR.puts "Warning: #$!"

文法:

          式1 rescue 式2

式1で例外が発生したとき、式2を評価します。
以下と同じ意味です。捕捉する例外クラスを指定することはできません。
(つまり、[[c:StandardError]] 例外クラスのサブクラスだけしか捕捉できません)

          begin
            式1
          rescue
            式2
          end

rescue修飾子を伴う式の値は例外が発生しなければ式1、例外が発生すれば式2
です。

          var = open("nonexistent file") rescue false
          p var
          => false

ただし、優先順位の都合により式全体を括弧で囲む必要がある場合があります。
メソッドの引数にするには二重の括弧が必要です。

          p(open("nonexistent file") rescue false)
          => parse error
          
          p((open("nonexistent file") rescue false))
          => false

=== その他

====[a:return] return

例:

          return
          return 12
          return 1,2,3

文法:

          return [式[`,' 式 ... ]]

式の値を戻り値としてメソッドの実行を終了します。式が2つ以上
与えられた時には、それらを要素とする配列をメソッドの戻り値と
します。式が省略された場合には nil を戻り値とします。

#@since 2.4.0
トップレベルで return した場合はプログラムが終了します。
require, load されたファイル内のトップレベルで return した場合は呼び出し元に返ります。
#@end

====[a:BEGIN] BEGIN

例:

          BEGIN {
             ...
          }

文法:

          BEGIN '{' 文.. '}'

初期化ルーチンを登録します。BEGINブロックで指定した文は当該ファ
イルのどの文が実行されるより前に実行されます。複数のBEGINが指定
された場合には指定された順に実行されます。

BEGINブロックはコンパイル時に登録されます。
#@since 1.9.1
BEGIN ブロックは、独立したローカル変数のスコープを導入しません。つまり、
BEGIN ブロック内で定義したローカル変数は BEGIN ブロックを抜けた後も使用
可能です。
#@else
即ち一つの記述につきただ一回だけ登録が行われます。

        if false
          BEGIN { p "begin" }
        end

        # => "begin"

BEGINブロックは独立したローカル変数のスコープを導入するため、ロー
カル変数を外部と共有できません。ブロックの外と情報を伝達するには定数や
グローバル変数などを介する必要があります。

        BEGIN { $foo, foo = true, true }
        p $foo  # => true
        p foo   # undefined local variable or method `foo' for main:Object (NameError)
#@end

#@since 1.9.1
BEGINはトップレベル以外では書けません。全て [[c:SyntaxError]]になります。

        def foo
          BEGIN { p "begin" }
        end
        # => -e:2: syntax error, unexpected keyword_BEGIN

        class Foo
          BEGIN { p "begin" }
        end
        # => -e:2: syntax error, unexpected keyword_BEGIN

        loop do
          BEGIN { p "begin" }
        end
        # => -e:2: syntax error, unexpected keyword_BEGIN

#@else
BEGINはメソッド定義式中には書けません。parse error になります。

        def foo
          BEGIN { p "begin" }
        end
        # => -:2: BEGIN in method
#@end

====[a:END] END

例:

          END {
             ...
          }

文法:

          END '{' 文.. '}'

「後始末」ルーチンを登録します。END ブロックで指定した文はインタ
プリタが終了する時に実行されます。Ruby の終了時処理について詳しくは
[[d:spec/terminate]]を参照してください。

複数の END ブロックを登録した場合は、登録したときと逆の順序で実
行されます。

        END { p 1 }
        END { p 2 }
        END { p 3 }

        # => 3
             2
             1

END ブロックは一つの記述につき最初の一回のみ有効です。たとえば以
下のようにループの中で実行しても複数の END ブロックが登録される
わけではありません。そのような目的には [[m:Kernel.#at_exit]] を使
います。

        5.times do |i|
          END { p i }
        end
        # => 0

END をメソッド定義式中に書くと警告が出ます
#@#((-((<ruby 1.8 feature>)): これは 1.8.1 から [[unknown:ruby-dev:21513]]-))。
意図的にこのようなことを行いたい場合は [[m:Kernel.#at_exit]] を使
います。

        def foo
          END { p "end" }
        end
        p foo

        # => -:2: warning: END in method; use at_exit
             nil
             "end"

END は、BEGIN とは異なり実行時に後処理を登録します。したがっ
て、以下の例では END ブロックは実行されません。

        if false
          END { p "end" }
        end

END や [[m:Kernel.#at_exit]] で登録した後処理を取り消すこと
はできません。

#@since 1.9.1
END ブロックは周囲とスコープを共有します。すなわちイテレータと同様のス
コープを持ちます。
#@else
END ブロックは BEGIN ブロックとは異なり周囲とスコープを共有し
ます。すなわちイテレータと同様のスコープを持ちます。
#@end

END ブロックの中で発生した例外はその END ブロックを中断し
ますが、すべての後始末ルーチンが実行されるよう、インタプリタは終了せず
にメッセージだけを出力します。

例:

        END { p "FOO" }
        END { raise "bar"; p "BAR" }
        END { raise "baz"; p "BAZ" }

        => baz (RuntimeError)
           bar (RuntimeError)
           "FOO"
