require rubygems
require rubygems/requirement

Gem パッケージのバージョンを扱うためのライブラリです。

= class Gem::Version
include Comparable

Gem パッケージのバージョンを扱うためのクラスです。

== Public Instance Methods

--- <=>(other) -> -1 | 0 | 1 | nil
#@todo

@param other 比較対象の [[c:Gem::Version]] を指定します。

--- bump -> Gem::Version
#@todo

自身の次のバージョンを表すオブジェクトを返します。

例:
  # 5.3.1 => 5.4
  a = Gem::Version.create('5.3.1') # => #<Gem::Version "5.3.1">
  a.bump                           # => #<Gem::Version "5.4">
  
--- eql?(other) -> bool
#@todo

引数で与えられた比較対象が自身と同じバージョンを表すオブジェクトである場合に真を返します。
そうでない場合は偽を返します。

例:
  a = Gem::Version.create('1.0') # => #<Gem::Version "1.0">
  b = Gem::Version.create('1.0') # => #<Gem::Version "1.0">
  c = Gem::Version.create('1')   # => #<Gem::Version "1">
  a.eql?(b) # => true
  a.eql?(c) # => false

@param other 比較対象の [[c:Gem::Version]] を指定します。

--- ints -> [Integer]
#@todo

自身のバージョンを表す数値の配列を返します。

例:
  # 5.3.1 => 5.4
  a = Gem::Version.create('5.3.1') # => #<Gem::Version "5.3.1">
  a.ints                           # => [5, 3, 1]

--- marshal_dump -> [String]
#@todo

完全なオブジェクトではなく自身のバージョンを表す文字列をダンプします。

--- marshal_load(array) -> self
#@todo

@param array


--- normalize
#@todo

末尾のゼロを削除します。

--- to_ints -> [Integer]
#@todo

自身が表すバージョンを数値の配列として返します。

--- to_s -> String
#@todo

自身が表すバージョンを文字列として返します。


--- to_yaml_properties -> [String]
#@todo

--- version -> String
#@todo

自身を文字列として返します。

--- version=(version)
#@todo

@param version バージョンを表す文字列を指定します。

--- yaml_initialize
#@todo

== Singleton Methods

--- correct?(version) -> bool
#@todo

与えられた引数がバージョンを表す文字列として有効であれば真を返します。そうでなければ偽を返します。

@param version バージョンを表す文字列を指定します。

--- create(input) -> Gem::Version | nil
#@todo

このクラスをインスタンス化するためのファクトリメソッドです。

@param input [[c:Gem::Version]] のインスタンスか、バージョンを表す文字列を指定します。

