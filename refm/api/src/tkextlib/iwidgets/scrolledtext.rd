#@since 1.8.2

require tk
require tk/text
require tkextlib/iwidgets

= class Tk::Iwidgets::Scrolledtext < Tk::Iwidgets::Scrolledwidget

include TkTextTagConfig

== Class Methods

--- new(*args)



== Instance Methods

--- bbox(index)



--- child_site



--- clear



--- compare(idx1, op, idx2)



--- current_image_configinfo(index, slot = nil)



--- debug



--- debug=(boolean)



--- delete(first, last = None)



--- dlineinfo(index)



--- export(file)



--- get(*index)



--- get_displaychars(*index)



--- image_cget(index, slot)



--- image_configinfo(index, slot = nil)



--- image_configure(index, slot, value = None)



--- image_names



--- import(file, idx = nil)



--- index(idx)



--- insert(index, *args)



--- mark_gravity(mark, direction = nil)



--- mark_names



--- mark_next(index)
alias next_mark



--- mark_previous(index)
alias previous_mark



--- mark_set(mark, index)
alias set_mark



--- mark_unset(*marks)
alias unset_mark



--- method_missing(id, *args)



--- next_mark(index)

Alias for #mark_next

--- previous_mark(index)

Alias for #mark_previous

--- rsearch(pat, start, stop = None)



--- rsearch_with_length(pat, start, stop = None)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- search(pat, start, stop = None)



--- search_with_length(pat, start, stop = None)



--- see(index)



--- set_mark(mark, index)

Alias for #mark_set

--- tksearch(*args)



--- tksearch_with_count(*args)



--- unset_mark(*marks)

Alias for #mark_unset

--- xview(*index)



--- xview_moveto(*index)



--- xview_scroll(*index)



--- yview(*index)



--- yview_moveto(*index)



--- yview_scroll(*index)




#@end
