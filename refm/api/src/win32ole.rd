#@since 1.8.0
category Windows

Microsoft Windows で COM や ActiveX を扱うためのライブラリです。

  * [[url:http://homepage1.nifty.com/markey/ruby/win32ole/index.html]]
  * [[url:http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Win32OLE]]
  * [[url:http://objectclub.jp/community/memorial/homepage3.nifty.com/masarl/article/ruby-win32ole.html]]
  * Rubyist Magazine [[url:http://magazine.rubyist.net/]]
    * Win32OLE 活用法【第 1 回】 Win32OLE ことはじめ [[url:http://magazine.rubyist.net/?0003-Win32OLE]]
    * Win32OLE 活用法【第 2 回】 Excel [[url:http://magazine.rubyist.net/?0004-Win32OLE]]
    * Win32OLE 活用法【第 3 回】 ADODB [[url:http://magazine.rubyist.net/?0005-Win32OLE]]
    * Win32OLE 活用法【第 4 回】 Adobe Illustrator [[url:http://magazine.rubyist.net/?0006-Win32OLE]]
    * Win32OLE 活用法【第 5 回】 Outlook [[url:http://magazine.rubyist.net/?0007-Win32OLE]]
    * Win32OLE 活用法【第 6 回】 Web 自動巡回 [[url:http://magazine.rubyist.net/?0008-Win32OLE]]
    * Win32OLE 活用法【第 7 回】ほかの言語での COM [[url:http://magazine.rubyist.net/?0009-Win32OLE]]

#@include(win32ole/WIN32OLE)
#@include(win32ole/WIN32OLE_EVENT)
#@include(win32ole/WIN32OLE_METHOD)
#@include(win32ole/WIN32OLE_PARAM)
#@include(win32ole/WIN32OLE_TYPE)
#@include(win32ole/WIN32OLE_VARIABLE)
#@since 1.9.1
#@include(win32ole/WIN32OLE_TYPELIB)
#@include(win32ole/WIN32OLE_VARIANT)
#@end

= class WIN32OLERuntimeError < RuntimeError

COMインターフェイスエラー時に発生する例外です。

WIN32OLERuntimeErrorは、OLEオートメーション呼び出しが例外ステータス
（HRESULTのMSBがオン）で返った場合や、メソッド呼び出し時にオートメーショ
ン仕様で認められていない値が与えられた場合に発生します。

OLEオートメーション呼び出しが例外ステータスで戻された場合は、メッセージ
に例外となったHRESULT値と対応するメッセージが表示されます。

HRESULT: [[url:http://msdn.microsoft.com/en-us/library/cc704587(v=PROT.10).aspx]]

= module WIN32OLE::VARIANT
OLEオートメーション型を指定するための定数を定義したモジュールです。

WIN32OLE::VARIANTは、[[c:WIN32OLE_VARIANT]]オブジェクトの作成時や、
[[m:WIN32OLE#_invoke]]などのメソッド呼び出し時に、ユーザがRubyのオブジェ
クトの変換方法を指定するための定数を提供します。

これらの値は、COMの仕様で定義されたOLEオートメーション型と呼ばれる一連
の型を決定する定数です。ただし、一部、OLEオートメーション非互換の型も定
義されているため、利用時にはOLEオートメーション互換型のみを利用するよう
にしてください。

== Constants

--- VT_ARRAY -> Integer
配列（SafeArray）を示します（0x2000）。

--- VT_BOOL -> Integer
真偽値を示します（11）。

--- VT_BSTR -> Integer
文字列（BSTR）を示します（8）。

OLEオートメーションのBSTRはUnicodeで表現された長さ付き文字列です。Ruby
のStringとBSTRの相互変換は、WIN32OLEが[[m:WIN32OLE#codepage]]に基づいて
自動的に行います。

--- VT_BYREF -> Integer
参照を示します（0x4000）。

VT_BYREFは型ではなく、参照を示す型属性です。OLEオートメーションサーバが
結果を引数に戻す場合、参照先の型を示す値と論理和を取るために利用します。

--- VT_CY -> Integer
通貨型（CURRENCY）を示します（6）。

OLEオートメーションのCURRENCY型は、符号付き64ビット整数を10進表記した時
の下4桁を小数点以下とすることで、加減算について誤差を生じさせない小数点
数を表現します。

CURRENCY型の有効範囲は-922337203685477.5808から922337203685477.5807です。

WIN32OLEはオートメーション呼び出しの返り値がCURRENCY型の場合、文字列に
変換します。

--- VT_DATE -> Integer
日付型（DATE）を示します（7）。

OLEオートメーションのDATE型は、1899年12月30日0時00分からの日時を示す64
ビット浮動小数点数型です。

WIN32OLEは、RubyのTime型と自動的に変換します。

--- VT_DISPATCH -> Integer
OLEオートメーションオブジェクトを示します（9）。

RubyのオブジェクトをOLEオートメーションサーバへ与える場合に利用します。

--- VT_ERROR -> Integer
HRESULTを示します（10）。

HRESULTは、COMを含むWindowsのサービスがアプリケーションへ通知する統一的
なエラーコードです。

HRESULT: [[url:http://msdn.microsoft.com/en-us/library/cc704587(v=PROT.10).aspx]]

--- VT_I1 -> Integer
符号付き8ビット整数（char）を示します（16）。

OLEオートメーションの仕様上は利用できません。

--- VT_I2 -> Integer
符号付き16ビット整数（short）を示します（2）。

--- VT_I4 -> Integer
符号付き32ビット整数（int）を示します（3）。

--- VT_INT -> Integer
符号付き整数（int）を示します（22）。

--- VT_PTR -> Integer
ポインタ型を示します（26）。

VT_PTRは、VOID*に相当するため、OLEオートメーションでは利用できません。

--- VT_R4 -> Integer
単精度浮動小数点数を示します（4）。

--- VT_R8 -> Integer
倍精度浮動小数点数を示します（5）。

--- VT_UI1 -> Integer
符号なし8ビット整数（unsigned char）を示します（17）。

--- VT_UI2 -> Integer
符号なし16ビット整数（unsigned short）を示します（18）。

OLEオートメーションでは利用できません。代わりにVT_I2を利用してください。

--- VT_UI4 -> Integer
符号なし32ビット整数（unsigned int）を示します（19）。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_UINT -> Integer
符号なし整数（unsigned int）を示します（23）。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_UNKNOWN -> Integer
COMインターフェイスを示します（13）。

--- VT_USERDEFINED -> Integer
ユーザ定義型を示します（29）。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_VARIANT -> Integer
VARIANT型を示します（12）。

#@since 1.9.1
--- VT_EMPTY -> Integer
空（初期化状態）のオブジェクトを示します（0）。

--- VT_NULL -> Integer
NULL型の値を示します（1）。

[[m:WIN32OLE::VARIANT.VT_EMPTY]]と異なり、NULLという値（たとえばSQLパラ
メータでNULLを指定する場合など）を示します。

#@end

#@end
