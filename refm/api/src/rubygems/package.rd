require rubygems/digest/md5
require rubygems/security
require rubygems/specification
#@# --
require rubygems/package/f_sync_dir
require rubygems/package/tar_header
require rubygems/package/tar_input
require rubygems/package/tar_output
require rubygems/package/tar_reader
require rubygems/package/tar_reader/entry
require rubygems/package/tar_writer

このライブラリは Gem パッケージを扱うためのライブラリです。

= class Gem::FileOperations

このクラスは [[c:FileUtils]] のラッパーです。

ロギングの機能を追加しています。

== Singleton Methods

--- new(logger = nil) -> Gem::FileOperations

このクラスを初期化します。

@param logger ロガーを指定します。ロガーは log という名前のメソッドを持っている必要があります。

= module Gem::Package


== Singleton Methods

--- open(io, mode = 'r', signer = nil){|tar_io| ... }
#@todo ???

io を開いて与えられたブロックに渡してブロックを評価します。

@param io IO オブジェクトを指定します。普通は Gem パッケージを開いたファイルオブジェクトを指定します。

@param mode モードを文字列で指定します。指定できるモードは読み込み (r) と書き込み (w) です。

@param signer ???


--- pack(src, destname, signer = nil)
#@todo

???

@param src ???

@param destname ???

@param signer ???

= class Gem::Package::Error < StandardError

[[c:Gem::Package]] での基本的な例外です。

= class Gem::Package::NonSeekableIO < Gem::Package::Error

シークできない IO に対してシーク使用とした場合に発生する例外です。

= class Gem::Package::ClosedIO < Gem::Package::Error

既に閉じている IO を操作した場合に発生する例外です。

= class Gem::Package::BadCheckSum < Gem::Package::Error

チェックサムが一致しない場合に発生する例外です。

= class Gem::Package::TooLongFileName < Gem::Package::Error

ファイル名が長すぎる場合に発生する例外です。

= class Gem::Package::FormatError < Gem::Package::Error

フォーマットに関する例外です。
