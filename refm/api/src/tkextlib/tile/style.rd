#@since 1.8.2

require tk
require tkextlib/tile

= module Tk::Tile::Style
extend TkCore
#@since 1.8.4
include Tk::Tile::ParseStyleLayout
#@end

== Singleton Methods
--- default(style, keys = nil)
#@since 1.8.4
--- configure(style, keys = nil)
#@todo

#@end
--- map(style, keys = nil)
#@todo

--- layout(style, spec = nil)
#@todo

--- element_create(name, type, *args)
#@todo

--- element_names
#@todo

--- theme_create(name, keys = nil)
#@todo

--- theme_settings(name, cmd = nil, &b)
#@todo

--- theme_names
#@todo

--- theme_use(name)
#@todo

#@end
