#@#require logger
require soap/rpc/soaplet
require soap/streamHandler
#@#require webrick

= class SOAP::RPC::HTTPServer < Logger::Application

== Class Methods

--- new(config)
#@todo

== Instance Methods

--- server
#@todo

--- default_namespace
--- default_namespace=(value)
#@todo

--- on_init
#@todo

--- status
#@todo

--- shutdown
#@todo

--- mapping_registry
--- mapping_registry=(mapping_registry)
#@todo

--- generate_explicit_type
--- generate_explicit_type=(generate_explicit_type)
#@todo

--- add_rpc_request_servant(factory, namespace = @default_namespace)
#@todo

--- add_rpc_servant(obj, namespace = @default_namespace)
#@todo

--- add_request_headerhandler(factory)
#@todo

--- add_headerhandler(obj)
--- add_rpc_headerhandler(obj)
#@todo

--- add_rpc_method(obj, name, *param)
--- add_method(obj, name, *param)
#@todo

--- add_rpc_method_as(obj, name, name_as, *param)
--- add_method_as(obj, name, name_as, *param)
#@todo

--- add_document_method(obj, soapaction, name, req_qnames, res_qnames)
#@todo

--- add_rpc_operation(receiver, qname, soapaction, name, param_def, opt = {})
#@todo

--- add_rpc_request_operation(factory, qname, soapaction, name, param_def, opt = {})
#@todo

--- add_document_operation(reseicer, soapaction, name, param_def, opt = {})
#@todo

--- add_document_request_operation(factory, soapaction, name, param_def, opt = {})
#@todo

