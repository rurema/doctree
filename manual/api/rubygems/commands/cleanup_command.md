---
type: library
require:
  - rubygems/command
  - rubygems/source_index
  - rubygems/dependency_list
---
ローカルにインストールされている古い Gem を削除するライブラリです。

```console
Usage: gem cleanup [GEMNAME ...] [options]
  Options:
    -d, --dryrun
```

#@include(common_options)

```console
Arguments:
  GEMNAME       削除する Gem パッケージの名前を指定します
Summary:
  ローカルリポジトリにインストールされている古いバージョンの
  Gem パッケージを削除します
Defaults:
  --no-dryrun
```

# class Gem::Commands::CleanupCommand < Gem::Command

ローカルにインストールされている古い Gem を削除するクラスです。

