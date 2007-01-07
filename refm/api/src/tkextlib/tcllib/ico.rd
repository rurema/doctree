#@since 1.8.2

require tk
require tk/image
require tkextlib/tcllib

= class Tk::Tcllib::ICO < TkImage

== Class Methods
#@since 1.8.3
--- package_name

#@end
--- package_version

--- list(file, keys = nil)

--- get(file, index, keys = nil)

--- get_image(file, index, keys = {})

--- get_data(file, index, keys = {})

--- write(file, index, depth, data, keys = nil)

--- copy(from_file, from_index, to_file, to_index, keys = nil)

--- exe_to_ico(exe_file, ico_file, keys = nil)

--- clear_cache(file = None)

--- transparent_color(image, color)

--- show(file, keys = nil)

--- new(file, index, keys = nil)

== Instance Methods
--- write(file, index, depth, keys = nil)

--- transparent_color(color)

#@end
