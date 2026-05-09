
C の型の別名を定義するライブラリです。

[[c:Fiddle::Win32Types]] や [[c:Fiddle::BasicTypes]] を [[m:Module#include]] する
ことで、[[m:Fiddle::Importer#extern]] や [[m:Fiddle::Importer#struct]] で
利用できる型が増えます。内部で [[m:Fiddle::Importer#typealias]] を
呼び出しています。

実装の問題があるため、 [[m:Fiddle::Importer#dlload]] を呼びだしてから
include してください。

例
  require 'fiddle/import'
  require 'fiddle/types'
  
  module M
    extend Fiddle::Importer
    dlload "libc.so.6" # include の前に dlload を呼ぶ
    include Fiddle::BasicTypes
  end
  
  # uint は Fiddle::BasicTypes によって定義された型で、unsigned int の別名
  p(M.sizeof("uint") == M.sizeof("unsigned int"))
  
= module Fiddle::Win32Types
Windows 用の型の別名を定義するモジュールです。

include すると 以下の型が定義されます。
  * "DWORD"
  * "PDWORD"
  * "DWORD32"
  * "DWORD64"
  * "WORD"
  * "PWORD"
  * "BOOL"
  * "ATOM"
  * "BYTE"
  * "PBYTE"
  * "UINT"
  * "ULONG"
  * "UCHAR"
  * "HANDLE"
  * "PHANDLE"
  * "PVOID"
  * "LPCSTR"
  * "LPSTR"
  * "HINSTANCE"
  * "HDC"
  * "HWND"

= module Fiddle::BasicTypes
よく使われる型の別名を定義するモジュールです。

include すると 以下の型が定義されます。
  * "uint" 
  * "u_int"
  * "ulong" 
  * "u_long" 
