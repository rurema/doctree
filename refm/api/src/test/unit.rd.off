ユニットテストを行うためのライブラリです。

[[m:URL:http:#/www.ruby-doc.org/stdlib/libdoc/test/unit/rdoc/index.html]]

== 使い方

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

次にユニットテスト(test_foo.rb)を書きます。テストを実行するメソッドの名前は
全て test_ で始まる必要があります。

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

== RubyUnit からの移行

assertion メソッドの違いは [[unknown:"ruby-src:lib/runit/assert.rb"]] を参照。
[[c:RUNIT::Assert]] も参照。

= class Test::Unit::TestCase
include Test::Unit::Assertions

テストはこのクラスのサブクラスとして定義します。

== Instance Methods

--- setup
各テストメソッドが呼ばれる前に必ず呼ばれます。

--- teardown
各テストメソッドが呼ばれた後に必ず呼ばれます。

= module Test::Unit::Assertions

Test::Unit::TestCase に include されて使われるモジュールです。assert メソッドを定義して
います。

各 assert メソッドの最後の引数 message はテストが失敗したときに表示される
メッセージです。

== Instance Methods

--- assert(boolean, message=nil)

boolean が真なら pass

--- assert_equal(expected, actual, message=nil)

expected == actual ならば pass

--- assert_not_equal(expected, actual, message="")

expected != actual ならば pass

--- assert_instance_of(klass, object, message="")

klass == object.class が真なら pass

--- assert_nil(object, message="")

object.nil? ならば pass

--- assert_not_nil(object, message="")

!object.nil? ならば pass

--- assert_kind_of(klass, object, message="")

object.kind_of?(klass) が真なら pass

--- assert_respond_to(object, method, message="")

object.respond_to?(method) が真なら pass

--- assert_match(pattern, string, message="")

string =~ pattern が真ならば pass

--- assert_no_match(regexp, string, message="")

regexp !~ string が真ならば pass

--- assert_same(expected, actual, message="")

actual.equal?(expected) が真なら pass

--- assert_not_same(expected, actual, message="")

!actual.equal?(expected) が真なら pass

--- assert_operator(object1, operator, object2, message="")

object1.send(operator, object2) が真なら pass

--- assert_raise(expected_exception_klass, message="") { ... }

ブロックを実行して例外が発生し、その例外が
expected_exception_klass クラスならば pass

--- assert_nothing_raised(*args) { ... }

ブロックを実行して例外が起きなければ pass

--- flunk(message="Flunked")

常に失敗

--- assert_throws(expected_symbol, message="") { ... }

ブロックを実行して :expected_symbol が throw されたら pass

--- assert_nothing_thrown(message="") { ... }

ブロックを実行して throw が起こらなければ pass

--- assert_in_delta(expected_float, actual_float, delta, message="")

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f 
が真なら pass

delta は正の数でなければならない。

--- assert_send(send_array, message="")

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真なら pass

--- assert_block(message="assert_block failed.") { ... }

block の結果が真なら pass

= class Test::Unit::AutoRunner

テストの実行を操作したいときにこの AutoRunner クラスを使います。
大量のテストの中から特定のテストスクリプトのみを実行したい場合、
特定のテストクラスのみを実行したい場合などに使います。
AutoRunner は Collector::Dir オブジェクトなどの Collector に
テストを集めさせて、UI::Console::TestRunner オブジェクトなどの
Runner にテストを実行させているクラスです。

#@# === 例

ディレクトリ ./somedir 以下にある全てのテストを実行したい場合は次のようなファイル(runner.rb)を用意して実行します。テストは test_*.rb というファイル名である必要があります。

#@# ruby 1.8.3 以降では AutoRunner.run の第一引数の意味が変わり、今までと真偽が逆になりました。
#@# 第一引数に true を与えると、./somedir 以下にある全てのテストを実行します。

#@#  # ruby 1.8.2 まで
#@if (version <= "1.8.2")
  require 'test/unit'
  Test::Unit::AutoRunner.run(false, './somedir')
#@end

#@#  # ruby 1.8.3 以降
#@if (version >= "1.8.3")
  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir')
#@end

単に実行します。

  $ ruby runner.rb 

ディレクトリ ./somedir 以下にあるテストをファイル somefile を除いて実行したい場合は次のように runner.rb にオプションを与えます。

  $ ruby runner.rb --exclude=somefile

同じことは、runner.rb に直接オプションを書いても実現できます。

  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--exclude=somefile'])

上のやり方では拡張子が .rb のファイルしか集めません。拡張子が .rbx のファイルも
テストとして集めたい場合は次のようにします。

  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--pattern=/test_.*\.rbx\Z/'])

== Class Methods

--- run(force_standalone = false, dir = nil, argv = ARGV)
テストを実行します。
        
#@if (version >= "1.8.3")
ruby 1.8.3 以降では force_standalone の意味が変わり、今までと真偽が逆になりました。        
force_standalone に true を与えると、dir 以下にある全てのテストを実行します。
false を与えた場合は既に読み込まれたファイルの中からテストを探して実行します。
デフォルトは false です。
#@end

#@if (version <= "1.8.2")
ruby 1.8.2 まで: force_standalone には $0 か false を与えます。
$0 を与えた場合は既に読み込まれたファイルの中からテストを探して実行します。
false を与えた場合は、dir の中からテストスクリプトを再帰的に探査して
実行します。デフォルトではファイル名が test_*.rb のテストスクリプトしか探査
しません。
false を与えた場合でも、既に読み込まれたファイルは実行するテストに含まれます。
#@end

dir には force_standalone に true を与えた時に再帰的に探査するディレクトリ名を
与えます。デフォルトではカレントディレクトリを再帰的に探査します。

argv にはオプションを配列として与えます。解釈するオプションは先に
出てきたものと同じです。

      -r, --runner=RUNNER              Use the given RUNNER.
                                       (c[onsole], f[ox], g[tk], g[tk]2, t[k])
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

force_standalone に true を与えた時には次のオプションが追加されます。

      -a, --add=TORUN                  Add TORUN to the list of things to run;
                                       can be a file or a directory.
      -p, --pattern=PATTERN            Match files to collect against PATTERN.
      -x, --exclude=PATTERN            Ignore files to collect against PATTERN.

例

      require 'test/unit'
      Test::Unit::AutoRunner.run(true, './', ['--runner=tk', '-v',
                                               '--exclude=/test_hoge.*\.rb\Z/i'])
    
argv にデフォルトのまま ARGV を渡しておけばコマンドラインからオプションを
指定できます。

      require 'test/unit'
      Test::Unit::AutoRunner.run(true, './')

と、runner.rb に書いておいて、コマンドラインから以下のように実行。
   
      $ ruby runner.rb --runner=tk -v --exclude=/test_hoge.\*\\.rb\\Z/i
