#@#require xsd/datatypes
require soap/soap
require soap/mapping/typeMap

#@include(baseData/SOAPModuleUtils)
#@include(baseData/SOAPType)
#@include(baseData/SOAPBasetype)
#@include(baseData/SOAPCompoundtype)
#@include(baseData/SOAPReference)
#@include(baseData/SOAPExternalReference)

= class SOAP::SOAPNil < XSD::XSDNil
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPRawString < XSD::XSDString
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPAnySimpleType < XSD::XSDAnySimpleType
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPString < XSD::XSDString
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPBoolean < XSD::XSDBoolean
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPDecimal < XSD::XSDDecimal
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPFloat < XSD::XSDFloat
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPDouble < XSD::XSDDouble
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPDuration < XSD::XSDDuration
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPDateTime < XSD::XSDDateTime
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPTime < XSD::XSDTime
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPDate < XSD::XSDDate
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPGYearMonth < XSD::XSDGYearMonth
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPGYear < XSD::XSDGYear
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPGMonthDay < XSD::XSDGMonthDay
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPGDay < XSD::XSDGDay
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPGMonth < XSD::XSDGMonth
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPHexBinary < XSD::XSDHexBinary
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

#@include(baseData/SOAPBase64)

= class SOAP::SOAPAnyURI < XSD::XSDAnyURI
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPQName < XSD::XSDQName
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPInteger < XSD::XSDInteger
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPNonPositiveInteger < XSD::XSDPositiveInteger
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPNegativeInteger < XSD::XSDNegativeInteger
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPLong < XSD::XSDLong
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPInt < XSD::XSDInt
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPShort < XSD::XSDShort
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPByte < XSD::XSDByte
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPNonNegativeInteger < XSD::XSDNonNegativeInteger
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPUnsignedLong < XSD::XSDUnsignedLong
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPUnsignedInt < XSD::XSDUnsignedInt
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPUnsignedShort < XSD::XSDUnsignedShort
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPUnsignedByte < XSD::XSDUnsignedByte
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

= class SOAP::SOAPPositiveInteger < XSD::XSDPositiveInteger
extend SOAP::SOAPModuleUtils
include SOAP::SOAPBasetype

#@include(baseData/SOAPStruct)
#@include(baseData/SOAPElement)
#@include(baseData/SOAPArray)

