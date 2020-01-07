
require tk
require tk/text
require tkextlib/iwidgets

= class Tk::Iwidgets::Scrolledtext < Tk::Iwidgets::Scrolledwidget

include TkTextTagConfig

== Class Methods

--- new(*args)
#@todo



== Instance Methods

--- bbox(index)
#@todo



--- child_site
#@todo



--- clear
#@todo



--- compare(idx1, op, idx2)
#@todo



--- current_image_configinfo(index, slot = nil)
#@todo



--- debug
#@todo



--- debug=(boolean)
#@todo



--- delete(first, last = None)
#@todo



--- dlineinfo(index)
#@todo



--- export(file)
#@todo



--- get(*index)
#@todo



--- get_displaychars(*index)
#@todo



--- image_cget(index, slot)
#@todo



--- image_configinfo(index, slot = nil)
#@todo



--- image_configure(index, slot, value = None)
#@todo



--- image_names
#@todo



--- import(file, idx = nil)
#@todo



--- index(idx)
#@todo



--- insert(index, *args)
#@todo



--- mark_gravity(mark, direction = nil)
#@todo



--- mark_names
#@todo



--- mark_next(index)
#@todo
alias next_mark



--- mark_previous(index)
#@todo
alias previous_mark



--- mark_set(mark, index)
#@todo
alias set_mark



--- mark_unset(*marks)
#@todo
alias unset_mark



--- method_missing(id, *args)
#@todo



--- next_mark(index)
#@todo

Alias for #mark_next

--- previous_mark(index)
#@todo

Alias for #mark_previous

--- rsearch(pat, start, stop = None)
#@todo



--- rsearch_with_length(pat, start, stop = None)
#@todo



--- scan_dragto(x, y)
#@todo



--- scan_mark(x, y)
#@todo



--- search(pat, start, stop = None)
#@todo



--- search_with_length(pat, start, stop = None)
#@todo



--- see(index)
#@todo



--- set_mark(mark, index)
#@todo

Alias for #mark_set

--- tksearch(*args)
#@todo



--- tksearch_with_count(*args)
#@todo



--- unset_mark(*marks)
#@todo

Alias for #mark_unset

--- xview(*index)
#@todo



--- xview_moveto(*index)
#@todo



--- xview_scroll(*index)
#@todo



--- yview(*index)
#@todo



--- yview_moveto(*index)
#@todo



--- yview_scroll(*index)
#@todo




