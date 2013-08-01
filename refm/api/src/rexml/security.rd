#@since 2.1.0
= module REXML::Security

REXML のセキュリティ関連の限界値を設定/参照するためのモジュールです。

== Singleton Methods
--- entity_expansion_limit -> Integer
実体参照の展開回数の上限を返します。

XML 文書([[c:REXML::Document]])ごとの展開回数がこの値を越えると
例外を発生させ、処理を中断します。

実体参照の展開処理を使った DoS 攻撃に対抗するための
仕組みです。

デフォルトは 10000 です。

@see [[m:REXML::Document.entity_expansion_limit]]

--- entity_expansion_limit=(val)
実体参照の展開回数の上限を指定します。

XML 文書([[c:REXML::Document]])ごとの展開回数がこの値を越えると
例外を発生させ、処理を中断します。

デフォルトは 10000 です。

@param val 設定する上限値(整数)
@see [[m:REXML::Document.entity_expansion_limit]]


--- entity_expansion_text_limit -> Integer
実体参照の展開による文字列の増分(テキストのバイト数)の
最大値を指定します。

展開によって増分値がこの値を越えると
例外を発生させ、処理を中断します。

実体参照の展開処理を使った DoS 攻撃に対抗するための
仕組みです。

デフォルトは 10240 (byte) です。

@see [[m:REXML::Document.entity_expansion_text_limit=]],
     [[url:http://www.ruby-lang.org/ja/news/2013/02/22/rexml-dos-2013-02-22/]]



--- entity_expansion_text_limit=(val)
実体参照の展開による文字列の増分(テキストのバイト数)の
最大値を指定します。

展開によって増分値がこの値を越えると
例外を発生させ、処理を中断します。

実体参照の展開処理を使った DoS 攻撃に対抗するための
仕組みです。

デフォルトは 10240 (byte) です。

@see [[m:REXML::Document.entity_expansion_text_limit]]
     [[url:http://www.ruby-lang.org/ja/news/2013/02/22/rexml-dos-2013-02-22/]]

#@end
