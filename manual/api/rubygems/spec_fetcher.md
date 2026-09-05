---
type: library
include:
  - Gem::UserInteraction
require:
  - rubygems
  - rubygems/remote_fetcher
  - rubygems/user_interaction
---
リモートリポジトリから Gem のメタデータを取得して更新するためのライブラリです。

# class Gem::SpecFetcher

リモートリポジトリから Gem のメタデータを取得して更新するためのクラスです。

## Singleton Methods

### def Gem::SpecFetcher.fetcher -> Gem::SpecFetcher

このクラスの唯一のインスタンスを返します。

#%# singleton ?

### def Gem::SpecFetcher.fetcher=(fetcher)
#%todo

## Instance Methods

### def latest_specs -> Hash

キャッシュされている最新の gemspec を返します。

### def specs -> Hash

キャッシュされている全ての gemspec を返します。

