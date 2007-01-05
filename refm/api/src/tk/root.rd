#@since 1.8.2
require tk
require tk/wm
require tk/menuspec

= class TkRoot < TkWindow
include Wm
include TkMenuSpec

== Constants

--- WidgetClassName
#@# = 'Tk'.freeze

--- WidgetClassNames
#@# [WidgetClassName] = self


== Class Methods

--- destroy

--- new(keys = nil, &block)

--- to_eval


== Instance Methods

--- add_menu(menu_info, tearoff = false, opts = nil)

--- add_menubar(menu_spec, tearoff = false, opts = nil)

--- path


#@end
