require runit/error

このライブラリは、
RubyUnit との互換性を提供するためだけに提供されています。
これから新しくユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。


= module RUNIT::Assert

RubyUnit のアサーションを集めたモジュールです。

このモジュールは RubyUnit との互換性のためにのみ提供されています。
これからユニットテストを書くときは [[lib:test/unit]] を使ってください。

== Module Functions

--- assert(condition[, message])

condition が Ruby の真 (false または nil 以外) であることを表明します。
condition が偽であったらこのアサーションは失敗します。

message はアサート失敗時のエラーメッセージです。

--- assert_equal(expected, actual[, message])
--- assert_equals(expected, actual[, message])

actual == expected であることを表明します。
actual != expected のときにこのアサーションは失敗します。

message はアサート失敗時のエラーメッセージです。

--- assert_operator(obj1, op, obj2[, message])

actual.__send__(op, expected) が真であることを表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_equal_float(expected, actual, e[, message])

浮動小数点数 actual と expected が等しいことを表明します。
このとき、expected-e <= actual <= expected+e
であれば「等しい」と判定されます。

message はアサート失敗時のエラーメッセージです。

--- assert_same(expected, actual[, message])

expected.equal?(actual) が真であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_send(obj, method, *args)

obj.__send__(method, *args) が真であることを表明します。

--- assert_nil(obj[, message])

obj が nil であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_not_nil(obj[, message])

obj が nil ではないと表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_respond_to(method, obj[, message])

オブジェクト obj にメソッド method が定義されていると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_kind_of(c, obj[, message])

obj.kind_of?(c) が真であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_instance_of(c, obj[, message])

c.instance_of?(c) が真であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_match(str, re[, message])
--- assert_matches(str, re[, message])

re =~ str が真であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_not_match(str, re[, message])

re =~ str が偽であると表明します。

message はアサート失敗時のエラーメッセージです。

--- assert_exception(exception[, message]) { ... }

ブロックを実行中に例外 exception が発生することを表明します。
ブロックを実行しても例外 exception が発生しなかったら
このアサーションは失敗します。
message はアサート失敗時のエラーメッセージです。

--- assert_no_exception(exceptions, ...[, message]) { ... }

ブロックを実行中に例外 exceptions が発生しないことを表明します。
ブロックを実行したときに例外 exception が発生すると
このアサーションは失敗します。
message はアサート失敗時のエラーメッセージです。

--- assert_fail(message)

このアサーションは常に失敗します。
message はアサート失敗時のエラーメッセージです。

このアサーションは、テストをまだ書いていない場合に、
それを明示するために使われます。
