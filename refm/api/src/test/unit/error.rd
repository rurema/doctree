= class Test::Unit::Error < Object

テスト時のエラーを表現するクラスです。テスト中に例外が発生した時に
[[c:Test::Unit::TestCase]] から作られます。

== Class Methods

--- new(test_name, exception) -> Test::Unit::Error

Test::Unit::Error オブジェクトのインスタンスを生成します。

@param test_name 対応するテストメソッドの名前を指定します。

@param exception 対応する例外オブジェクトを指定します。

== Instance Methods

--- exception -> Exception

自身に対応する例外オブジェクトを返します。

--- long_display -> String
--- to_s -> String

エラーの詳細な説明を文字列で返します。

--- message -> String

発生した例外に関連するエラーメッセージを文字列で返します。

[[m:Test::Unit::Error#short_display]] や
[[m:Test::Unit::Error#long_display]] で使われます。

@see [[m:Test::Unit::Error#short_display]],
     [[m:Test::Unit::Error#long_display]]

--- short_display -> String

エラーの簡単な説明を文字列で返します。

--- single_character_display -> String

テストメソッド実行中に例外が発生した時に表示する 'E' を返します。

--- test_name -> String

自身に対応するテストメソッドの名前を返します。
