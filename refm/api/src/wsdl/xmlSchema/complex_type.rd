require wsdl/info
require wsdl/xmlSchema/content
require wsdl/xmlSchema/element
require xsd/namedelements

= class WSDL::XMLSchema::ComplexType < WSDL::Info

== Class Methods

--- new(name = nil)

== Instance Methods

--- all_elements=(elements)

--- attributes

--- complexcontent
--- complexcontent=

--- content
#@if(version == "1.8.1")
--- content=
#@end

--- each_element

#@since 1.8.3
--- elementformdefault

#@end

--- final
--- final=

--- find_element(name)

--- find_element_by_name(name)

--- mixed
--- mixed=

--- name
--- name=

--- parse_attr(attr, value)

--- parse_element(element)

--- sequence_elements=(elements)

#@since 1.8.2
--- simplecontent
--- simplecontent=

#@end

--- targetnamespace

== Constants

#@since 1.8.2
--- AnyAsElement

#@end
