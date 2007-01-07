#@since 1.8.1
require xsd/qname
require xsd/charset

= module SOAP

== Constants

--- VERSION

--- PropertyName

--- EnvelopeNamespace

--- EncodingNamespace

--- LiteralNamespace

--- NextActor

--- EleEnvelope

--- EleHeader

--- EleBody

--- EleFault

--- EleFaultString

--- EleFaultActor

--- EleFaultCode

--- EleFaultDetail

--- AttrMustUnderstand

--- AttrEncodingStyle

--- AttrActor

--- AttrRoot

--- AttrArrayType

--- AttrOffset

--- AttrPosition

--- ValueArray

--- EleEnvelopeName

--- EleHeaderName

--- EleBodyName

--- EleFaultName

--- EleFaultStringName

--- EleFaultActorName

--- EleFaultCodeName

--- EleFaultDetailName

--- AttrMustUnderstandName

--- AttrEncodingStyleName

--- AttrRootName

--- AttrArrayTypeName

--- AttrOffsetName

--- AttrPositionName

--- ValueArrayName

--- Base64Literal

--- SOAPNamespaceTag

--- XSDNamespaceTag

--- XSINamespaceTag

--- MediaType

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

#@end
