
require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Notebook < Tk::Itk::Widget

include TkItemConfigMethod

== Instance Methods

--- add(keys = {})
#@todo



--- child_site(idx)
#@todo



--- child_site_list
#@todo



--- delete(idx1, idx2 = nil)
#@todo



--- index(idx)
#@todo



--- insert(idx, keys = {})
#@todo



--- next
#@todo



--- prev
#@todo



--- scrollbar(bar = nil)
#@todo

Alias for #yscrollbar

--- scrollcommand(cmd = Proc.new)
#@todo
alias xscrollcommand
alias yscrollcommand



--- select(idx)
#@todo



--- tagid(tagOrId)
#@todo



--- view(*idxs)
#@todo
alias xview
alias yview



--- view_moveto(*idxs)
#@todo
alias xview_moveto
alias yview_moveto



--- view_scroll(*idxs)
#@todo
alias xview_scroll
alias yview_scroll



--- xscrollbar(bar = nil)
#@todo



--- xscrollcommand(cmd = Proc.new)
#@todo

Alias for #scrollcommand

--- xview(*idxs)
#@todo

Alias for #view

--- xview_moveto(*idxs)
#@todo

Alias for #view_moveto

--- xview_scroll(*idxs)
#@todo

Alias for #view_scroll

--- yscrollbar(bar = nil)
#@todo
alias scrollbar



--- yscrollcommand(cmd = Proc.new)
#@todo

Alias for #scrollcommand

--- yview(*idxs)
#@todo

Alias for #view

--- yview_moveto(*idxs)
#@todo

Alias for #view_moveto

--- yview_scroll(*idxs)
#@todo

Alias for #view_scroll


