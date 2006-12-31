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

#@include(soap/marshal.rd)

#@since 1.8.2
#@# soap/mimemessage.rb
#@include(soap/MIMEMessage)
#@include(soap/MIMEMessage__Headers)
#@include(soap/MIMEMessage__Part)
#@end

#@# soap/netHttpClient.rb
#@include(soap/NetHttpClient)
#@include(soap/NetHttpClient__SessionManager)
#@include(soap/NetHttpClient__Response)

#@# soap/parser.rb
#@include(soap/Parser)
#@include(soap/Parser__ParseFrame)
#@include(soap/Parser__ParseFrame__NodeContainer)

#@# soap/processor.rb
#@include(soap/Processor)

#@# soap/property.rb
#@include(soap/Property)
#@include(soap/Property__Util)
#@# add Enumerable#inject

#@# soap/rpc/cgistub.rb
#@include(soap/RPC__CGIStub)
#@include(soap/RPC__CGIStub__SOAPRequest)
#@include(soap/RPC__CGIStub__SOAPStdinRequest)
#@include(soap/RPC__CGIStub__SOAPFCGIRequest)

#@# soap/rpc/driver.rb
#@include(soap/RPC__Driver)

#@include(soap/rpc/element.rd)

#@# soap/rpc/httpserver.rb
#@include(soap/RPC__HTTPServer)

#@# soap/rpc/proxy.rb
#@include(soap/RPC__Proxy)
#@include(soap/RPC__Proxy__Operation)

#@# soap/rpc/router.rb
#@include(soap/RPC__Router)
#@include(soap/RPC__Router__Operation)
#@include(soap/RPC__Router__ApplicationScopeOperation)
#@include(soap/RPC__Router__RequestScopeOperation)

#@# soap/rpc/rpc.rb
#@include(soap/RPC__)

#@include(soap/rpc/soaplet.rd)

#@# soap/rpc/standaloneServer.rb
#@include(soap/RPC__StandaloneServer)

#@include(soap/soap.rd)
#@# add Object#instance_variable_get
#@# add Object#instance_variable_set
#@# add Kernel#warn

#@# soap/streamHandler.rb
#@include(soap/StreamHandler)
#@include(soap/StreamHandler__ConnectionData)
#@include(soap/HTTPStreamHandler)

#@end
