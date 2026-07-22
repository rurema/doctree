---
type: library
include:
  - Gem::VersionOption
require:
  - rubygems/command
  - rubygems/format
  - rubygems/installer
  - rubygems/version_option
---
インストールされている Gem パッケージを初期状態にするためのライブラリです。

```text
Usage: gem pristine [args] [options]
  Options:
        --all                        インストールされている全ての Gem パッケージを
                                     初期状態に戻します
    -v, --version VERSION            指定したバージョンの Gem パッケージを
                                     初期状態に戻します
```

#@include(common_options)

```text
Arguments:
  GEMNAME       gem to restore to pristine condition (unless --all)
Summary:
  Restores installed gems to pristine condition from files located in the gem
  cache
Description:
  The pristine command compares the installed gems with the contents of the
  cached gem and restores any files that don't match the cached gem's copy.
      
  If you have made modifications to your installed gems, the pristine command
  will revert them.  After all the gem's files have been checked all bin stubs
  for the gem are regenerated.
      
  If the cached gem cannot be found, you will need to use `gem install` to
  revert the gem.
Defaults:
  --all
```

# class Gem::Commands::PristineCommand < Gem::Command

インストールされている Gem パッケージを初期状態にするためのクラスです。

