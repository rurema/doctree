= 引数

* メソッド呼び出しで 配列を展開した変数列を渡す

    def sum(a,b,c)
      print a+b+c,"\n"
    end

    a = [1,2,3]
    sum(*a) # -> sum(1,2,3) -> 6

* 同様にProcをブロックとして渡せる。

    def foo
      yield(2)
    end

    pr = proc {|i| i*i}
    foo(&pr) #=> 4


* 逆に仮引数でまとめて受け取ったりProcとして受け取ったりできる。

    def foo(*arg, &block)
      block.call arg[1]
    end

    foo(0,1,2) do |i|
      puts i #=> 1
    end

    def test(*a)
      @b = [a]  #正しくは、@b = a
    end

    def a = (b)  #正しくは、a=(b)
      @a = b
    end

* superとsuper(...)の違い。
    class Foo
      def initialize
      end
    end

    class Bar < Foo
      def initialize(a)
        super
      end
    end

    obj = Bar.new(1)

    => -:8:in `initialize': wrong # of arguments(1 for 0) (ArgumentError)

  上のはバグります。引数なしの super は上の例では super(a) と見なされ
  るからです。呼び出したメソッドと異なる引数で呼び出すには引数を明示し
  ます。

    class Foo
      def initialize
      end
    end

    class Bar < Foo
      def initialize(a)
        super()    # <- 0個 の引数であることを明示している
      end
    end

    obj = Bar.new(1)

* たまたま同じ signature のメソッドをもってると、オブジェクトのクラス違いに気がつかず、
  後々とんでもないところで例外が起こる場合があります。
  (例:PStore#abortとabort)

* ARGVで引数を受け取った後、getsなどで標準入力を使う場合、ARGV.shiftなどで
  ARGVを空にしておかないとARGVに残っているファイル名のファイルから読み込もうと
  してしまいます。
