
BDD 風にテストを書くためのクラスやメソッドを定義するためのライブラリです。

このライブラリは [[c:Object]] に BDD 用の検査メソッドが追加します。
追加されるメソッドは [[c:MiniTest::Assertions]] に定義されているメソッドへの
薄いラッパーになっています。

#@# message を指定するとおかしなことになる

= reopen Module

== Public Instance Methods

--- infect_with_assertions(positive_prefix, negative_prefix, skip_regexp, map = {})
#@todo

BDD 風にテストを書くために使用するメソッド群を定義します。

@param positive_prefix assert の代わりのプレフィックスを指定します。

@param negative_prefix refute の代わりのプレフィックスを指定します。

@param skip_regexp この正規表現にマッチしたメソッドは定義しません。

@param map メソッド名の変換規則のハッシュを指定します。

= reopen Object

== Public Instance Methods

--- must_be_empty -> true
#@todo

自身が空である場合、検査にパスしたことになります。

@raise MiniTest::Assertion 自身が empty? メソッドを持たない場合に発生します。
                           また、自身が空でない場合にも発生します。

@see [[m:MiniTest::Assertions#assert_empty]]

--- must_equal(expected) -> true
#@todo

自身が比較対象のオブジェクトと等しい場合、検査にパスしたことになります。

@param expected 比較対象のオブジェクトを指定します。

@raise MiniTest::Assertion 与えられた期待値と実際の値が等しくない場合に発生します。

@see [[m:Object#==]]

--- must_be_within_delta(expected, delta = 0.001) -> true
--- must_be_close_to(expected, delta = 0.001) -> true
#@todo

自身と期待値の差の絶対値が与えられた差分以下である場合、検査にパスしたことになります。

@param expected 期待値を指定します。

@param delta 許容する差分を指定します。

@raise MiniTest::Assertion 与えられた期待値と実際の値の差の絶対値が与えられた差分を越える場合に発生します。

@see [[m:MiniTest::Assertions#assert_in_delta]]

--- must_be_within_epsilon(another, epsilon = 0.001) -> true
#@todo

#@# ???

@raise MiniTest::Assertion ???

@see [[m:MiniTest::Assertions#assert_in_epsilon]]

--- must_include(object) -> true
#@todo

自身に与えられたオブジェクトが含まれている場合、検査にパスしたことになります。

@param object 任意のオブジェクトを指定します。

@raise MiniTest::Assertion 自身が include? メソッドを持たない場合に発生します。
                           自身に与えられたオブジェクトが含まれていない場合に発生します。

@see [[m:MiniTest::Assertions#assert_includes]]

--- must_be_instance_of(klass) -> true
#@todo

自身が与えられたクラスのインスタンスである場合、検査にパスしたことになります。

@param klass 任意のクラスを指定します。



--- must_be_kind_of
#@todo

--- must_match
#@todo

--- must_be_nil
#@todo

--- must_be
#@todo

--- must_raise
#@todo

--- must_respond_to
#@todo

--- must_be_same_as
#@todo

--- must_send
#@todo

--- must_throw
#@todo

--- wont_be_empty
#@todo

--- wont_equal
#@todo

--- wont_be_within_delta
--- wont_be_close_to
#@todo


--- wont_be_within_epsilon
#@todo

--- wont_include
#@todo

--- wont_be_instance_of
#@todo

--- wont_be_kind_of
#@todo

--- wont_match
#@todo

--- wont_be_nil
#@todo

--- wont_be
#@todo

--- wont_respond_to
#@todo

--- wont_be_same_as
#@todo


= reopen Kernel

== Private Instance Methods

--- describe(desc){ ... }

与えられた説明文から名前を作成してテストクラスを定義します。

クラスの定義は、与えられたブロックの内容になります。

@param desc ブロックに対する説明を指定します。

= class MiniTest::Unit::TestCase
= class MiniTest::Spec < MiniTest::Unit::TestCase

BDD 風にテストを書くための [[c:MiniTest::Unit::TestCase]] に対するラッパークラスです。

== Singleton Methods

--- new(name)

与えられた名前で自身を初期化します。

--- current -> MiniTest::Spec
#@todo

現在実行中の [[c:MiniTest::Spec]] のインスタンスを返します。

--- before(type = :each){ ... }
#@todo

各テストの前にに実行するブロックを登録します。


--- after(type = :each){ ... }
#@todo

各テストの後に実行するブロックを登録します。

--- it(desc){ ... }
#@todo

テストケースを一つ定義します。

与えられたブロックが一つのテストケースに相当します。
