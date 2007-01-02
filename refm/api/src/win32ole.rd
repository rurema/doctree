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

--- codepage

--- codepage=

--- connect(oleserver)

--- const_load(ole [, obj])

--- ole_free(obj)

--- ole_reference_count(obj)

--- ole_show_help(info [, helpcontext])


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

== Constants
--- VERSION

--- ARGV

--- CP_ACP
--- CP_MACCP
--- CP_OEMCP
--- CP_SYMBOL
--- CP_THREAD_ACP
--- CP_UTF7
--- CP_UTF8



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

= class WIN32OLERuntimeError < RuntimeError

= class WIN32OLE_EVENT < Object
== Class Methods
--- new(ole, interface)

--- message_loop

== Instance Methods
--- on_event([event]) {...}

--- on_event_with_outargs([event]) {...}

= class WIN32OLE_METHOD < Object
== Class Methods
--- new(win32ole_type, method)

== Instance Methods
--- dispid

--- event?

--- event_interface

--- helpcontext

--- helpfile

--- helpstring

--- invkind

--- invoke_kind

--- name

--- offset_vtbl

--- params

--- return_type

--- return_type_detail

--- return_vtype

--- size_opt_params

--- size_params

--- to_s

--- visible?

= class WIN32OLE_PARAM < Object
== Instance Methods
--- default

--- input?

--- name

--- ole_type

--- ole_type_detail

--- optional?

--- output?

--- retval?

--- to_s

= class WIN32OLE_TYPE < Object
== Class Methods
--- new(typelibrary, class)

--- ole_classes(typelibrary)

--- progids

--- typelibs

== Instance Methods
--- guid

--- helpcontext

--- helpfile

--- helpstring

--- major_version

--- minor_version

--- name

--- ole_methods

--- ole_type

--- progid

--- src_type

--- to_s

--- typekind

--- variables

--- visible?

= class WIN32OLE_VARIABLE < Object
== Instance Methods
--- name

--- ole_type

--- ole_type_detail

--- to_s

--- value

--- variable_kind

--- varkind

--- visible?

#@end
