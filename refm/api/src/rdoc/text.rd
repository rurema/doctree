コメントテキストを処理するためのサブライブラリです。

= module RDoc::Text

コメントテキストを処理するためのクラスです。

== Instance Methods

--- expand_tabs(text) -> String

引数中のタブ(\t)を直前の連続するスペースと合計して 8 文字のスペースにな
るように置き換えます。

@param text 文字列を指定します。

--- flush_left(text) -> String

引数から各行の行頭のスペースを削除します。

@param text 文字列を指定します。

--- markup(text) -> String

引数を整形します。

include したクラスに self#formatter メソッドが必要です。

@param text 文字列を指定します。

--- normalize_comment(text) -> String

引数から行頭のスペースや改行文字などを削除します。

詳しくは [SEE ALSO] の各メソッドを参照してください。

@param text 文字列を指定します。

@see [[m:RDoc::Text#strip_hashes]], [[m:RDoc::Text#expand_tabs]],
     [[m:RDoc::Text#flush_left]], [[m:RDoc::Text#strip_newlines]]

--- parse(text) -> RDoc::Markup::Document | Array

引数から [[m:RDoc::Text#normalize_comment]] でスペースや改行文字などを削
除した後に解析を行います。

@param text 文字列を指定します。

@see [[m:RDoc::Text#normalize_comment]]

--- strip_hashes(text) -> String

引数から各行の行頭の # を削除します。

@param text 文字列を指定します。

--- strip_newlines(text) -> String

引数から先頭と末尾の改行を削除します。

@param text 文字列を指定します。

--- strip_stars(text) -> String

引数から /* 〜 */ 形式のコメントを削除します。

@param text 文字列を指定します。
