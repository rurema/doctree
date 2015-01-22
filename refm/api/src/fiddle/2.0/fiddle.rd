*.dllや*.soなど、ダイナミックリンクライブラリを扱うためのライブラリです。

#@since 2.2.0
dl と同等の機能を持ちますが、
#@else
[[lib:dl]] と同等の機能を持ちますが、
#@end
dl は 2.0 以降deprecated となり、2.2.0 で削除されました。このライブラリ
を代わりに使います。

=== 使い方

通常は [[lib:fiddle/import]] ライブラリを require して 
[[c:Fiddle::Importer]] モジュールを使用します。
#@until 2.2.0
[[lib:dl]] と基本的な使いかたは良く似ています。
#@end
[[c:Fiddle]] モジュール自体はプリミティブな機能しか提供していません。
[[c:Fiddle::Importer]] モジュールは以下のようにユーザが定義した
モジュールを拡張する形で使います。

  require "fiddle/import"
  module M
    extend Fiddle::Importer
  end

以後、このモジュールで dlload や extern などのメソッドが使用できるようになります。
以下のように dlload を使ってライブラリをロードし、
使用したいライブラリ関数に対して extern メソッドを呼んで
ラッパーメソッドを定義します。

  require "fiddle/import"
  module M
    extend Fiddle::Importer
    dlload "libc.so.6","libm.so.6"
    extern "int strlen(char*)"
  end
  # Note that we should not include the module M from some reason.
  
  p M.strlen('abc') #=> 3

M.strlen を使用することで、ライブラリ関数 strlen() を使用できます。

==== 構造体を扱う

構造体も扱うことができます。たとえば [[man:gettimeofday(2)]]
を使って現在時刻を得たい場合は以下のとおりです。

 require 'fiddle/import'
 module M
   extend Fiddle::Importer
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

  require 'fiddle/import'
  module M 
    extend Fiddle::Importer
    dlload "libc.so.6"
    QsortCallback = bind("void *qsort_callback2(void*,void*)"){|ptr1,ptr2| 
      ptr1[0] <=> ptr2[0]
    }
    type
    extern 'void qsort(void *, int, int, void *)'
  end

  buff = "3465721"
  M.qsort(buff, buff.size, 1, M::QsortCallback)
  p buff #=>   "1234567"

ここで M::QsortCallback はブロックを呼ぶ [[c:Fiddle::Function]] オブジェクトです。


==== ポインタを扱う

fiddle においては、文字列/整数/[[c:Fiddle::Pointer]]をポインタとして
扱うことができます。
文字列をポインタ引数として渡すと文字列のメモリ領域を指す
ポインタとして扱われます。

 require 'fiddle/import' 
 
 module M
   extend Fiddle::Importer
   dlload 'libc.so.6'
   extern 'void * memmove(void *, void *, unsigned long)'
 end
 
 s = 'xxxyyyzzz'
 M.memmove(s, 'abc', 3)
 p s                    #=> "abcyyyzzz"

char * 以外の型のポインタを受け取る関数に対しても文字列を渡します。

 module M
   extend Fiddle::Importer
   dlload 'libm.so.6'
   extern 'double modf(double, double *)'
 end 
 
 s = ' ' * 8
 p M2.modf(1.25, s)  #=> 0.25
 p s.unpack('d')[0]  #=> 1.0

==== 関数の引数と返り値
fiddle でインポートした C の関数を呼び出すとき、
その引数と返り値はインポートする際に指定した型と
Ruby のオブジェクトの種類によって変換されます。

#@include(callargs)

#@include(Fiddle)
#@include(Fiddle__Pointer)
#@include(Fiddle__Handle)
#@include(Fiddle__Function)

