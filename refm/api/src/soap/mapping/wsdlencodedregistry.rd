#@since 1.8.1

= class SOAP::Mapping::WSDLEncodedRegistry < SOAP::Mapping::Registry
include SOAP::Mapping::TraverseSupport

== Class Methods

--- new(definedtypes = XSD::NamedElements::Empty)

== Instance Methods

--- definedelements

--- definedtypes

--- excn_handler_obj2soap
--- excn_handler_obj2soap=(value)

--- excn_handler_soap2obj
--- excn_handler_soap2obj=(value)

--- obj2soap(obj, qname = nil)

--- soap2obj(node, obj_class = nil)

== Constants

--- MapKeyName

--- MapValueName

#@end
