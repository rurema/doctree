require rexml/child

= class REXML::Comment < REXML::Child
include Comparable

== Class Methods

--- new(first, second = nil)

== Instance Methods

--- string
--- string=(value)

--- clone

--- write(output, indent = -1, transitive = false, ie_hack = false)

--- to_s

--- <=>(other)

--- ==(other)

--- node_type

== Constants

--- START

--- STOP
