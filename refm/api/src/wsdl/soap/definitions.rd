require wsdl/info
require xsd/namedelements
require soap/mapping

= class WSDL::Definitions < WSDL::Info

== Class Methods

--- array_complextype

--- exception_complextype

--- fault_complextype

--- soap_rpc_complextypes

== Instance Methods

#@since 1.8.2
--- collect_faulttypes

#@end

--- soap_rpc_complextypes(binding)


== Private Instance Methods

--- collect_fault_messages

--- rpc_operation_complextypes(binding)

--- op_bind_rpc?(op_bind)

--- elements_from_message(message)

