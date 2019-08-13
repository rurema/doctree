
require tk
require tk/canvas
require tkextlib/bwidget

= class Tk::BWidget::Tree < TkWindow

include TkItemConfigMethod
include Tk::Scrollable

== Instance Methods

--- close_tree(node, recurse = None)
#@todo



--- delete(*args)
#@todo



--- edit(node, text, *args)
#@todo



--- exist?(node)
#@todo



--- get_node(node, idx)
#@todo



--- imagebind(context, *args)
#@todo

def imagebind(*args)

  _bind_for_event_class(Event_for_Items, [path, 'bindImage'], *args)
  self

end

--- imagebind_append(context, *args)
#@todo

def imagebind_append(*args)

  _bind_append_for_event_class(Event_for_Items, [path, 'bindImage'], *args)
  self

end

--- imagebind_remove(*args)
#@todo



--- imagebindinfo(*args)
#@todo



--- index(node)
#@todo



--- insert(idx, parent, node, keys = {})
#@todo



--- move(parent, node, idx)
#@todo



--- nodes(node, first = None, last = None)
#@todo



--- open?(node)
#@todo



--- open_tree(node, recurse = None)
#@todo



--- parent(node)
#@todo



--- reorder(node, neworder)
#@todo



--- see(node)
#@todo



--- selection_add(*args)
#@todo



--- selection_clear
#@todo



--- selection_get
#@todo



--- selection_include?(*args)
#@todo



--- selection_range(*args)
#@todo



--- selection_remove(*args)
#@todo



--- selection_set(*args)
#@todo



--- selection_toggle(*args)
#@todo



--- tagid(tag)
#@todo



--- textbind(context, *args)
#@todo

def textbind(*args)

  _bind_for_event_class(Event_for_Items, [path, 'bindText'], *args)
  self

end

--- textbind_append(context, *args)
#@todo

def textbind_append(*args)

  _bind_append_for_event_class(Event_for_Items, [path, 'bindText'], *args)
  self

end

--- textbind_remove(*args)
#@todo



--- textbindinfo(*args)
#@todo



--- toggle(node)
#@todo



--- visible(node)
#@todo



#@include(tree/Tree__Node)
#@include(tree/Tree__Event_for_Items)

