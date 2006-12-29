#@if (version >= "1.8.0")
#@# = soap

#@# [[unknown:ºπ…Æº‘ ÁΩ∏]]

#@since 1.8.2
# soap/attachment.rb
#@include(soap/SOAPAttachment)
#@include(soap/Attachment)
#@include(soap/Mapping__AttachmentFactory)
#@end

# soap/baseData.rb
#@include(soap/SOAPModuleUtils)
#@include(soap/SOAPType)
#@include(soap/SOAPBasetype)
#@include(soap/SOAPCompoundtype)
#@#@include(soap/SOAPReference)
#@#@include(soap/SOAPExternalReference)
#@#@include(soap/SOAPNil)
#@#@include(soap/SOAPRawString)
#@#@include(soap/SOAPAnySimpleType)
#@#@include(soap/SOAPString)
#@#@include(soap/SOAPBoolean)
#@#@include(soap/SOAPDecimal)
#@#@include(soap/SOAPFloat)
#@#@include(soap/SOAPDouble)
#@#@include(soap/SOAPDuration)
#@#@include(soap/SOAPDateTime)
#@#@include(soap/SOAPTime)
#@#@include(soap/SOAPDate)
#@#@include(soap/SOAPGYearMonth)
#@#@include(soap/SOAPGYear)
#@#@include(soap/SOAPGMonthDay)
#@#@include(soap/SOAPGDay)
#@#@include(soap/SOAPGMonth)
#@#@include(soap/SOAPHexBinary)
#@#@include(soap/SOAPBase64)
#@#@include(soap/SOAPAnyURI)
#@#@include(soap/SOAPQName)
#@#@include(soap/SOAPInteger)
#@#@include(soap/SOAPNonPositiveInteger)
#@#@include(soap/SOAPNegativeInteger)
#@#@include(soap/SOAPLong)
#@#@include(soap/SOAPInt)
#@#@include(soap/SOAPShort)
#@#@include(soap/SOAPByte)
#@#@include(soap/SOAPNonNegativeInteger)
#@#@include(soap/SOAPUnsignedLong)
#@#@include(soap/SOAPUnsignedInt)
#@#@include(soap/SOAPUnsignedShort)
#@#@include(soap/SOAPUnsignedByte)
#@#@include(soap/SOAPPositiveInteger)
#@#@include(soap/SOAPStruct)
#@#@include(soap/SOAPElement)
#@#@include(soap/SOAPArray)

# soap/element.rb
#@#@include(soap/SOAPEnvelopeElement)
#@#@include(soap/SOAPFault)
#@#@include(soap/SOAPBody)
#@#@include(soap/SOAPHeaderItem)
#@#@include(soap/SOAPHeader)
#@#@include(soap/SOAPEnvelope)

# soap/encodingstype/aspDotNetHandler.rb
#@#@include(soap/EncodingStyle__ASPDotnetHandler)
#@#@include(soap/EncodingStyle__ASPDotnetHandler__SOAPTemporalObject)
#@#@include(soap/EncodingStyle__ASPDotnetHandler__SOAPUnknown)

# soap/encodingstype/handler.rb
#@#@include(soap/EncodingStyle__Handler)
#@#@include(soap/EncodingStyle__Handler__EncodingStyleError)

# soap/encodingstype/literalHandler.rb
#@#@include(soap/EncodingStyle__LiteralHandler)
#@#@include(soap/EncodingStyle__LiteralHandler__SOAPTemporalObject)
#@#@include(soap/EncodingStyle__LiteralHandler__SOAPUnknown)

# soap/encodingstype/soapHandler.rb
#@#@include(soap/EncodingStyle__SOAPHandler)
#@#@include(soap/EncodingStyle__SOAPHandler__SOAPTemporalObject)
#@#@include(soap/EncodingStyle__SOAPHandler__SOAPUnknown)

# soap/generator.rb
#@#@include(soap/SOAPGenerator)
#@#@include(soap/SOAPGenerator__FormatEncodingError)

# soap/header/handler.rb
#@#@include(soap/Header__Handler)

# soap/header/handlerset.rb
#@#@include(soap/Header__HandlerSet)

# soap/header/simplehandler.rb
#@#@include(soap/Header__SimpleHandler)

# soap/httpconfigloader.rb
#@#@include(soap/HTTPConfigLoader)

# soap/mapping/factory.rb
#@#@include(soap/Mapping/Factory)
#@#@include(soap/Mapping/StringFactory_)
#@#@include(soap/Mapping/BasetypeFactory_)
#@#@include(soap/Mapping/DateTimeFactory_)
#@#@include(soap/Mapping/Base64Factory_)
#@#@include(soap/Mapping/URIFactory_)
#@#@include(soap/Mapping/ArrayFactory_)
#@#@include(soap/Mapping/TypedFactory_)
#@#@include(soap/Mapping/TypedStructFactory_)
#@#@include(soap/Mapping/HashFactory_)

# soap/mapping/mapping.rb
#@#@include(soap/Mapping)
#@#@include(soap/Mapping__TraverseSupport)

# soap/mapping.rb
#@#@include(soap/Marshallable)
#@#@include(soap/Mapping__MappedExceptin)
#@#@include(soap/Mapping__SOAPException)
#@#@include(soap/Mapping__Object)
#@#@include(soap/Mapping__MappingError)
#@#@include(soap/Mapping__Registry)
#@#@include(soap/Mapping__Registry__Map)

# soap/mapping/rubytypeFactory.rb
#@#@include(soap/Mapping__RubytypeFactory)

# soap/mapping/typeMap.rb

# soap/mapping/wsdlencodedregistry.rb
#@#@include(soap/Mapping__WSDLEncodedRegistry)

# soap/mapping/wsdlliteralregistry.rb
#@#@include(soap/Mapping__WSDLLiteralRegistry)

# soap/mapping.rb

# soap/marshal.rb
#@#@include(soap/Marshal)

# soap/mimemessage.rb
#@#@include(soap/MIMEMessage)
#@#@include(soap/MIMEMessage__MIMEMessageError)
#@#@include(soap/MIMEMessage__Headers)
#@#@include(soap/MIMEMessage__Part)

# soap/netHttpClient.rb
#@#@include(soap/NetHttpClient)
#@#@include(soap/NetHttpClient__SessionManager)
#@#@include(soap/NetHttpClient__Response)

# soap/parser.rb
#@#@include(soap/Parser)
#@#@include(soap/Parser__ParserError)
#@#@include(soap/Parser__FormatDecodeError)
#@#@include(soap/Parser__UnexpectedElementError)
#@#@include(soap/Parser__ParseFrame)
#@#@include(soap/Parser__ParseFrame__NodeContainer)

# soap/processor.rb
#@#@include(soap/Processor)

# soap/property.rb
#@#@include(soap/Property)
#@#@include(soap/Property__Util)
# add Enumerable#inject

# soap/rpc/cgistab.rb
#@#@include(soap/RPC__CGIStab)
#@#@include(soap/RPC__CGIStab__SOAPRequest)
#@#@include(soap/RPC__CGIStab__SOAPStdinRequest)
#@#@include(soap/RPC__CGIStab__SOAPCGIRequest)

# soap/rpc/driver.rb
#@#@include(soap/RPC__Driver)

# soap/rpc/element.rb
#@#@include(soap/SOAPBody)
#@#@include(soap/RPC__RPCError)
#@#@include(soap/RPC__MethodDefinitionError)
#@#@include(soap/RPC__ParameterError)
#@#@include(soap/RPC__SOAPMethod)
#@#@include(soap/RPC__SOAPMethodRequest)
#@#@include(soap/RPC__SOAPMethodResponse)
#@#@include(soap/RPC__SOAPVoid)

# soap/rpc/httpserver.rb
#@#@include(soap/RPC__HTTPServer)

# soap/rpc/proxy.rb
#@#@include(soap/RPC__Proxy)
#@#@include(soap/RPC__Proxy__Operation)

# soap/rpc/router.rb
#@#@include(soap/RPC__Router)
#@#@include(soap/RPC__Router__Operation)
#@#@include(soap/RPC__Router__ApplicationScopeOperation)
#@#@include(soap/RPC__Router__RequestScopeOperation)

# soap/rpc/rpc.rb
#@#@include(soap/RPC)

# soap/rpc/soaplet.rb
# WEBrick::Log#debug
#@#@include(soap/RPC__SOAPlet)

# soap/rpc/standaloneServer.rb
#@#@include(soap/RPC__StandaloneServer)

# soap/soap.rb
# SOAP
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

# Object#instance_variable_get
# Object#instance_variable_set
# Kernel#warn

# soap/streamHandler.rb
#@#@include(soap/StreamHandler)
#@#@include(soap/StreamHandler__ConnectionData)
#@#@include(soap/HTTPStreamHandler)

#@since 1.8.1
#@include(soap/wsdlDriver.rd)
#@end

#@end
