require rubygems/indexer

Gem のインデックスを構築するための抽象クラスを扱うライブラリです。

テンプレートパターンを使用しています。

= class Gem::Indexer::AbstractIndexBuilder

Gem のインデックスを構築するための抽象クラスです。

テンプレートパターンを使用しています。

== Public Instance Methods

--- build{ ... }
#@# -> discard
Gem のインデックスを作成します。

実際のインデックスを作成する処理の詳細は与えられたブロックに記述されています。
基本的な処理をカスタマイズするために、適切なタイミングで
begin_index, end_index, cleanup が呼び出されるようになっています。

--- cleanup -> nil

インデックスファイルを閉じたあとに呼び出されます。

--- compress(filename, ext = 'rz')
#@# -> discard
与えられたファイルを圧縮します。

@param filename 圧縮するファイルの名前を指定します。

@param ext 圧縮後のファイルの拡張子を指定します。

--- directory -> String

インデックスファイルに入れるファイルを配置しているディレクトリ名を返します。

--- end_index -> nil

[[m:Gem::Indexer::AbstractIndexBuilder#build]] 内でブロックが実行された後に呼び出されます。
インデックスファイルは有効で、@file も参照可能です。

--- filename -> String

作成するインデックスファイルの名前を返します。

--- files -> [String]

作成するインデックスファイルに含まれるファイルのリストを返します。

--- start_index -> nil

[[m:Gem::Indexer::AbstractIndexBuilder#build]] 内でブロックが実行される前に呼び出されます。
インデックスファイルは有効で、@file も参照可能です。

--- unzip(string) -> String

与えられた圧縮済み文字列を展開して返します。

@param string 圧縮されているデータを指定します。

@see [[m:Zlib::Inflate.inflate]]

--- zip(string) -> String

与えられた文字列を圧縮して返します。

@param string 圧縮するデータを指定します。

@see [[m:Zlib::Deflate.deflate]]

== Singleton Methods

--- new(filename, directory) -> Gem::Indexer::AbstractIndexBuilder

自身を初期化します。

@param filename 作成するインデックスを保存するファイル名です。

@param directory インデックスファイルを保存する作業ディレクトリです。
