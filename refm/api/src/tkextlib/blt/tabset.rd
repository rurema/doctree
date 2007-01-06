#@since 1.8.2

require tk
require tkextlib/blt

= class Tk::BLT::Tabset < TkWindow

include Tk::X_Scrollable
include TkItemConfigMethod

== Instance Methods

--- __boolval_optkeys



--- __destroy_hook__



--- activate(index)
alias highlight



--- delete(first, last = None)



--- focus(index)



--- get_tab(index)



--- highlight(index)

Alias for #activate

--- index(str)



--- index_name(tab)



--- insert(pos, tab, keys = {})



--- invoke(index)



--- move_after(index, base_idx)



--- move_before(index, base_idx)



--- nearest(x, y)



--- perforation_highlight(index, mode)



--- perforation_invoke(index)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- scrollcommand(cmd = Proc.new)

Alias for #xscrollcommand

--- see(index)



--- select(index)



--- size



--- tab_names(pat = None)



--- tab_tearoff(index, name = None)



--- tabbind(tag, context, *args)

def tabbind(tag, context, cmd=Proc.new, *args)

  _bind([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- tabbind_append(tag, context, *args)

def tabbind_append(tag, context, cmd=Proc.new, *args)

  _bind_append([path, "bind", tagid(tag)], context, cmd, *args)
  self

end

--- tabbind_remove(tag, context)



--- tabbindinfo(tag, context = nil)



--- tagid(tab)



--- tagindex(tab)



--- view(*index)

Alias for #xview

--- xscrollcommand(cmd = Proc.new)
alias scrollcommand



--- xview(*index)
alias view



#@include(tabset/Tabset__Tab)
#@include(tabset/Tabset__NamedTab)

#@end
