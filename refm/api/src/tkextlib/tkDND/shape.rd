#@since 1.8.2

require tk
require tkextlib/setup
require tkextlib/tkDND/setup

= Module Tk::TkDND::Shape
extend TkCore

== Class Methods
--- package_version

--- package_patchlevel

--- version

== Instance Methods
--- shape_bounds(kind = nil)

--- shape_get(kind = nil)

--- shape_offset(x, y, kind = nil)

--- shape_set(*args)

--- shape_update(op, *args)

= reopen TkWindow
include Tk::TkDND::Shape

#@end
