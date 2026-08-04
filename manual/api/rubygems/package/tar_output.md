---
type: library
---
gem-format な tar ファイルを書き出す [c:Gem::Package::TarWriter] のラッパークラスを提供するライブラリです。

# class Gem::Package::TarOutput

gem-format な tar ファイルを書き出す [c:Gem::Package::TarWriter] のラッパークラスです。

## Public Instance Methods

### def add_gem_contents{|data_tar_writer| ... } -> self

gem-format な tar ファイル内の data.tar.gz にファイルを追加するためのメソッドです。

ブロックには data.tar.gz に紐付いた [c:Gem::Package::TarWriter] のインスタンスが渡されます。このブロックパラメータには
[c:Gem::Specification] を追加するための metadata, metadata= という特異メソッドが追加されています。

### def add_metadata
#%# -> discard
gem-format な tar ファイルに metadata.gz を追加します。

前回の [m:Gem::Package::TarOutput#add_gem_contents] の呼び出し以降に変更したメタデータを書き込みます。

### def add_signatures
#%# -> discard
gem-format な tar ファイルに data.tar.gz.sig, metadata.gz.sig を追加します。

- **SEE** [c:Gem::Security::Signer]

### def close
#%# -> discard

自身に関連付けられた IO を close します。

## Singleton Methods

### def Gem::Package::TarOutput.open(io, signer = nil){|data_tar_writer| ... }
#%# -> discard

gem-format な tar ファイル内の data.tar.gz にファイルを追加するためのメソッドです。

- **param** `io` -- gem-format な tar ファイルを扱うための IO を指定します。

- **param** `signer` -- [c:Gem::Security::Signer] のインスタンスを指定します。

- **SEE** [m:Gem::Package::TarOutput#add_gem_contents]

### def Gem::Package::TarOutput.new(io, signer) -> Gem::Package::TarOutput

gem-format な tar ファイル内の data.tar.gz にファイルを追加するために自身を初期化します。

- **param** `io` -- gem-format な tar ファイルを扱うための IO を指定します。

- **param** `signer` -- [c:Gem::Security::Signer] のインスタンスを指定します。

- **SEE** [c:Gem::Security::Signer]
