---
type: library
include:
  - Gem::LocalRemoteOptions
  - Gem::VersionOption
require:
  - rubygems/command
  - rubygems/local_remote_options
  - rubygems/version_option
  - rubygems/source_info_cache
---
インストールされている Gem パッケージの依存関係を表示するためのライブラリです。

```text
Usage: gem dependency GEMNAME [options]
  Options:
    -v, --version VERSION            指定したバージョンの依存関係を表示します
        --platform PLATFORM          指定したプラットフォームの依存関係を表示します
    -R, --[no-]reverse-dependencies  この Gem を使用している Gem を表示します
    -p, --pipe                       Pipe Format (name --version ver)
```

#@include(local_remote_options)
#@include(common_options)

```text
Arguments:
  GEMNAME       依存関係を表示する Gem の名前を指定します
Summary:
  インストールされている Gem の依存関係を表示します
Defaults:
  --local --version '>= 0' --no-reverse-dependencies
```

# class Gem::Commands::DependencyCommand < Gem::Command

インストールされている Gem パッケージの依存関係を表示するためのクラスです。

## Public Instance Methods

### def usage -> String

使用方法を表す文字列を返します。

### def arguments -> String

引数の説明を表す文字列を返します。

### def execute -> ()

コマンドを実行します。

### def find_gems(name, source_index) -> Hash

与えられた Gem の名前をインデックスから検索します。

- **param** `name` -- Gem の名前を指定します。

- **param** `source_index` -- [c:Gem::SourceIndex] のインスタンスを指定します。

- **SEE** [m:Gem::SourceIndex#search]

### def find_reverse_dependencies(spec) -> Array

与えられた Gem スペックに依存する Gem のリストを返します。

- **param** `spec` -- [c:Gem::Specification] のインスタンスを指定します。

### def print_dependencies(spec, level = 0) -> String

依存関係を表す文字列を返します。

- **param** `spec` -- [c:Gem::Specification] のインスタンスを指定します。

- **param** `level` -- 依存関係の深さを指定します。
