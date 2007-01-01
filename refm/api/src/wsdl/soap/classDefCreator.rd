require wsdl/data
require wsdl/soap/classDefCreatorSupport
require xsd/codegen


= class WSDL::SOAP::ClassDefCreator < Object
include ClassDefCreatorSupport

== Constants

#@since 1.8.3
--- DEFAULT_ITEM_NAME
#@end

== Class Methods

--- new(definitions)


== Instance Methods

--- dump(type = nil)

== Private Instance Methods

--- attribute_basetype(attr)

--- basetype_class(type)

--- define_attribute(c, attributes)

--- dump_arraydef(complextype)

--- dump_classdef(qname, typedef, qualified = false)

--- dump_complextype

--- dump_element

--- dump_simpleclassdef(type_or_element)

--- dump_simpletype

--- dump_simpletypedef(qname, simpletype)

--- element_basetype(ele)

--- name_attribute(attribute)

--- name_element(element)

