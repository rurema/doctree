require wsdl/info
require wsdl/soap/classDefCreatorSupport
require soap/rpc/element


= class WSDL::SOAP::MethodDefCreator < Object
include ClassDefCreatorSupport


== Class Methods

--- new(definitions)

== Instance Methods

#@since 1.8.3
--- collect_documentparameter(operation)

--- collect_rpcparameter(operation)

#@end

--- definitions

--- dump(porttype)


== Private Instance Methods

--- dump_method(operation, binding)

--- rpcdefinedtype(part)

--- documentdefinedtype(part)

--- elementqualified(part)

--- param_set(io_type, name, type, ele = nil)

--- collect_type(type)

--- param2str(params)

--- type2str(type)

--- ele2str(ele)

--- cdr(ary)

