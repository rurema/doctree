#@since 1.8.2

require tk
require tk/canvas
require tkextlib/bwidget

= class Tk::BWidget::ListBox < TkWindow

include TkItemConfigMethod
include Tk::Scrollable

== Instance Methods

--- delete(*args)



--- edit(item, text, *args)



--- exist?(item)



--- get_item(idx)



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



--- index(item)



--- insert(idx, item, keys = {})



--- items(first = None, last = None)



--- move(item, idx)



--- reorder(neworder)



--- see(item)



--- selection_add(*args)



--- selection_clear



--- selection_get(*args)



--- selection_remove(*args)



--- selection_set(*args)



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



#@include(listbox/ListBox__Item)
#@include(listbox/ListBox__Event_for_Items)

#@end
