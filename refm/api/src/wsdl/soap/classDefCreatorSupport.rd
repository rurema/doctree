require wsdl/info
require soap/mapping
require soap/mapping/typeMap
require xsd/codegen/gensupport

= module WSDL::SOAP::ClassDefCreatorSupport
include XSD::CodeGen::GenSupport

== Instance Methods

--- basetype_mapped_class(name)

--- create_class_name(qname)

--- dq(ele)

#@since 1.8.3
--- dqname(qname)

#@end

--- dump_method_signature(operation)

--- ndq(ele)

--- sym(ele)

== Private Instance Methods

--- dump_inout_type(param)

--- dump_inputparam(input)

--- add_at(base, str, pos)



