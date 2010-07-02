このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。

= class RUNIT::CUI::TestRunner < Test::Unit::UI::Console::TestRunner

CUI でテストを実行するためのクラスです。

== Class Methods

--- new -> RUNIT::CUI::TestRunner

自身を初期化します。

--- run(suite) -> ()

与えられたテストスイートを実行します。

@param suite テストスイートを与えます。

--- quiet_mode=(bool)

真をセットすると出力が静かになります。

@param bool 真を指定すると、出力が静かになります。

== Instance Methods

--- run(suite, quiet_mode = @@quiet_mode) -> ()

与えられたテストスイートを実行します。

@param suite テストスイートを指定します。

@param quiet_mode 真を指定すると、出力が静かになります。

--- create_mediator(suite)

与えられたテストスイートを使ってテストの仲介者を作成します。

@param suite テストスイートを指定します。

--- create_result -> RUNIT::TestResult

テストの実行結果を作成します。


