#@#require rexml/namespace
#@#require rexml/xmltokens
#@#require rexml/attribute
#@#require rexml/syncenumerator
#@#require rexml/parsers/xpathparser

= reopen Object

== Instance Methods

#@since 1.8.3
--- dclone
#@end

#@if (version <= "1.8.0")
--- __ne__(b)
#@end

= reopen Symbol

== Instance Methods

#@since 1.8.3
--- dclone
#@end

= reopen Array

== Instance Methods

#@since 1.8.3
--- dclone
#@end

= class REXML::XPathParser < Object
include REXML::XMLTokens

== Class Methods

--- new

== Instance Methods

--- namespaces=(namespaces = {})

--- variables=(vars = {})

--- parse(path, nodeset)

#@since 1.8.3
--- get_first(path, nodeset)
#@end

--- predicate(path, nodeset)

--- []=(variable_name, value)

#@since 1.8.3
--- first(path_stack, node)
#@end

#@since 1.8.2
--- match(path_stack, nodeset)
#@end

== Constants

--- LITERAL

#@since 1.8.3
--- ALL

--- ELEMENTS
#@end
