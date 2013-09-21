RD 形式で記述されたファイルを解析するためのサブライブラリです。

= class RDoc::Parser::RD < RDoc::Parser

include RDoc::Parser::Text

RD 形式で記述されたファイルを解析するためのクラスです。

解析された情報はコメントとして扱われます。

== Instance Methods

--- scan -> RDoc::TopLevel

RD 形式で記述されたファイルを解析します。

@return [[c:RDoc::TopLevel]] オブジェクトを返します。
