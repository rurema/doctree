#@#require rexml/functions
#@#require rexml/xmltokens

= class REXML::QuickPath
include REXML::Functions
include REXML::XMLTokens

== Class Methods

--- first(element, path, namespaces = EMPTY_HASH)

--- each(element, path, namespaces = EMPTY_HASH) {|element| ... }

--- match(element, path, namespaces = EMPTY_HASH)

--- filter(elements, path)

--- axe(elements, axe_name, rest)

--- predicate(elements, path)

--- attribute(name)

--- name

--- method_missing(id, *args)

--- function(elements, fname, rest)

--- parse_args(element, string)

== Constants

--- EMPTY_HASH
