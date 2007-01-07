#@since 1.8.2

require tk
require tkextlib/tcllib

= module Tk::Tcllib::Cursor
extend TkCore

== Singleton Methods
#@since 1.8.3
--- package_name

#@end
--- package_version

--- cursor_display(win = None)

--- cursor_propagate(win, cursor)

--- cursor_restore(win, cursor = None)

= reopen Tk::Tcllib
== Singleton Methods
--- cursor_display(parent = None)

= reopen TkWindow
== Instance Methods
--- cursor_propagate(cursor)

--- cursor_restore(cursor = None)

#@end
