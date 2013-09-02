= クラス／メソッドの定義

  * [[ref:class]]
  * [[ref:singleton_class]]
  * [[ref:module]]
  * [[ref:method]]
  * [[ref:operator]]
  * [[ref:nest_method]]
  * [[ref:eval_method]]
  * [[ref:singleton_method]]
  * [[ref:class_method]]
  * [[ref:limit]]

定義に関する操作:
  * [[ref:alias]]
  * [[ref:undef]]
  * [[ref:defined]]

===[a:class] クラス定義

例:

          class Foo < Super
            def test
               :
            end
               :
          end

文法:

          class 識別子 [`<' superclass ]
            式..
          end

#@since 1.8.0
文法:

          class 識別子 [`<' superclass ]
            式..
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end
#@end

クラスを定義します。クラス名はアルファベットの大文字で始まる識別子です。

rescue/ensure 節を指定し、例外処理ができます。
例外処理については[[ref:d:spec/control#begin]]参照。

クラス定義は、識別子で指定した定数へのクラスの代入になります
(Ruby では、クラスもオブジェクトの一つで [[c:Class]]クラスの
インスタンスです)。

クラスが既に定義されているとき、さらに同じクラス名でクラス定義を書くとク
ラスの定義の追加になります。
#@since 1.8.2
ただし、元のクラスと異なるスーパークラスを指定すると TypeError が発生します。
#@else
ただし、元のクラスと異なるスーパークラスを
明示的に指定して定義すると、元のクラスとは異なる新たなクラスを同名で定
義することになります。このとき、クラス名の定数を上書きすることになるの
で警告メッセージが出ます。
#@end

        class Foo < Array
          def foo
          end
        end

        # 定義を追加(スーパークラス Array を明示的に指定しても同じ)
        class Foo
          def bar
          end
        end

#@since 1.8.2
        # 間違ったスーパークラスを指定するとエラー
        class Foo < String
        end
        # => superclass mismatch for class Foo (TypeError)
#@else
        # 別のクラスを定義(スーパークラスが異なるので)
        class Foo < String
        end
        # => warning: already initialized constant Foo
#@end

クラス定義式の中は self がそのクラスであることと、
[[ref:limit]]のデフォルトが異なること以外
にトップレベルとの違いはありません。クラス定義式中には任意の式を書くこ
とができクラス定義の際に実行されます。

クラス定義はネスト(入れ子)にして定義できます。以下の例で入れ子の外側の
クラス Foo と内側のクラス Bar の間には、定数 Bar が Foo の中の定数
Foo::Bar であること以外、継承関係などの機能的な関連はまったくありません。

        class Foo
          class Bar
          end
        end

#@since 1.8.0
クラス Foo が既に定義されていれば、以下の書き方もできます。

        class Foo
        end

        class Foo::Bar
        end
#@end

クラスのネストは、意味的に関連するクラスを外側のクラス／モジュールでひ
とまとまりにしたり、包含関係を表すために使用されます。

        # 関連するクラスを Net というカテゴリにまとめる
        # このような場合は外側は普通モジュールが利用される
        # (Net のインスタンスがない。Net を include できるなどのため)
        module Net
          class HTTP
          end
          class FTP
          end
        end

        obj = Net::HTTP.new

        # あるいは

        include Net
        obj = HTTP.new

        # 以下のような使い方は組み込みのクラスにも見られる
        # 利用者は File::Constants を include することで、
        # File::RDONLY などと書かずに直接 RDONLY と書くことができる。
        class File
          module Constants
             RDONLY = 0
             WRONLY = 1
          end
          include Constants
        end

        File.open("foo", File::RDONLY)

        # あるいは

        include File::Constants
        File.open("foo", RDONLY)

        # 上記はあくまでも例である。実際の File.open ではより簡便な
        # File.open("foo", "r") という形式が使われる

#@since 1.8.0
クラス定義式は、最後に評価した式の結果を返します。最後に評価した式
が値を返さない場合は nil を返します。
#@else
クラス定義式は値を返しません。
#@end

===[a:singleton_class] 特異クラス定義

例:

          obj = Object.new # obj = nil でも可
          class << obj
            def test
               :
            end
               :
          end

文法:

          class `<<' expr
            式..
          end

#@since 1.8.0
文法:

          class `<<' expr
            式..
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end
#@end

クラス定義と同じ構文で特定のオブジェクトにメソッドやインスタンス変数を
定義/追加します。この構文の内部で定義したメソッドや定数は指定した
オブジェクトに対してだけ有効になります。
Object#clone で生成したオブジェクトには引き継がれますが，
Object#dup で生成したオブジェクトには引き継がれません．

rescue/ensure 節を指定し、例外処理ができます。
例外処理については[[ref:d:spec/control#begin]]参照。

特異クラス定義式は、最後に評価した式の結果を返します。最後に評価した式
が値を返さない場合は nil を返します。

===[a:module] モジュール定義

例:

          module Foo
            def test
               :
            end
               :
          end

文法:

          module 識別子
            式..
          end

#@since 1.8.0
文法:

          module 識別子
            式..
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end
#@end

モジュールを定義します。モジュール名はアルファベットの大文字
で始まる識別子です。

rescue/ensure 節を指定し、例外処理ができます。
例外処理については[[ref:d:spec/control#begin]]参照。

モジュール定義は、識別子で指定した定数へのモジュールの代入になります。
Ruby では、モジュールもオブジェクトの一つで [[c:Module]] クラスのインスタンスです。
モジュールが既に定義されいるとき、さらに同じモジュール名でモジュール定
義を書くとモジュールの定義の追加になります。

#@since 1.8.0
モジュール定義式は、最後に評価した式の結果を返します。最後に評価した式
が値を返さない場合は nil を返します。
#@else
モジュール定義式は値を返しません。
#@end

===[a:method] メソッド定義

例:

          def fact(n)
            if n == 1 then
               1
            else
              n * fact(n-1)
            end
          end

文法:

#@since 1.9.1
          def メソッド名 [`(' [arg0 ['=' default0]] ... [`,' `*' rest_args [, post ...]] [',' '&' block_arg]`)']
#@else
          def メソッド名 [`(' [arg0 ['=' default0]] ... [`,' `*' rest_args] [',' '&' block_arg]`)']
#@end
            式.. (body)
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end

この定義のある場所にメソッドを定義します。すなわち、クラス/モジュール
定義中ならばそのクラス/モジュールのメソッドを定義します。トップレベル
ならばどこからでも呼べるメソッドを定義します。このようなメソッドは結果
として他の言語における「関数」のように使えます。

例:

          def hello    # 引数のないメソッド。
            puts "Hello, world!"
          end

          def foo(a, b)    # 引数のあるメソッド。括弧を省いてdef foo a, bとも
            a + 3 * b
          end

メソッド名としては通常の識別子の他に、再定義可能な演算子(例: ==, +, -
など [[d:spec/operator]] を参照)も指定できます([[ref:operator]]参照)。

例:

          class Vector2D
            attr_accessor :x, :y   # インスタンス変数@x, @yに対応するゲッタとセッタを定義
            def initialize(x, y)   # コンストラクタ
              @x = x; @y = y   # @がつくのがインスタンス変数（メンバ変数）
            end
            def ==(other_vec)   # いわゆる演算子オーバーライド
              other_vec.x == @x && other_vec.y == @y
            end
            def +(other_vec)
              Vector2D.new(other_vec.x + @x, other_vec.y + @y)
            end
            ...
          end
          vec0 = Vector2D.new(10, 20); vec1 = Vector2D.new(20, 30)
          p vec0 + vec1 == Vector2D.new(30, 50) #=> true

仮引数にデフォルト式が与えられた場合、メソッド呼び出しで実引数を省略し
たときのデフォルト値になります。
ただし実引数との対応を取るため、i番目の引数にデフォルト値を指定したならば、
i+1番目以降でも全てデフォルト値を指定するか、可変長引数を利用しなければなりません（詳細は後述）。
デフォルト式の評価は呼び出し時にメソッド定義内のコンテキストで行われます。

例:

          def foo(x, y = 1)    # 2番目の引数yにデフォルト値を指定
            10 * x + y
          end
          p foo(1, 5)  #=> 15
          p foo(3)     #=> 31
          p foo        #=> ArgumentError (wrong number of arguments)

          $gvar = 3
          def bar(x, y = $gvar)  # 確かに定義時には$gvar == 3だが
            10 * x + y
          end
          $gvar = 7
          # 呼び出し時の$gvarの値が使われる
          p bar(5)   #=> 57 (!= 53)

仮引数の直前に * がある場合には残りの実引数
#@since 1.9.1
(後述の post 引数を除く)
#@end
はみな配列とし てこの引数に格納されます。
可変長引数、rest 引数などと呼ばれる機能です。
このような引数は 1 つしか作れません。

例:

         def foo(x, *xs)
           puts "#{x} : #{xs.inspect}"   # Object#inspect は p のような詳細な内部表示
         end
         foo(1)        #=> 1 : []
         foo(1, 2)     #=> 1 : [2]
         foo(1, 2, 3)  #=> 1 : [2, 3]

         def bar(x, *) # 残りの引数を単に無視したいとき
           puts "#{x}"   
         end
         bar(1)        #=> 1 
         bar(1, 2)     #=> 1
         bar(1, 2, 3)  #=> 1

#@since 1.9.1
Ruby 1.9 では可変長引数よりも後にまだ通常の引数を置くことができます。
#@end

最後の仮引数の直前に & があるとこのメソッドに与えられているブロッ
クが手続きオブジェクト([[c:Proc]])としてこの引数に格納されます。これは、
イテレータを定義する方法の一つです。イテレータを定義する代表的な方法は 
yield を呼び出すことです。
他に [[m:Proc.new]]/[[m:Kernel.#proc]] を使う方法などもあります。
ブロックが与えられなかった場合のブロック引数の値はnilです。

例:

          def foo(cnt, &block_arg)
            cnt.times { block_arg.call } # ブロックに収まったProcオブジェクトはcallで実行
          end
          foo(3) { print "Ruby! " } #=> Ruby! Ruby! Ruby!

メソッド定義において、仮引数はその種類毎に以下の順序でしか指定すること
はできません。いずれも省略することは可能です。

    * デフォルト式のない引数(複数指定可)
    * デフォルト式のある引数(複数指定可)
    * * を伴う引数(1つだけ指定可)
    * & を伴う引数(1つだけ指定可)

例:

          # すべて持つ
          def foo(arg0, arg1, arg2 = 10, *rest, &block)
            block.call if block
            puts "#{arg0}: #{arg1}: #{arg2}?: #{rest.inspect}"
          end
          foo(1, 2, 3, 4, 5) { print "Args are " }  #=> Args are 1: 2: 3?: [4, 5]

例: イテレータの定義

          # yield を使う
          def foo
          # block_given? は、メソッドがブロックを渡されて
          # 呼ばれたかどうかを判定する組み込み関数
            if block_given?
              yield(1,2)
            end
          end

          # Proc.new を使う
          def bar
            if block_given?
              Proc.new.call(1,2)    # proc.call(1,2) でも同じ(proc は組み込み関数)
            end
          end

          # 応用: 引数として Proc オブジェクトとブロックの
          # 両方を受け付けるイテレータを定義する例
          def foo(block = Proc.new)
            block.call(1,2)
          end
          foo(proc {|a,b| p [a,b]})
          foo {|a,b| p [a,b]}

          # ブロック引数を使う
          def baz(&block)
            if block
              block.call(1,2)
            end
          end

またメソッド実行時の例外を捕捉するために begin 式と同様
のrescue, else, ensure 節を指定できます。
例外処理については[[ref:d:spec/control#begin]]参照。

#@since 1.8.0
メソッド定義式は、nil を返します。
#@else
メソッド定義式は値を返しません。
#@end

====[a:operator] 演算子式の定義

[[d:spec/operator]]において、「再定義可能な演算子」に分類された演算子の実装
はメソッドなので、定義することが可能です。

これらの演算子式を定義する例を以下に挙げます。

          # 二項演算子
          def +(other)                # obj + other
          def -(other)                # obj - other

          # 単項プラス/マイナス
          def +@                      # +obj
          def -@                      # -obj

          # 要素代入
          def foo=(value)             # obj.foo = value

          # [] と []=
          def [](key)                 # obj[key]
          def []=(key, value)         # obj[key] = value
          def []=(key, key2, value)   # obj[key, key2] = value

          # バッククォート記法
          def `(arg)                  # `arg` または %x(arg)

バッククォート記法の実装はメソッドなのでこのように再定義が可能です。普
通はこのメソッドを再定義するべきではありませんが、まれにOS(シェル)のコ
マンド実行の挙動に不具合がある場合などに利用できます。
#@#((- 実際の応用例が[[unknown:ruby-talk:10006]],[[unknown:ruby-dev:12829]]にあります-))

====[a:nest_method] メソッド定義のネスト

#@since 1.8.0
ネスト可能です。ネストされた定義式は、
それを定義したメソッドが実行された時に定義されます。このことを除けば、
普通のメソッド定義式と同じです。以下の例を参照してください。
#@else
[[ref:singleton_method]]を除くメソッド定義式はネストできません。
#@end
#@#version 1.8.0 には、ネストして定義したメソッドが Object のインスタンス
#@#メソッドになるというバグがありました-))

#@since 1.8.0
        class Foo
          def foo
            def bar
              p :bar
            end
          end

          def Foo.method_added(name)
            puts "method \"#{name}\" was added"
          end
        end
        obj = Foo.new
        obj.bar rescue nil # => undefined method `bar' for #<Foo:0x4019eda4>
        obj.foo            # => method "bar" was added
        obj.foo            # => warning: method redefined; discarding old bar
        Foo.new.bar        # => :bar  (他のインスタンスでも定義済み)

#@else
version 1.6 以前は、同じことを行うのに [[m:Object#instance_eval]] を使
う必要がありました(この場合特異メソッドが定義されるので少し異なります)。

        class Foo
          def foo
            instance_eval <<-END
              def bar
                p :bar
              end
            END
          end
        end

        obj = Foo.new
        def obj.singleton_method_added(name)
            puts "singleton method \"#{name}\" was added"
        end                # => singleton method "singleton_method_added" was added

        obj.bar rescue nil # => undefined method `bar' for #<Foo:0x4019eda4>
        obj.foo            # => singleton method "bar" was added

        obj.foo            # => warning: method redefined; discarding old bar
                           # => singleton method "bar" was added
        Foo.new.bar        # => undefined method `bar' for #<Foo:0x4019eda4>

または、以下のように書くこともできます。
#@#1.6 以前は、def 式内の def 式が
#@#parser で許されなかったのでこのように書くことはできませんでした

       class Foo
          def foo
            instance_eval {
              def bar
                p :bar
              end
            }
          end
        end
#@end

====[a:eval_method] メソッドの評価

メソッドが呼び出されると、以下の順で式が評価されます。

 * 指定されていれば引数のデフォルト式
 * メソッドの本体 body
 * 指定されていれば例外の発生の有無によりメソッド定義式の rescue
   節または else 節
 * 指定されていれば ensure 節

引数のデフォルト式も含め、すべてそのメソッドのコンテキストで評価されます。

メソッドの戻り値は return に渡した値です。return が呼び出されなかった場合は、
body の最後の式の値を返します。
body の最後の式が値を返さない式の場合は nil を返します。

またメソッドは定義する前に呼び出すことはできません。例えば

          foo          # <- foo は未定義
          def foo
            print "foo\n"
          end

は未定義メソッドの呼び出しで例外 [[c:NameError]] を発生させます。

===[a:singleton_method] 特異メソッド定義

例:

          def foo.test
            print "this is foo\n"
          end

文法:

          def 式 `.' 識別子 [`(' [引数 [`=' default]] ... [`,' `*' 引数 ]`)']
            式..
          [rescue [error_type,..] [=> evar] [then]
            式..]..
          [else
            式..]
          [ensure
            式..]
          end

特異メソッドとはクラスではなくある特定のオブジェクトに固有の
メソッドです。特異メソッドの定義はネストできます。

クラスの特異メソッドはそのサブクラスにも継承されます。言い替
えればクラスの特異メソッドは他のオブジェクト指向システムにお
けるクラスメソッドの働きをすることになります。

#@since 1.8.0
特異メソッド定義式は、nil を返します。
#@else
特異メソッド定義式は値を返しません。
#@end

===[a:class_method] クラスメソッドの定義

Ruby におけるクラスメソッドとはクラスの特異メソッドのことです。Ruby で
は、クラスもオブジェクトなので、普通のオブジェクトと同様に特異メソッド
を定義できます。

したがって、何らかの方法でクラスオブジェクトにメソッドを定義すれば、そ
れがクラスメソッドとなります。具体的には以下のようにして定義することが
出来ます(モジュールも同様です)。

        # 特異メソッド方式。
        class Hoge
          def Hoge.foo
          end
        end

        # クラス定義の外でも良い
        def Hoge.bar
        end

        # 以下のようにすればクラス名が変わってもメソッド部の変更が不要
        class Hoge
          def self.baz
            'To infinity and beyond!'
          end
        end

        # 特異クラス方式。複数のメソッドを一度に定義するとき向き
        class << Hoge
          def bar
            'bar'
          end
        end

        # モジュールをクラスに extend すれば、モジュールのインスタンス
        # メソッドがクラスメソッドになる
        module Foo
          def foo
          end
        end
        class Hoge
          extend Foo
        end

extend については、[[m:Object#extend]] を参照して
ください。

===[a:limit] 呼び出し制限

メソッドは public、private、protected の三通りの
呼び出し制限を持ちます。

 * public に設定されたメソッドは制限なしに呼び出せます。
 * private に設定されたメソッドは関数形式でしか呼び出せません。
 * protected に設定されたメソッドは、そのメソッドを持つオブジェクトが
   selfであるコンテキスト(メソッド定義式やinstance_eval)でのみ呼び出せ
   ます。

例: protected の可視性

        class Foo
          def foo
           p caller.last
          end
          protected :foo
        end

        obj = Foo.new

        # そのままでは呼べない
        obj.foo rescue nil    # => -:11 - private method `foo' called for #<Foo:0x401a1860> (NameError)

        # クラス定義内でも呼べない
        class Foo
          Foo.new.foo rescue nil # => -:15 - protected method `foo' called for #<Foo:0x4019eea8>
          # メソッド定義式内で呼べる
          def bar
            self.foo
          end
        end
        Foo.new.bar             # => ["-:21"]

        # 特異メソッド定義式内でも呼べる
        def obj.bar
          self.foo rescue nil
        end
        obj.bar                 # => ["-:27"]

#@#         class <<obj
#@#           def baz
#@#             self.foo rescue nil
#@#           end
#@#         end
#@#         obj.baz                 # => ["-:34"]
#@# 
#@#         module Baz
#@#           def baz
#@#             self.foo
#@#           end
#@#         end
#@#         class Foo
#@#           include Baz
#@#         end
#@#         Foo.new.baz             # => ["-:44"]

デフォルトでは def 式がクラス定義の外(トップレベル)にあれば private、
クラス定義の中にあれば public に定義します。これは [[m:Module#public]]、[[m:Module#private]]、
[[m:Module#protected]] を用いて変更できます。ただし [[m:Object#initialize]] という名前のメソッドと
#@since 1.8.0
[[m:Object#initialize_copy]] という名前のメソッド
#@end
は定義する場所に関係なく常に private になります。

例:
          def foo           # デフォルトは private
          end

          class C
            def bar         # デフォルトは public
            end

            def ok          # デフォルトは public
            end
            private :ok     # …だが、ここで private に変わる

            def initialize  # initialize は private
            end
          end

private と protected は同じ目的(そのメソッドを隠し外から呼
べないようにする)で使用されますが、以下のような例では、private
は使えず、protected を利用する必要があります。
正確には、private には関数を定義する目的があるが、呼び
出し制限の目的でも(ここに挙げた制限があるにもかかわらず)
protected よりは private が使われることの方が多いようです。

        class Foo
          def _val
            @val
          end
          protected :_val

          def op(other)

            # other も Foo のインスタンスを想定
            # _val が private だと関数形式でしか呼べないため
            # このように利用できない

            self._val + other._val
          end
        end

=== 定義に関する操作

====[a:alias] alias

例:

          alias foo bar
          alias :foo :bar
          alias $MATCH $&

文法:

          alias 新メソッド名 旧メソッド名
          alias 新グローバル変数名 旧グローバル変数名

メソッドあるいはグローバル変数に別名をつけます。メソッド名に
は識別子そのものか [[ref:d:spec/literal#symbol]] を指定します(obj.method のよ
うな式を書くことはできません)。alias の引数はメソッド
呼び出し等の一切の評価は行われません。

メソッドの定義内で別名を付けるには[[c:Module]]クラスのメソッド
[[m:Module#alias_method]] を利用して下さい。

別名を付けられたメソッドは、その時点でのメソッド定義を引き継
ぎ、元のメソッドが再定義されても、再定義前の古いメソッドと同
じ働きをします。あるメソッドの動作を変え、再定義するメソッド
で元のメソッドの結果を利用したいときなどに利用されます。

    # メソッド foo を定義
    def foo
      "foo"
    end

    # 別名を設定(メソッド定義の待避)
    alias :_orig_foo :foo

    # foo を再定義(元の定義を利用)
    def foo
      _orig_foo * 2
    end

    p foo  # => "foofoo"

グローバル変数の alias を設定するとまったく同じ変数が定義されます。こ
のことは一方の変数への代入は他方の変数にも反映されるようになることを意
味します。
#@until 1.9.1
添付ライブラリの [[lib:importenv]] はこのことを利用して組み込み変数
([[ref:d:spec/variables#builtin]] を参照)に英語名をつけます。
#@end

#@until 1.8.0
グローバル変数の別名づけは特定の組み込み変数だけが対象です。
#@end

    # 特殊な変数のエイリアスは一方の変更が他方に反映される
    $_ = 1
    alias $foo $_
    $_ = 2
    p [$foo, $_]   # => [2, 2]

#@since 1.8.0
    $bar = 3
    alias $foo $bar
    $bar = 4
    p [$foo, $bar] # => [4, 4]
#@else
    # こちらは通常の変数のエイリアスで本当の意味での
    # エイリアスにはならない。これは、version 1.6 ま
    # での制限
    $bar = 3
    alias $foo $bar
    $bar = 4
    p [$foo, $bar] # => [3, 4]
#@end

ただし、正規表現の部分文字列に対応する変数 $1,$2, ... には別名を付けることができません。
また、インタプリタに対して重要な意味のあるグローバル変数
([[ref:d:spec/variables#builtin_variable]] を参照)を再定義すると動作に
支障を来す場合があります。

alias 式は nil を返します。

====[a:undef] undef

例:

          undef bar

文法:

          undef メソッド名[, メソッド名[, ...]]

メソッドの定義を取り消します。メソッド名には識別子そのもの
か [[ref:d:spec/literal#symbol]] を指定します(obj.method のような式を書くことはできません)。
undef の引数はメソッド呼び出し等の一切の評価は行われません。

メソッドの定義内で定義を取り消すには[[c:Module]]クラスのメソッ
ド [[m:Module#undef_method]] を利用して下
さい。

undef のより正確な動作は、メソッド名とメソッド定義との関係を取り除き、
そのメソッド名を特殊な定義と関連づけます。この状態のメソッドの呼び出しは
例えスーパークラスに同名のメソッドがあっても例外 [[c:NameError]] を発生させます。
(一方、メソッド [[m:Module#remove_method]] は、関係を取り除くだけです。この違いは重要です)。

alias による別名定義と undef による定義取り消しによってクラスのインタフェースを
スーパークラスと独立に変更することができます。ただし、メソッドが self にメッセージを
送っている場合もあるので、よく注意しないと既存のメソッドが動作しなくなる可能性があります。

undef 式は nil を返します。

====[a:defined] defined?

例:

          defined? print
          defined? File.print
          defined?(foobar)
          defined?($foobar)
          defined?(@foobar)
          defined?(Foobar)

文法:

          defined? 式

式が定義されていなければ、偽を返します。定義されていれば式の種別
を表す文字列を返します。

定義されていないメソッド、undef されたメソッド、[[m:Module#remove_method]] 
により削除されたメソッドのいずれに対しても defined? は偽を返します。

特別な用法として以下があります。

   defined? yield

yield の呼び出しが可能なら真(文字列 "yield")を返します。
[[m:Kernel.#block_given?]] と同様にメソッドがブロック付きで呼ばれたか
を判断する方法になります。

   defined? super

super の実行が可能なら真(文字列 "super")を返します。

   defined? a = 1
   p a # => nil

"assignment" を返します。実際に代入は行いませんがローカル変数は定義されます。

#@since 1.9.1
  /(.)/ =~ "foo"
  defined? $&  # => "global-variable"
  defined? $1  # => "global-variable"
  defined? $2  # => nil
#@else
  /(.)/ =~ "foo"
  defined? $&  # => "$&"
  defined? $1  # => "$1"
  defined? $2  # => nil
#@end

$&, $1, $2, などは直前のマッチの結果値が設定された場合だけ真を返します。

   def Foo(a,b)
   end
   p defined? Foo       # => nil
   p defined? Foo()     # => "method"
   Foo = 1
   p defined? Foo       # => "constant"

大文字で始まるメソッド名に対しては () を明示しなければ定数の判定
を行ってしまいます。

以下は、defined? が返す値の一覧です。

 * "super"
 * "method"
 * "yield"
 * "self"
 * "nil"
 * "true"
 * "false"
 * "assignment"
 * "local-variable"
 * "local-variable(in-block)"
 * "global-variable"
 * "instance-variable"
 * "constant"
 * "class variable"
#@until 1.9.1
 * "$&", "$`", "$1", "$2", ...
#@end
 * "expression"
