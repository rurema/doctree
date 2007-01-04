#@since 1.8.2

require tk
require tk/variable

= class TkDialogObj < TkWindow
extend Tk

== Class Methods

--- show(*args)

== Instance Methods

--- show

--- value

--- name

== Constants

--- TkCommandNames

= class TkDialog < TkDialogObj

== Class Methods

--- show(*args)

--- new(*args)

= class TkWarningObj < TkDialogObj

== Class Methods

--- new(parent = nil, mes = nil)

== Instance Methods

--- show(mes = nil)

= class TkWarning < TkWarningObj

== Class Methods

--- show(*args)

--- new(*args)

= reopen Kernel

== Constants

--- TkDialog2

--- TkWarning2

#@end
