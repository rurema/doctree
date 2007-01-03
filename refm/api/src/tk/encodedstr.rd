#@since 1.8.2
require tk

= class Tk::EncodedString < String

== Constants

--- Encoding

== Class Methods

--- new(str, enc = nil)

--- new_with_utf_backslash(str, enc = nil)

--- new_without_utf_backslash(str, enc = nil)

--- subst_tk_backslash(str)

--- subst_utf_backslash(str)

--- to_backslash_sequence(str)

--- utf_backslash(str)

--- utf_to_backslash(str)

--- utf_to_backslash_sequence(str)


== Instance Methods

--- encoding

= class Tk::BinaryString < EncodedString

== Constants

--- Encoding

= class Tk::UTF8_String < EncodedString

== Constans

--- Encoding

== Class Methods

--- new(str)

== Instance Methods


#@end
