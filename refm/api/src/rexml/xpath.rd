#@#require rexml/functions
#@#require rexml/xpath_parser

= class REXML::XPath < Object
include REXML::Functions

== Class Methods

--- first(element, path = nil, namespaces = {}, variables = {})

--- each(element, path = nil, namespaces = {}, variables = {}) {|e| ... }

--- match(element, path = nil, namespaces = {}, variables = {})

== Constants

--- EMPTY_HASH
