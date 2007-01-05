#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Promptdialog < Tk::Iwidgets::Dialog

== Instance Methods

--- clear

based on Tk::Iwidgets::Entryfield

--- cursor=(index)
alias icursor



--- default(name)

index method is not available, because it shows index of the
entry field

--- delete(first, last = None)



--- dragto(pos)



--- get

Alias for #value

--- hide(name)



--- icursor(index)

Alias for #cursor=

--- index(idx)



--- insert(pos, text)



--- invoke(name = nil)



--- mark(pos)



--- selection_adjust(index)



--- selection_clear



--- selection_from(index)



--- selection_present



--- selection_range(s, e)



--- selection_to(index)



--- set(val)

Alias for #value=

--- show(name)



--- value
alias get



--- value=(val)
alias set



--- xview(*index)



--- xview_moveto(*index)



--- xview_scroll(*index)




#@end
