require runit/error

このライブラリは、
RubyUnit との互換性を提供するためだけに提供されています。
これから新しくユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。


= module RUNIT::Assert
include Test::Unit::Assertions

RubyUnit のアサーションを集めたモジュールです。

このモジュールは RubyUnit との互換性のためにのみ提供されています。
これからユニットテストを書くときは [[lib:test/unit]] を使ってください。

== Instance Methods

--- assert_equal_float(expected, actual, delta, message = "") -> ()

期待値と実際の値の差の絶対値が与えられた絶対誤差以下である場合、検査にパスしたことになります。

@param expected 期待値を指定します。

@param actual 実際の値を指定します。

@param delta 許容する絶対誤差を指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_send(object, method, *args) -> ()

object.__send__(method, *args) が真である場合、検査にパスしたことになります。

@param object 任意のオブジェクトを指定します。

@param method 呼び出すメソッド名を指定します。

@param args メソッドに渡す引数を指定します。

--- assert_not_nil(actual, message = "") -> ()
与えられたオブジェクトが nil でない場合、検査にパスしたことになります。

@param actual 検査したいオブジェクトを指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_respond_to(method, object, message = "") -> ()

与えられたオブジェクトが与えられたメソッドを持つ場合、検査にパスしたことになります。

@param method メソッド名を指定します。

@param object 任意のオブジェクトを指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_match(str, re, message = "") -> ()
--- assert_matches(str, re, message = "") -> ()

与えられた文字列が与えられた正規表現にマッチする場合、検査にパスします。

@param str 文字列を指定します。

@param re 正規表現を指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_not_match(str, re, message = "") -> ()
与えられた文字列が与えられた正規表現にマッチしない場合、検査にパスします。

@param str 文字列を指定します。

@param re 正規表現を指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_exception(exception, message = "") { ... } -> ()

与えられたブロックを評価中に与えられた例外が発生する場合、検査にパスしたことになります。

@param exception 例外クラスを指定します。

@param message 検査に失敗したときのメッセージを指定します。

--- assert_no_exception(*args) { ... }
与えられたブロックを評価中に与えられた例外が発生しない場合、検査にパスしたことになります。

@param args 例外クラスを一つ以上指定します。最後の引数に文字列を指定した場合、それは検査に
            失敗したときのメッセージになります。

--- assert_fail(message) -> ()

常に失敗します。

@param message 検査に失敗したときのメッセージを指定します。

--- setup_assert

何もしません。

--- called_internally? -> bool

内部で使用します。

