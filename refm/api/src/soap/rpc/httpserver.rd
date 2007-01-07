#@since 1.8.1
#@#require logger
require soap/rpc/soaplet
require soap/streamHandler
#@#require webrick

= class SOAP::RPC::HTTPServer < Logger::Application

== Class Methods

--- new(config)

== Instance Methods

--- server

--- default_namespace
--- default_namespace=(value)

--- on_init

--- status

--- shutdown

--- mapping_registry
--- mapping_registry=(mapping_registry)

--- generate_explicit_type
--- generate_explicit_type=(generate_explicit_type)

--- add_rpc_request_servant(factory, namespace = @default_namespace)

--- add_rpc_servant(obj, namespace = @default_namespace)

--- add_request_headerhandler(factory)

--- add_headerhandler(obj)
--- add_rpc_headerhandler(obj)

--- add_rpc_method(obj, name, *param)
--- add_method(obj, name, *param)

--- add_rpc_method_as(obj, name, name_as, *param)
--- add_method_as(obj, name, name_as, *param)

--- add_document_method(obj, soapaction, name, req_qnames, res_qnames)

--- add_rpc_operation(receiver, qname, soapaction, name, param_def, opt = {})

--- add_rpc_request_operation(factory, qname, soapaction, name, param_def, opt = {})

--- add_document_operation(reseicer, soapaction, name, param_def, opt = {})

--- add_document_request_operation(factory, soapaction, name, param_def, opt = {})

#@end
