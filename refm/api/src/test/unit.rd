category Development

#@until 2.2.0
require test/unit/testcase
#@end

ユニットテストを行うためのライブラリです。

このライブラリは 2.2.0 からbundled gem(gemファイルのみを同梱)になりまし
た。詳しい内容は下記のプロジェクトページを参照してください。

  * Test::Unit - Ruby用単体テストフレームワーク: [[url:http://test-unit.github.io/]]

なお、2.2.0以前のtest/unit は [[lib:minitest/unit]] を使って再実装され
ていましたが、上記のtest/unitと完全な互換性がある訳ではありません。

#@until 2.2.0
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

--name=test_barのような指定は行えません。

以下のようにすると help も表示されます。

  $ ruby test_foo.rb --help
  Usage: test_foo [options]
  minitest options:
      -h, --help                       Display this help.
      -s, --seed SEED                  Sets random seed
      -v, --verbose                    Verbose. Show progress processing files.
      -n, --name PATTERN               Filter test names on pattern.
          --jobs-status [TYPE]         Show status of jobs every file; Disabled when --jobs isn't specified.
      -j, --jobs N                     Allow run tests with N jobs at once
          --no-retry                   Don't retry running testcase when --jobs specified
          --ruby VAL                   Path to ruby; It'll have used at -j option
      -q, --hide-skip                  Hide skipped tests
      -b, --basedir=DIR                Base directory of test suites.
      -x, --exclude PATTERN            Exclude test files on pattern.
      -Idirectory                      Add library load path
          --[no-]gc-stress             Set GC.stress as true

複数のテストを一度に行う場合、以下のように書いただけのファイルを実行します。

 require 'test/unit'
 require 'test_foo.rb'
 require 'test_bar.rb'

=== いつテストは実行されるか

上の例では、テストクラスを「定義しただけ」で、テストが実行されています。
これは、require 'test/unit'した時に[[m:MiniTest::Unit.autorun]]を実行し
ているためです。その結果、終了時の後処理として実行されるようになってい
ます。

=== Error と Failure の違い

: Error
  テストメソッド実行中に例外が発生した。

: Failure
  アサーションに失敗した。

=== 並列実行

1.9.3 から単体テストの高速化のために、並列実行がサポートされました。

並列化の仕組みについては以下の記事をご覧ください。

 * Rubyist Magazine 0033 号 詳解! test-all 並列化: [[url:http://magazine.rubyist.net/?0033-ParallelizeTestAll]]

= module Test::Unit

ユニットテストを行うためのモジュールです。

== Singleton Methods

--- setup_argv(original_argv = ARGV) { |files| ... } -> [String]

original_argvで指定されたオプションを解析して、テスト対象になるファイル
をrequireします。

@param original_argv オプションを指定します。省略された場合は、
                     [[m:Object::ARGV]]が使用されます。

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
  も使えます。なお、--name=test_fooのような指定は行えません。--name test_foo
  のように指定してください。

: -x
  指定されたファイルを除外します。ファイルの指定に正規表現も使えます。

: -s, --seed
  [[m:Kernel.#rand]] の乱数の種を指定した値に設定します。

: --jobs-status

  テストするファイルの状態を表示します。--jobs が指定されなかった場合は有効になりません。

: -j, --jobs

  並列実行する数を指定します。

: --no-retry

  --jobs オプションも指定された場合に、リトライ機能を無効化します。

: --ruby

  ruby コマンドのパスを指定します。省略した場合は、[[m:RbConfig.ruby]] の値を使用します。

: -q, --hide-skip

  スキップしたテストを表示しません。

: -I

  ライブラリのロードパスに指定した値を追加します。

: --gc-stress

  [[m:GC.stress]] に true を設定します。

: --no-gc-stress

  [[m:GC.stress]] に false を設定します。

===== 注意

Test::Unit.setup_argvはoriginal_argvの指定に関わらず、ARGVをfilesで置き
換えます。置き換えられたARGVは[[lib:minitest/unit]]によってもう1度解析されます。

#@end
