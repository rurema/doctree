---
type: library
---
tar アーカイブ中のそれぞれのエントリを扱うためのクラスを提供するライブ
ラリです。

# class Gem::Package::TarReader::Entry

tar アーカイブ中のそれぞれのエントリを扱うためのクラスです。

## Public Instance Methods

### def bytes_read -> Integer

自身から読み込んだバイト数を返します。

#@#--- check_closed
#@# nodoc

### def close -> true

自身を close します。

### def closed? -> bool

自身が close 済みである場合、真を返します。
そうでない場合は、偽を返します。

### def directory? -> bool

自身がディレクトリであれば、真を返します。
そうでない場合は、偽を返します。

### def eof? -> bool

自身を最後まで読み込んでいる場合は、真を返します。
そうでない場合は、偽を返します。

### def file? -> bool

自身がファイルであれば、真を返します。
そうでない場合は、偽を返します。

### def full_name -> String

自身の完全な名前を返します。

### def getc -> String | nil

自身から外部エンコーディングに従い 1 文字読み込んで返します。
EOF に到達した時には nil を返します。

### def header -> Gem::Package::TarHeader

自身のヘッダを返します。

### def pos -> Integer

自身から読み込んだバイト数を返します。

### def read(length = nil) -> String

自身から指定されたバイト数読み込みます。

- **param** `length` -- 読み込むバイト数を指定します。
              省略すると全てを読み込みます。

### def rewind -> 0

ファイルポインタを先頭に移動します。

- **raise** `Gem::Package::NonSeekableIO` -- シークできない場合に発生します。
