#@since 1.8.2

require tk
require tk/frame
require tk/composite
require tk/menuspec

= class TkMenubar < TkFrame
include TkComposite
include TkMenuSpec

== Class Methods

--- new(parent = nil, spec = nil, options = nil

== Instance Methods

--- add_menu(menu_info)

--- [](index)

#@end
