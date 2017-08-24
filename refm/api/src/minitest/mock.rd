category Development

シンプルなモックライブラリです。

#@since 2.2.0
このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

  * rubygems.org: [[url:https://rubygems.org/gems/minitest]]
  * プロジェクトページ: [[url:https://github.com/seattlerb/minitest]]
  * リファレンス: [[url:http://www.rubydoc.info/gems/minitest]]

#@else
=== 注意

このライブラリは 2.2.0 で bundled gem(gemファイルのみを同梱)になりました。

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
#@end
