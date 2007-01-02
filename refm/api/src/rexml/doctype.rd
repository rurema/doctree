= class REXML::DocType < REXML::Parent
include REXML::XMLTokens

== Class Methods

--- new(first, parent = nil)

== Instance Methods

--- name

--- external_id

--- entities

--- namespaces

--- node_type

--- attributes_of(element)

--- attribute_of(element, attribute)

--- clone

--- write(output, indent = 0, transitive = false, ie_hack = false)

#@since 1.8.2
--- context
#@end

--- entity(name)

--- add(child)

#@since 1.8.5
--- public

--- system

--- notations

--- notation(name)
#@end

== Constants

--- START

--- STOP

--- SYSTEM

--- PUBLIC

--- DEFAULT_ENTITIES

= class REXML::Declaration < REXML::Child

== Class Methods

--- new(src)

== Instance Methods

--- to_s

--- write(output, indent)

= class REXML::ElementDecl < REXML::Declaration

== Class Methods

--- new(src)

= class REXML::ExternalEntity < REXML::Child

== Class Methods

--- new(src)

== Instance Methods

--- to_s

--- write(output, indent)

= class REXML::NotationDecl < REXML::Child

== Class Methods

--- new(name, middle, pub, sys)

== Instance Methods

--- public
--- public=(value)

--- system
--- system=(value)

--- to_s

--- write(output, indent = -1)

--- name
