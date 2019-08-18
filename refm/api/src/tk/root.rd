require tk
require tk/wm
require tk/menuspec

= class TkRoot < TkWindow
include Tk::Wm
include TkMenuSpec

== Constants

--- WidgetClassName
#@todo
#@# = 'Tk'.freeze

--- WidgetClassNames
#@todo
#@# [WidgetClassName] = self


== Class Methods

--- destroy
#@todo

--- new(keys = nil, &block)
#@todo

--- to_eval
#@todo


== Instance Methods

--- add_menu(menu_info, tearoff = false, opts = nil)
#@todo

--- add_menubar(menu_spec, tearoff = false, opts = nil)
#@todo

--- path
#@todo


