#@since 1.8.1

require wsdl/info
require xsd/namedelements

= class WSDL::Definitions < WSDL::Info

== Class Methods

--- new

--- parse_element(element)

== Instance Methods

--- add_type(complextype)

--- binding(name)

--- bindings

#@since 1.8.3
--- collect_attributes

#@end

--- collect_complextypes

--- collect_elements

#@since 1.8.2
--- collect_simpletypes

#@end

#@since 1.8.3
--- importedschema

属性

#@end

--- imports

属性

--- inspect

#@since 1.8.3
--- location
--- location=(val)

#@end

--- message(name)


--- messages


--- name

属性

--- parse_attr(attr, name)

--- parse_element(element)

[[m:WSDL::Info#parse_element]]を呼び出そうとするが実装が無い

--- porttype

--- porttype_binding

--- porttypes

#@if(version <= "1.8.2")
--- root
--- root=(val)

#@end

--- service

--- services

--- targetnamespace
--- targetnamespace=(targetnamespace)

属性

#@end
