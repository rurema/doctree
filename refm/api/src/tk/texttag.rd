#@since 1.8.2

require tk
require tk/text
require tk/tagfont

= class TkTextTag < TkObject
include TkTreatTagFont
include TkText::IndexModMethods

== Class Methods

--- id2obj(text, id)

--- new(parent, *args)

== Instance Methods

--- id

--- exist?

--- first

--- last

--- add(*indices)

--- remove(*indices)

--- ranges

--- nextrange(first, last = TkUtil::None)

--- prevrange(first, last = TkUtil::None)

--- [](key)

--- []=(key, val)

--- cget(key)

--- configure(key, val = TkUtil::None)

--- configinfo(key = nil)

--- current_configinfo(key = nil)

--- bind(seq, *args)

--- bind_append(seq, *args)

--- bind_remove(seq)

--- bindinfo(context = nil)

--- raise(above = TkUtil::None)

--- lower(below = TkUtil::None)

--- destroy

== Constants

--- TTagID_TBL

--- Tk_TextTag_ID

= class TkTextNamedTag < TkTextTag

== Class Methods

--- new(parent, name, *args)

= class TkTextTagSel < TkTextNamedTag

== Class Methods

--- new(parent, *args)

#@end
