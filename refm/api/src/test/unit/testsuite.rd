
= class Test::Unit::TestSuite < Object

複数のテストをひとつにまとめたクラスです。TestSuite 同士をまとめてひとつの
TestSuite にすることもできます。
[[m:Test::Unit::TestSuite#run]] によりまとめたテストを一度に
実行することができます。

== Class Methods

--- new(name = "Unnamed TestSuite")

TestSuite のインスタンスを生成して返します。

@param name TestSuite の名前です。文字列で与えます。

== Instance Methods

--- <<(test)

テストを加えます。self を返します。

@param test TestCase か TestSuite のインスタンスを与えます。

#@since 1.8.1
--- ==(other)
#@todo

It's handy to be able to compare TestSuite instances.

--- delete(test)

testと等しいもの全てを自身から削除します。test と等しい要素が見つかった場合は、testを返します。
test と等しいものがなければ nil を返します

@param test  TestCase か TestSuite のインスタンスを与えます。

#@end

--- empty?
実行すべきテストが空なら true を返します。そうでないなら false を返します。


--- run(result) 
--- run(result) {|STARTED, name| ...}
#@todo

テストを実行します。TestSuite に最初に加えられたテストから順に実行されます。
自身が TestSuite を含んでいる場合は、再帰的にテストを実行します。

--- size

実行するテストの総数を返します。
もし自身が他の TestSuite を含んでいる場合は、その TestSuite が
持っているテストを再帰的に合計した数を返します。

--- to_s
#@todo

Overridden to return the name given the suite at creation.

--- name
#@todo

--- tests
#@todo
