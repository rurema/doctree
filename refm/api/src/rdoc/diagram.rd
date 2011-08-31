#@since 1.9.1
require rdoc/dot
#@else
require rdoc/dot/dot
require rdoc/options
#@end

モジュールやクラスの関係を描く図を作成するためのサブライブラリです。

本サブライブラリを利用するためには dot コマンド
([[url:http://www.research.att.com/sw/tools/graphviz/]] 参照)のバージョ
ン 1.8.6 以降に PATH が通っている必要があります。

[注意] rdoc/diagram ライブラリは 1.9.2 で廃止されました。

= class RDoc::Diagram

モジュールやクラスの関係を描く図を作成するためのクラスです。

== Constants

--- FONT -> "Arial"

[[c:RDoc::Diagram]] が使用するフォント名を返します。

--- DOT_PATH -> "dot"

画像を作成するサブディレクトリ名を返します。

== Class Methods

--- new(info, options) -> RDoc::Diagram

自身を初期化します。

@param info [[c:RDoc::TopLevel]] オブジェクトの配列を指定します。

#@since 1.9.1
@param options [[c:RDoc::Options]] オブジェクトを指定します。
#@else
@param options [[c:Options]] オブジェクトを指定します。
#@end

== Instance Methods

--- draw -> ()

自身が持つ全ての [[c:RDoc::TopLevel]] オブジェクトを解析してモジュール
やクラスの関係を描く図を作成します。
