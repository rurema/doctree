
= class Test::Unit::Failure < Object

テストの失敗を表現するクラスです。テスト中にアサーションが失敗した時に
[[c:Test::Unit::TestCase]]から作られます。

== Class Methods

--- new(test_name, location, message) -> Test::Unit::Failure

Test::Unit::Failure オブジェクトのインスタンスを生成します。

@param test_name 対応するテストメソッドの名前を指定します。

@param location 呼び出し元の情報を [[m:$@]] の形式で指定します。

@param message 対応する assert メソッドに渡した message を指定します。

== Instance Methods

--- long_display -> String
--- to_s -> String

アサーションに失敗した時の詳細な説明を文字列で返します。

--- message -> String

自身に対応する assert メソッドに渡した message を指定します。

[[m:Test::Unit::Failure#short_display]] や
[[m:Test::Unit::Failure#long_display]] で使われます。

@see [[m:Test::Unit::Failure#short_display]],
     [[m:Test::Unit::Failure#long_display]]

--- short_display -> String

アサーションに失敗した時の簡単な説明を文字列で返します。

--- single_character_display -> String

アサーションに失敗した時に表示する 'F' を返します。

--- test_name -> String

自身に対応するテストメソッドの名前を返します。

--- location -> [String]

自身に対応する呼び出し元の情報を [[m:$@]] の形式のバックトレースとして返します。
