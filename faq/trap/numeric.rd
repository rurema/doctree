= Numeric

* リテラルの符号は、単項演算子 `(({-}))', `(({+}))' のメソッド呼び出しでは
  ありません。

    class Fixnum
      def -@
        "negative #{self}"
      end
    end

    p -10   # => -10

    n = 10
    p -n    # => "negative 10"

  この違いは結合強度にも影響します。

    p -10.abs   # => 10

    n = 10
    p -n.abs    # => -10

* 実際の数値クラスの親クラスに当たるNumeric や Integer のメソッドを
  alias などで定義する場合には、その元のメソッドがどのクラスで
  定義されているものか、注意する必要があります。

  例えば、Integer のクラスに to_s の alias を加えても、Fixnum や Bignum では
  意図したような動作になりません。

    class Integer
      alias_method :foo, :to_s
      alias :bar :to_s
      def baz; to_s; end
    end

    1.class  #=> Fixnum
    1.to_s   #=> "1"
    1.foo    #=> "#<Fixnum:0x3>"   ... 1.to_s ではない
    1.bar    #=> "#<Fixnum:0x3>"   ... 1.to_s ではない
    1.baz    #=> "1"

  これは、Fixnum#foo が（定義されている）Fixnum#to_s ではなく、
  （定義されていない）Integer#to_s、すなわち Object#to_s を
  呼び出しているためです。

  どのメソッドがどのクラスで定義されているかは、((<Numeric>)) に記されています。

* 整数(Integer)に対する除法(割り算) `/' は本来の値を超えない最大の整数を返し
  ます(整除)。特に、負の符合を扱う時は、取り扱いに注意が必要かも知れません。

    p( 5/2 )       # => 2
    p( 1/2 )       # => 0
    p( -1/2 )      # => -1
    p( -(1/2) )    # => 0
    p( (-1)/2 )    # => -1
    p( (-1)/(-2) ) # => 0
    p( 1/(-2) )    # => -1
    p( -(1/(-2)) ) # => 1

  整除でなく、`普通の'数字を返して欲しい時は、((<mathn>)) をrequire
  すると幸せになれるかも知れません。

