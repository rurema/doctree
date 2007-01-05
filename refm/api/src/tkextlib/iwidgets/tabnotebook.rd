#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Tabnotebook < Tk::Itk::Widget

include TkItemConfigMethod

== Class Methods

--- new(*args)



== Instance Methods

--- add(keys = {})



--- child_site(idx)



--- child_site_list



--- delete(idx1, idx2 = nil)



--- index(idx)



--- insert(idx, keys = {})



--- next



--- prev



--- scrollbar(bar = nil)

Alias for #yscrollbar

--- scrollcommand(cmd = Proc.new)
alias xscrollcommand
alias yscrollcommand



--- select(idx)



--- tagid(tagOrId)



--- view(*index)
alias xview
alias yview



--- view_moveto(*index)
alias xview_moveto
alias yview_moveto



--- view_scroll(*index)
alias xview_scroll
alias yview_scroll



--- xscrollbar(bar = nil)



--- xscrollcommand(cmd = Proc.new)

Alias for #scrollcommand

--- xview(*index)

Alias for #view

--- xview_moveto(*index)

Alias for #view_moveto

--- xview_scroll(*index)

Alias for #view_scroll

--- yscrollbar(bar = nil)
alias scrollbar



--- yscrollcommand(cmd = Proc.new)

Alias for #scrollcommand

--- yview(*index)

Alias for #view

--- yview_moveto(*index)

Alias for #view_moveto

--- yview_scroll(*index)

Alias for #view_scroll


#@end
