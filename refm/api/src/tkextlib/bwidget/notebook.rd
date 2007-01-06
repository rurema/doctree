#@since 1.8.2

require tk
require tk/frame
require tkextlib/bwidget

= class Tk::BWidget::NoteBook < TkWindow

include TkItemConfigMethod

== Instance Methods

--- add(page, &b)



--- compute_size



--- delete(page, destroyframe = None)



--- get_frame(page, &b)



--- get_page(page)



--- index(page)



--- insert(index, page, keys = {}, &b)



--- move(page, index)



--- pages(first = None, last = None)



--- raise(page = nil)



--- see(page)



--- tabbind(context, *args)

def tabbind(*args)

  _bind_for_event_class(Event_for_Tabs, [path, 'bindtabs'], *args)
  self

end

--- tabbind_append(context, *args)

def tabbind_append(*args)

  _bind_append_for_event_class(Event_for_Tabs, [path, 'bindtabs'], *args)
  self

end

--- tabbind_remove(*args)



--- tabbindinfo(*args)



--- tagid(id)



#@include(notebook/NoteBook__Event_for_Tabs)

#@end
