#@#require rexml/child
#@#require rexml/source

= class REXML::AttlistDecl < REXML::Child
include Enumerable

== Class Methods

--- new(source)

== Instance Methods

--- [](key)

--- each {|name, value| ... }

--- element_name

--- include?(key)

--- node_type

--- write(out, indent = -1)
