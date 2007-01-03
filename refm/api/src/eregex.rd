2 つの正規表現による AND/OR を提供します。

Regexp クラスに & と | のメソッドを定義し、それぞれ
2つの正規表現の両方にマッチすれば真となるもの (RegAnd) と
いずれかにマッチすれば真となるもの (RegOr) を返します。
RegAnd、RegOr は =~ のみサポートしています。

=== 使用例

  require 'eregex'
  p "abc" =~ /b/|/c/
  p "abc" =~ /b/&/c/



= reopen Regexp

#@# 組み込みクラス Regexpを拡張して次のメソッドを定義しています。

== Instance Methods

--- &(other)

[[m:RegAnd.new]](self, other) を返します。

--- |(other)

[[m:RegOr.new]](self, other) を返します。



= class RegAnd < Object

== Class Methods

--- new(re1, re2)

新しい RegAnd オブジェクトを生成します。

== Instance Methods

--- =~(str)

str が re1 と re2 の両方にマッチすれば真を返します。



= class RegOr < Object

== Class Methods

--- new(re1, re2)

新しい RegOr オブジェクトを生成します。

== Instance Methods

--- =~(str)

str が re1 か re2 のいずれかにマッチすれば真を返します。
