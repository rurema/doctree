require dl
require dl/types

= module DL::Importable

include DL::Importable::Internal

=== 補足

実際には、メソッドは、
DL::Importable::Internal において定義されています。
Importable モジュールは
Internal モジュールをインクルードしているために、
Internal で定義されたメソッドは
Importable モジュールによって提供されます。

== Constants

--- LIB_MAP
#@todo

ロードされたライブラリを保持する[[c:Hash]]オブジェクトです。

= module DL::Importable::Internal

== Instance Methods

--- dlload(lib, ...)
--- dllink(lib, ...)
#@todo

[[m:DL.dlopen]] を用いてライブラリをロードし、extend した
モジュール内でそのライブラリで定義されている参照可能なシンボルを取得できるよ
うにします。

--- extern(prototype)
#@todo

C の関数プロトタイプを与えることによって、その関数を呼び出すメソッドを動的に
定義することができます。頭文字が大文字の場合は小文字に自動的に変換されます。

--- callback(proto)
#@todo

C の関数プロトタイプを与えることによって、既に定義された Ruby のメソッドを C の
コールバック関数として扱うことができるようにします。
[[c:DL::Symbol]] オブジェクトを返す。

--- typealias(newtype, oldtype)
#@todo

newtype 型を oldtype 型のエイリアスとして定義する。
newtype で与えた型は extern や callback メソッド
のプロトタイプを与えるときに利用します。

--- symbol(sym, [typespec])
#@todo

シンボル名が sym のシンボルを取り出す。
typespec には型情報を与えて、[[c:DL::Symbol]]オブジェクトを返します。
typespecが省略された場合、シンボルへの参照を[[c:DL::PtrData]]オブジェクト
として返します。

--- []
#@todo

@if (version >= "1.8.2")
--- encode_argument_types(tys)
#@todo

@end

@if (version <= "1.8.1")
--- encode_types
#@todo

@end

--- import(name, rettype, argtypes = nil)
#@todo

#@# example:
#@##   import("get_length", "int", ["void*", "int"])

--- parse_cproto(proto)
#@todo

--- init_sym
#@todo

--- init_types
#@todo

--- _args_
#@todo

--- _retval_
#@todo

