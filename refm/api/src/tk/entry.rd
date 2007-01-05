#@since 1.8.2

require 'tk'
require 'tk/label'
require 'tk/scrollable'
require 'tk/validation'

= class TkEntry < TkLabel

include X_Scrollable
include TkValidation

== Instance Methods

--- bbox(index)

--- cursor
--- icursor

--- cursor=(index)
--- icursor=(index)

--- index(idx)

--- insert(pos, text)

--- delete(first, last = Tk::None)

--- mark(pos)

--- dragto(pos)

--- selection_adjust(index)

--- selection_clear

--- selection_from(index)

--- selection_present

--- selection_range(s, e)

--- selection_to(index)

--- invoke_validate

--- validate(mode = nil)

--- value
--- get

--- value=(val)
--- set(val)

--- [](*args)

--- []=(*args)


== Constants

--- TkCommandNames

--- WidgetClassName

--- WidgetClassNames



#@end
