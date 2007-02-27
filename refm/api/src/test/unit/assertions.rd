= class Test::Unit::AssertionFailedError < StandardError
Thrown by Test::Unit::Assertions when an assertion fails.

= module Test::Unit::Assertions

Test::Unit::TestCase に include されて使われるモジュールです。assert メソッドを定義して
います。

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
#@todo

boolean が真なら pass

--- assert_equal(expected, actual, message=nil)
#@todo

expected == actual ならば pass

--- assert_not_equal(expected, actual, message="")
#@todo

expected != actual ならば pass

--- assert_instance_of(klass, object, message="")
#@todo

klass == object.class が真なら pass

--- assert_nil(object, message="")
#@todo

object.nil? ならば pass

--- assert_not_nil(object, message="")
#@todo

!object.nil? ならば pass

--- assert_kind_of(klass, object, message="")
#@todo

object.kind_of?(klass) が真なら pass

--- assert_respond_to(object, method, message="")
#@todo

object.respond_to?(method) が真なら pass

--- assert_match(pattern, string, message="")
#@todo

string =~ pattern が真ならば pass

--- assert_no_match(regexp, string, message="")
#@todo

regexp !~ string が真ならば pass

--- assert_same(expected, actual, message="")
#@todo

actual.equal?(expected) が真なら pass

--- assert_not_same(expected, actual, message="")
#@todo

!actual.equal?(expected) が真なら pass

--- assert_operator(object1, operator, object2, message="")
#@todo

object1.send(operator, object2) が真なら pass

#@since 1.8.1
--- assert_raise(expected_exception_klass, message="") { ... }
#@todo

ブロックを実行して例外が発生し、その例外が
expected_exception_klass クラスならば pass
#@end

#@# bc-rdoc: detected missing name: assert_raises
--- assert_raises(*args, &block)
#@todo

Alias of assert_raise.

Will be deprecated in 1.9, and removed in 2.0.

#@# bc-rdoc: detected missing name: build_message
--- build_message(head, template=nil, *arguments)
#@todo

Builds a failure message. head is added before the template and
arguments replaces the '?'s positionally in the template.

--- assert_nothing_raised(*args) { ... }
#@todo

ブロックを実行して例外が起きなければ pass

--- flunk(message="Flunked")
#@todo

常に失敗

--- assert_throws(expected_symbol, message="") { ... }
#@todo

ブロックを実行して :expected_symbol が throw されたら pass

--- assert_nothing_thrown(message="") { ... }
#@todo

ブロックを実行して throw が起こらなければ pass

--- assert_in_delta(expected_float, actual_float, delta, message="")
#@todo

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f 
が真なら pass

delta は正の数でなければならない。

--- assert_send(send_array, message="")
#@todo

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真なら pass

--- assert_block(message="assert_block failed.") { ... }
#@todo

block の結果が真なら pass
