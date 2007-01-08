このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。

= class RUNIT::CUI::TestRunner < Test::Unit::UI::Console::TestRunner

== Class Methods

--- new

--- run(suite)

--- quiet_mode=(bool)

== Instance Methods

--- run(suite, quiet_mode = @@quiet_mode)

--- create_mediator(suite)

--- create_result

