RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするサブライ
ブラリです。

#@until 1.9.3
  require 'rdoc/markup/formatter'
#@end
  require 'rdoc/markup/to_ansi'

  h = RDoc::Markup::ToAnsi.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

= class RDoc::Markup::ToAnsi < RDoc::Markup::ToRdoc

RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするクラスで
す。

== Class Methods

#@since 1.9.3
--- new(markup = nil) -> RDoc::Markup::ToAnsi
#@else
--- new -> RDoc::Markup::ToAnsi
#@end

自身を初期化します。

#@since 1.9.3
@param markup [[c:RDoc::Markup]] オブジェクトを指定します。省略した場合
              は新しく作成します。
#@end
