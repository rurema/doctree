require tk

= module TkSelection
extend Tk
include Tk

== Constants

--- TkCommandNames
#@# = ['selection'.freeze].freeze


== Class Methods

--- clear(sel = nil)

--- clear_on_display(win, sel = nil)

--- get(keys = nil)

--- get_on_display(win, keys = nil)

--- get_owner(sel = nil)

--- get_owner_on_display

--- handle(win, func = Proc.new, keys = nil, &block)

--- set_owner(win, keys = nil)

== Instance Methods

--- clear(sel = nil)

--- get(keys = nil)

--- get_owner(sel = nil)

--- handle(func = Proc.new, keys = nil, &block)

--- set_owner(keys = nil)
