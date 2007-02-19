#@#require rexml/namespace
#@#require rexml/xmltokens
#@#require rexml/attribute
#@#require rexml/syncenumerator
#@#require rexml/parsers/xpathparser

= reopen Object

== Instance Methods

#@since 1.8.3
--- dclone
#@todo
#@end

#@if (version <= "1.8.0")
--- __ne__(b)
#@todo
#@end

= reopen Symbol

== Instance Methods

#@since 1.8.3
--- dclone
#@todo
#@end

= reopen Array

== Instance Methods

#@since 1.8.3
--- dclone
#@todo
#@end

= class REXML::XPathParser < Object
include REXML::XMLTokens

== Class Methods

--- new
#@todo

== Instance Methods

--- namespaces=(namespaces = {})
#@todo

--- variables=(vars = {})
#@todo

--- parse(path, nodeset)
#@todo

#@since 1.8.3
--- get_first(path, nodeset)
#@todo
#@end

--- predicate(path, nodeset)
#@todo

--- []=(variable_name, value)
#@todo

#@since 1.8.3
--- first(path_stack, node)
#@todo
#@end

#@since 1.8.2
--- match(path_stack, nodeset)
#@todo
#@end

== Constants

--- LITERAL
#@todo

#@since 1.8.3
--- ALL
#@todo

--- ELEMENTS
#@todo
#@end
