#@if (version >= "1.7.0")
#@# = dl

Ruby/DL は、UNIX の [[man:dlopen(3)]] や Windows の
LoadLibrary() などのダイナミックリンカへのインタフェースを提供す
します。また、現在[[unknown:dl2|URL:http://rubyforge.net/projects/ruby-dl2/]]のruby-1.8
版も開発されています。

=== Libraries

* [[c:DL]]
  * [[c:DL::Handle]]
  * [[c:DL::Symbol]]
  * [[c:DL::PtrData]]
* [[unknown:DL::Importable|"dl/import"]]
  * [[unknown:"dl/struct"]]
* [[unknown:DL::Types|"dl/types"]]
* [[unknown:"dl/win32"]]

=== Using Ruby/DL

通常は、[[unknown:DL::Importable|"dl/import"]] モジュールを使用します。
これはライブラリ関数にアクセスするための高水準の関数を持っています。
あるモジュールを拡張するには以下のように DL::Importable を使用します。

  require "dl/import"
  module LIBC
    extend DL::Importable
  end

以後、このモジュールの dlload と extern メソッドを使用できます。以下のよ
うに dlload 使ってライブラリをロードし、それぞれのライブラリ関数に対し
て extern を使用することでラッパーメソッドを定義します。

  module LIBC
    extend DL::Importable
    dlload "libc.so.6","libm.so.6"
    extern "int strlen(char*)"
  end
  # Note that we should not include the module LIBC from some reason.

#@# We can call the library function strlen() using LIBC.strlen. If the first
#@# character of given function name is an uppercase, the first character of the
#@# defined method name becomes lowercase.
#@# We can also construct memory images of structures and unions using functions
#@# struct and union which are defined in "dl/struct" as follows:

LIBC.strlen を使用することで、ライブラリ関数 strlen() を使用できます。与
えられた関数名の最初の文字が大文字なら、定義されるメソッド名の最初の文
字は小文字になります。

以下のように [[unknown:"dl/struct"]] で定義される struct や union 関数を使用す
ることで構造体や共用体のメモリイメージを作成することもできます。

  require "dl/import"
  require "dl/struct"
  module LIBC
    extend DL::Importable
    Timeval = struct [       # define timeval structure.
      "long tv_sec",
      "long tv_uses",
    ]
  end
  val = LIBC::Timeval.malloc # allocate memory.

#@# Notice that the above example takes LIBC::Timeval.malloc to allocate memory,
#@# rather than LIBC::Timeval.new. It is because DL::Timeval.new is for wrapping
#@# an object, PtrData, which has already been created.

上の例で、メモリの割り当てに LIBC::Timeval.new ではなく、
LIBC::Timeval.malloc を使用していることに注意してください。LIBC::Timeval.new は、
作成済みの PtrData オブジェクトをラップするためのものです。

#@# We can define a callback using the module function "callback" as follows:

以下のように モジュール関数 callback を使用したコールバックを定義できます。

  module Foo
    extend DL::Importable
    def my_comp(str1,str2)
      str1 <=> str2
    end
    COMPARE = callback "int my_comp(char*,char*)"
  end

#@# where Foo::COMPARE is a Symbol object which invokes the method "my_comp".

ここで Foo::COMPARE は、my_comp メソッドを起動する Symbol オブジェクトです。

#@# DL::Importable module is very useful. However, we sometimes encounter a case
#@# that we must directly use low-level functions such as dlsym(). In such case,
#@# we would use DL module functions. They are described in next section.

DL::Importable モジュールはとても便利です。しかし、ときにはdlsym() のよ
うな低レベル関数を直接使わなければならない場面に遭遇します。このような場
合には DL モジュールの関数を使用することになるでしょう。これについては
[[c:DL]] で説明します。


#@include(dl/DL)
#@include(dl/Handle)
#@include(dl/PtrData)
#@include(dl/Symbol)
#@end
