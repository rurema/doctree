require dl
require dl/types

= module DL::Importable

DL モジュールの各クラスの便利なラッパーです。

Importable モジュールは、モジュールから extend を呼んで使います。include ではありません。
クラスやオブジェクトから extend を呼んで使うことはできません。

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

--- extern(proto)    -> DL::Symbol
#@todo

与えられたプロトタイプにしたがって、ダイナミックライブラリ内のシンボルを検索し、
自身の特異メソッドとして、定義します。

@param proto C の関数プロトタイプを与えます。頭文字が大文字の場合は小文字に自動的に変換されます。

  require "dl/import"
  
  module M
    extend DL::Importable
    dlload "libc.so.6"
    extern "double strtod(char*, void**)"
  end
  
  p M.strtod("1.23", nil) #=> 1.23

--- callback(proto)    -> DL::Symbol
#@todo

与えられたプロトタイプにしたがって、自身のインスタンスメソッドを
C のコールバック関数に変換し、[[c:DL::Symbol]] として返します。

@param proto C の関数プロトタイプを与えます。頭文字が大文字の場合は小文字に自動的に変換されます。

 require 'dl/import'
 module M
   extend DL::Importable
   dlload "libc.so.6"
 
   def cmp(a, b)
     a.ptr.to_s[-1] <=> b.ptr.to_s[-1]
   end
   callback 'int cmp(const char **, const char **)'
   extern 'void qsort(void *, int, int, void *)'
 end
 
 a = ['1b', '2a', '3c']
 ap = a.to_ptr
 M.qsort(ap, a.size, DL.sizeof('P'), M['cmp'])
 p ap.to_a('P').map{|s| s.to_s } #=> ["2a", "1b", "3c"]

--- typealias(newtype, oldtype)    -> ()
#@todo

newtype 型を oldtype 型のエイリアスとして定義する。
newtype で与えた型は extern や callback メソッド
のプロトタイプを与えるときに利用します。

--- symbol(sym, typespec = nil)    -> DL::Symbol 
#@todo

ロードしたダイナミックライブラリ内のシンボルを検索し
名前が sym のシンボルを取り出します。

@param sym 欲しいシンボル名を文字列で与えます。

@param typespec 型情報を与えます。

@raise RuntimeError ライブラリ内でシンボルが見つからない時に発生します。

--- [](func)    -> nil |  DL::Symbol

[[m:DL::Importable#extern]]、[[m:DL::Importable#import]] または
[[m:DL::Importable#callback]] によって定義した、
C レベルの関数 func に対応する [[DL::Symbol]] オブジェクトを返します。

定義していない場合は、nil を返します。

@param func 取得したい関数名を文字列で与えます。

--- import(name, rettype, argtypes = nil)    -> DL::Symbol
#@todo

#@# example:
#@##   import("get_length", "int", ["void*", "int"])

--- _args_ -> [object]

直前に呼んだダイナミックライブラリの関数の引数の配列を返します。

--- _retval_ -> object

直前に呼んだダイナミックライブラリの関数の返り値を返します。

== Constants

--- LIB_MAP
#@todo
ロードされたライブラリを保持する[[c:Hash]]オブジェクトです。
