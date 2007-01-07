#@since 1.8.1
require xsd/qname
require soap/baseData

= module SOAP::SOAPEnvelopeElement

= class SOAP::SOAPFault < SOAP::SOAPStruct
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(faultcode = nil, faultstring = nil, faultactor = nil, detail = nil)

== Instance Methods

--- faultcode
--- faultcode=(rhs)

--- faultstring
--- faultstring=(rhs)

--- faultactor
--- faultactor=(rhs)

--- detail
--- detail=(rhs)

--- encode(generator, ns, attrs = {})

= class SOAP::SOAPBody < SOAP::Struct
include SOAP::SOAPEnvelopeElement

== Class Methods

--- new(data = nil, is_fault = nil)

== Instance Methods

--- encode(generator, ns, attrs = {})

--- root_node

= class SOAP::SOAPHeaderItem < XSD::NSDBase
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(element, mustunderstand = true, encodingstype = nil)

== Instance Methods

#@since 1.8.2
--- element
--- element=(value)
#@end
#@if (version == "1.8.1")
--- content
--- content=(value)
#@end

--- mustunderstand
--- mustunderstand=(value)

--- encodingstyle
--- encodingstyle=(value)

--- encode(generator, ns, attrs = {})

#@since 1.8.2
= class SOAP::SOAPHeader < SOAP::SOAPStruct
#@end
#@if (version == "1.8.1")
= class SOAP::SOAPHeader < SOAP::SOAPArray
#@end
include SOAP::SOAPEnvelopeElement

== Class Methods

--- new

== Instance Methods

--- encode(generator, ns, attrs = {})

#@since 1.8.2
--- add(name, value)
#@end

--- length
#@since 1.8.2
--- size
#@end

= class SOAP::SOAPEnvelope < XSD::NSDBase
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(header = nil, body = nil)

== Instance Methods

--- header
--- header=(header)

--- body
--- body=(body)

#@since 1.8.2
--- external_content
#@end

--- encode(generator, ns, attrs = {})

#@since 1.8.2
--- to_ary
#@end

#@end
