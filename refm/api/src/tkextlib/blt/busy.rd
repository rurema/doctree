#@since 1.8.2

require tk
require tk/itemconfig
require tkextlib/blt

= module Tk::BLT::Busy

extend TkCore
extend TkItemConfigMethod

== Singleton Methods

--- check(win)



--- forget(*wins)



--- hold(win, keys = {})



--- is_busy(pat = None)



--- names(pat = None)



--- release(*wins)



--- shield_path(win)



--- status(win)



#@include(Busy__Shield)

#@end
