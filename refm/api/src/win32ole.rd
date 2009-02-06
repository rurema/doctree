#@since 1.8.0

Microsoft Windows で COM や ActiveX を扱うためのライブラリです。

  * [[url:http://homepage1.nifty.com/markey/ruby/win32ole/index.html]]
  * [[url:http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Win32OLE]]
  * [[url:http://www.morijp.com/masarl/homepage3.nifty.com/masarl/article/ruby-win32ole.html]]
  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
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

= module WIN32OLE::VARIANT
== Constants
--- VT_ARRAY
--- VT_BOOL
--- VT_BSTR
--- VT_BYREF
--- VT_CY
--- VT_DATE
--- VT_DISPATCH
--- VT_ERROR
--- VT_I1
--- VT_I2
--- VT_I4
--- VT_INT
--- VT_PTR
--- VT_R4
--- VT_R8
--- VT_UI1
--- VT_UI2
--- VT_UI4
--- VT_UINT
--- VT_UNKNOWN
--- VT_USERDEFINED
--- VT_VARIANT

#@end
