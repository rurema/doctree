#@#require rexml/entity
#@#require rexml/doctype
#@#require rexml/child
#@#require rexml/doctype
#@#require rexml/parseexception

= class REXML::Text < REXML::Child
include Comparable

== Class Methods

--- new(arg, respect_whitespace = false, parent = nil, raw = nil, entity_filter = nil, illegal = REXML::Text::ILLEGAL)
#@todo

--- read_with_substitution(input, illegal = nil)
#@todo

--- normalize(input, doctype = nil, entity_filter = nil)
#@todo

--- unnormalize(string, doctype = nil, filter = nil, illegal = nil)
#@todo

== Instance Methods

--- raw
--- raw=(value)
#@todo

--- node_type
#@todo

--- empty?
#@todo

--- clone
#@todo

--- <<(to_append)
#@todo

--- <=>(other)
#@todo

--- to_s
#@todo

#@since 1.8.3
--- inspect
#@todo
#@end

--- value
#@todo

#@since 1.8.2
--- wrap(string, width, addnewline = false)
#@todo

--- value=(val)
#@todo
#@end

#@since 1.8.2
--- indent_text(string, level = 1, style = "\t", indentfirstline = true)
#@todo
#@end

--- write(writer, indent = -1, transitive = false, ie_hack = false)
#@todo

#@since 1.8.2
--- xpath
#@todo
#@end

--- write_with_substitution(out, input)
#@todo

== Constants

--- SPECIALS
#@todo

--- SUBSTITUTES
#@todo

--- SLAICEPS
#@todo

--- SETUTITSBUS
#@todo

--- ILLEGAL
#@todo

--- NUMERICENTITY
#@todo

--- REFERENCE
#@todo

--- EREFERENCE
#@todo
