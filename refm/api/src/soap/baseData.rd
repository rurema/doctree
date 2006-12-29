#@since 1.8.1

#@include(SOAPModuleUtils)
#@include(SOAPType)
#@include(SOAPBasetype)
#@include(SOAPCompoundtype)
#@include(SOAPReference)
#@since 1.8.2
#@include(SOAPExternalReference)
#@end

= class SOAP::SOAPNil < XSD::XSDNil
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPRawString < XSD::XSDString
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPAnySimpleType < XSD::XSDAnySimpleType
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPString < XSD::XSDString
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPBoolean < XSD::XSDBoolean
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPDecimal < XSD::XSDDecimal
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPFloat < XSD::XSDFloat
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPDouble < XSD::XSDDouble
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPDuration < XSD::XSDDuration
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPDateTime < XSD::XSDDateTime
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPTime < XSD::XSDTime
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPDate < XSD::XSDDate
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPGYearMonth < XSD::XSDGYearMonth
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPGYear < XSD::XSDGYear
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPGMonthDay < XSD::XSDGMonthDay
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPGDay < XSD::XSDGDay
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPGMonth < XSD::XSDGMonth
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPHexBinary < XSD::XSDHexBinary
include SOAPBasetype
extend SOAPModuleUtils

#@include(SOAPBase64)

= class SOAP::SOAPAnyURI < XSD::XSDAnyURI
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPQName < XSD::XSDQName
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPInteger < XSD::XSDInteger
include SOAPBasetype
extend SOAPModuleUtils

#@since 1.8.2
= class SOAP::SOAPNonPositiveInteger < XSD::XSDPositiveInteger
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPNegativeInteger < XSD::XSDNegativeInteger
include SOAPBasetype
extend SOAPModuleUtils
#@end

= class SOAP::SOAPLong < XSD::XSDLong
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPInt < XSD::XSDInt
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPShort < XSD::XSDShort
include SOAPBasetype
extend SOAPModuleUtils

#@since 1.8.2
= class SOAP::SOAPByte < XSD::XSDByte
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPNonNegativeInteger < XSD::XSDNonNegativeInteger
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPUnsignedLong < XSD::XSDUnsignedLong
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPUnsignedInt < XSD::XSDUnsignedInt
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPUnsignedShort < XSD::XSDUnsignedShort
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPUnsignedByte < XSD::XSDUnsignedByte
include SOAPBasetype
extend SOAPModuleUtils

= class SOAP::SOAPPositiveInteger < XSD::XSDPositiveInteger
include SOAPBasetype
extend SOAPModuleUtils
#@end

#@include(SOAPStruct)
#@include(SOAPElement)
#@include(SOAPArray)



#@#include(mapping/typeMap.rd)

#@end
