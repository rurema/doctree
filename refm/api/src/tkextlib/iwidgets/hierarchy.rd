
require tk
require tk/text
require tkextlib/iwidgets

= class Tk::Iwidgets::Hierarchy < Tk::Iwidgets::Scrolledwidget

include TkTextTagConfig
include Tk::ValidateConfigure

== Instance Methods

--- __validation_class_list
#@todo



--- bbox(index)
#@todo

based on TkText widget

--- clear
#@todo



--- collapse(node)
#@todo



--- compare(idx1, op, idx2)
#@todo



--- current
#@todo



--- debug
#@todo



--- debug=(boolean)
#@todo



--- delete(first, last = None)
#@todo



--- dlineinfo(index)
#@todo



--- draw(mode = None)
#@todo



--- exp_state
#@todo
alias expand_state
alias expanded_list



--- expand(node)
#@todo



--- expand_state
#@todo

Alias for #exp_state

--- expanded?(node)
#@todo



--- expanded_list
#@todo

Alias for #exp_state

--- get(*index)
#@todo



--- index(index)
#@todo



--- insert(index, chars, *tags)
#@todo



--- mark_add(*nodes)
#@todo



--- mark_clear
#@todo



--- mark_get
#@todo



--- mark_remove(*nodes)
#@todo



--- prune(node)
#@todo



--- refresh(node)
#@todo



--- scan_dragto(x, y)
#@todo



--- scan_mark(x, y)
#@todo



--- see(index)
#@todo



--- selection_add(*nodes)
#@todo



--- selection_clear
#@todo



--- selection_get
#@todo



--- selection_remove(*nodes)
#@todo



--- toggle(node)
#@todo



--- xview(*index)
#@todo

based on tk/scrollable.rb

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



#@include(hierarchy/Hierarchy__QueryCommand)
#@include(hierarchy/Hierarchy__QueryCommand__ValidateArgs)
#@include(hierarchy/Hierarchy__IndicatorCommand)
#@include(hierarchy/Hierarchy__IndicatorCommand__ValidateArgs)
#@include(hierarchy/Hierarchy__IconCommand)
#@include(hierarchy/Hierarchy__IconCommand__ValidateArgs)

