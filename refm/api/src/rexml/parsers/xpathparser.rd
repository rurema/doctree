#@#require rexml/namespace
#@#require rexml/xmltokens

= class REXML::Parsers::XPathParser < Object
include REXML::XMLTokens

== Instance Methods

--- namespaces=(namespaces)

--- parse(path)

--- predicate(path)

#@since 1.8.2
--- abbreviate(path)

--- expand(path)
#@end

#@if (version <= "1.8.1")
--- to_string(path)
#@end

--- predicate_to_string(path) {|path| ... }

== Constants

--- LITERAL

--- AXIS

--- NCNAMETEST

--- QNAME

--- NODE_TYPE

--- PI

--- VARIABLE_REFERENCE

--- NUMBER

--- NT
