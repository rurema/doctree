#@since 1.8.0

Microsoft Windows で COM や ActiveX を扱うためのライブラリです。

  * [[url:http://homepage1.nifty.com/markey/ruby/win32ole/index.html]]
  * [[url:http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Win32OLE]]
  * [[url:http://www.morijp.com/masarl/homepage3.nifty.com/masarl/article/ruby-win32ole.html]]
  * Rubyist Magazine [[url:http://jp.rubyist.net/magazine/]]
    * Win32OLE 活用法【第 1 回】 Win32OLE ことはじめ [[url:http://jp.rubyist.net/magazine/?0003-Win32OLE]]
    * Win32OLE 活用法【第 2 回】 Excel [[url:http://jp.rubyist.net/magazine/?0004-Win32OLE]]
    * Win32OLE 活用法【第 3 回】 ADODB [[url:http://jp.rubyist.net/magazine/?0005-Win32OLE]]
    * Win32OLE 活用法【第 4 回】 Adobe Illustrator [[url:http://jp.rubyist.net/magazine/?0006-Win32OLE]]
    * Win32OLE 活用法【第 5 回】 Outlook [[url:http://jp.rubyist.net/magazine/?0007-Win32OLE]]
    * Win32OLE 活用法【第 6 回】 Web 自動巡回 [[url:http://jp.rubyist.net/magazine/?0008-Win32OLE]]
    * Win32OLE 活用法【第 7 回】ほかの言語での COM [[url:http://jp.rubyist.net/magazine/?0009-Win32OLE]]

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

WIN32OLERuntimeErrorは、OLEオートメーション呼び出しが例外ステータス（HRESULTのMSBがオン）で返った場合や、メソッド呼び出し時にオートメーション仕様で認められていない値が与えられた場合に発生します。

OLEオートメーション呼び出しが例外ステータスで戻された場合は、メッセージに例外となったHRESULT値と対応するメッセージが表示されます。

HRESULT: [[url:http://msdn.microsoft.com/en-us/library/cc704587(v=PROT.10).aspx]]

= module WIN32OLE::VARIANT
OLEオートメーション型を指定するための定数を定義したモジュールです。

WIN32OLE::VARIANTは、[[c:WIN32OLE_VARIANT]]オブジェクトの作成時や、[[m:WIN32OLE#_invoke]]などのメソッド呼び出し時に、ユーザがRubyのオブジェクトの変換方法を指定するための定数を提供します。

これらの値は、COMの仕様で定義されたOLEオートメーション型と呼ばれる一連の型を決定する定数です。ただし、一部、OLEオートメーション非互換の型も定義されているため、利用時にはOLEオートメーション互換型のみを利用するようにしてください。

== Constants

--- VT_ARRAY -> Integer
配列（SafeArray）を示します。

--- VT_BOOL -> Integer
真偽値を示します。

--- VT_BSTR -> Integer
文字列（BSTR）を示します。

OLEオートメーションのBSTRはUnicodeで表現された長さ付き文字列です。RubyのStringとBSTRの相互変換は、WIN32OLEが[[m:WIN32OLE#codepage]]に基づいて自動的に行います。

--- VT_BYREF -> Integer
参照を示します。

VT_BYREFは型ではなく、参照を示す型属性です。OLEオートメーションサーバが結果を引数に戻す場合、参照先の型を示す値と論理和を取るために利用します。

--- VT_CY -> Integer
通貨型（CURRENCY）を示します。

OLEオートメーションのCURRENCY型は、符号付き64ビット整数を10進表記した時の下4桁を小数点以下とすることで、加減算について誤差を生じさせない小数点数を表現します。

CURRENCY型の有効範囲は-922337203685477.5808から922337203685477.5807です。

WIN32OLEはオートメーション呼び出しの返り値がCURRENCY型の場合、文字列に変換します。

--- VT_DATE -> Integer
日付型（DATE）を示します。

OLEオートメーションのDATE型は、1899年12月30日0時00分からの日時を示す64ビット浮動小数点数型です。

WIN32OLEは、RubyのTime型と自動的に変換します。

--- VT_DISPATCH -> Integer
OLEオートメーションオブジェクトを示します。

RubyのオブジェクトをOLEオートメーションサーバへ与える場合に利用します。

--- VT_ERROR -> Integer
HRESULTを示します。

HRESULTは、COMを含むWindowsのサービスがアプリケーションへ通知する統一的なエラーコードです。

HRESULT: [[url:http://msdn.microsoft.com/en-us/library/cc704587(v=PROT.10).aspx]]

--- VT_I1 -> Integer
符号付き8ビット整数（char）を示します。

OLEオートメーションの仕様上は利用できません。

--- VT_I2 -> Integer
符号付き16ビット整数（short）を示します。

--- VT_I4 -> Integer
符号付き32ビット整数（int）を示します。

--- VT_INT -> Integer
符号付き32ビット整数（int）を示します。

--- VT_PTR -> Integer
ポインタ型を示します。

VT_PTRは、VOID*に相当するため、OLEオートメーションでは利用できません。

--- VT_R4 -> Integer
単精度浮動小数点数を示します。

--- VT_R8 -> Integer
倍精度浮動小数点数を示します。

--- VT_UI1 -> Integer
符号なし8ビット整数（unsigned char）を示します。

--- VT_UI2 -> Integer
符号なし16ビット整数（unsigned short）を示します。

OLEオートメーションでは利用できません。代わりにVT_I2を利用してください。

--- VT_UI4 -> Integer
符号なし32ビット整数（unsigned int）を示します。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_UINT -> Integer
符号なし32ビット整数（unsigned int）を示します。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_UNKNOWN -> Integer
COMインターフェイスを示します。

--- VT_USERDEFINED -> Integer
ユーザ定義型を示します。

OLEオートメーションでは利用できません。代わりにVT_I4を利用してください。

--- VT_VARIANT -> Integer
VARIANT型を示します。

#@end
