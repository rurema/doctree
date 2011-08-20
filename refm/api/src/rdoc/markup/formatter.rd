require rdoc/markup

rdoc 形式のドキュメントを整形するためのサブライブラリです。

= class RDoc::Markup::Formatter

rdoc 形式のドキュメントを整形するためのクラスです。

実際にドキュメントを整形するには、[[c:RDoc::Markup::ToHtml]] のような、
継承したクラスで convert メソッドを実行してください。

== Class Methods

--- new -> RDoc::Markup::Formatter

自身を初期化します。

== Instance Methods

--- convert(content) -> ()

content で指定された文字列を変換します。

@param content 変換する文字列を指定します。
