= module DL::Importable

=== 補足

実際には、メソッドは、
DL::Importable::Internal において定義されています。
Importable モジュールは
Internal モジュールをインクルードしているために、
Internal で定義されたメソッドは
Importable モジュールによって提供されます。

== Instance Methods

--- dlload(lib,...)

[[m:DL.dlopen]] を用いてライブラリをロードし、extend した
モジュール内でそのライブラリで定義されている参照可能なシンボルを取得できるよ
うにします。

--- extern(prototype)

C の関数プロトタイプを与えることによって、その関数を呼び出すメソッドを動的に
定義することができます。頭文字が大文字の場合は小文字に自動的に変換されます。

--- callback(proto)

C の関数プロトタイプを与えることによって、既に定義された Ruby のメソッドを C の
コールバック関数として扱うことができるようにします。
[[c:DL::Symbol]] オブジェクトを返す。

--- typealias(newtype, oldtype)

newtype 型を oldtype 型のエイリアスとして定義する。
newtype で与えた型は extern や callback メソッド
のプロトタイプを与えるときに利用します。

--- symbol(sym[, typespec])

シンボル名が sym のシンボルを取り出す。
typespec には型情報を与えて、[[c:DL::Symbol]]オブジェクトを返します。
typespecが省略された場合、シンボルへの参照を[[c:DL::PtrData]]オブジェクト
として返します。
