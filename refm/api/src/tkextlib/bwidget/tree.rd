#@since 1.8.2

require tk
require tk/canvas
require tkextlib/bwidget

= class Tk::BWidget::Tree < TkWindow

include TkItemConfigMethod
include Tk::Scrollable

== Instance Methods

--- close_tree(node, recurse = None)



--- delete(*args)



--- edit(node, text, *args)



--- exist?(node)



--- get_node(node, idx)



--- imagebind(context, *args)

def imagebind(*args)

  _bind_for_event_class(Event_for_Items, [path, 'bindImage'], *args)
  self

end

--- imagebind_append(context, *args)

def imagebind_append(*args)

  _bind_append_for_event_class(Event_for_Items, [path, 'bindImage'], *args)
  self

end

--- imagebind_remove(*args)



--- imagebindinfo(*args)



--- index(node)



--- insert(idx, parent, node, keys = {})



--- move(parent, node, idx)



--- nodes(node, first = None, last = None)



--- open?(node)



--- open_tree(node, recurse = None)



--- parent(node)



--- reorder(node, neworder)



--- see(node)



--- selection_add(*args)



--- selection_clear



--- selection_get



--- selection_include?(*args)



--- selection_range(*args)



--- selection_remove(*args)



--- selection_set(*args)



--- selection_toggle(*args)



--- tagid(tag)



--- textbind(context, *args)

def textbind(*args)

  _bind_for_event_class(Event_for_Items, [path, 'bindText'], *args)
  self

end

--- textbind_append(context, *args)

def textbind_append(*args)

  _bind_append_for_event_class(Event_for_Items, [path, 'bindText'], *args)
  self

end

--- textbind_remove(*args)



--- textbindinfo(*args)



--- toggle(node)



--- visible(node)



#@include(tree/Tree__Node)
#@include(tree/Tree__Event_for_Items)

#@end
