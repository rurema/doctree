= module DL::Importable

=== 概要

DL::Importable を extend したモジュールに構造体/共用体を定義する機能を与える。


=== 補足

メソッドやクラスは、
実際には DL::Importable::Internal に定義されている。

== Instance Methods

--- define_struct(contents)
--- struct(contents)

構造体を定義します。
contentsについては [[m:DL::Importable::Struct.new]]
を参照せよ。

--- define_union(contents)
--- union(contents)

共用体を定義します。
contents については上記 define_struct と同様です。


= class DL::Importable::Memory < Object

=== 概要

DL::PtrData のラッパー用クラス。
ドット形式で構造体や共用体の要素へアクセスできるようになります。
Struct,Unionのインスタンスのmalloc,newメソッドを呼ぶことによって、
Memoryクラスのインスタンスが生成できます。
そのため、通常、直接生成する必要はありません。

== Class Methods

--- new(ptr, names, ty, len, enc, dec)

DL::PtrData オブジェクト ptr の各メンバへアクセスするためのメソッドを
動的に定義する。Struct, Union のインスタンスがこれらの情報を保持する。

== Instance Method

--- to_ptr

保持している DL::PtrData オブジェクトを返します。

--- size

DL::PtrData#size を呼びます。



= class DL::Importable::Struct < Object

== Class Methods

--- new(types, contents)

types には DL::Types のインスタンス、contents には構造体の定義を
以下のようにして与える。

  ["int size",
   "char *str"]
  
このようにして生成されたStructオブジェクトは、以下の構造体のように振舞う。

  struct {
    int size;
    char *str;
  }

== Instance Methods

--- new(ptr)

[[c:DL::PtrData]] オブジェクト ptr を保持する Memory オブジェクトを返します。

--- malloc(size = nil)

sizeバイトの領域を確保してDL::PtrDataオブジェクトを生成し、その
DL::PtrDataオブジェクトを保持するMemoryオブジェクトを返します。


= class DL::Importable::Union < Ojbect

共用体に対するクラスである以外は、Struct とほぼ同じです。
