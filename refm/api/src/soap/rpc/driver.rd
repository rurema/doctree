require soap/soap
require soap/mapping
require soap/mapping/wsdlliteralregistry
require soap/rpc/rpc
require soap/rpc/proxy
require soap/rpc/element
require soap/streamHandler
require soap/property
require soap/header/handlerset

= class SOAP::RPC::Driver < Object

== Class Methods

--- __attr_proxy(symbol, assignable = false)
#@todo

--- new(endpoint_url, namespace = nil, soapaction = nil)
#@todo

== Instance Methods

--- endpoint_url
--- endpoint_url=(value)
#@todo

--- mapping_registry
--- mapping_registry=(value)
#@todo

--- default_encodingstyle
--- default_encodingstyle=(value)
#@todo

--- generate_explicit_type
--- generate_explicit_type=(value)
#@todo

--- allow_unqualified_element
--- allow_unqualified_element=(value)
#@todo

--- headerhandler
--- headerhandler=(value)
#@todo

--- streamhandler
--- streamhandler=(value)
#@todo

--- test_loopback_response
--- test_loopback_response=(value)
#@todo

--- reset_stream
--- reset_stream=(value)
#@todo

--- proxy
#@todo

--- options
#@todo

--- soapaction
--- soapaction=(value)
#@todo

--- inspect
#@todo

--- httpproxy
--- httpproxy=(httpproxy)
#@todo

--- wiredump_dev
--- wiredump_dev=(value)
#@todo

--- mandatorycharset
#@todo

--- wiredump_file_base
--- wiredump_file_base=(value)
#@todo

--- loadproperty(propertyname)
#@todo

--- add_rpc_method(name, *params)
--- add_method(name, *params)
#@todo

--- add_rpc_method_as(name, name_as, *params)
--- add_method_as(name, name_as, *params)
#@todo

--- add_rpc_method_with_soapaction(name, soapaction, *params)
--- add_method_with_soapaction(name, soapaction, *params)
#@todo

--- add_rpc_method_with_soapaction_as(name, name_as, soapaction, *params)
--- add_method_with_soapaction_as(name, name_as, soapaction, *params)
#@todo

--- add_document_method(name, soapaction, req_qname, res_qname)
#@todo

--- add_rpc_operation(qname, soapaction, name, param_def, opt = {})
#@todo

--- add_document_operation(soapaction, name, param_def, opt = {})
#@todo

--- invoke(headers, body)
#@todo

--- call(name, *params)
#@todo

