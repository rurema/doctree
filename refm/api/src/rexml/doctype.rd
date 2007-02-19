= class REXML::DocType < REXML::Parent
include REXML::XMLTokens

== Class Methods

--- new(first, parent = nil)
#@todo

== Instance Methods

--- name
#@todo

--- external_id
#@todo

--- entities
#@todo

--- namespaces
#@todo

--- node_type
#@todo

--- attributes_of(element)
#@todo

--- attribute_of(element, attribute)
#@todo

--- clone
#@todo

--- write(output, indent = 0, transitive = false, ie_hack = false)
#@todo

#@since 1.8.2
--- context
#@todo
#@end

--- entity(name)
#@todo

--- add(child)
#@todo

#@since 1.8.5
--- public
#@todo

--- system
#@todo

--- notations
#@todo

--- notation(name)
#@todo
#@end

== Constants

--- START
#@todo

--- STOP
#@todo

--- SYSTEM
#@todo

--- PUBLIC
#@todo

--- DEFAULT_ENTITIES
#@todo

= class REXML::Declaration < REXML::Child

== Class Methods

--- new(src)
#@todo

== Instance Methods

--- to_s
#@todo

--- write(output, indent)
#@todo

= class REXML::ElementDecl < REXML::Declaration

== Class Methods

--- new(src)
#@todo

= class REXML::ExternalEntity < REXML::Child

== Class Methods

--- new(src)
#@todo

== Instance Methods

--- to_s
#@todo

--- write(output, indent)
#@todo

= class REXML::NotationDecl < REXML::Child

== Class Methods

--- new(name, middle, pub, sys)
#@todo

== Instance Methods

--- public
--- public=(value)
#@todo

--- system
--- system=(value)
#@todo

--- to_s
#@todo

--- write(output, indent = -1)
#@todo

--- name
#@todo
