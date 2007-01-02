#@#require rexml/namespace
#@#require rexml/text

= class REXML::Attribute
include REXML::Node
include REXML::Namespace

== Class Methods

--- new(first, second = nil, parrent = nil)

== Instance Methods

--- element

--- normalized=(value)

--- prefix

--- namespace(arg = nil)

--- ==(other)

--- hash

--- to_string

--- to_s

--- value

--- clone

--- element=(element)

--- remove

--- write(output, indent = -1)

--- node_type

#@since 1.8.2
--- inspect

--- xpath
#@end

== Constants

--- PATTERN
