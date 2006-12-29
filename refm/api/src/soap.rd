#@since 1.8.1
#@# = soap

#@# [[unknown:ºπ…Æº‘ ÁΩ∏]]

#@since 1.8.2
#@# soap/attachment.rb
#@include(soap/SOAPAttachment)
#@include(soap/Attachment)
#@include(soap/Mapping__AttachmentFactory)
#@end

#@include(soap/baseData.rd)
#@include(soap/element.rd)

#@# soap/encodingstype/aspDotNetHandler.rb
#@include(soap/EncodingStyle__ASPDotNetHandler)
#@include(soap/EncodingStyle__ASPDotNetHandler__SOAPTemporalObject)
#@include(soap/EncodingStyle__ASPDotNetHandler__SOAPUnknown)

#@# soap/encodingstype/handler.rb
#@include(soap/EncodingStyle__Handler)

#@# soap/encodingstype/literalHandler.rb
#@include(soap/EncodingStyle__LiteralHandler)
#@include(soap/EncodingStyle__LiteralHandler__SOAPTemporalObject)
#@include(soap/EncodingStyle__LiteralHandler__SOAPUnknown)

#@# soap/encodingstype/soapHandler.rb
#@include(soap/EncodingStyle__SOAPHandler)
#@include(soap/EncodingStyle__SOAPHandler__SOAPTemporalObject)
#@include(soap/EncodingStyle__SOAPHandler__SOAPUnknown)

#@# soap/generator.rb
#@include(soap/SOAPGenerator)

#@since 1.8.2
#@# soap/header/handler.rb
#@include(soap/Header__Handler)

#@# soap/header/handlerset.rb
#@include(soap/Header__HandlerSet)

#@# soap/header/simplehandler.rb
#@include(soap/Header__SimpleHandler)
#@end

#@since 1.8.3
#@# soap/httpconfigloader.rb
#@include(soap/HTTPConfigLoader)
#@end

#@include(soap/mapping.rd)
#@include(soap/mapping/typeMap.rd)
#@include(soap/mapping/wsdlencodedregistry.rd)
#@include(soap/mapping/wsdlliteralregistry.rd)

#@# soap/marshal.rb
#@#@include(soap/Marshal)

#@# soap/mimemessage.rb
#@#@include(soap/MIMEMessage)
#@#@include(soap/MIMEMessage__MIMEMessageError)
#@#@include(soap/MIMEMessage__Headers)
#@#@include(soap/MIMEMessage__Part)

#@# soap/netHttpClient.rb
#@#@include(soap/NetHttpClient)
#@#@include(soap/NetHttpClient__SessionManager)
#@#@include(soap/NetHttpClient__Response)

#@# soap/parser.rb
#@#@include(soap/Parser)
#@#@include(soap/Parser__ParserError)
#@#@include(soap/Parser__FormatDecodeError)
#@#@include(soap/Parser__UnexpectedElementError)
#@#@include(soap/Parser__ParseFrame)
#@#@include(soap/Parser__ParseFrame__NodeContainer)

#@# soap/processor.rb
#@#@include(soap/Processor)

#@# soap/property.rb
#@#@include(soap/Property)
#@#@include(soap/Property__Util)
#@# add Enumerable#inject

#@# soap/rpc/cgistab.rb
#@#@include(soap/RPC__CGIStab)
#@#@include(soap/RPC__CGIStab__SOAPRequest)
#@#@include(soap/RPC__CGIStab__SOAPStdinRequest)
#@#@include(soap/RPC__CGIStab__SOAPCGIRequest)

#@# soap/rpc/driver.rb
#@#@include(soap/RPC__Driver)

#@# soap/rpc/element.rb
#@#@include(soap/SOAPBody)
#@#@include(soap/RPC__RPCError)
#@#@include(soap/RPC__MethodDefinitionError)
#@#@include(soap/RPC__ParameterError)
#@#@include(soap/RPC__SOAPMethod)
#@#@include(soap/RPC__SOAPMethodRequest)
#@#@include(soap/RPC__SOAPMethodResponse)
#@#@include(soap/RPC__SOAPVoid)

#@# soap/rpc/httpserver.rb
#@#@include(soap/RPC__HTTPServer)

#@# soap/rpc/proxy.rb
#@#@include(soap/RPC__Proxy)
#@#@include(soap/RPC__Proxy__Operation)

#@# soap/rpc/router.rb
#@#@include(soap/RPC__Router)
#@#@include(soap/RPC__Router__Operation)
#@#@include(soap/RPC__Router__ApplicationScopeOperation)
#@#@include(soap/RPC__Router__RequestScopeOperation)

#@# soap/rpc/rpc.rb
#@#@include(soap/RPC)

#@# soap/rpc/soaplet.rb
#@# WEBrick::Log#debug
#@#@include(soap/RPC__SOAPlet)

#@# soap/rpc/standaloneServer.rb
#@#@include(soap/RPC__StandaloneServer)

#@# soap/soap.rb
#@# SOAP
#@#@include(soap/Error)

#@#@include(soap/StreamError)
#@#@include(soap/HTTPStreamError)
#@#@include(soap/PostUnavailableError)
#@#@include(soap/MPostUnavailableError)

#@#@include(soap/ArrayIndexOutOfBoundsError)
#@#@include(soap/ArrayStoreError)

#@#@include(soap/RPCRoutingError)
#@#@include(soap/EmptyResponseError)
#@#@include(soap/ResponseFormatError)

#@#@include(soap/UnhandledMustUnderstandHeaderError)

#@#@include(soap/FaultError)

#@#@include(soap/Env)

#@# Object#instance_variable_get
#@# Object#instance_variable_set
#@# Kernel#warn

#@# soap/streamHandler.rb
#@#@include(soap/StreamHandler)
#@#@include(soap/StreamHandler__ConnectionData)
#@#@include(soap/HTTPStreamHandler)

#@end
