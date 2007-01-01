require wsdl/xmlSchema/complexType
require soap/mapping

= reopen WSDL::XMLSchema::ComplexType

== Instance Methods

--- compoundtype

--- check_type

--- child_type(name = nil)

--- child_defined_complextype(name)

--- find_arytype

--- find_aryelement

== Private Instance Methods

--- element_simpletype(element)

--- check_array_content(content)

--- content_arytype
