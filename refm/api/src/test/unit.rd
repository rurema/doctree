require test/unit/testcase
require test/unit/autorunner

ユニットテストを行うためのライブラリです。

#@#[[url:http://www.ruby-doc.org/stdlib/libdoc/test/unit/rdoc/index.html]]

=== 使い方

Test::Unit は以下のように使います。

まずテスト対象のソース(foo.rb)が必要です。

    class Foo
       def foo
         "foo"
       end
       def bar
         "foo"
       end
    end

次にユニットテスト(test_foo.rb)を書きます。テストを実行するメソッド(テストメソッド)の名前は
全て test_ で始まる必要があります。テストメソッドが実行される前には setup メソッドが必ず
呼ばれます。実行されたあとには、teardown メソッドが必ず呼ばれます。

    require 'test/unit'
    require 'foo'

    class TC_Foo < Test::Unit::TestCase
      def setup
        @obj = Foo.new
      end

      # def teardown
      # end

      def test_foo
        assert_equal("foo", @obj.foo)
      end
      def test_bar
        assert_equal("bar", @obj.bar)
      end
    end

テストを実行するには上で用意した test_foo.rb を実行します。
デフォルトではすべてのテストが実行されます。

        $ ruby test_foo.rb

        Loaded suite test_foo
        Started
        F.
        Finished in 0.022223 seconds.

          1) Failure!!!
        test_bar(TC_Foo) [test_foo.rb:16]:
        <bar> expected but was
        <foo>

        2 tests, 2 assertions, 1 failures, 0 errors

test_bar だけテストしたい場合は以下のようなオプションを与えます。

        $ ruby test_foo.rb --name=test_bar

        Loaded suite test_foo
        Started
        F
        Finished in 0.019573 seconds.

          1) Failure!!!
        test_bar(TC_Foo) [test_foo.rb:16]:
        <bar> expected but was
        <foo>

        1 tests, 1 assertions, 1 failures, 0 errors

gtk を使った testrunner

        $ ruby test_foo.rb --runner=gtk --name=test_bar

fox を使う

        $ ruby test_foo.rb --runner=fox --name=test_bar

console を使う (default)

        $ ruby test_foo.rb --runner=console --name=test_bar

以下のようにすると help も表示されます。

  $ ruby test_foo.rb --help

     Usage: test_foo.rb [options] [-- untouched arguments]
     
         -r, --runner=RUNNER              Use the given RUNNER.
                                          (c[onsole], f[ox], g[tk], g[tk]2, t[k])
#@since 1.8.6
         -b, --basedir=DIR                Base directory of test suites.
         -w, --workdir=DIR                Working directory to run tests.
#@end
         -n, --name=NAME                  Runs tests matching NAME.
                                          (patterns may be used).
         -t, --testcase=TESTCASE          Runs tests in TestCases matching TESTCASE.
                                          (patterns may be used).
         -v, --verbose=[LEVEL]            Set the output level (default is verbose).
                                          (s[ilent], p[rogress], n[ormal], v[erbose])
             --                           Stop processing options so that the
                                          remaining options will be passed to the
                                          test.
         -h, --help                       Display this help.

複数のテストを一度に行う場合、以下のように書いただけのファイルを実行します。

 require 'test/unit'
 require 'test_foo.rb'
 require 'test_bar.rb'

もう少し高度なテストの実行方法に関しては [[c:Test::Unit::AutoRunner]] を
参照して下さい。

=== いつテストは実行されるか

上の例では、テストクラスを「定義しただけ」で、テストが実行されています。
これは、[[m:Kernel.#at_exit]] と [[m:ObjectSpace.#each_object]] を使って
実装されています。つまり、上の例ではテストは終了時の後処理として実行されます。

大抵の場合は、これで問題ありません。が、そうでない場合は、
testrb コマンドや [[c:Test::Unit::AutoRunner]] 、各種 TestRunner クラスを使うことにより、
明示的にテストを実行することができます。

=== Error と Failure の違い

テストメソッド実行中に例外が発生したなら Error です。例外が発生せず assert に
失敗しただけなら Failure です。

=== RubyUnit からの移行

assertion メソッドの違いは [[unknown:"ruby-src:lib/runit/assert.rb"]] を参照。
[[c:RUNIT::Assert]] も参照。

= module Test::Unit

== Singleton Methods

#@since 1.8.1
--- run?        -> bool
--- run=(flag)  
#@todo

#@#単なるバグかも知れない。
trueをセットすると[[c:Test::Unit]]はユニットテストを自動実行``しなくなります''。
runは過去分詞のrunです。trueにするとテストを実行し終えたという意味になります。

#@end

