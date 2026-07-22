---
type: library
require:
  - rubygems/command
  - rubygems/version_option
  - rubygems/validator
---
インストールされている Gem パッケージを検証するためのライブラリです。

```console
Usage: gem check [options]
  Options:
        --verify FILE                内部のチェックサムにより Gem パッケージを検証します
    -a, --alien                      管理されていないパッケージを報告します
    -t, --test                       Gem パッケージのユニットテストを実行します
    -v, --version VERSION            特定のバージョンのテストを実行します
```

#@include(common_options)

```console
Summary:
  インストールされている Gem パッケージをチェックします
```

# class Gem::Commands::CheckCommand < Gem::Command

インストールされている Gem パッケージを検証するためのクラスです。

