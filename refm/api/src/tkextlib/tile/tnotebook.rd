#@since 1.8.2

require tk
require tkextlib/tile

= class Tk::Tile::TNotebook < TkWindow
include TkItemConfigMethod
include Tk::Tile::TileWidget

== Instance Methods
--- tabcget

--- tabconfigure

--- tabconfiginfo

--- current_tabconfiginfo

--- enable_traversal

--- add(child, keys = nil)

--- forget(idx)

--- index(idx)

#@since 1.8.4
--- insert(idx, subwin, keys = nil)

#@end
--- select(idx)

--- tabs

#@end
