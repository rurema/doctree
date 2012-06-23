category Development

シンプルなモックライブラリです。

= class MiniTest::Mock

シンプルなモックを実現するためのクラスです。

== Class Methods

--- new

自身を初期化します。

== Public Instance Methods

--- expect(name, retval, args = []) -> self

モックを構築するメソッドです。

@param name メソッド名を指定します。

@param retval 返り値として期待する値を指定します。

@param args 引数として期待する値を配列で指定します。

--- verify -> true

モックの検証を行います。

@raise MockExpectationError モックの検証に失敗した場合に発生します。

= class MockExpectationError < StandardError

モックの検証に失敗した場合に発生する例外です。
