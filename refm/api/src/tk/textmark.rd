#@since 1.8.2

require tk
require tk/text

= class TkTextMark < TkObject
include TkText::IndexModMethods

== Class Methods

--- id2obj(text, id)

--- new(parent, index)

== Instance Methods

--- id

--- exist?

#@since 1.8.3
--- pos

--- pos=(where)
#@end

--- set(where)

--- unset
--- destroy

--- gravity

--- gravity=(direction)

--- next(index = nil)

--- previous(index = nil)

#@if (version <= "1.8.2")

--- +(mod)

--- -(mod)
#@end

== Constants

--- TMarkID_TBL

--- Tk_TextMark_ID

= class TkTextNamedMark < TkTextMark

== Class Methods

--- new(parent, name, *args)

= class TkTextMarkInsert < TkTextNamedMark

== Class Methods

--- new(parent, *args)

= class TkTextMarkCurrent < TkTextNamedMark

== Class Methods

--- new(parent, *args)

= class TkTextMarkAnchor < TkTextNamedMark

== Class Methods

--- new(parent, *args)

#@end
