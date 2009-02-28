require rubygems/indexer

##
# Construct a quick index file and all of the individual specs to support
# incremental loading.

= class Gem::Indexer::QuickIndexBuilder < Gem::Indexer::AbstractIndexBuilder

== Public Instance Methods
--- add(spec)
#@todo

与えられた [[c:Gem::Specification]] のインスタンスをインデックスに追加します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- add_marshal(spec)
#@todo

--- add_yaml(spec)
#@todo

--- cleanup
#@todo

@see [[m:Gem::Indexer::AbstractIndexBuilder#cleanup]]

