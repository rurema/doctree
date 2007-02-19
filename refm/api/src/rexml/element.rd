= class REXML::Element < REXML::Parent
include REXML::Namespace

== Class Methods

--- new(arg = UNDEFINED, parent = nil, context = nil)
#@todo

== Instance Methods

--- attributes
#@todo

--- elements
#@todo

--- context
--- context=(value)
#@todo

#@since 1.8.2
--- inspect
#@todo
#@end

--- clone
#@todo

#@since 1.8.3
--- root_node
#@todo
#@end

--- root
#@todo

--- document
#@todo

--- whitespace
#@todo

--- ignore_whitespace_nodes
#@todo

--- raw
#@todo

--- prefixes
#@todo

--- namespaces
#@todo

--- namespace
#@todo

--- add_namespace(prefix, uri = nil)
#@todo

--- delete_namespace(namespace = "xmlns")
#@todo

--- add_element(element, attrs = nil)
#@todo

--- delete_element(element)
#@todo

--- has_elements?
#@todo

--- each_element_with_attribute(key, value = nil, max = 0, name = nil) {|element| ... }
#@todo

--- each_element_with_text(text = nil, max = 0, name = nil) {|element| ... }
#@todo

--- each_element(xpath = nil) {|element| ... }
#@todo

--- get_elements(xpath)
#@todo

--- next_element
#@todo

--- previous_element
#@todo

--- has_text?
#@todo

--- text(path = nil)
#@todo

--- get_text(path = nil)
#@todo

--- text=(text)
#@todo

--- add_text(text)
#@todo

--- node_type
#@todo

#@since 1.8.2
--- xpath
#@todo
#@end

--- attribute(name, namespace = nil)
#@todo

--- has_attributes?
#@todo

--- add_attribute(key, value = nil)
#@todo

--- add_attributes(hash)
#@todo

--- delete_attribute(key)
#@todo

--- cdatas
#@todo

--- comments
#@todo

--- instructions
#@todo

--- texts
#@todo

--- write(writer = $stdout, indent = -1, transitive = false, ie_hack = false)
#@todo

== Constants

--- UNDEFINED
#@todo

= class REXML::Elements
include Enumerable

== Class Methods

--- new(parent)
#@todo

== Instance Methods

--- [](index, name = nil)
#@todo

--- []=(index, element)
#@todo

--- empty?
#@todo

--- index(element)
#@todo

--- delete(element)
#@todo

--- delete_all(xpath)
#@todo

--- add(element = nil)
--- <<(element = nil)
#@todo

--- each(xpath = nil) {|element| ... }
#@todo

--- size
#@todo

--- to_a(xpath = nil)
#@todo

#@since 1.8.6
--- collect(xpath = nil) {|element| .. }
#@todo

--- inject(xpath = nil, initial = nil) {|element| ... }
#@todo
#@end

= class REXML::Attributes < Hash

== Class Methods

--- new(element)
#@todo

== Instance Methods

--- [](name)
#@todo

#@since 1.8.2
--- to_a
#@todo
#@end

--- length
--- size
#@todo

--- each_attribute {|attribute| ... }
#@todo

--- each {|name, value| ... }
#@todo

--- get_attribute(name)
#@todo

--- []=(name, value)
#@todo

--- prefixes
#@todo

--- namespaces
#@todo

--- delete(attribute)
#@todo

--- add(attribute)
--- <<(attribute)
#@todo

--- delete_all(name)
#@todo

#@since 1.8.5
--- get_attribute_ns(namespace, name)
#@todo
#@end
