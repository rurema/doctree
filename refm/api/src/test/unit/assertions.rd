= class Test::Unit::AssertionFailedError < StandardError
Thrown by Test::Unit::Assertions when an assertion fails.

= module Test::Unit::Assertions


各種の assert メソッドを提供するモジュールです。Test::Unit::TestCase に include されて使われます。
[[lib:test/unit]] の他のクラスとは独立して、提供されている assert メソッドだけを使うこともできます。
[[m:Test::Unit::Assertions#assert_block]] を使うことにより、新しい assert メソッドを加えることもできます。

assert が失敗した時は、例外 [[c:Test::Unit::AssertionFailedError]] を投げます。
各 assert メソッドの最後の引数 message はテストが失敗したときに表示される
メッセージです。


== Singleton Methods

--- use_pp=(value)
#@todo

Select whether or not to use the pretty-printer. If this option
is set to false before any assertions are made, pp.rb will not
be required.


== Instance Methods

--- assert(boolean, message=nil)

boolean が真ならパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_equal(expected, actual, message=nil)

expected == actual ならばパスします。[[m:Test::Unit::Assertions#assert_same]]
との違いに注意して下さい。
[[m:Object#==]] も参照して下さい。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_not_equal(expected, actual, message="")

expected != actual ならばパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_instance_of(klass, object, message="")

object が klass の直接のインスタンスであるなら、パスします。
[[m:Object#instance_of?]]も参照して下さい。

[[m:Test::Unit::Assertions#assert_kind_of]] との違いに注意して下さい。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_nil(object, message="")

object が nil ならばパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_not_nil(object, message="")

object が nil でないならばパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_kind_of(klass, object, message="")

object.kind_of?(klass) が真ならパスします。

正確には、object が klass かそのサブクラスのインスタンスであるならパスします。
また、kalss がモジュールである場合は、object が klass をインクルードしたクラスかそのサブクラスの
インスタンスであるならパスします。[[m:Object#kind_of?]] を参照して下さい。

[[m:Test::Unit::Assertions#assert_instance_of]] との違いに注意して下さい。

@param klass クラスかモジュールを与えます。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_respond_to(object, method, message="")
#@todo

object.respond_to?(method) が真ならパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_match(pattern, string, message="")
#@todo

string =~ pattern が真ならばパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_no_match(regexp, string, message="")
#@todo

regexp !~ string が真ならばパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_same(expected, actual, message="")
#@todo

actual.equal?(expected) が真ならパスします。
[[m:Test::Unit::Assertions#assert_equal]] との違いに注意して下さい。
[[m:Object#equal?]] も参照して下さい。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_not_same(expected, actual, message="")
#@todo

!actual.equal?(expected) が真ならパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_operator(object1, operator, object2, message="")
#@todo

object1.send(operator, object2) が真ならパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

#@since 1.8.1
--- assert_raise(expected_exception_klass, message="") { ... }
#@todo

ブロックを実行して例外が発生し、その例外が
expected_exception_klass クラスならばパスします。

assert にパスした時は、実際に投げられた例外を返します。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

#@end

--- assert_raises(*args, &block)
#@todo

Alias of assert_raise.

Will be deprecated in 1.9, and removed in 2.0.

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- build_message(head, template=nil, *arguments)
#@todo

Builds a failure message. head is added before the template and
arguments replaces the '?'s positionally in the template.

--- assert_nothing_raised(*args) { ... }
#@todo

ブロックを実行して例外が起きなければパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- flunk(message="Flunked")
#@todo

常に失敗します。ちゃんとしたテストを書くまでの間、テストを失敗させておきたい場合などに使います。

@raise Test::Unit::AssertionFailedError 常に発生します。

--- assert_throws(expected_symbol, message="") { ... }
#@todo

ブロックを実行して :expected_symbol が throw されたらパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_nothing_thrown(message="") { ... }
#@todo

ブロックを実行して throw が起こらなければパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_in_delta(expected_float, actual_float, delta, message="")
#@todo

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f 
が真ならパスします。

delta は正の数でなければならない。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_send(send_array, message="")
#@todo

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真ならパスします。

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。

--- assert_block(message="assert_block failed.") { ... }
#@todo

ブロックを実行し、その結果が真ならパスします。

新しい assert メソッドを定義する時にも使います。

  def deny(boolean, message = nil)
    message = build_message message, '<?> is not false or nil.', boolean
    assert_block message do
      not boolean
    end
  end

@raise Test::Unit::AssertionFailedError assert がパスしなかった時に発生します。
