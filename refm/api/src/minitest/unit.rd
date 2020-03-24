category Development

sublibrary minitest/autorun

ユニットテストを行うためのライブラリです。

#@since 2.2.0
このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

  * rubygems.org: [[url:https://rubygems.org/gems/minitest]]
  * プロジェクトページ: [[url:https://github.com/seattlerb/minitest]]
  * リファレンス: [[url:https://www.rubydoc.info/gems/minitest]]

#@else
=== 使い方

[[lib:minitest/unit]] は以下のように使います。

テスト対象のソース (foo.rb) を用意します。

  class Foo
    def foo
      "foo"
    end
    def bar
      "foo"
    end
  end

次にユニットテスト (test_foo.rb) を書きます。
テストを実行するメソッド (テストメソッド) の名前はすべて "test" で始まる必要があります。
テストメソッドが実行される前には setup メソッドが必ず実行されます。
テストメソッドが実行された後には teardown メソッドが必ず実行されます。

[[lib:minitest/unit]] を [[m:Kernel.#require]] しただけではテストが自動実行されません。

  require 'minitest/unit'
  require 'foo'
  
  MiniTest::Unit.autorun
  
  class TestFoo < MiniTest::Unit::TestCase
    def setup
      @foo = Foo.new
    end
    # teardown はあまり使わない
    def teardown
      @foo = nil
    end
  
    def test_foo
      assert_equal "foo", @foo.foo
    end
  
    def test_bar
      assert_equal "bar", @foo.bar
    end
  end

または MiniTest::Unit.autorun を省略して以下のように書くこともできます。

  require 'minitest/unit'
  require 'minitest/autorun'
  require 'foo'
  # 以下略

テストを実行するには上で用意した test_foo.rb を実行します。
デフォルトではすべてのテストが実行されます。

  $ ruby test_foo.rb
  Loaded suite test_foo
  Started
  F.
  Finished in 0.000940 seconds.
  
    1) Failure:
  test_bar(TestFoo) [test_foo.rb:20]:
  Expected "bar", not "foo".
  
  2 tests, 2 assertions, 1 failures, 0 errors, 0 skips

test_bar だけテストしたい場合は以下のようなオプションを与えます。

  $ ruby test_foo.rb -n test_bar
  Loaded suite test_foo
  Started
  F
  Finished in 0.000820 seconds.
  
    1) Failure:
  test_bar(TestFoo) [test_foo.rb:20]:
  Expected "bar", not "foo".
  
  1 tests, 1 assertions, 1 failures, 0 errors, 0 skips

コンソールを使った testrunner のみ提供されています。
またヘルプを表示することもできません。

=== 使用可能なオプション

: -v
  詳細を表示します。
: -n, --name
  指定されたテストメソッドを実行します。テストメソッドの指定に正規表現も使えます。

=== いつテストは実行されるか

上述のとおり、MiniTest::Unit.autorun や require 'minitest/autorun' をテストコードに
明示的に書かなかった場合は、単にそのテストファイルを実行しても何も起こりません。

=== Error と Failure と Skip の違い

: Error
  テストメソッド実行中に例外が発生した。
: Failure
  アサーションに失敗した。
: Skip
  テストメソッド内で [[m:MiniTest::Assertions#skip]] を呼び出した。

=== test/unit からの移行

細かい違いはいくつかありますが、移行のためにしなければならないことは特にありません。
require 'test/unit' している場合は互換レイヤーが読み込まれ以前の [[lib:test/unit]]
との互換性が確保されます。

そうではなくて require 'minitest/unit' する場合は、テストクラスの定義時に親クラスを
[[c:MiniTest::Unit::TestCase]] にしなければなりません。

=== 注意

このライブラリは 2.2.0 で bundled gem(gemファイルのみを同梱)になりました。

= module MiniTest

[[lib:minitest/unit]] で使用するクラスやモジュールを定義しているモジュールです。

== Singleton Methods

--- filter_backtrace(backtrace) -> Array

バックトレースからこのライブラリに関する部分を取り除いた結果を返します。

@param backtrace バックトレースを指定します。

== Constants

--- MINI_DIR -> String

このライブラリがインストールされているディレクトリの親ディレクトリの名前を返します。

= class MiniTest::Assertion < Exception

アサーションに失敗した時に発生する例外です。

= class MiniTest::Skip < MiniTest::Assertion

[[m:MiniTest::Assertions#skip]] を呼び出した時に発生する例外です。


#@include(MiniTest__Unit)
#@include(MiniTest__Unit__TestCase)
#@include(MiniTest__Assertions)
#@end
