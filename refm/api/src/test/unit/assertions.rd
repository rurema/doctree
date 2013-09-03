各種の assert メソッドを提供します。

#@until 1.9.1
= class Test::Unit::AssertionFailedError < StandardError
アサーションに失敗した時に [[c:Test::Unit::Assertions]] から raise されます。
#@end

= module Test::Unit::Assertions

#@since 1.9.1
include MiniTest::Assertions
#@end

各種の assert メソッドを提供するモジュールです。

Test::Unit::TestCase に include されて使われます。
[[lib:test/unit]] の他のクラスとは独立して、提供されている assert メソッドだけを使うこともできます。
assert_block メソッドを使うことにより、新しい assert メソッドを加えることもできます。

#@since 1.9.1
assert が失敗した時は、例外 [[c:MiniTest::Assertion]] を投げます。
#@else
assert が失敗した時は、例外 [[c:Test::Unit::AssertionFailedError]] を投げます。
#@end
各 assert メソッドの最後の引数 message はテストが失敗したときに表示される
メッセージです。


#@until 1.9.1
== Singleton Methods

--- use_pp=(value)

出力に [[lib:pp]] を使用するかどうかを指定します。偽を指定した場合は
[[lib:pp]] は require されません。

@param value [[lib:pp]] を使用するかどうか。
#@end

== Instance Methods

#@until 1.9.1
--- assert(boolean, message = nil)    -> ()

boolean が真ならパスします。

@param boolean 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_instance_of(klass, object, message = "")    -> ()

object が klass の直接のインスタンスであるなら、パスします。
[[m:Object#instance_of?]]も参照して下さい。

@param klass 期待するクラスを指定します。

@param object 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

[[m:Test::Unit::Assertions#assert_kind_of]] との違いに注意して下さい。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_nil(object, message = "")    -> ()

object が nil ならばパスします。

@param object 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Test::Unit::Assertions#assert_not_nil]]

--- assert_kind_of(klass, object, message = "")    -> ()

object.kind_of?(klass) が真ならパスします。

正確には、object が klass かそのサブクラスのインスタンスであるならパスします。
また、klass がモジュールである場合は、object が klass をインクルードしたクラスかそのサブクラスの
インスタンスであるならパスします。

[[m:Test::Unit::Assertions#assert_instance_of]] との違いに注意して下さい。

@param klass 期待するクラスかモジュールを与えます。

@param object 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Object#kind_of?]]

--- assert_respond_to(object, method, message = "")    -> ()

object.respond_to?(method) が真ならパスします。

@param object 検証するオブジェクトを指定します。

@param method 検証するメソッドを [[c:Symbol]] か文字列で指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Object#respond_to?]]

--- assert_match(pattern, string, message = "")    -> ()

string =~ pattern が真ならばパスします。

@param pattern 期待するパターンを文字列か正規表現で指定します。文字列を
               指定した場合は内部で文字列そのものにマッチする正規表現に変換されます。

@param string 検証する文字列を指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Test::Unit::Assertions#assert_no_match]]

--- assert_same(expected, actual, message = "")    -> ()

actual.equal?(expected) が真ならパスします。

[[m:Test::Unit::Assertions#assert_equal]] との違いに注意して下さい。

@param expected 期待するオブジェクトを指定します。

@param actual 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Object#equal?]], [[m:Test::Unit::Assertions#assert_not_same]]

--- assert_operator(object1, operator, object2, message = "")    -> ()

object1.send(operator, object2) が真ならパスします。

@param object1 検証するオブジェクトを指定します。

@param operator 検証のための演算子(メソッド)を [[c:Symbol]] か
                to_str メソッドが使用できるオブジェクトで指定します。

@param object2 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_raises(*args, &block)    -> object

[[m:Test::Unit::Assertions#assert_raise]] のエイリアスです。

@param args [[m:Test::Unit::Assertions#assert_raise]] にそのまま渡します。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Test::Unit::Assertions#assert_raise]]

--- flunk(message = "Flunked")    -> ()

常に失敗します。

ちゃんとしたテストを書くまでの間、テストを失敗させておきたい場合などに使います。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError 常に発生します。

--- assert_throws(expected_symbol, message = "") { ... }    -> ()

ブロックを実行して :expected_symbol が throw されたらパスします。

@param expected_symbol throw されると期待するシンボルを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_in_delta(expected_float, actual_float, delta, message = "")    -> ()

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f
が真ならパスします。

@param expected_float 期待する実数値を指定します。

@param actual_float 検証する実数値を指定します。

@param delta 許容できる誤差を正の数で指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_send(send_array, message = "")    -> ()

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真ならパスします。

@param send_array 検証するオブジェクトを [レシーバ、メソッド、メソッドの引数]
                  で指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_block(message = "assert_block failed.") { ... }    -> ()

ブロックを実行し、その結果が真ならパスします。

新しい assert メソッドを定義する時にも使います。

  def deny(boolean, message = nil)
    message = build_message message, '<?> is not false or nil.', boolean
    assert_block message do
      not boolean
    end
  end

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_equal(expected, actual, message = nil)    -> ()

expected == actual ならばパスします。

#@since 1.9.1
[[m:MiniTest::Assertions#assert_same]]との違いに注意して下さい。
#@else
[[m:Test::Unit::Assertions#assert_same]]との違いに注意して下さい。
#@end

@param expected 期待するオブジェクトを指定します。

@param actual 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

@see [[m:Test::Unit::Assertions#assert_not_equal]], [[m:Object#==]]

--- assert_not_equal(expected, actual, message = "")    -> ()

expected != actual ならばパスします。

@param expected 同じものではないと期待するオブジェクトを指定します。

@param actual 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

@see [[m:Test::Unit::Assertions#assert_equal]]

--- assert_not_nil(object, message = "")    -> ()

object が nil でないならばパスします。

@param object 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。

@see [[m:MiniTest::Assertions#assert_nil]]
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Test::Unit::Assertions#assert_nil]]
#@end

--- assert_no_match(regexp, string, message = "")    -> ()

regexp !~ string が真ならばパスします。

@param regexp マッチしないと期待するパターンを正規表現で指定します。

@param string 検証する文字列を指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。

[[m:MiniTest::Assertions#assert_match]] とは異なり regexp には正規表現
以外は指定できません。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

[[m:Test::Unit::Assertions#assert_match]] とは異なり regexp には正規表
現以外は指定できません。
#@end

--- assert_not_same(expected, actual, message = "")    -> ()

!actual.equal?(expected) が真ならパスします。

@param expected 期待するオブジェクトを指定します。

@param actual 検証するオブジェクトを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。

@see [[m:Object#equal?]], [[m:MiniTest::Assertions#assert_same]]
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

@see [[m:Object#equal?]], [[m:Test::Unit::Assertions#assert_same]]
#@end

#@since 1.8.1

--- assert_raise(message = "") { ... }    -> object
--- assert_raise(klass1, klass2, ..., message = "") { ... }    -> object

ブロックを実行して例外が発生し、その例外が
klass1, klass2,... のいずれかのクラスのインスタンスならばパスします。

assert にパスした時は、実際に投げられた例外を返します。

@param klassX 例外クラスを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

#@end

--- build_message(head, template = nil, *arguments)

テストが失敗したときに表示されるメッセージを作成します。

@param head templateから作成するメッセージの前に表示する文字列を指定します。

@param template 作成するメッセージのテンプレートを文字列で指定します。

@param arguments template 内の '?' を置き換えるオブジェクトを配列で指定します。

@return 作成したメッセージをTest::Unit::Assertions::AssertionMessageの
        インスタンスで返します。

head は template の前に追加されます。template に指定した文字列に '?' が
含まれていた場合は、arguments に指定したオブジェクトでそれぞれ置き換え
られます。

--- assert_nothing_raised(message = "") { ... }
--- assert_nothing_raised(klass1, klass2, ..., message = "") { ... }

ブロックを実行して例外が起きなければパスします。

ブロックを実行して発生した例外が klass1, klass2, ..., のいずれかのクラスの
インスタンスである場合は、assert は失敗扱いとなり、Test::Unit::AssertionFailedError
を投げます。そうでない場合は、エラー扱いとなり発生した例外を再び投げます。

@param klassX 例外クラスを指定します。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_nothing_thrown(message = "") { ... }    -> ()

ブロックを実行して throw が起こらなければパスします。

@param message assert が失敗した時に表示するメッセージを文字列で指定し
               ます。指定しなかった場合は表示しません。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

#@since 1.9.1
--- mu_pp(obj)     -> String

obj を人間が読みやすい形の文字列表現にして返します。

@param obj 任意のオブジェクト

@return obj を人間が読みやすい形式にした文字列
#@end
