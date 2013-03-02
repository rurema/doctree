
C の型の別名を定義するライブラリです。

[[c:DL::Win32Types]] や [[c:DL::BasicTypes]] を [[m:Module#include]] する
ことで、[[m:DL::Importer#extern]] や [[m:DL::Importer#struct]] で
利用できる型が増えます。内部で [[m:DL::Importer#typealias]] を
呼び出しています。

実装の問題があるため、 [[m:DL::Importer#dlload]] を呼びだしてから
include してください。

例
  require 'dl/import'
  require 'dl/types'
  
  module M
    extend DL::Importer
    dlload "libc.so.6" # include の前に dlload を呼ぶ
    include DL::BasicTypes
  end
  
  # uint は DL::BasicTypes によって定義された型で、unsigned int の別名
  p(M.sizeof("uint") == M.sizeof("unsigned int"))
  
= module DL::Win32Types
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

= module DL::BasicTypes
よく使われる型の別名を定義するモジュールです。

include すると 以下の型が定義されます。
  * "uint" 
  * "u_int"
  * "ulong" 
  * "u_long" 
