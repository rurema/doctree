#@if (version >= "1.7.0")

-> [[unknown:"ruby-src:ext/win32ole/doc/win32ole.rd"]]

see also

  * [[m:URL:http:#/homepage1.nifty.com/markey/ruby/win32ole/index.html]]
  * [[m:URL:http:#/pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=Win32OLE]]
  * [[m:URL:http:#/www.morijp.com/masarl/homepage3.nifty.com/masarl/article/ruby-win32ole.html]]
  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
    * [[unknown:Win32OLE 活用法【第 1 回】 Win32OLE ことはじめ|URL:http://jp.rubyist.net/magazine/?0003-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 2 回】 Excel|URL:http://jp.rubyist.net/magazine/?0004-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 3 回】 ADODB|URL:http://jp.rubyist.net/magazine/?0005-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 4 回】 Adobe Illustrator|URL:http://jp.rubyist.net/magazine/?0006-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 5 回】 Outlook|URL:http://jp.rubyist.net/magazine/?0007-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 6 回】 Web 自動巡回|URL:http://jp.rubyist.net/magazine/?0008-Win32OLE]]
    * [[unknown:Win32OLE 活用法【第 7 回】ほかの言語での COM|URL:http://jp.rubyist.net/magazine/?0009-Win32OLE]]

= class WIN32OLE < Object
== Class Methods
--- new(oleserver)
#@todo

--- codepage
#@todo

--- codepage=
#@todo

--- connect(oleserver)
#@todo

--- const_load(ole [, obj])
#@todo

--- ole_free(obj)
#@todo

--- ole_reference_count(obj)
#@todo

--- ole_show_help(info [, helpcontext])
#@todo


== Instance Methods
--- [](property)
--- []=(property, value)
--- _getproperty
--- _invoke(dispid, args, types)
--- _setproperty
--- each {...}
--- invoke(methods, *args)
--- method_missing
--- ole_free
--- ole_func_methods
--- ole_get_methods
--- ole_method(method)
--- ole_method_help(method)
--- ole_methods
--- ole_obj_help
--- ole_put_methods
--- setproperty(property, key, val)
#@todo

== Constants
--- VERSION
#@todo

--- ARGV
#@todo

--- CP_ACP
--- CP_MACCP
--- CP_OEMCP
--- CP_SYMBOL
--- CP_THREAD_ACP
--- CP_UTF7
--- CP_UTF8
#@todo



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
#@todo

= class WIN32OLERuntimeError < RuntimeError

= class WIN32OLE_EVENT < Object
== Class Methods
--- new(ole, interface)
#@todo

--- message_loop
#@todo

== Instance Methods
--- on_event([event]) {...}
#@todo

--- on_event_with_outargs([event]) {...}
#@todo

= class WIN32OLE_METHOD < Object
== Class Methods
--- new(win32ole_type, method)
#@todo

== Instance Methods
--- dispid
#@todo

--- event?
#@todo

--- event_interface
#@todo

--- helpcontext
#@todo

--- helpfile
#@todo

--- helpstring
#@todo

--- invkind
#@todo

--- invoke_kind
#@todo

--- name
#@todo

--- offset_vtbl
#@todo

--- params
#@todo

--- return_type
#@todo

--- return_type_detail
#@todo

--- return_vtype
#@todo

--- size_opt_params
#@todo

--- size_params
#@todo

--- to_s
#@todo

--- visible?
#@todo

= class WIN32OLE_PARAM < Object
== Instance Methods
--- default
#@todo

--- input?
#@todo

--- name
#@todo

--- ole_type
#@todo

--- ole_type_detail
#@todo

--- optional?
#@todo

--- output?
#@todo

--- retval?
#@todo

--- to_s
#@todo

= class WIN32OLE_TYPE < Object
== Class Methods
--- new(typelibrary, class)
#@todo

--- ole_classes(typelibrary)
#@todo

--- progids
#@todo

--- typelibs
#@todo

== Instance Methods
--- guid
#@todo

--- helpcontext
#@todo

--- helpfile
#@todo

--- helpstring
#@todo

--- major_version
#@todo

--- minor_version
#@todo

--- name
#@todo

--- ole_methods
#@todo

--- ole_type
#@todo

--- progid
#@todo

--- src_type
#@todo

--- to_s
#@todo

--- typekind
#@todo

--- variables
#@todo

--- visible?
#@todo

= class WIN32OLE_VARIABLE < Object
== Instance Methods
--- name
#@todo

--- ole_type
#@todo

--- ole_type_detail
#@todo

--- to_s
#@todo

--- value
#@todo

--- variable_kind
#@todo

--- varkind
#@todo

--- visible?
#@todo

#@end
