#@until 1.9.1
require dl
require dl/import

DL::Importable を extend したモジュールに構造体/共用体を定義する機能を与えます。

= reopen DL::Importable

== Instance Methods

--- define_struct(contents)
--- struct(contents)
#@todo

構造体を定義します。
contentsについては [[m:DL::Importable::Struct.new]] を参照してください。

--- define_union(contents)
--- union(contents)
#@todo

共用体を定義します。
contents については上記 define_struct と同様です。



= class DL::Importable::Memory < Object

DL::PtrData のラッパー用クラス。
ドット形式で構造体や共用体の要素へアクセスできるようになります。
Struct,Unionのインスタンスのmalloc,newメソッドを呼ぶことによって、
Memoryクラスのインスタンスが生成できます。
そのため、通常、直接生成する必要はありません。

== Class Methods

--- new(ptr, names, ty, len, enc, dec)
#@todo

DL::PtrData オブジェクト ptr の各メンバへアクセスするためのメソッドを
動的に定義します。Struct, Union のインスタンスがこれらの情報を保持します。

== Instance Method

--- to_ptr
#@todo

保持している DL::PtrData オブジェクトを返します。

--- size
#@todo

DL::PtrData#size を呼びます。



= class DL::Importable::Struct < Object

== Class Methods

--- new(types, contents)
#@todo

types には DL::Types のインスタンス、contents には構造体の定義を
以下のようにして与えます。

  ["int size",
   "char *str"]
  
このようにして生成されたStructオブジェクトは、以下の構造体のように振舞います。

  struct {
    int size;
    char *str;
  }

== Instance Methods

--- new(ptr)
#@todo

[[c:DL::PtrData]] オブジェクト ptr を保持する Memory オブジェクトを返します。

--- malloc(size = nil)
#@todo

sizeバイトの領域を確保してDL::PtrDataオブジェクトを生成し、その
DL::PtrDataオブジェクトを保持するMemoryオブジェクトを返します。

--- size
#@todo

malloc されたサイズを返します。

--- members
#@todo

構造体の要素名で構成される [[c:Array]] オブジェクトを返します。

--- parse(contents)
#@todo

--- parse_elem(elem)
#@todo


= class DL::Importable::Union < DL::Importable::Struct

共用体に対するクラスである以外は、Struct とほぼ同じです。

== Instance Methods

--- new
#@todo

#@end
