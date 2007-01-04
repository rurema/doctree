#@#require rexml/entity
#@#require rexml/doctype
#@#require rexml/child
#@#require rexml/doctype
#@#require rexml/parseexception

= class REXML::Text < REXML::Child
include Comparable

== Class Methods

--- new(arg, respect_whitespace = false, parent = nil, raw = nil, entity_filter = nil, illegal = REXML::Text::ILLEGAL)

--- read_with_substitution(input, illegal = nil)

--- normalize(input, doctype = nil, entity_filter = nil)

--- unnormalize(string, doctype = nil, filter = nil, illegal = nil)

== Instance Methods

--- raw
--- raw=(value)

--- node_type

--- empty?

--- clone

--- <<(to_append)

--- <=>(other)

--- to_s

#@since 1.8.3
--- inspect
#@end

--- value

#@since 1.8.2
--- wrap(string, width, addnewline = false

--- value=(val)
#@end

#@since 1.8.2
--- indent_text(string, level = 1, style = "\t", indentfirstline = true)
#@end

--- write(writer, indent = -1, transitive = false, ie_hack = false)

#@since 1.8.2
--- xpath
#@end

--- write_with_substitution(out, input)

== Constants

--- SPECIALS

--- SUBSTITUTES

--- SLAICEPS

--- SETUTITSBUS

--- ILLEGAL

--- NUMERICENTITY

--- REFERENCE

--- EREFERENCE
