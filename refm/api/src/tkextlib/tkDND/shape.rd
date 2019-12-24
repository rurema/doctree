
require tk
require tkextlib/setup
require tkextlib/tkDND/setup

= Module Tk::TkDND::Shape
extend TkCore

== Class Methods
--- package_version
#@todo

--- package_patchlevel
#@todo

--- version
#@todo

== Instance Methods
--- shape_bounds(kind = nil)
#@todo

--- shape_get(kind = nil)
#@todo

--- shape_offset(x, y, kind = nil)
#@todo

--- shape_set(*args)
#@todo

--- shape_update(op, *args)
#@todo

= reopen TkWindow
include Tk::TkDND::Shape

