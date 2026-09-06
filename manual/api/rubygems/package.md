---
type: library
require:
  - rubygems/digest/md5
  - rubygems/security
  - rubygems/specification
  - rubygems/package/f_sync_dir
  - rubygems/package/tar_header
  - rubygems/package/tar_input
  - rubygems/package/tar_output
  - rubygems/package/tar_reader
  - rubygems/package/tar_reader/entry
  - rubygems/package/tar_writer
---
このライブラリは Gem パッケージを扱うためのライブラリです。

# module Gem::Package

## Singleton Methods

### def Gem::Package.open(io, mode = 'r', signer = nil){|tar_io| ... }
#%todo ???

io を開いて与えられたブロックに渡してブロックを評価します。

- **param** `io` -- IO オブジェクトを指定します。普通は Gem パッケージを開いたファイルオブジェクトを指定します。

- **param** `mode` -- モードを文字列で指定します。指定できるモードは読み込み (r) と書き込み (w) です。

- **param** `signer` -- ???

# class Gem::Package::Error < StandardError

[c:Gem::Package] での基本的な例外です。

# class Gem::Package::NonSeekableIO < Gem::Package::Error

シークできない IO に対してシーク使用とした場合に発生する例外です。

# class Gem::Package::ClosedIO < Gem::Package::Error

既に閉じている IO を操作した場合に発生する例外です。

# class Gem::Package::BadCheckSum < Gem::Package::Error

チェックサムが一致しない場合に発生する例外です。

# class Gem::Package::TooLongFileName < Gem::Package::Error

ファイル名が長すぎる場合に発生する例外です。

# class Gem::Package::FormatError < Gem::Package::Error

フォーマットに関する例外です。
