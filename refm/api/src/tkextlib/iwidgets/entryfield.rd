#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Entryfield < Tk::Iwidgets::Labeledwidget

include Tk::ValidateConfigure

== Instance Methods

--- __validation_class_list



--- clear



--- cursor=(index)
alias icursor



--- delete(first, last = None)



--- dragto(pos)



--- get

Alias for #value

--- icursor(index)

Alias for #cursor=

--- index(index)



--- insert(pos, text)



--- mark(pos)



--- selection_adjust(index)



--- selection_clear



--- selection_from(index)



--- selection_present



--- selection_range(s, e)



--- selection_to(index)



--- set(val)

Alias for #value=

--- value
alias get



--- value=(val)
alias set



--- xview(*index)

based on tk/scrollable.rb

--- xview_moveto(*index)



--- xview_scroll(*index)




#@end
