#@since 1.8.2

require tk
require tkextlib/iwidgets

= class Tk::Iwidgets::Toolbar < Tk::Itk::Widget

include TkItemConfigMethod

== Instance Methods

--- add(type, tag = nil, keys = {})



--- delete(idx1, idx2 = nil)



--- index(idx)



--- insert(idx, type, tag = nil, keys = {})



--- tagid(tagOrId)




#@end
