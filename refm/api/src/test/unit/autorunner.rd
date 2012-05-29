require test/unit
require test/unit/ui/testrunnerutilities

ユニットテストの実行を操作したいときに使います。

#@since 1.8.1
= class Test::Unit::AutoRunner

テストの実行を操作したいときにこの AutoRunner クラスを使います。
大量のテストの中から特定のテストスクリプトのみを実行したい場合、
特定のテストクラスのみを実行したい場合などに使います。
AutoRunner は Collector::Dir オブジェクトなどの Collector に
テストを集めさせて、UI::Console::TestRunner オブジェクトなどの
Runner にテストを実行させているクラスです。

=== 例

ディレクトリ ./somedir 以下にある全てのテストを実行したい場合は次のよう
なファイル(runner.rb)を用意して実行します。テストは test_*.rb というファ
イル名である必要があります。

#@since 1.8.3
第一引数に true を与えると、./somedir 以下にある全てのテストを実行します。
  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir')
#@else
第一引数に false を与えると、./somedir 以下にある全てのテストを実行します。
  require 'test/unit'
  Test::Unit::AutoRunner.run(false, './somedir')
#@end

単に実行します。

  $ ruby runner.rb

ディレクトリ ./somedir 以下にあるテストをファイル somefile を除いて実行
したい場合は次のように runner.rb にオプションを与えます。

  $ ruby runner.rb --exclude=somefile

同じことは、runner.rb に直接オプションを書いても実現できます。

#@since 1.8.3
  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--exclude=somefile'])
#@else
  require 'test/unit'
  Test::Unit::AutoRunner.run(false, './somedir', ['--exclude=somefile'])
#@end

上のやり方では拡張子が .rb のファイルしか集めません。拡張子が .rbx のファイルも
テストとして集めたい場合は次のようにします。

#@since 1.8.3
  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--pattern=/test_.*\.rbx\Z/'])
#@else
  require 'test/unit'
  Test::Unit::AutoRunner.run(false, './somedir', ['--pattern=/test_.*\.rbx\Z/'])
#@end

== Class Methods

#@since 1.8.3
--- run(force_standalone = false, dir = '.', argv = ARGV)    -> bool
#@else
--- run(force_standalone = nil, dir = '.', argv = ARGV)    -> bool
#@end

テストを実行します。全てのテストが成功した場合、true を返します。そうでない場合は、
false を返します。

#@since 1.8.3
@param force_standalone true を与えると、dir 以下にある全てのテストを実
                        行します。false を与えた場合は既に読み込まれた
                        ファイルの中からテストを探して実行します。テス
                        トが読み込まれておらず、スクリプトを -e から実
                        行している場合は、dir 以下にある全てのテストを
                        実行します。デフォルトは false です。

@param dir force_standalone に true を与えた時に再帰的に探査するディレクトリ名を
           与えます。デフォルトではカレントディレクトリを再帰的に探査します。
#@else
@param force_standalone $0 か false を与えます。$0 を与えた場合は既に読
                        み込まれたファイルの中からテストを探して実行し
                        ます。false を与えた場合は、dir の中からテスト
                        スクリプトを再帰的に探査して実行します。デフォ
                        ルトではファイル名が test_*.rb のテストスクリプ
                        トしか探査しません。false を与えた場合でも、既
                        に読み込まれたファイルは実行するテストに含まれ
                        ます。

@param dir force_standalone に false を与えた時に再帰的に探査するディレクトリ名を
           与えます。デフォルトではカレントディレクトリを再帰的に探査します。
#@end

@param argv オプションを配列として与えます。解釈するオプションは先に
            出てきたものと同じです。

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
#@since 1.8.2
force_standalone に false を与えた時には次のオプションが追加されます。
#@else
force_standalone に true を与えた時には次のオプションが追加されます。
#@end
      -a, --add=TORUN                  Add TORUN to the list of things to run;
                                       can be a file or a directory.
      -p, --pattern=PATTERN            Match files to collect against PATTERN.
#@since 1.8.2
      -x, --exclude=PATTERN            Ignore files to collect against PATTERN.
#@end

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

#@end
