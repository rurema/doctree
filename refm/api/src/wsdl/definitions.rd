#@since 1.8.1

require wsdl/info
require xsd/namedelements

= class WSDL::Definitions < WSDL::Info

== Class Methods

--- new
#@todo

--- parse_element(element)
#@todo

== Instance Methods

--- add_type(complextype)
#@todo

--- binding(name)
#@todo

--- bindings
#@todo

#@since 1.8.3
--- collect_attributes
#@todo

#@end

--- collect_complextypes
#@todo

--- collect_elements
#@todo

#@since 1.8.2
--- collect_simpletypes
#@todo

#@end

#@since 1.8.3
--- importedschema
#@todo

属性

#@end

--- imports
#@todo

属性

--- inspect
#@todo

#@since 1.8.3
--- location
--- location=(val)
#@todo

#@end

--- message(name)
#@todo


--- messages
#@todo


--- name
#@todo

属性

--- parse_attr(attr, name)
#@todo

--- parse_element(element)
#@todo

[[m:WSDL::Info#parse_element]]を呼び出そうとするが実装が無い

--- porttype
#@todo

--- porttype_binding
#@todo

--- porttypes
#@todo

#@if(version <= "1.8.2")
--- root
--- root=(val)
#@todo

#@end

--- service
#@todo

--- services
#@todo

--- targetnamespace
--- targetnamespace=(targetnamespace)
#@todo

属性

#@end
