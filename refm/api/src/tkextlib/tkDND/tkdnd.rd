
require tk
require tkextlib/setup
require tkextlib/tkDND/setup

= Module Tk::TkDND

== Class Methods
--- package_version
#@todo

--- package_name
#@todo


= reopen TkWindow
include Tk::TkDND::Shape

#@include(DND_Subst)
#@include(DND)

