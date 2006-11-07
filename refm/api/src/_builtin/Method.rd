= class Method < Object

[[m:Object#method]] によりオブジェクト化され
たメソッドオブジェクトのクラスです。メソッドの実体（名前でなく）とレシー
バの組を封入します。[[c:Proc]] オブジェクトと違ってコンテキストを保持
しません。

[[c:Proc]] との差…Method は取り出しの対象であるメソッドが
なければ作れませんが、Proc は準備なしに作れます。その点から
Proc は使い捨てに向き、Method は何度も繰り返し生成する
場合に向くと言えます。また内包するコードの大きさという点では
Proc は小規模、Method は大規模コードに向くと言えます。


例:

既存のメソッドを Method オブジェクト化する
([[m:Object#method]] を参照)

  class Foo
    def foo(arg)
      "foo called with arg #{arg}"
    end
  end

  m = Foo.new.method(:foo)

  p m             # => #<Method: Foo#foo>
  p m.call(1)     # => "foo called with arg 1"

名前のないメソッド(の代わり)が必要なら [[c:Proc]] を使うと良い

  pr = Proc.new {|arg|
    "proc called with arg #{arg}"
  }

  p pr            # => #<Proc:0x401b1fcc>
  p pr.call(1)    # => "proc called with arg 1"

Method オブジェクトが有用なのは以下のような場合

  class Foo
    def foo() "foo" end
    def bar() "bar" end
    def baz() "baz" end
  end

  obj = Foo.new

  # 任意のキーとメソッドの関係をハッシュに保持しておく
  methods = {1 => obj.method(:foo),
             2 => obj.method(:bar),
             3 => obj.method(:baz)}

  # キーを使って関連するメソッドを呼び出す
  p methods[1].call       # => "foo"
  p methods[2].call       # => "bar"
  p methods[3].call       # => "baz"

が、レシーバを固定させる(Method オブジェクトはレシーバを保持する)必
要がないなら [[m:Object#send]]を使う方法も有用。

  class Foo
    def foo() "foo" end
    def bar() "bar" end
    def baz() "baz" end
  end

  # 任意のキーとメソッド(の名前)の関係をハッシュに保持しておく
  # レシーバの情報がここにはないことに注意
  methods = {1 => :foo,
             2 => :bar,
             3 => :baz}

  # キーを使って関連するメソッドを呼び出す
  # レシーバは任意(Foo クラスのインスタンスである必要もない)
  p Foo.new.send(methods[1])      # => "foo"
  p Foo.new.send(methods[2])      # => "bar"
  p Foo.new.send(methods[3])      # => "baz"

== Instance Methods

--- [](arg, ...)
--- call(arg ... )
--- call(arg ... ) { ... }

メソッドオブジェクトに封入されているメソッドを起動します。
引数やブロックはそのままメソッドに渡されます。

self[] の形の呼び出しは通常のメソッド呼び出しに見た目を
近付けるためだけに用意されたもので、Array#[]のような
他の [] メソッドとの意味的な関連性はありません。

メソッドオブジェクトが汚染されている場合、そのメソッドは、セーフレ
ベル 4 で実行されます
([[unknown:セキュリティモデル/セーフレベルに関するその他の詳細]]を参照)。

--- arity

メソッドオブジェクトの引数の数を返します。self が引数の数を
可変長で受け取れる場合

-(最低限必要な数 + 1)

を返します。

--- inspect

[[m:Object#inspect]] 参照。以下の形式の文字列を返し
ます。

  #<Method: klass1(klass2)#method>                (形式1)

klass1 は、[[m::Method#inspect]] では、レシーバのクラス名、
[[m:UnboundMethod#inspect]] では、[[c:UnboundMethod]] オブジェクトの生成
元となったクラス／モジュール名です。

klass2 は、実際にそのメソッドを定義しているクラス／モジュール名、
method は、メソッド名を表します。

  module Foo
    def foo
      "foo"
    end
  end
  class Bar
    include Foo
    def bar
    end
  end

  p Bar.new.method(:foo)        # => #<Method: Bar(Foo)#foo>
  p Bar.new.method(:bar)        # => #<Method: Bar(Bar)#bar>

#@since 1.8.0
klass1 と klass2 が同じ場合は以下の形式になります。
  #<Method: klass1#method>                        (形式2)

特異メソッドに対しては、
  #<Method: obj.method>                           (形式3)
  #<Method: klass1(klass2).method>                (形式4)
という形式の文字列を返します。二番目の形式では klass1 はレシーバ、
klass2 は実際にそのメソッドを定義しているオブジェクトになります。

  # オブジェクトの特異メソッド
  obj = ""
  class <<obj
    def foo
    end
  end
  p obj.method(:foo)      # => #<Method: "".foo>

  # クラスメソッド(クラスの特異メソッド)
  class Foo
    def Foo.foo
    end
  end
  p Foo.method(:foo)      # => #<Method: Foo.foo>

  # スーパークラスのクラスメソッド
  class Bar < Foo
  end
  p Bar.method(:foo)      # => #<Method: Bar(Foo).foo>

  # 以下は(形式1)の出力になる
  module Baz
    def baz
    end
  end

  class <<obj
    include Baz
  end
  p obj.method(:baz)      # => #<Method: Object(Baz)#baz>
#@end

--- to_proc

    self を call する [[c:Proc]] オブジェクトを生成して返
    します。

--- unbind

    self のレシーバとの関連を取り除いた [[c:UnboundMethod]] オブ
    ジェクトを生成して返します。
