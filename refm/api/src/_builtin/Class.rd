= class Class < Module

クラスのクラス。より正確に言えば、個々のクラスはそれぞれメタクラスと呼
ばれる名前のないクラスをクラスとして持っていて、Class はそのメタ
クラスのクラスです。この関係は少し複雑ですが、Ruby を利用するにあたっ
ては特に重要ではありません。

クラスは、モジュールとは

  * インスタンスを作成できる
  * [[m:Module#include]] による Mix-in ができない

という違いがありますが、それ以外のほとんどの機能は [[c:Module]] から継
承されています。Module のメソッドのうち

  * [[m:Module#module_function]]
  * [[m:Module#extend_object]]
  * [[m:Module#append_features]]

は Class では未定義にされています。

== Class Methods

--- new([superclass])
#@if (version >= "1.7.0")
--- new([superclass]) {|klass| ... }
#@end

新しく名前の付いていない superclass のサブクラスを生成します。
superclass が省略された時にはObject のサブクラスを生成
します。

名前のないクラスは、最初に名前を求める際に代入されている定数名を検
索し、見つかった定数名をクラス名とします。

例:

  p foo = Class.new   # => #<Class:0x401b90f8>
  p foo.name          # => ""
  Foo = foo           # ここで p foo すれば "Foo" 固定
  Bar = foo
  p foo.name          # => "Bar"  ("Foo" になるか "Bar" になるかは不定)

#@if (version >= "1.7.0")
ブロックが与えられると生成したクラスをブロックの引数に渡し、クラス
のコンテキストでブロックを実行します。この場合も生成したクラスを返
します。

  klass = Class.new(super)
  klass.module_eval {|m| ... }
  klass

と同じです。ブロックの実行は Module#initialize が行います。
#@end

== Instance Methods

#@if (version >= "1.7.0")
--- allocate

クラスのインスタンスを生成して返します。生成したオブジェクトは
(通常)クラスのインスタンスであること以外には何も特性を持ちません。
#@end

--- new( ... )

クラスのインスタンスを生成して返します。このメソッドの引数はブロック引数も
含め [[m:Object#initialize]] に渡されます。

#@if (version >= "1.7.0")
version 1.7 では、new は、allocate でイン
スタンスを生成し、initialize で初期化を行うメソッドです。
#@end

--- superclass

クラスのスーパークラスを返します。

== Private Instance Methods

--- inherited(subclass)

クラスのサブクラスが定義された時、新しく生成されたサブクラスを引数
にインタプリタから呼び出されます。このメソッドが呼ばれるタイミングは
クラス定義文の実行直前です。

例:

  class Foo
    def Foo.inherited(subclass)
      puts "class \"#{self}\" was inherited by \"#{subclass}\""
    end
  end
  class Bar < Foo
    puts "executing class body"
  end
  
  # => class "Foo" was inherited by "Bar"
       executing class body
