---
type: library
---
tar ファイルを書き込むためのクラスを提供するライブラリです。

# class Gem::Package::TarWriter

tar ファイルを書き込むためのクラスです。

## Public Instance Methods

### def add_file(name, mode) -> self
### def add_file(name, mode){|io| ... } -> self

自身に関連付けられた IO にファイルを追加します。

ブロックを与えると、自身に関連付けられた IO をブロックに渡してブロック
を評価します。

- **param** `name` -- 追加するファイルの名前を指定します。

- **param** `mode` -- 追加するファイルのパーミッションを指定します。

### def add_file_simple(name, mode, size) -> self
### def add_file_simple(name, mode, size){|io| ... } -> self

自身に関連付けられた IO にファイルを追加します。

ブロックを与えると、自身に関連付けられた IO をブロックに渡してブロック
を評価します。

- **param** `name` -- 追加するファイルの名前を指定します。

- **param** `mode` -- 追加するファイルのパーミッションを指定します。

- **param** `size` -- 追加するファイルのサイズを指定します。

### def check_closed
#@# -> discard
自身に関連付けられた IO が既に close されているかどうかチェックします。

- **raise** `IOError` -- 自身に関連付けられた IO が既に close されている場合に発
               生します。

### def close -> true

自身を close します。

### def closed? -> bool

自身が既に close されている場合は、真を返します。
そうでない場合は、偽を返します。

### def flush
#@# -> discard
自身に関連付けられた IO をフラッシュします。

### def mkdir(name, mode) -> self

自身に関連付けられた IO にディレクトリを追加します。

- **param** `name` -- 追加するディレクトリの名前を指定します。

- **param** `mode` -- 追加するディレクトリのパーミッションを指定します。

#@#--- split_name
#@# nodoc

## Singleton Methods

### def new(io) -> Gem::Package::TarWriter

自身を初期化します。

- **param** `io` -- 自身に関連付ける IO を指定します。

# class Gem::Package::TarWriter::BoundedStream

データサイズの上限がある [c:IO] のラッパークラスです。

## Singleton Methods

### def new(io, limit) -> Gem::Package::TarWriter::BoundedStream

自身を初期化します。

- **param** `io` -- ラップする IO を指定します。

- **param** `limit` -- 書き込み可能な最大のサイズを指定します。

## Public Instance Methods

### def limit -> Integer

書き込み可能な最大のサイズを返します。

### def written -> Integer

既に書き込んだデータのサイズを返します。

### def write(data) -> Integer

与えられたデータを自身に関連付けられた IO に書き込みます。

- **param** `data` -- 書き込むデータを指定します。

- **return** -- 書き込んだデータのサイズを返します。

- **raise** `Gem::Package::TarWriter::FileOverflow` -- [m:Gem::Package::TarWriter::BoundedStream#limit] を越えて
       書き込もうとした場合に発生します。

# class Gem::Package::TarWriter::RestrictedStream

write メソッドのみを提供する [c:IO] のラッパークラスです。

## Singleton Methods

### def new(io) -> Gem::Package::TarWriter::RestrictedStream

自身を初期化します。

- **param** `io` -- ラップする IO を指定します。

## Public Instance Methods

### def write(data) -> Integer

与えられたデータを自身に関連付けられた IO に書き込みます。

- **param** `data` -- 書き込むデータを指定します。

- **return** -- 書き込んだデータのサイズを返します。

# class Gem::Package::TarWriter::FileOverflow < StandardError

上限サイズを越えて書き込もうとした場合に発生する例外です。
