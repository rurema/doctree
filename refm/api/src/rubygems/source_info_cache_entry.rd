require rubygems
require rubygems/source_index
require rubygems/remote_fetcher

[[c:Gem::SourceInfoCache]] が持つエントリを表すためのライブラリです。

= class Gem::SourceInfoCacheEntry

[[c:Gem::SourceInfoCache]] が持つエントリを表すためのクラスです。

== Public Instance Methods

--- refresh(source_uri, all) -> Gem::SourceIndex

ソースインデックスを更新します。

@param source_uri データを取得する URI を指定します。

@param all 全てのインデックスを更新するかどうかを指定します。

--- size -> Integer

ソースエントリのサイズです。

ソースインデックスが変化したことを検出するために使用します。

--- source_index -> Gem::SourceIndex

このキャッシュエントリに対するソースインデックスです。

== Singleton Methods

--- new(si, size) -> Gem::SourceInfoCacheEntry

キャッシュのエントリを作成します。

@param si [[c:Gem::SourceIndex]] のインスタンスを指定します。

@param size エントリのサイズを指定します。
