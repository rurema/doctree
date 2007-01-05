#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Panedwindow < Tk::Itk::Widget

include TkItemConfigMethod

== Instance Methods

--- add(tag = nil, keys = {})



--- child_site(idx)



--- child_site_list



--- delete(idx)



--- fraction(*percentages)



--- hide(idx)



--- index(idx)



--- insert(idx, tag = nil, keys = {})



--- invoke(idx = nil)



--- reset



--- show(idx)



--- tagid(tagOrId)




#@end
