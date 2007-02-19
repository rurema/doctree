#@since 1.8.2

require tk
require tkextlib/setup
require tkextlib/tkDND/setup

= Module Tk::TkDND

== Class Methods
--- package_version
#@todo

#@since 1.8.3
--- package_name
#@todo

#@end

= reopen TkWindow
include Tk::TkDND::Shape

#@include(DND_Subst)
#@include(DND)

#@end
