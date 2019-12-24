require rdoc/markup/to_html

RDoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

[[c:RDoc::Markup::ToHtml]] を拡張して、ドキュメント内のメソッド名やクラ
ス名を自動的にリンクにします。

= class RDoc::Markup::ToHtmlCrossref < RDoc::Markup::ToHtml

RDoc 形式のドキュメントを HTML に整形するクラスです。

== Class Methods

--- new(path, context, show_hash) -> RDoc::Markup::ToHtmlCrossref

自身を初期化します。

@param path 生成するファイルのパスを文字列で指定します。

@param context [[c:RDoc::Context]] オブジェクトかそのサブクラスのオブジェ
               クトを指定します。

@param show_hash true を指定した場合、メソッド名のリンクに # を表示しま
                 す。false の場合は表示しません。

@raise ArgumentError path に nil を指定した場合に発生します。
