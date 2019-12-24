#@#require xsd/qname
#@#require xsd/charset

= module SOAP

== Constants

--- VERSION
#@todo

--- PropertyName
#@todo

--- EnvelopeNamespace
#@todo

--- EncodingNamespace
#@todo

--- LiteralNamespace
#@todo

--- NextActor
#@todo

--- EleEnvelope
#@todo

--- EleHeader
#@todo

--- EleBody
#@todo

--- EleFault
#@todo

--- EleFaultString
#@todo

--- EleFaultActor
#@todo

--- EleFaultCode
#@todo

--- EleFaultDetail
#@todo

--- AttrMustUnderstand
#@todo

--- AttrEncodingStyle
#@todo

--- AttrActor
#@todo

--- AttrRoot
#@todo

--- AttrArrayType
#@todo

--- AttrOffset
#@todo

--- AttrPosition
#@todo

--- ValueArray
#@todo

--- EleEnvelopeName
#@todo

--- EleHeaderName
#@todo

--- EleBodyName
#@todo

--- EleFaultName
#@todo

--- EleFaultStringName
#@todo

--- EleFaultActorName
#@todo

--- EleFaultCodeName
#@todo

--- EleFaultDetailName
#@todo

--- AttrMustUnderstandName
#@todo

--- AttrEncodingStyleName
#@todo

--- AttrRootName
#@todo

--- AttrArrayTypeName
#@todo

--- AttrOffsetName
#@todo

--- AttrPositionName
#@todo

--- ValueArrayName
#@todo

--- Base64Literal
#@todo

--- SOAPNamespaceTag
#@todo

--- XSDNamespaceTag
#@todo

--- XSINamespaceTag
#@todo

--- MediaType
#@todo

= class SOAP::Error < StandardError

= class SOAP::StreamError < SOAP::Error

= class SOAP::HTTPStreamError < SOAP::Error

= class SOAP::PostUnavailableError < SOAP::Error

= class SOAP::MPostUnavailableError < SOAP::Error

= class SOAP::ArrayIndexOutOfBoundsError < SOAP::Error

= class SOAP::ArrayStoreError < SOAP::Error

= class SOAP::RPCRoutingError < SOAP::Error

= class SOAP::EmptyResponseError < SOAP::Error

= class SOAP::ResponseFormatError < SOAP::Error

= class SOAP::UnhandledMustUnderstandHeaderError < SOAP::Error

#@include(soap/FaultError)
#@include(soap/Env)

#@# add Object#instance_variable_get
#@# add Object#instance_variable_set
#@# add Kernel#warn

