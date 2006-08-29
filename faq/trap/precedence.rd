= ()で解決するもの

* 結合強度の話

  Range オブジェクトのリテラル(あるいは範囲式)を表す (({..})),
  (({...})) は結合強度(((<演算子式>))参照)が低いので、以下はエラーにな
  ります

      1..3.to_a

      => -:1: bad value for range (ArgumentError)

  上記は、以下のように解釈されています。

      1..(3.to_a)

  範囲式は括弧で囲むのが無難です。

      (1..3).to_a  # => [1, 2, 3]

* メソッド呼出のかっこ省略による誤解釈

  上の例の続きで、以下は意図通りにはなりません

    p (1..3).to_a
    => 1..3

  これは以下のように解釈されます。

    (p (1..3)).to_a

  これは範囲式に限らず、メソッドの後に括弧があれば括弧の中身だけが引数
  であると解釈されるためです。以下も同様です。

    Time.gm (19+1)*100,2,11,12,34,56
    => -:1: parse error
           Time.gm (19+1)*100,2,11,12,34,56
                              ^

  このような場合は、引数全体を括弧で囲む必要があります。
  ((-((<ruby 1.7 feature>)): version 1.7 では、メソッド名と
  括弧の間に空白があると(おそらく)期待通りの動作をするよう
  に変更されています-))

    p ((1..3).to_a)
    => [1, 2, 3]

    Time.gm((19+1)*100,2,11,12,34,56)
    => Fri Feb 11 12:34:56 UTC 2000

* メソッド呼出のかっこ省略による誤解釈(2)

  以下のようなメソッド呼び出しと代入を含む式は parse error になります。

    p obj = String.new "foo"
    => -:1: parse error

  以下のようにする必要があります。

    p obj = String.new("foo")
    p ((obj = String.new "foo"))

* and/or の優先順位
    p :a if true || false &&  false
    p :b if true or false and false
      #=> :a

  && が || よりも優先順位が高いのに対し、
  and と or の優先順位が同じであることに注意。上記は以下のように解釈さ
  れています。

    p :a if true || (false &&  false)
    p :b if (true or false) and false

* 式と文
    p (true && true)    #=> true
    p (true and true)   #=> parse error
    p ((true and true)) #=> true

  true and falseは文と解釈されるので式として解釈されるための括弧とpの
  引数をくくる括弧が必要になります。

  ((<ruby-list:24664>))式を要求するコンテキストでは、以下のものが直接
  は書けません。

  * and/or/not を含む文
  * do .. endのブロックのついたメソッド呼び出し((-version 1.6以降では改善されました-))
  * かっこを省略したメソッド呼び出し(実はラストの1個だけは置ける)((-version 1.7以降では最後の引数にも括弧を省略したメソッド呼び出しは書けなくなってます-))
  * alias
  * undef
  * if/unless/while/until/rescue修飾子
  * 多重代入

* do..end の parse error
    (1..5).sort   do |a,b| b <=> a end.reverse # parse error
    (1..5).sort() do |a,b| b <=> a end.reverse # [1,2,3,4,5]

  ((-version 1.6 以降、前者でもparse errorにならないよう改善されました-))

* ハッシュ引数

    p {1=>2}    #=> parse error (ブレースがブロックと解釈される)
    p ({1=>2})  #=> {1=>2}
    p (1=>2)    #=> {1=>2} (引数がハッシュと解釈される)
    p (1=>2, 3) #=> parse error    (ブレースを省略したハッシュが引数にかけるのは最後だけ)
    p (0,1=>2)  #=> 0
                    1=>2

* 大文字で始まるメソッドの呼び出し

  大文字で始まるメソッドを :: 記法により呼び出す場合やレシーバを省略し
  て呼び出す場合、そのままでは定数と判断されるので注意が必要。()により
  メソッドコールであることを明示することで回避できる。

    obj = Object
    def obj.Foo
      p "ok"
    end
    def Bar
      p "ok"
    end

    obj.Foo     # => "ok"
    obj::Foo    # => uninitialized constant Foo::Bar (NameError)
    obj::Foo()  # => "ok"
    Bar         # => uninitialized constant Foo::Bar (NameError)
    Bar()       # => "ok"

* defined?

  defined? はメソッドではなく構文要素。なので：

    defined? obj.doit && obj.doit

  は：

    defined? (obj.doit && obj.doit)

  と等しくなる。
