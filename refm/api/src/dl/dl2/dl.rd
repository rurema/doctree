
=== 使い方

通常は [[lib:dl/import]] ライブラリを require して [[c:DL::Importer]] モジュールを使用します。
[[c:DL]] モジュール自体はプリミティブな機能しか提供していません。
[[c:DL::Importer]] モジュールは以下のようにユーザが定義したモジュールを拡張する形で使います。

  require "dl/import"
  module M
    extend DL::Importer
  end

以後、このモジュールで dlload や extern などのメソッドが使用できるようになります。
以下のように dlload を使ってライブラリをロードし、
使用したいライブラリ関数に対して extern メソッドを呼んで
ラッパーメソッドを定義します。

  require "dl/import"
  module M
    extend DL::Importer
    dlload "libc.so.6","libm.so.6"
    extern "int strlen(char*)"
  end
  # Note that we should not include the module M from some reason.
  
  p M.strlen('abc') #=> 3

M.strlen を使用することで、ライブラリ関数 strlen() を使用できます。
与えられた関数名の最初の文字が大文字なら、
定義されるメソッド名の最初の文字は小文字になります。

==== 構造体を扱う

構造体も扱うことができます。たとえば [[man:gettimeofday(2)]]
を使って現在時刻を得たい場合は以下のとおりです。

 require 'dl/import'
 module M
   extend DL::Importer
   dlload "libc.so.6"
   extern('int gettimeofday(void *, void *)')
   Timeval = struct( ["long tv_sec",
                      "long tv_usec"])
 end
 
 timeval = M::Timeval.malloc
 e = M.gettimeofday(timeval, nil)

 if e == 0
  p timeval.tv_sec #=> 1173519547
 end

上の例で、メモリの割り当てに M::Timeval.new ではなく
M::Timeval.malloc を使用していることに注意してください。

==== コールバック

以下のようにモジュール関数 bind を使用したコールバックを定義できます。

  require 'dl/import'
  module M 
    extend DL::Importer
    dlload "libc.so.6"
    QsortCallbackWithoutBlock = bind("void *qsort_callback(void*, void*)", :temp)
    QsortCallback             = bind("void *qsort_callback2(void*,void*)"){|ptr1,ptr2| ptr1[0] <=> ptr2[0]}
    extern 'void qsort(void *, int, int, void *)'
  end

  buff = "3465721"
  M.qsort(buff, buff.size, 1, M::QsortCallback)
  p buff #=>   "1234567"

  M.qsort(buff, buff.size, 1, M::QsortCallbackWithoutBlock){|ptr1,ptr2| ptr2[0] <=> ptr1[0]}
  p buff #=>   "7654321"

ここで M::QsortCallback はブロックを呼ぶ [[c:DL::Function]] オブジェクトです。


==== ポインタを扱う

引数としてポインタを受け取る関数に対しては、ポインタの変わりに
文字列を渡します。文字列はポインタが指すメモリ領域として扱われます。

 require 'dl/import' 
 
 module M
   extend DL::Importer
   dlload 'libc.so.6'
   extern 'void * memmove(void *, void *, unsigned long)'
 end
 
 s = 'xxxyyyzzz'
 M.memmove(s, 'abc', 3)
 p s                    #=> "abcyyyzzz"

char * 以外の型のポインタを受け取る関数に対しても文字列を渡します。

 module M
   extend DL::Importer
   dlload 'libm.so.6'
   extern 'double modf(double, double *)'
 end 
 
 s = ' ' * 8
 p M2.modf(1.25, s)  #=> 0.25
 p s.unpack('d')[0]  #=> 1.0

==== 関数の引数と返り値
dl でインポートした C の関数を呼び出すとき、
その引数と返り値はインポートする際に指定した型と
Ruby のオブジェクトの種類によって変換されます。

#@include(callargs)

==== fiddle との関係
[[lib:fiddle]] が利用可能な環境では、DL 内部的に fiddle を利用し、
関数呼び出しを実現します。DL 単体では例えば x86_64 のような環境では
正しく動作しませんが、fiddle によってうまく動きます。
