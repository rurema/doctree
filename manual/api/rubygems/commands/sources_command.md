---
type: library
require:
  - rubygems/command
  - rubygems/remote_fetcher
  - rubygems/source_info_cache
  - rubygems/spec_fetcher
---
Gem パッケージの取得元の情報を管理するためのライブラリです。

```text
Usage: gem sources [options]
  Options:
    -a, --add SOURCE_URI             取得元を追加します
    -l, --list                       取得元一覧を表示します
    -r, --remove SOURCE_URI          取得元を削除します
    -u, --update                     取得元のキャッシュを更新します
    -c, --clear-all                  全ての取得元を削除し、キャッシュもクリアします
```

#@include(common_options)

```text
Summary:
  Gem パッケージの取得元の情報を管理します
Defaults:
  --list
```

# class Gem::Commands::SourcesCommand < Gem::Command

Gem パッケージの取得元の情報を管理するためのクラスです。

