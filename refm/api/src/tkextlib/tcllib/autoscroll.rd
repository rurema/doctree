#@since 1.8.2

require tk
require tk/scrollbar
require tkextlib/tcllib

= module Tk::Tcllib::Autoscroll
extend TkCore

== Singleton Methods
#@since 1.8.3
--- package_name

#@end
--- package_version

--- autoscroll(win)

--- unautoscroll(win)

#@since 1.8.4
--- wrap

--- unwrap

#@end

= reopen Tk::Scrollable
== Instance Methods
--- autoscroll(mode = nil)

--- unautoscroll(mode = nil)

= reopen TkScrollbar
== Instance Methods
--- autoscroll

--- unautoscroll

#@end
