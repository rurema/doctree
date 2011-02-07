このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。


= class RUNIT::TestSuite < Test::Unit::TestSuite

テストスイートを構成するクラスです。

== Instance Methods

--- add_test(*args) -> self
--- add(*args) -> self

[[m:Test::Unit::TestSuite#<<]] と同じです。

--- count_test_cases -> Integer

テストの件数を返します。

--- run(result) { .... }

テストスイートを実行します。

