= スコープ、制御構造

* ローカル変数と等号付きメソッド

  レシーバを省略するとメソッドではなくローカル変数として扱われます。
  普通のメソッドはselfのレシーバを省略できますが、この場合は不可。

    class Foo
       def bar=(v)
       end
       def baz
          bar = 0           # ローカル変数 bar への代入
          self.bar = 0      # メソッド bar= の呼び出し
       end
    end

* 制御構造(ifやwhileなど)はスコープを作らない。

  while や for がスコープを作らないのに対し、loop や each などのイテレー
  タはスコープを作ります。

    while true
      var = true
      break
    end
    p var
    # => true

    loop {
      var = true        # このブロックの中でローカル
      break
    }
    p var
    # => -:5: undefined local variable or method `var' for #<Object:0x401a7b28> (NameError)

    for i in 1..3
      var = true
    end
    p var
    # => true

    (1..3).each {
      var = true        # このブロックの中でローカル
    }
    p var
    # => -:4: undefined local variable or method `var' for #<Object:0x401a7b28> (NameError)

* 多重ループを抜ける

  重複したループを抜けるには、(({break})) ではなく (({catch}))/(({throw}))
  を使用します。

    catch(:last) {
      while true
        (1..5).each{|x|
          throw :last if x == 3
          print "#{x}\n"
        }
      end
    }

* ローカル変数は本当にローカル。Perl の my とかとは違う

    # Ruby
    local = "hoge"
    def hoge
      print local, "\n" # 未定義。エラー
    end
    hoge

    # Perl
    my $local = "hoge";
    sub hoge {
        print $local, "\n"; #=> hoge
    }
    hoge;

* 組み込み関数

  loadのように組み込み関数と同じ名前のメソッドを定義しているクラスで、
  組み込み関数のloadを呼び出すにはKernel.をつけます。

    class Hoge
      def call_load
        load "nosuchfile.rb"
        self.load "nosuchfile.rb"
        Kernel.load "nosuchfile.rb"
      end

      def load(arg)
        puts "Hoge#load #{arg}"
      end
    end

    Hoge.new.call_load
    # => Hoge#load nosuchfile.rb
    #    Hoge#load nosuchfile.rb
    #    LoadError: No such file to load -- nosuchfile.rb

* ブロックの引数のスコープ
    a = [1,2,3]
    a.sort{|a,b| b<=>a}         # a に代入される
    p a.class #=> Fixnum         # 最後に代入された a
