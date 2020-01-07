require wsdl/info
require wsdl/soap/classDefCreatorSupport
require soap/rpc/element


= class WSDL::SOAP::MethodDefCreator < Object
include WSDL::SOAP::ClassDefCreatorSupport


== Class Methods

--- new(definitions)
#@todo

== Instance Methods

--- collect_documentparameter(operation)
#@todo

--- collect_rpcparameter(operation)
#@todo


--- definitions
#@todo

--- dump(porttype)
#@todo


== Private Instance Methods

--- dump_method(operation, binding)
#@todo

--- rpcdefinedtype(part)
#@todo

--- documentdefinedtype(part)
#@todo

--- elementqualified(part)
#@todo

--- param_set(io_type, name, type, ele = nil)
#@todo

--- collect_type(type)
#@todo

--- param2str(params)
#@todo

--- type2str(type)
#@todo

--- ele2str(ele)
#@todo

--- cdr(ary)
#@todo

