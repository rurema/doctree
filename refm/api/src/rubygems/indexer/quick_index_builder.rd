require rubygems/indexer

全ての gemspec をインクリメンタルにロードするためのライブラリです。

= class Gem::Indexer::QuickIndexBuilder < Gem::Indexer::AbstractIndexBuilder

全ての gemspec をインクリメンタルにロードするためのクラスです。

== Public Instance Methods
--- add(spec)
#@# -> discard
与えられた [[c:Gem::Specification]] のインスタンスをインデックスに追加します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- add_marshal(spec)
#@# -> discard
与えられた [[c:Gem::Specification]] のインスタンスを YAML 形式でファイルに書き出します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- add_yaml(spec)
#@# -> discard
与えられた [[c:Gem::Specification]] のインスタンスを [[m:Marshal.#dump]] してファイルに書き出します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- cleanup
#@# -> discard
インデックスファイルを圧縮します。

@see [[m:Gem::Indexer::AbstractIndexBuilder#cleanup]]

