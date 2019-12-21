require soap/baseData

= reopen SOAP::SOAPBody

== Instance Methods

--- request
#@todo

--- response
#@todo

--- outparams
#@todo

--- fault
--- fault=(fault)
#@todo

= class SOAP::RPC::RPCError < SOAP::Error

= class SOAP::RPC::MethodDefinitionError < SOAP::RPC::RPCError

= class SOAP::RPC::ParameterError < SOAP::RPC::RPCError

= class SOAP::RPC::SOAPMethod < SOAP::SOAPStruct

== Class Methods

--- new(qname, param_def = nil)
#@todo

--- param_count(paramdef, *type)
#@todo

--- derive_rpc_param_def(obj, name, *param)
#@todo

--- create_rpc_param_def(param_names)
#@todo

--- create_doc_param_def(req_qnames, res_qnames)
#@todo

== Instance Methods

--- param_def
#@todo

--- inparam
#@todo

--- outparam
#@todo

--- retval_name
#@todo

--- retval_class_name
#@todo

--- have_outparam?
#@todo

--- input_params
#@todo

--- output_params
#@todo

--- set_param(params)
#@todo

--- set_outparam(params)
#@todo

== Constants

--- RETVAL
#@todo

--- IN
#@todo

--- OUT
#@todo

--- INOUT
#@todo

= class SOAP::RPC::SOAPMethodRequest < SOAP::RPC::SOAPMethod

== Class Methods

--- create_request(qname, *params)
#@todo

--- new(qname, param_def = nil, soapaction = nil)
#@todo

== Instance Methods

--- soapaction
--- soapaction=(value)
#@todo

--- each {|name, inparam| ... }
#@todo

--- dup
#@todo

--- create_method_response(response_name = nil)
#@todo

= class SOAP::RPC::SOAPMethodResponse < SOAP::RPC::SOAPMethod

== Class Methods

--- new(qname, param_def = nil)
#@todo

== Instance Methods

--- retval=(retval)
#@todo

--- each {|retval_name, retval| ... }
#@todo

= class SOAP::RPC::SOAPVoid < XSD::XSDAnySimpleType

== Class Methods

--- new
#@todo

== Constants

--- Name
#@todo

