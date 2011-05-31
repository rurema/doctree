tar アーカイブの各エントリのヘッダを表すクラスを提供するライブラリです。

= class Gem::Package::TarHeader

tar アーカイブの各エントリのヘッダを表すクラスです。

  * [[man:tar(5)]]

== Public Instance Methods

--- ==(other) -> bool

自身と other が等しければ真を返します。
そうでない場合は偽を返します。

@param other 比較対象のオブジェクトを指定します。

--- checksum -> Integer

tar のヘッダに含まれるチェックサムを返します。

--- devmajor -> Integer

tar のヘッダに含まれる devmajor を返します。

--- devminor -> Integer

tar のヘッダに含まれる devminor を返します。

--- empty? -> bool

ヘッダが "\0" で埋められている場合、真を返します。
そうでない場合は、偽を返します。

--- gid -> Integer

tar のヘッダに含まれる gid を返します。

--- gname -> String

tar のヘッダに含まれるグループ名を返します。

--- linkname -> String

tar のヘッダに含まれる linkname を返します。

--- magic -> String

tar のヘッダに含まれる magic を返します。

--- mode -> Integer

tar のヘッダに含まれる mode を返します。

--- mtime -> Integer

tar のヘッダに含まれる mtime を返します。

--- name -> String

tar のヘッダに含まれる name を返します。

--- prefix -> String

tar のヘッダに含まれる prefix を返します。

--- size -> Integer

tar のヘッダに含まれる size を返します。

--- to_s -> String

ヘッダの情報を文字列として返します。

--- typeflag -> String

tar のヘッダに含まれる typeflag を返します。

--- uid -> Integer

tar のヘッダに含まれる uid を返します。

--- uname -> String

tar のヘッダに含まれるユーザ名を返します。

--- update_checksum
#@# -> discard
チェックサムを更新します。

--- version -> Integer

tar のヘッダに含まれる version を返します。

== Singleton Methods

--- from(stream) -> Gem::Package::TarHeader

stream から先頭 512 バイトを読み込んで [[c:Gem::Package::TarHeader]] の
インスタンスを作成して返します。

@param stream IO のように read メソッドを持つオブジェクトを指定します。

== Constants

--- FIELDS -> Array

内部で使用します。

--- PACK_FORMAT -> String

内部で使用します。

--- UNPACK_FORMAT -> String

内部で使用します。

