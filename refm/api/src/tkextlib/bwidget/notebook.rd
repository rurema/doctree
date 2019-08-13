
require tk
require tk/frame
require tkextlib/bwidget

= class Tk::BWidget::NoteBook < TkWindow

include TkItemConfigMethod

== Instance Methods

--- add(page, &b)
#@todo



--- compute_size
#@todo



--- delete(page, destroyframe = None)
#@todo



--- get_frame(page, &b)
#@todo



--- get_page(page)
#@todo



--- index(page)
#@todo



--- insert(index, page, keys = {}, &b)
#@todo



--- move(page, index)
#@todo



--- pages(first = None, last = None)
#@todo



--- raise(page = nil)
#@todo



--- see(page)
#@todo



--- tabbind(context, *args)
#@todo

def tabbind(*args)

  _bind_for_event_class(Event_for_Tabs, [path, 'bindtabs'], *args)
  self

end

--- tabbind_append(context, *args)
#@todo

def tabbind_append(*args)

  _bind_append_for_event_class(Event_for_Tabs, [path, 'bindtabs'], *args)
  self

end

--- tabbind_remove(*args)
#@todo



--- tabbindinfo(*args)
#@todo



--- tagid(id)
#@todo



#@include(notebook/NoteBook__Event_for_Tabs)

