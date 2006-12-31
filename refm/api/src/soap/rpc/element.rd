#@since 1.8.1

= reopen SOAP::SOAPBody

== Instance Methods

--- request

--- response

--- outparams

--- fault
--- fault=(fault)

= class SOAP::RPC::RPCError < SOAP::Error

= class SOAP::RPC::MethodDefinitionError < SOAP::RPC::RPCError

= class SOAP::RPC::ParameterError < SOAP::RPC::RPCError

= class SOAP::RPC::SOAPMethod < SOAP::SOAPStruct

== Class Methods

--- new(qname, param_def = nil)

--- param_count(paramdef, *type)

--- derive_rpc_param_def(obj, name, *param)

--- create_rpc_param_def(param_names)

--- create_doc_param_def(req_qnames, res_qnames)

== Instance Methods

--- param_def

--- inparam

--- outparam

--- retval_name

--- retval_class_name

--- have_outparam?

--- input_params

--- output_params

--- set_param(params)

--- set_outparam(params)

== Constants

--- RETVAL

--- IN

--- OUT

--- INOUT

= class SOAP::RPC::SOAPMethodRequest < SOAP::RPC::SOAPMethod

== Class Methods

--- create_request(qname, *params)

--- new(qname, param_def = nil, soapaction = nil

== Instance Methods

--- soapaction
--- soapaction=(value)

--- each {|name, inparam| ... }

--- dup

--- create_method_response(response_name = nil)

= class SOAP::RPC::SOAPMethodResponse < SOAP::RPC::SOAPMethod

== Class Methods

--- new(qname, param_def = nil)

== Instance Methods

--- retval=(retval)

--- each {|retval_name, retval| ... }

= class SOAP::RPC::SOAPVoid < XSD::XSDAnySimpleType

== Class Methods

--- new

== Constants

--- Name

#@end
