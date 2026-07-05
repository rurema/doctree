---
type: library
require:
  - rubygems
  - rubygems/source_index
  - rubygems/remote_fetcher
---
[c:Gem::SourceInfoCache] が持つエントリを表すためのライブラリです。

# class Gem::SourceInfoCacheEntry

[c:Gem::SourceInfoCache] が持つエントリを表すためのクラスです。

## Public Instance Methods

### def refresh(source_uri, all) -> Gem::SourceIndex

ソースインデックスを更新します。

- **param** `source_uri` -- データを取得する URI を指定します。

- **param** `all` -- 全てのインデックスを更新するかどうかを指定します。

### def size -> Integer

ソースエントリのサイズです。

ソースインデックスが変化したことを検出するために使用します。

### def source_index -> Gem::SourceIndex

このキャッシュエントリに対するソースインデックスです。

## Singleton Methods

### def new(si, size) -> Gem::SourceInfoCacheEntry

キャッシュのエントリを作成します。

- **param** `si` -- [c:Gem::SourceIndex] のインスタンスを指定します。

- **param** `size` -- エントリのサイズを指定します。
