require rubygems/indexer

マスターとなる Gem のインデックスファイルを作成するためのライブラリです。

= class Gem::Indexer::MasterIndexBuilder < Gem::Indexer::AbstractIndexBuilder

マスターとなる Gem のインデックスファイルを作成するためのクラスです。

== Public Instance Methods

--- add(spec)
#@# -> discard

自身が持つインデックスに与えられた [[c:Gem::Specification]] のインスタンスを追加します。

@param spec インデックスに追加する [[c:Gem::Specification]] のインスタンスを指定します。

--- cleanup
#@# -> discard
インデックスファイルを圧縮します。

@see [[m:Gem::Indexer::AbstractIndexBuilder#cleanup]]

--- end_index
#@# -> discard
取得したインデックスをファイルに書き込みます。

@see [[m:Gem::Indexer::AbstractIndexBuilder#end_index]]

--- start_index
#@# -> discard
インデックスの取得を始める準備をします。

@see [[m:Gem::Indexer::AbstractIndexBuilder#start_index]]

