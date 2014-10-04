category Development

BDD 風にテストを書くためのクラスやメソッドを定義するためのライブラリです。

このライブラリは [[c:Object]] に BDD (Behavior Driven Development) 用の検査メソッドを追加します。
追加されるメソッドは [[c:MiniTest::Assertions]] に定義されているメソッドへの
薄いラッパーになっています。

#@# message を指定するとおかしなことになる

=== 注意

このライブラリは 2.2.0 で削除されました。2.2.0 以降では以下を RubyGems
でインストールして利用してください。.gem ファイルはソースコードにも同梱
されています。

  * [[url:https://rubygems.org/gems/minitest]]

= reopen Module

== Public Instance Methods

--- infect_with_assertions(positive_prefix, negative_prefix, skip_regexp, map = {}) -> ()

BDD 風にテストを書くために使用するメソッド群を定義します。

@param positive_prefix assert の代わりのプレフィックスを指定します。

@param negative_prefix refute の代わりのプレフィックスを指定します。

@param skip_regexp この正規表現にマッチしたメソッドは定義しません。

@param map メソッド名の変換規則のハッシュを指定します。

= reopen Object

== Public Instance Methods

--- must_be_empty -> true

自身が空である場合、検査にパスしたことになります。

@raise MiniTest::Assertion 自身が empty? メソッドを持たない場合に発生します。
                           また、自身が空でない場合にも発生します。

@see [[m:MiniTest::Assertions#assert_empty]]

--- must_equal(expected) -> true

自身が比較対象のオブジェクトと等しい場合、検査にパスしたことになります。

@param expected 比較対象のオブジェクトを指定します。

@raise MiniTest::Assertion 与えられた期待値と実際の値が等しくない場合に発生します。

@see [[m:Object#==]], [[m:MiniTest::Assertions#assert_equal]]

--- must_be_within_delta(expected, delta = 0.001) -> true
--- must_be_close_to(expected, delta = 0.001) -> true

自身と期待値の差の絶対値が与えられた絶対誤差以下である場合、検査にパスしたことになります。

@param expected 期待値を指定します。

@param delta 許容する絶対誤差を指定します。

@raise MiniTest::Assertion 与えられた期待値と実際の値の差の絶対値が与えられた差分を越える場合に発生します。

@see [[m:MiniTest::Assertions#assert_in_delta]]

--- must_be_within_epsilon(actual, epsilon = 0.001) -> true
自身と実際の値の相対誤差が許容範囲内である場合、検査にパスしたことになります。

@param actual 実際の値を指定します。

@param epsilon 許容する相対誤差を指定します。

@raise MiniTest::Assertion 検査に失敗した場合に発生します。

--- must_include(object) -> true

自身に与えられたオブジェクトが含まれている場合、検査にパスしたことになります。

@param object 任意のオブジェクトを指定します。

@raise MiniTest::Assertion 自身が include? メソッドを持たない場合に発生します。
                           自身に与えられたオブジェクトが含まれていない場合に発生します。

@see [[m:MiniTest::Assertions#assert_includes]]

--- must_be_instance_of(klass) -> true

自身が与えられたクラスのインスタンスである場合、検査にパスしたことになります。

@param klass 任意のクラスを指定します。

@raise MiniTest::Assertion 自身がが与えられたクラスの直接のインスタンスでない場合に発生します。

@see [[m:MiniTest::Assertions#assert_instance_of]]

--- must_be_kind_of(klass) -> true

自身がが与えられたクラスまたはそのサブクラスのインスタンス
である場合、検査にパスしたことになります。

@param klass 自身が所属することを期待するクラスを指定します。

@raise MiniTest::Assertion 自身が与えられたクラスまたはそのサブクラスのインスタンスではない場合に発生します。

@see [[m:MiniTest::Assertions#assert_kind_of]]

--- must_match(regexp) -> true

自身がが与えられた正規表現にマッチした場合、検査にパスしたことになります。

@param regexp 正規表現か文字列を指定します。文字列を指定した場合は文字列そのものにマッチする
              正規表現に変換してから使用します。

@raise MiniTest::Assertion 自身が与えられた正規表現にマッチしなかった場合に発生します。

@see [[m:MiniTest::Assertions#assert_match]]

--- must_be_nil -> true

自身が nil である場合、検査にパスしたことになります。

@raise MiniTest::Assertion 自身が nil でない場合に発生します。

@see [[m:MiniTest::Assertions#assert_nil]]

--- must_be -> true

自身の評価結果が真である場合、検査にパスしたことになります。

@raise MiniTest::Assertion 自身の評価結果が偽である場合に発生します。

@see [[m:MiniTest::Assertions#assert]]

--- must_raise(*args) -> true
自身を評価中に与えられた例外が発生する場合、検査にパスしたことになります。

@param args 自身を評価中に発生する可能性のある例外クラスを一つ以上指定します。

@raise MiniTest::Assertion 自身を評価した結果、例外が発生しない場合に発生します。
                           また、自身を評価中に発生した例外が、与えられた例外
                           またはそのサブクラスでない場合に発生します。

@see [[m:MiniTest::Assertions#assert_raises]]

--- must_respond_to(method_name) -> true
自身が与えられたメソッドを持つ場合、検査にパスしたことになります。

@param method_name メソッド名を指定します。

@raise MiniTest::Assertion 自身が与えられたメソッドを持たない場合に発生します。

@see [[m:MiniTest::Assertions#assert_respond_to]]

--- must_be_same_as(actual) -> true
自身と与えられたオブジェクトの [[m:Object#object_id]] が同じ場合、検査にパスしたことになります。

@param actual 任意のオブジェクトを指定します。

@raise MiniTest::Assertion 自身と与えられたオブジェクトが異なる場合に発生します。

--- must_send -> true
#@todo
#@# どうやって使う？
#@# 引数から、式を取り出して評価した結果が真の場合、検査にパスしたことになります。
#@# 
#@# @param array 第一要素にレシーバとなる任意のオブジェクト、第二要素にメソッド名、
#@#              第三要素にパラメータをそれぞれ指定した配列を指定します。
#@# 
#@# @raise MiniTest::Assertion 取り出した式が偽を返す場合に発生します。
#@#
#@# @see [[m:MiniTest::Assertions#assert_send]]

--- must_throw(tag) -> true
自身を評価中に、与えられたタグが [[m:Kernel.#throw]] された場合、検査にパスしたことになります。

@param tag 自身を評価中に [[m:Kernel.#throw]] されるタグを任意のオブジェクトとして指定します。

@raise MiniTest::Assertion 与えられたタグが [[m:Kernel.#throw]] されなかった場合に発生します。

@see [[m:MiniTest::Assertions#assert_throws]]

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

現在実行中の [[c:MiniTest::Spec]] のインスタンスを返します。

--- before(type = :each){ ... } -> Proc

各テストの前に実行するブロックを登録します。

@param type :each を指定することができます。

@raise RuntimeError type に :each 以外を指定すると発生します。

--- after(type = :each){ ... } -> Proc

各テストの後に実行するブロックを登録します。

@param type :each を指定することができます。

@raise RuntimeError type に :each 以外を指定すると発生します。

--- it(desc){ ... } -> ()

テストケースを一つ定義します。

与えられたブロックが一つのテストケースに相当します。

@param desc テストケースの説明を指定します。

