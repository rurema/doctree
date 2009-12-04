require test/unit/testcase
#@until 1.9.1
require test/unit/autorunner
#@end

ユニットテストを行うためのライブラリです。

#@#[[url:http://www.ruby-doc.org/stdlib/libdoc/test/unit/rdoc/index.html]]

#@since 1.9.1
test/unit は [[lib:minitest/unit]] を使って再実装されましたが、完全な互
換性がある訳ではありません。
#@end

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

#@since 1.9.1

        $ ruby test_foo.rb

        Loaded suite test_foo
        Started
        F.
        Finished in 0.022223 seconds.

          1) Failure:
        test_bar(TC_Foo) [test_foo.rb:16]:
        <"bar"> expected but was
        <"foo">.

        2 tests, 2 assertions, 1 failures, 0 errors, 0 skips

test_bar だけテストしたい場合は以下のようなオプションを与えます。

        $ ruby test_foo.rb --name test_bar

        Loaded suite test_foo
        Started
        F
        Finished in 0.019573 seconds.

          1) Failure:
        test_bar(TC_Foo) [test_foo.rb:16]:
        <"bar"> expected but was
        <"foo">.

        1 tests, 1 assertions, 1 failures, 0 errors, 0 skips

--name=test_barのような指定は行えません。その他の使用可能なオプションにつ
いては、[[lib:minitest/unit]]と同様です。

#@else

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

#@end

複数のテストを一度に行う場合、以下のように書いただけのファイルを実行します。

 require 'test/unit'
 require 'test_foo.rb'
 require 'test_bar.rb'

#@until 1.9.1
もう少し高度なテストの実行方法に関しては [[c:Test::Unit::AutoRunner]] を
参照して下さい。
#@end

=== いつテストは実行されるか

上の例では、テストクラスを「定義しただけ」で、テストが実行されています。
#@since 1.9.1
これは、require 'test/unit'した時に[[m:MiniTest::Unit.autorun]]を実行し
ているためです。その結果、終了時の後処理として実行されるようになってい
ます。
#@else
これは、[[m:Kernel.#at_exit]] と [[m:ObjectSpace.#each_object]] を使って
実装されています。つまり、上の例ではテストは終了時の後処理として実行されます。

大抵の場合は、これで問題ありません。が、そうでない場合は、
testrb コマンドや [[c:Test::Unit::AutoRunner]] 、各種 TestRunner クラスを使うことにより、
明示的にテストを実行することができます。
#@end

=== Error と Failure の違い

: Error
  テストメソッド実行中に例外が発生した。

: Failure
  アサーションに失敗した。

#@until 1.9.1
=== RubyUnit からの移行

assertion メソッドの違いは [[unknown:"ruby-src:lib/runit/assert.rb"]] を参照。
[[c:RUNIT::Assert]] も参照。
#@end

= module Test::Unit

ユニットテストを行うためのモジュールです。

== Singleton Methods

#@since 1.8.1
#@until 1.9.1
--- run?        -> bool

ユニットテストを実行したかどうかを返します。
戻り値が false だった場合は、まだユニットテストを実行していない事になります。

@return ユニットテストを実行したかどうか

--- run=(flag)  

ユニットテストを自動実行したかどうかを指定します。

@param flag ユニットテストを自動実行したかどうか

trueをセットすると[[c:Test::Unit]]はユニットテストを自動実行``しなくなります''。
runは過去分詞のrunです。trueにするとテストを実行し終えたという意味になります。

#@end
#@end

#@since 1.9.1
--- setup_argv(original_argv = ARGV) { |files| ... } -> [String]

original_argvで指定されたオプションを解析して、テスト対象になるファイル
をrequireします。

@param original_argv オプションを指定します。省略された場合は、
                     [[m:Kernel::ARGV]]が使用されます。

@raise ArgumentError 指定されたファイルが存在しない場合に発生します。

ブロックが指定された場合にはブロックを評価して、その結果をrequireの対象
にします。

ブロックパラメータには上記のoriginal_argvから-xで指定されたもの以外のオ
プションが配列で渡されます。ファイル名の代わりにディレクトリを指定する
と、ディレクトリの中にあるtest_*.rbを全てrequireします。

このメソッド自体は、オプションを解析してrequireを行う以外の処理は行いま
せんが、test/unit.rbをrequireして呼び出すメソッドのため、結果的にユニッ
トテストが実行されます。testrbコマンドのように、ユニットテストを実行す
るプログラムを作成する場合に使用します。

===== 使用可能なオプション

: -v
  詳細を表示します。

: -n, --name
  指定されたテストメソッドを実行します。テストメソッドの指定に正規表現
  も使えます。--name=test_fooのような指定は行えません。--name test_foo
  のように指定してください。

: -x
  指定されたファイルを除外します。ファイルの指定に正規表現も使えます。

===== 注意

Test::Unit.setup_argvはoriginal_argvの指定に関わらず、ARGVをfilesで置き
換えます。置き換えられたARGVは[[lib:minitest/unit]]によってもう1度解析されます。

#@end
