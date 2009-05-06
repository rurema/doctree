#@if("1.8.0" <= version and version < "1.9.1")

Ruby/DL は、UNIX の [[man:dlopen(3)]] や
Windows の LoadLibrary() などの
ダイナミックリンカへのインタフェースを提供します。

#@# 現在 dl2 の Ruby 1.8 版も開発されています。

=== Using Ruby/DL

通常は、[[c:DL::Importable]] モジュールを使用します。
これは [[c:DL]] モジュールの便利なラッパーです。
#@#のライブラリ関数にアクセスするための高水準の関数を持っています。
ある Ruby のモジュールを拡張するには以下のように使用します。

  require "dl/import"
  module LIBC
    extend DL::Importable
  end

以後、このモジュールの dlload と extern メソッドを使用できます。
以下のように dlload 使ってライブラリをロードし、
それぞれのライブラリ関数に対して extern を使用することで
ラッパーメソッドを定義します。

  module LIBC
    extend DL::Importable
    dlload "libc.so.6","libm.so.6"
    extern "int strlen(char*)"
  end
  # Note that we should not include the module M from some reason.
  
  p LIBC.strlen('abc') #=> 3

LIBC.strlen を使用することで、ライブラリ関数 strlen() を使用できます。
与えられた関数名の最初の文字が大文字なら、
定義されるメソッド名の最初の文字は小文字になります。

==== 構造体を扱う

構造体も扱うことができます。たとえば [[man:gettimeofday(2)]]
を使って現在時刻を得たい場合は以下のとおりです。

 require 'dl/import'
 module LIBC
   extend DL::Importable
   dlload "libc.so.6"
   extern('int gettimeofday(void *, void *)')
 end
 
 timeval = DL.malloc(DL.sizeof('LL'))
 timeval.struct!('LL', :tv_sec, :tv_usec)
 
 e = LIBC.gettimeofday(timeval, nil)
 if e == 0
  p timeval[:tv_sec] #=> 1173519547
 end

構造体や共用体の作成には、以下のように [[lib:dl/struct]] で定義されている
[[m:DL::Importable::Internal#struct]] メソッドや
[[m:DL::Importable::Internal#union]] メソッドを使用することもできます。

 require 'dl/import'
 require "dl/struct"

 module LIBC
   extend DL::Importable
   dlload "libc.so.6"
   extern('int gettimeofday(void *, void *)')
   Timeval = struct ["long tv_sec", "long tv_usec"]
 end
 
 timeval = LIBC::Timeval.malloc # allocate memory.
 
 e = LIBC.gettimeofday(timeval, nil)
 if e == 0
  p timeval.tv_sec #=> 1173519547
 end

上の例で、メモリの割り当てに LIBC::Timeval.new ではなく、
LIBC::Timeval.malloc を使用していることに注意してください。
LIBC::Timeval.new は作成済みの PtrData オブジェクトをラップするためのものです。

==== コールバック

以下のように モジュール関数 callback を使用したコールバックを定義できます。

  require 'dl/import'
  module M 
    extend DL::Importable
    dlload "libc.so.6"
  
    COMPARE = DL.callback('IPP'){|ptr1, ptr2|
      str1 = ptr1.ptr.to_s
      str2 = ptr2.ptr.to_s
      ret = str1[-1] <=> str2[-1]      
    }
    extern 'void qsort(void *, int, int, void *)'
  end
  
  a = ['1b', '2a', '3c']
  ap = a.to_ptr
  M.qsort(ap, a.size, DL.sizeof('P'), M::COMPARE)
  p ap.to_a('P').map{|s| s.to_s } #=> ["2a", "1b", "3c"]
  
ここで M::COMPARE は、ブロックを呼ぶ [[c:DL::Symbol]] オブジェクトです。

DL::Importable モジュールはとても便利です。
しかし、ときにはdlsym() のような低レベル関数を
直接使わなければならない場面に遭遇します。
このような場合には DL モジュールの関数を使用することになるでしょう。
これについては [[c:DL]] で説明します。

#@end
