#@since 1.9.1

[[c:Gem::Specification]] のインスタンスから Gem パッケージを作成するためのライブラリです。

= class Gem::Builder < Object
include Gem::UserInteraction

[[c:Gem::Specification]] のインスタンスから Gem パッケージを作成するためのクラスです。

== Singleton Methods

--- new(spec) -> Gem::Builder

与えられた [[c:Gem::Specification]] のインスタンスによって
[[c:Gem::Builder]] のインスタンスを生成します。

@param spec [[c:Gem::Specification]] のインスタンスを指定します。

== Instance Methods

--- build -> String

スペックから Gem を作成する。

@return 作成したファイル名を返します。

--- success -> String

Gem の作成に成功したときに表示するメッセージを返します。

#@end

