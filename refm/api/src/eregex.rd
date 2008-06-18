2 つの正規表現による AND/OR を提供します。

このライブラリはコンセプト実証用のおもちゃのようなものです。

[[c:Regexp]] クラスに & と | のメソッドを定義し、それぞれ
2つの正規表現の両方にマッチすれば真となるもの ([[c:RegAnd]]) と
いずれかにマッチすれば真となるもの ([[c:RegOr]]) を返します。
[[c:RegAnd]]、[[c:RegOr]] は =~ のみサポートしています。

=== 使用例

  require 'eregex'
  p "abc" =~ /b/|/c/
  p "abc" =~ /b/&/c/



= reopen Regexp

#@# 組み込みクラス Regexpを拡張して次のメソッドを定義しています。

== Instance Methods

--- &(other) -> RedAnd

[[m:RegAnd.new]](self, other) を返します。

@param other 正規表現オブジェクト。

--- |(other) -> RegOr

[[m:RegOr.new]](self, other) を返します。

@param other 正規表現オブジェクト。

= class RegAnd < Object

二つの正規表現を内部で保持するクラスです。

== Class Methods

--- new(re1, re2) -> RegAnd

新しい RegAnd オブジェクトを生成します。

@param re1 正規表現オブジェクト。

@param re2 正規表現オブジェクト。

== Instance Methods

--- =~(str) -> bool

str が内部で保持している正規表現の両方にマッチすれば真を返します。

@param str 文字列。

= class RegOr < Object

二つの正規表現を内部で保持するクラスです。

== Class Methods

--- new(re1, re2) -> RegOr

新しい RegOr オブジェクトを生成します。

@param re1 正規表現オブジェクト。

@param re2 正規表現オブジェクト。

== Instance Methods

--- =~(str) -> bool

str が 内部で保持しているいずれかの正規表現にマッチすれば真を返します。

@param str 文字列。
