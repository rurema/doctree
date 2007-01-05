#@since 1.8.2

require tk
require tk/listbox
require tkextlib/iwidgets

= class Tk::Iwidgets::Scrolledlistbox < Tk::Iwidgets::Scrolledwidget

include TkListItemConfig

== Class Methods

--- new(*args)



== Instance Methods

--- activate(y)



--- bbox(index)



--- clear



--- curselection



--- delete(first, last = None)



--- get(*index)



--- get_curselection



--- index(idx)



--- insert(index, *args)



--- justify(dir)



--- method_missing(id, *args)



--- nearest(y)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- see(index)



--- selected_item_count



--- selection_anchor(index)



--- selection_clear(first, last = None)



--- selection_includes(index)



--- selection_set(first, last = None)



--- size



--- sort(*params, &b)



--- sort_ascending



--- sort_descending



--- xview(*index)



--- xview_moveto(*index)



--- xview_scroll(*index)



--- yview(*index)



--- yview_moveto(*index)



--- yview_scroll(*index)




#@end
