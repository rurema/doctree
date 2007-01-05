#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Selectiondialog < Tk::Iwidgets::Dialog

== Instance Methods

--- child_site



--- clear_items



--- clear_selection



--- curselection

based on TkListbox ( and TkTextWin )

--- delete(first, last = None)



--- get



--- index(idx)



--- insert_items(idx, *args)



--- insert_selection(pos, text)



--- nearest(y)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- select_item



--- selection_anchor(index)



--- selection_clear(first, last = None)



--- selection_includes(index)



--- selection_set(first, last = None)



--- size




#@end
