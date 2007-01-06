#@since 1.8.2
require tk

= reopen Tk

== Class Methods

--- load_tclscript_rsrc(resource_name, file = Tk::None)

--- load_tclscript_rsrcid(resource_id, file = Tk::None)

= module TkMacResource
extend Tk
extend TkMacResource

== Constants

--- TkCommandNames
#@# ['resource'.freeze].freeze

--- PACKAGE_NAME
#@# = 'resource'.freeze

== Class Methods

--- package_name

--- close(rsrcRef)

--- delete(rsrcType, opts = nil)

--- files(rsrcRef = nil)

--- list(rsrcType, rsrcRef = nil)

--- open(fname, access = nil)

--- read(rsrcType, rsrcID, rsrcRef = nil)

--- types(rsrcRef = nil)

--- write(rsrcType, data, opts = nil)

== Instance Methods

--- close(rsrcRef)

--- delete(rsrcType, opts = nil)

--- files(rsrcRef = nil)

--- list(rsrcType, rsrcRef = nil)

--- open(fname, access = nil)

--- read(rsrcType, rsrcID, rsrcRef = nil)

--- types(rsrcRef = nil)

--- write(rsrcType, data, opts = nil)


#@end
