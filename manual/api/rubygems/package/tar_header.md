---
type: library
---
tar アーカイブの各エントリのヘッダを表すクラスを提供するライブラリです。

# class Gem::Package::TarHeader

tar アーカイブの各エントリのヘッダを表すクラスです。

  - [man:tar(5)]

## Public Instance Methods

### def ==(other) -> bool

自身と other が等しければ真を返します。
そうでない場合は偽を返します。

- **param** `other` -- 比較対象のオブジェクトを指定します。

### def checksum -> Integer

tar のヘッダに含まれるチェックサムを返します。

### def devmajor -> Integer

tar のヘッダに含まれる devmajor を返します。

### def devminor -> Integer

tar のヘッダに含まれる devminor を返します。

### def empty? -> bool

ヘッダが "\0" で埋められている場合、真を返します。
そうでない場合は、偽を返します。

### def gid -> Integer

tar のヘッダに含まれる gid を返します。

### def gname -> String

tar のヘッダに含まれるグループ名を返します。

### def linkname -> String

tar のヘッダに含まれる linkname を返します。

### def magic -> String

tar のヘッダに含まれる magic を返します。

### def mode -> Integer

tar のヘッダに含まれる mode を返します。

### def mtime -> Integer

tar のヘッダに含まれる mtime を返します。

### def name -> String

tar のヘッダに含まれる name を返します。

### def prefix -> String

tar のヘッダに含まれる prefix を返します。

### def size -> Integer

tar のヘッダに含まれる size を返します。

### def to_s -> String

ヘッダの情報を文字列として返します。

### def typeflag -> String

tar のヘッダに含まれる typeflag を返します。

### def uid -> Integer

tar のヘッダに含まれる uid を返します。

### def uname -> String

tar のヘッダに含まれるユーザ名を返します。

### def update_checksum
#@# -> discard
チェックサムを更新します。

### def version -> Integer

tar のヘッダに含まれる version を返します。

## Singleton Methods

### def from(stream) -> Gem::Package::TarHeader

stream から先頭 512 バイトを読み込んで [c:Gem::Package::TarHeader] の
インスタンスを作成して返します。

- **param** `stream` -- IO のように read メソッドを持つオブジェクトを指定します。

## Constants

### const FIELDS -> Array

内部で使用します。

### const PACK_FORMAT -> String

内部で使用します。

### const UNPACK_FORMAT -> String

内部で使用します。

