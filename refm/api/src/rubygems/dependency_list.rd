

= class Gem::DependencyList

include TSort

== Public Instance Methods

--- add(*gemspecs)
#@todo

与えられた [[c:Gem::Specification]] のインスタンスを自身に追加します。

@param gemspecs [[c:Gem::Specification]] のインスタンスを一つ以上指定します。

--- dependency_order -> [Gem::Specification]
#@todo

#@# 自信なし
依存する Gem の数が少ない順にソートされた [[c:Gem::Specification]] のリストを返します。

--- find_name(full_name) -> Gem::Specification | nil
#@todo

自身に含まれる与えられた名前を持つ [[c:Gem::Specification]] のインスタンスを返します。

見つからなかった場合は nil を返します。

@params full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]]

--- ok? -> bool
#@todo

自身に含まれる全ての [[c:Gem::Specification]] が依存関係を満たしていれば真を返します。
そうでない場合は、偽を返します。

--- ok_to_remove?(full_name) -> bool
#@todo

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除しても OK な場合は真を返します。
そうでない場合は、偽を返します。

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除すると、
依存関係を壊してしまう場合が、それを削除してはいけない場合です。

@params full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]]

--- remove_by_name(full_name) -> Gem::Specification
#@todo

与えられた名前を持つ [[c:Gem::Specification]] を自身から削除します。

このメソッドでは削除後の依存関係をチェックしません。

@params full_name バージョンを含むフルネームで Gem の名前を指定します。

@see [[m:Gem::Specification#full_name]], [[m:Array#delete_if]]

--- spec_predecessors -> Hash
#@todo

#@# よくわからない。
#@# [[c:Gem::Specification]] => Array of [[c:Gem::Specification]]


== Singleton Methods

--- from_source_index(src_index) -> Gem::DependencyList
#@todo

与えられた [[c:Gem::SourceIndex]] のインスタンスから自身を作成します。

@param src_index [[c:Gem::SourceIndex]] を指定します。

@see [[c:Gem::SourceIndex]]
