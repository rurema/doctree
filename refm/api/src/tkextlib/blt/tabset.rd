
require tk
require tkextlib/blt

= class Tk::BLT::Tabset < TkWindow

include Tk::X_Scrollable
include TkItemConfigMethod

== Instance Methods

--- __boolval_optkeys
#@todo



--- __destroy_hook__
#@todo



--- activate(index)
#@todo
alias highlight



--- delete(first, last = None)
#@todo



--- focus(index)
#@todo



--- get_tab(index)
#@todo



--- highlight(index)
#@todo

Alias for #activate

--- index(str)
#@todo



--- index_name(tab)
#@todo



--- insert(pos, tab, keys = {})
#@todo



--- invoke(index)
#@todo



--- move_after(index, base_idx)
#@todo



--- move_before(index, base_idx)
#@todo



--- nearest(x, y)
#@todo



--- perforation_highlight(index, mode)
#@todo



--- perforation_invoke(index)
#@todo



--- scan_dragto(x, y)
#@todo



--- scan_mark(x, y)
#@todo



--- scrollcommand(cmd = Proc.new)
#@todo

Alias for #xscrollcommand

--- see(index)
#@todo



--- select(index)
#@todo



--- size
#@todo



--- tab_names(pat = None)
#@todo



--- tab_tearoff(index, name = None)
#@todo



--- tabbind(tag, context, *args)
#@todo

def tabbind(tag, context, cmd=Proc.new, *args)

  _bind([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- tabbind_append(tag, context, *args)
#@todo

def tabbind_append(tag, context, cmd=Proc.new, *args)

  _bind_append([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- tabbind_remove(tag, context)
#@todo



--- tabbindinfo(tag, context = nil)
#@todo



--- tagid(tab)
#@todo



--- tagindex(tab)
#@todo



--- view(*index)
#@todo

Alias for #xview

--- xscrollcommand(cmd = Proc.new)
#@todo
alias scrollcommand



--- xview(*index)
#@todo
alias view



#@include(tabset/Tabset__Tab)
#@include(tabset/Tabset__NamedTab)

