eregex

=== 目的・概要

2つの正規表現による AND/OR を提供します。

Regexp クラスに & と | のメソッドを定義し、それぞれ
2つの正規表現の両方にマッチすれば真となるもの (RegAnd) と
いずれかにマッチすれば真となるもの (RegOr) を返します。
RegAnd、RegOr は =~ のみサポートしています。

=== サンプルコード

  require 'eregex'
  p "abc" =~ /b/|/c/
  p "abc" =~ /b/&/c/

= reopen Regexp

#@# 組み込みクラス Regexpを拡張して次のメソッドを定義しています。

== Instance Methods

--- &(other)

RegAnd(self,other) を返します。

--- |(other)

RegOr(self,other) を返します。

= class RegAnd < Object

== Class Methods

--- new(reg1, reg2)

コンストラクタです。

== Instance Methods

--- =~(str)

str が reg1 と reg2 の両方にマッチすれば真を返します。

= class RegOr < Object

== Class Methods

--- new(reg1, reg2)

コンストラクタです。

== Instance Methods

--- =~(str)

str が reg1 か reg2 のいずれかにマッチすれば真を返します。
