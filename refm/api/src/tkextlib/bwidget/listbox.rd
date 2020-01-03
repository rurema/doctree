
require tk
require tk/canvas
require tkextlib/bwidget

= class Tk::BWidget::ListBox < TkWindow

include TkItemConfigMethod
include Tk::Scrollable

== Instance Methods

--- delete(*args)
#@todo



--- edit(item, text, *args)
#@todo



--- exist?(item)
#@todo



--- get_item(idx)
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



--- index(item)
#@todo



--- insert(idx, item, keys = {})
#@todo



--- items(first = None, last = None)
#@todo



--- move(item, idx)
#@todo



--- reorder(neworder)
#@todo



--- see(item)
#@todo



--- selection_add(*args)
#@todo



--- selection_clear
#@todo



--- selection_get(*args)
#@todo



--- selection_remove(*args)
#@todo



--- selection_set(*args)
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



#@include(listbox/ListBox__Item)
#@include(listbox/ListBox__Event_for_Items)

