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

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_instance_of(klass, object, message = "")    -> ()

object が klass の直接のインスタンスであるなら、パスします。
[[m:Object#instance_of?]]も参照して下さい。

[[m:Test::Unit::Assertions#assert_kind_of]] との違いに注意して下さい。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_nil(object, message = "")    -> ()

object が nil ならばパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_kind_of(klass, object, message = "")    -> ()

object.kind_of?(klass) が真ならパスします。

正確には、object が klass かそのサブクラスのインスタンスであるならパスします。
また、klass がモジュールである場合は、object が klass をインクルードしたクラスかそのサブクラスの
インスタンスであるならパスします。[[m:Object#kind_of?]] を参照して下さい。

[[m:Test::Unit::Assertions#assert_instance_of]] との違いに注意して下さい。

@param klass クラスかモジュールを与えます。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_respond_to(object, method, message = "")    -> ()
#@todo

object.respond_to?(method) が真ならパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_match(pattern, string, message = "")    -> ()
#@todo

string =~ pattern が真ならばパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_same(expected, actual, message = "")    -> ()
#@todo

actual.equal?(expected) が真ならパスします。

[[m:Test::Unit::Assertions#assert_equal]] との違いに注意して下さい。
[[m:Object#equal?]] も参照して下さい。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_operator(object1, operator, object2, message = "")    -> ()
#@todo

object1.send(operator, object2) が真ならパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_raises(*args, &block)    -> object

[[m:Test::Unit::Assertions#assert_raise]] のエイリアスです。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- flunk(message = "Flunked")    -> ()
#@todo

常に失敗します。

ちゃんとしたテストを書くまでの間、テストを失敗させておきたい場合などに使います。

@raise Test::Unit::AssertionFailedError 常に発生します。

--- assert_throws(expected_symbol, message = "") { ... }    -> ()
#@todo

ブロックを実行して :expected_symbol が throw されたらパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_in_delta(expected_float, actual_float, delta, message = "")    -> ()
#@todo

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f
が真ならパスします。

delta は正の数でなければならない。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_send(send_array, message = "")    -> ()
#@todo

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真ならパスします。

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。

--- assert_block(message = "assert_block failed.") { ... }    -> ()
#@todo

ブロックを実行し、その結果が真ならパスします。

新しい assert メソッドを定義する時にも使います。

  def deny(boolean, message = nil)
    message = build_message message, '<?> is not false or nil.', boolean
    assert_block message do
      not boolean
    end
  end

@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_equal(expected, actual, message = nil)    -> ()

expected == actual ならばパスします。

[[m:Test::Unit::Assertions#assert_same]]との違いに注意して下さい。
[[m:Object#==]] も参照して下さい。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_not_equal(expected, actual, message = "")    -> ()

expected != actual ならばパスします。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_not_nil(object, message = "")    -> ()

object が nil でないならばパスします。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_no_match(regexp, string, message = "")    -> ()
#@todo

regexp !~ string が真ならばパスします。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_not_same(expected, actual, message = "")    -> ()
#@todo

!actual.equal?(expected) が真ならパスします。

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

#@since 1.8.1

--- assert_raise(klass1, klass2, ..., message = "") { ... }    -> object

ブロックを実行して例外が発生し、その例外が
klass1, klass2,... のいずれかのクラスのインスタンスならばパスします。

assert にパスした時は、実際に投げられた例外を返します。

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

#@since 1.9.1
@raise MiniTest::Assertion assert が失敗した時に発生します。
#@else
@raise Test::Unit::AssertionFailedError assert が失敗した時に発生します。
#@end

--- assert_nothing_thrown(message = "") { ... }    -> ()
#@todo

ブロックを実行して throw が起こらなければパスします。

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
