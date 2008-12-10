require rubygems/indexer

マスターとなる Gem のインデックスファイルを作成するためのライブラリです。

= class Gem::Indexer::MasterIndexBuilder < Gem::Indexer::AbstractIndexBuilder

マスターとなる Gem のインデックスファイルを作成するためのクラスです。

== Public Instance Methods

--- add(spec)
#@todo

自身が持つインデックスに与えられた [[c:Gem::Specification]] のインスタンスを追加します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- cleanup
#@todo

@see [[m:Gem::Indexer::AbstractIndexBuilder#cleanup]]

--- end_index
#@todo

@see [[m:Gem::Indexer::AbstractIndexBuilder#end_index]]

--- start_index
#@todo

@see [[m:Gem::Indexer::AbstractIndexBuilder#start_index]]

