#@since 1.8.2

require tk
require tk/text
require tkextlib/iwidgets

= class Tk::Iwidgets::Hierarchy < Tk::Iwidgets::Scrolledwidget

include TkTextTagConfig
include Tk::ValidateConfigure

== Instance Methods

--- __validation_class_list



--- bbox(index)

based on TkText widget

--- clear



--- collapse(node)



--- compare(idx1, op, idx2)



--- current



--- debug



--- debug=(boolean)



--- delete(first, last = None)



--- dlineinfo(index)



--- draw(mode = None)



--- exp_state
alias expand_state
alias expanded_list



--- expand(node)



--- expand_state

Alias for #exp_state

--- expanded?(node)



--- expanded_list

Alias for #exp_state

--- get(*index)



--- index(index)



--- insert(index, chars, *tags)



--- mark_add(*nodes)



--- mark_clear



--- mark_get



--- mark_remove(*nodes)



--- prune(node)



--- refresh(node)



--- scan_dragto(x, y)



--- scan_mark(x, y)



--- see(index)



--- selection_add(*nodes)



--- selection_clear



--- selection_get



--- selection_remove(*nodes)



--- toggle(node)



--- xview(*index)

based on tk/scrollable.rb

--- xview_moveto(*index)



--- xview_scroll(*index)



--- yview(*index)



--- yview_moveto(*index)



--- yview_scroll(*index)



#@include(hierarchy/Hierarchy__QueryCommand)
#@include(hierarchy/Hierarchy__QueryCommand__ValidateArgs)
#@include(hierarchy/Hierarchy__IndicatorCommand)
#@include(hierarchy/Hierarchy__IndicatorCommand__ValidateArgs)
#@include(hierarchy/Hierarchy__IconCommand)
#@include(hierarchy/Hierarchy__IconCommand__ValidateArgs)

#@end
