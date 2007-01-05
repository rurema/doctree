#@since 1.8.2

require tk
require tk/frame
require tkextlib/bwidget
require tkextlib/bwidget/buttonbox

= class Tk::BWidget::Dialog < TkWindow

include TkItemConfigMethod

== Class Methods

--- new(parent = nil, keys = nil)



== Instance Methods

--- add(keys = {}, &b)



--- cget(slot)



--- configinfo(slot = nil)



--- configure(slot, value = None)



--- create_self(keys)



--- draw(focus_win = None)



--- enddialog(ret)



--- get_buttonbox(&b)



--- get_frame(&b)



--- index(idx)



--- invoke(idx)



--- set_focus(idx)



--- tagid(tagOrId)



--- withdraw




#@end
