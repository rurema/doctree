require rubygems/version

Gem パッケージのバージョンに関する必須条件を扱うためのライブラリです。

= class Gem::Requirement
alias Gem::Version::Requirement
include Comparable

Gem の必要条件を扱うクラスです。

このクラスのインスタンスには複数の必要条件を含めることができます。

== Constants

--- OPS -> Hash

比較演算子と対応する処理を格納したハッシュです。

--- OP_RE

比較演算子のいずれかにマッチする正規表現です。

== Singleton Methods

--- create(input) -> Gem::Requirement

[[c:Gem::Requirement]] のインスタンスを作成するためのファクトリメソッドです。

@param input 文字列か配列か [[c:Gem::Requirement]], [[c:Gem::Version]] のインスタンス
             のいずれかを指定します。

@return 上記以外の値を input に指定するとデフォルト値を返します。

@see [[m:Gem::Requirement.new]], [[m:Gem::Requirement.default]]

--- default -> Gem::Requirement

ゼロ以上 ( '>= 0' ) を指定して作成された [[c:Gem::Requirement]] のインスタンスを返します。


--- new(requirements) -> Gem::Requirement

[[c:Gem::Requirement]] のインスタンスを作成します。

@param requirements 文字列か配列か [[c:Gem::Version]] のインスタンスを指定します。

@see [[m:Gem::Requirement#parse]], [[m:Gem::Requirement.create]]

== Public Instance Methods

#@#--- <=>(other) -> Integer
#@# nodoc

#@#--- as_list -> [String]
#@# nodoc
#@#必要条件を文字列の配列で返します。

#@#--- marshal_dump -> Array
#@# nodoc
#@#必要条件のみを [[m:Marshal.#dump]] で使用するために返します。

#@#--- marshal_load(array) -> Gem::Requirement
#@# nodoc
#@#必要条件をロードします。

--- normalize -> nil

self を正規化します。

--- parse(obj) -> Array

バージョンの必要上件をパースして比較演算子とバージョンを要素とする二要素の配列を返します。

@param obj 必要上件を表す文字列または [[c:Gem::Version]] のインスタンスを指定します。

@return 比較演算子と [[c:Gem::Version]] のインスタンスを要素とする二要素の配列を返します。

@raise ArgumentError obj に不正なオブジェクトを指定すると発生します。

#@#--- requirements -> Array
#@# nodoc
#@#自身に含まれる必要条件の配列を返します。
#@#
#@#配列に含まれる各要素は、比較演算子と [[c:Gem::Version]] のインスタンスを要素とする二要素の配列です。


--- satisfied_by?(version) -> bool

引数 version が自身に含まれる全ての必要条件を満たす場合に真を返します。
そうでなければ偽を返します。

@param version [[c:Gem::Version]] のインスタンスを指定します。

@see [[m:Gem::Requirement#satisfy?]]

--- satisfy?(op, version, required_version) -> bool

version op required_version を満たす場合に真を返します。
そうでなければ偽を返します。

@param op 比較演算子 (<, <=, =, =>, >, !=, ~>) を文字列で指定します。

@param version  外部から与えられるバージョンを [[c:Gem::Version]] のインスタンスで指定します。

@param required_version 満たすべき条件を示すバージョンを指定します。

@see [[m:Gem::Requirement#satisfied_by?]]

#@#--- to_s -> String
#@# nodoc


