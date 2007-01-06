#@since 1.8.2
require tk

= class TkScale < TkWindow

== Constants

--- TkCommandNames
#@# = ['scale'.freeze].freeze

--- WidgetClassName
#@# = 'Scale'.freeze

--- WidgetClassNames
#@#[WidgetClassName] = self

== Instance Methods

--- command(cmd = Proc.new)

--- configure(slot, value = Tk::None)

--- configure_cmd(slot, value)

--- coords(value = Tk::None)

--- get(x = Tk::None, y = Tk::None)

--- identify(x, y)

--- set(value)

--- value

--- value=(value)



#@end
