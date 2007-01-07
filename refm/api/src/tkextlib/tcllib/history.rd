#@since 1.8.4

require tk
require tk/entry
require tkextlib/tcllib

= module Tk::Tcllib::History
extend TkCore

== Singleton Methods
--- package_name

--- package_version

--- init(entry, length = None)

--- remove(entry)

== Instance Methods
--- history_remove

--- history_add(text)

--- history_get

--- history_clear

--- history_configure(opt, value)

--- history_configinfo(opt)

#@end
