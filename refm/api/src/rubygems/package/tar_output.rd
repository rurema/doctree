
gem-format な tar ファイルを書き出す [[c:Gem::Package::TarWriter]] のラッ
パークラスを提供するライブラリです。

= class Gem::Package::TarOutput

gem-format な tar ファイルを書き出す [[c:Gem::Package::TarWriter]] のラッ
パークラスです。

== Public Instance Methods

--- add_gem_contents{|data_tar_writer| ... } -> self

gem-format な tar ファイル内の data.tar.gz にファイルを追加するためのメ
ソッドです。

ブロックには data.tar.gz に紐付いた [[c:Gem::Package::TarWriter]] のイ
ンスタンスが渡されます。このブロックパラメータには
[[c:Gem::Specification]] を追加するための metadata, metadata= という特
異メソッドが追加されています。

--- add_metadata
#@# -> discard
gem-format な tar ファイルに metadata.gz を追加します。

前回の [[m:Gem::Package::TarOutput#add_gem_contents]] の呼び出し以降に
変更したメタデータを書き込みます。

--- add_signatures
#@# -> discard
gem-format な tar ファイルに data.tar.gz.sig, metadata.gz.sig を追加します。

@see [[c:Gem::Security::Signer]]

--- close
#@# -> discard

自身に関連付けられた IO を close します。

== Singleton Methods

--- open(io, signer = nil){|data_tar_writer| ... }
#@# -> discard

gem-format な tar ファイル内の data.tar.gz にファイルを追加するためのメ
ソッドです。

@param io gem-format な tar ファイルを扱うための IO を指定します。

@param signer [[c:Gem::Security::Signer]] のインスタンスを指定します。

@see [[m:Gem::Package::TarOutput#add_gem_contents]]

--- new(io, signer) -> Gem::Package::TarOutput

gem-format な tar ファイル内の data.tar.gz にファイルを追加するために
自身を初期化します。

@param io gem-format な tar ファイルを扱うための IO を指定します。

@param signer [[c:Gem::Security::Signer]] のインスタンスを指定します。

@see [[c:Gem::Security::Signer]]
