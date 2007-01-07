#@since 1.8.1
#@#require xsd/datatypes
require soap/soap
require soap/mapping/typeMap

#@include(baseData/SOAPModuleUtils)
#@include(baseData/SOAPType)
#@include(baseData/SOAPBasetype)
#@include(baseData/SOAPCompoundtype)
#@include(baseData/SOAPReference)
#@since 1.8.2
#@include(baseData/SOAPExternalReference)
#@end

= class SOAP::SOAPNil < XSD::XSDNil
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPRawString < XSD::XSDString
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPAnySimpleType < XSD::XSDAnySimpleType
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPString < XSD::XSDString
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPBoolean < XSD::XSDBoolean
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPDecimal < XSD::XSDDecimal
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPFloat < XSD::XSDFloat
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPDouble < XSD::XSDDouble
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPDuration < XSD::XSDDuration
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPDateTime < XSD::XSDDateTime
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPTime < XSD::XSDTime
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPDate < XSD::XSDDate
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPGYearMonth < XSD::XSDGYearMonth
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPGYear < XSD::XSDGYear
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPGMonthDay < XSD::XSDGMonthDay
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPGDay < XSD::XSDGDay
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPGMonth < XSD::XSDGMonth
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPHexBinary < XSD::XSDHexBinary
extend SOAPModuleUtils
include SOAPBasetype

#@include(baseData/SOAPBase64)

= class SOAP::SOAPAnyURI < XSD::XSDAnyURI
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPQName < XSD::XSDQName
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPInteger < XSD::XSDInteger
extend SOAPModuleUtils
include SOAPBasetype

#@since 1.8.2
= class SOAP::SOAPNonPositiveInteger < XSD::XSDPositiveInteger
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPNegativeInteger < XSD::XSDNegativeInteger
extend SOAPModuleUtils
include SOAPBasetype
#@end

= class SOAP::SOAPLong < XSD::XSDLong
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPInt < XSD::XSDInt
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPShort < XSD::XSDShort
extend SOAPModuleUtils
include SOAPBasetype

#@since 1.8.2
= class SOAP::SOAPByte < XSD::XSDByte
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPNonNegativeInteger < XSD::XSDNonNegativeInteger
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPUnsignedLong < XSD::XSDUnsignedLong
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPUnsignedInt < XSD::XSDUnsignedInt
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPUnsignedShort < XSD::XSDUnsignedShort
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPUnsignedByte < XSD::XSDUnsignedByte
extend SOAPModuleUtils
include SOAPBasetype

= class SOAP::SOAPPositiveInteger < XSD::XSDPositiveInteger
extend SOAPModuleUtils
include SOAPBasetype
#@end

#@include(baseData/SOAPStruct)
#@include(baseData/SOAPElement)
#@include(baseData/SOAPArray)

#@end
