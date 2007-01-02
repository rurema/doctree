= class REXML::Element < REXML::Parent
include REXML::Namespace

== Class Methods

--- new(arg = UNDEFINED, parent = nil, context = nil)

== Instance Methods

--- attributes

--- elements

--- context
--- context=(value)

#@since 1.8.2
--- inspect
#@end

--- clone

#@since 1.8.3
--- root_node
#@end

--- root

--- document

--- whitespace

--- ignore_whitespace_nodes

--- raw

--- prefixes

--- namespaces

--- namespace

--- add_namespace(prefix, uri = nil)

--- delete_namespace(namespace = "xmlns")

--- add_element(element, attrs = nil)

--- delete_element(element)

--- has_elements?

--- each_element_with_attribute(key, value = nil, max = 0, name = nil) {|element| ... }

--- each_element_with_text(text = nil, max = 0, name = nil) {|element| ... }

--- each_element(xpath = nil) {|element| ... }

--- get_elements(xpath)

--- next_element

--- previous_element

--- has_text?

--- text(path = nil)

--- get_text(path = nil)

--- text=(text)

--- add_text(text)

--- node_type

#@since 1.8.2
--- xpath
#@end

--- attribute(name, namespace = nil)

--- has_attributes?

--- add_attribute(key, value = nil)

--- add_attributes(hash)

--- delete_attribute(key)

--- cdatas

--- comments

--- instructions

--- texts

--- write(writer = $stdout, indent = -1, transitive = false, ie_hack = false)

== Constants

--- UNDEFINED

= class REXML::Elements
include Enumerable

== Class Methods

--- new(parent)

== Instance Methods

--- [](index, name = nil)

--- []=(index, element)

--- empty?

--- index(element)

--- delete(element)

--- delete_all(xpath)

--- add(element = nil)
--- <<(element = nil)

--- each(xpath = nil) {|element| ... }

--- size

--- to_a(xpath = nil)

#@since 1.8.6
--- collect(xpath = nil) {|element| .. }

--- inject(xpath = nil, initial = nil) {|element| ... }
#@end

= class REXML::Attributes < Hash

== Class Methods

--- new(element)

== Instance Methods

--- [](name)

#@since 1.8.2
--- to_a
#@end

--- length
--- size

--- each_attribute {|attribute| ... }

--- each {|name, value| ... }

--- get_attribute(name)

--- []=(name, value)

--- prefixes

--- namespaces

--- delete(attribute)

--- add(attribute)
--- <<(attribute)

--- delete_all(name)

#@since 1.8.5
--- get_attribute_ns(namespace, name)
#@end
