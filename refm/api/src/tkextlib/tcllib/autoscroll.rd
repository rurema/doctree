#@since 1.8.2

require tk
require tk/scrollbar
require tkextlib/tcllib

= module Tk::Tcllib::Autoscroll
extend TkCore

== Singleton Methods
#@since 1.8.3
--- package_name
#@todo

#@end
--- package_version
#@todo

--- autoscroll(win)
#@todo

--- unautoscroll(win)
#@todo

#@since 1.8.4
--- wrap
#@todo

--- unwrap
#@todo

#@end

= reopen Tk::Scrollable
== Instance Methods
--- autoscroll(mode = nil)
#@todo

--- unautoscroll(mode = nil)
#@todo

= reopen TkScrollbar
== Instance Methods
--- autoscroll
#@todo

--- unautoscroll
#@todo

#@end
