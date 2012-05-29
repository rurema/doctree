[[c:RDoc::RubyLex]] と [[c:RDoc::RubyToken]] を使って Ruby のソースコー
ドのパーサを記述するためのモジュールを定義するサブライブラリです。

= module RDoc::Parser::RubyTools

include RDoc::RubyToken

[[c:RDoc::RubyLex]] と [[c:RDoc::RubyToken]] を使って Ruby のソースコー
ドのパーサを記述するためのメソッドを定義するモジュールです。

[[c:RDoc::Parser]] を継承していないため、パーサクラスとしては利用できま
せん。

ライブラリの内部で使用します。
