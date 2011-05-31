Gem の依存関係を扱うためのライブラリです。

= class Gem::DependencyList
include TSort

Gem の依存関係を扱うためのクラスです。

== Public Instance Methods

--- add(*gemspecs)
#@# -> discard

与えられた [[c:Gem::Specification]] のインスタンスを自身に追加します。

@param gemspecs [[c:Gem::Specification]] のインスタンスを一つ以上指定します。

--- dependency_order -> [Gem::Specification]

依存する Gem の数が少ない順にソートされた [[c:Gem::Specification]] のリストを返します。

このことは、インストール済みの Gem を削除するときに便利です。
このメソッドで返された順にインストール済みの Gem 削除すると、
依存関係による多くの問題を回避することができます。

If there are circular dependencies (yuck!), then gems will be
returned in order until only the circular dependents and anything
they reference are left.  Then arbitrary gemspecs will be returned
until the circular dependency is broken, after which gems will be
returned in dependency order again.

--- find_name(full_name) -> Gem::Specification | nil

自身に含まれる与えられた名前を持つ [[c:Gem::Specification]] のインスタンスを返します。

見つからなかった場合は nil を返します。

@param full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]]

--- ok? -> bool

自身に含まれる全ての [[c:Gem::Specification]] が依存関係を満たしていれば真を返します。
そうでない場合は、偽を返します。

--- ok_to_remove?(full_name) -> bool

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除しても OK な場合は真を返します。
そうでない場合は、偽を返します。

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除すると、
依存関係を壊してしまう場合が、それを削除してはいけない場合です。

@param full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]]

--- remove_by_name(full_name) -> Gem::Specification

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除します。

このメソッドでは削除後の依存関係をチェックしません。

@param full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]], [[m:Array#delete_if]]

--- spec_predecessors -> Hash
#@todo ???

Return a hash of predecessors.  <tt>result[spec]</tt> is an
Array of gemspecs that have a dependency satisfied by the named
spec.

#@# よくわからない。
#@# [[c:Gem::Specification]] => Array of [[c:Gem::Specification]]

== Singleton Methods

--- from_source_index(src_index) -> Gem::DependencyList

与えられた [[c:Gem::SourceIndex]] のインスタンスから自身を作成します。

@param src_index [[c:Gem::SourceIndex]] を指定します。

@see [[c:Gem::SourceIndex]]
