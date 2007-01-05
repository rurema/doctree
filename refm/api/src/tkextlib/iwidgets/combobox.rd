#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Combobox < Tk::Iwidgets::Entryfield

== Instance Methods

--- clear(component = None)



--- delete_entry(first, last = None)



--- delete_list(first, last = None)



--- get_curselection

scrolledlistbox methods

--- get_list_contents(index)



--- insert_entry(idx, *elems)



--- insert_list(idx, *elems)



--- justify(dir)



--- see(index)



--- selection_anchor(index)



--- selection_clear(first, last = None)



--- selection_includes(index)



--- selection_set(first, last = None)



--- size

listbox methods

--- sort(*params, &b)



--- sort_ascending



--- sort_descending




#@end
