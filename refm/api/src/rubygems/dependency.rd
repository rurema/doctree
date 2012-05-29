
Gem の依存関係を管理するためのライブラリです。

= class Gem::Dependency

Gem の依存関係を管理するクラスです。

== Public Instance Methods

--- <=>(other) -> Integer

self と other を [[m:Gem::Dependency#name]] の ASCII コードで比較して
self が大きい時には正の整数、等しい時には 0、小さい時には負の整数を返します。

--- =~(other) -> bool

self と other を比較して真偽値を返します。

self の [[m:Gem::Dependency#name]] が正規表現として other とマッチしない場合は偽を返します。
self が other との依存関係を満たしていれば真を返します。満たしていなければ偽を返します。

--- name -> String

依存関係の名前を文字列か正規表現で返します。

--- name=(name)

依存関係の名前を文字列か正規表現でセットします。

#@until 1.9.2
--- normalize -> nil
#@todo ???

@see [[c:Gem::Requirement]]
#@end
--- requirement_list  -> [String]
--- requirements_list -> [String]

バージョンの必要条件を文字列の配列として返します。

--- type -> Symbol

依存関係の型を返します。

--- version_requirements -> Gem::Requirement

依存しているバージョンを返します。

--- version_requirements=(version_requirements)

依存しているバージョンを設定します。

@param version_requirements [[c:Gem::Requirement]] のインスタンスを指定します。

== Constants

--- TYPES -> Array

有効な依存関係の型を表す配列です。

@see [[m:Gem::Specification::CURRENT_SPECIFICATION_VERSION]]
