require dl
require dl/types

= module DL::Importable

DL モジュールの各クラスの便利なラッパーです。

Importable モジュールは extend して使います。include ではありません。

  require "dl/import"
  
  module M
    extend DL::Importable
    dlload "libc.so.6"
    extern "int strlen(char*)"
  end
  
  p M.strlen("abc") #=> 3

== Instance Methods

--- dlload(lib, ...)    -> ()
--- dllink(lib, ...)    -> ()
#@todo

[[m:DL.dlopen]] を用いてライブラリをロードし、extend した
モジュール内でそのライブラリで定義されている参照可能なシンボルを取得できるよ
うにします。

--- extern(prototype)    -> DL::Symbol
#@todo

C の関数プロトタイプを与えることによって、その関数を呼び出すメソッドを動的に
定義することができます。頭文字が大文字の場合は小文字に自動的に変換されます。

--- callback(proto)    -> DL::Symbol
#@todo

C の関数プロトタイプを与えることによって、既に定義された Ruby のメソッドを C の
コールバック関数として扱うことができるようにします。
[[c:DL::Symbol]] オブジェクトを返す。

@param proto 

--- typealias(newtype, oldtype)    -> ()
#@todo

newtype 型を oldtype 型のエイリアスとして定義する。
newtype で与えた型は extern や callback メソッド
のプロトタイプを与えるときに利用します。

--- symbol(sym, [typespec])    -> DL::Symbol 
#@todo

シンボル名が sym のシンボルを取り出す。
typespec には型情報を与えて、[[c:DL::Symbol]]オブジェクトを返します。

--- [](name)    -> DL::Symbol
#@todo
関数 name のラッパーである [[DL::Symbol]] オブジェクトを返します。

@param name 取得したい関数名を文字列で与えます。

--- import(name, rettype, argtypes = nil)    -> DL::Symbol
#@todo

#@# example:
#@##   import("get_length", "int", ["void*", "int"])

--- _args_ -> [object]
#@todo
直前に呼んだダイナミックライブラリの関数の引数を返します。

--- _retval_ -> object
#@todo
直前に呼んだダイナミックライブラリの関数の返り値を返します。

== Constants

--- LIB_MAP
#@todo
ロードされたライブラリを保持する[[c:Hash]]オブジェクトです。
