#@since 1.8.2

require tk
require tk/itemconfig
require tkextlib/blt

= class Tk::BLT::Htext < TkWindow

include TkItemConfigMethod
include Tk::Scrollable

== Instance Methods

--- append(win, keys = {})



--- current_line



--- goto_line(idx)



--- index(str)



--- line_pos(str)



--- range(from = None, to = None)



--- scan_dragto(pos)



--- scan_mark(pos)



--- search(pat, from = None, to = None)



--- selection_adjust(index)



--- selection_clear



--- selection_from(index)



--- selection_line(index)



--- selection_present



--- selection_range(first, last)



--- selection_to(index)



--- selection_word(index)



--- windows(pat = None)




#@end
