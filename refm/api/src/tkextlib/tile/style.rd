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

#@end
--- map(style, keys = nil)

--- layout(style, spec = nil)

--- element_create(name, type, *args)

--- element_names

--- theme_create(name, keys = nil)

--- theme_settings(name, cmd = nil, &b)

--- theme_names

--- theme_use(name)

#@end
