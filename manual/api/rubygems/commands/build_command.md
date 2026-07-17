---
type: library
require:
  - rubygems/command
  - rubygems/builder
---
Gem パッケージをビルドするためのライブラリです。


```console
Usage: gem build GEMSPEC_FILE [options]
```
#@include(common_options)
```console
Arguments:
  GEMSPEC_FILE  Gem パッケージをビルドするのに必要な gemspec ファイル名を指定します
Summary:
  gemspec ファイルから Gem パッケージをビルドします
```


# class Gem::Commands::BuildCommand < Gem::Command

Gem パッケージをビルドするためのクラスです。

## Public Instance Methods

### def execute -> ()

コマンドを実行します。

### def load_gemspecs(filename) -> Array

gemspec ファイルをロードします。

- **param** `filename` -- ファイル名を指定します。

### def usage -> String

使用方法を表す文字列を返します。

### def arguments -> String

引数の説明を表す文字列を返します。

### def yaml?(filename) -> bool

与えられたファイル名を持つファイルが yaml ファイルである場合に真を返します。

- **param** `filename` -- ファイル名を指定します。
