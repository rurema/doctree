#@since 1.8.1
#@#require xsd/qname
require soap/baseData

= module SOAP::SOAPEnvelopeElement

= class SOAP::SOAPFault < SOAP::SOAPStruct
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(faultcode = nil, faultstring = nil, faultactor = nil, detail = nil)
#@todo

== Instance Methods

--- faultcode
--- faultcode=(rhs)
#@todo

--- faultstring
--- faultstring=(rhs)
#@todo

--- faultactor
--- faultactor=(rhs)
#@todo

--- detail
--- detail=(rhs)
#@todo

--- encode(generator, ns, attrs = {})
#@todo

= class SOAP::SOAPBody < SOAP::SOAPStruct
include SOAP::SOAPEnvelopeElement

== Class Methods

--- new(data = nil, is_fault = nil)
#@todo

== Instance Methods

--- encode(generator, ns, attrs = {})
#@todo

--- root_node
#@todo

= class SOAP::SOAPHeaderItem < XSD::NSDBase
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(element, mustunderstand = true, encodingstyle = nil)
#@todo

== Instance Methods

#@since 1.8.2
--- element
--- element=(value)
#@todo
#@end
#@if (version == "1.8.1")
--- content
--- content=(value)
#@todo
#@end

--- mustunderstand
--- mustunderstand=(value)
#@todo

--- encodingstyle
--- encodingstyle=(value)
#@todo

--- encode(generator, ns, attrs = {})
#@todo

#@since 1.8.2
= class SOAP::SOAPHeader < SOAP::SOAPStruct
#@end
#@if (version == "1.8.1")
= class SOAP::SOAPHeader < SOAP::SOAPArray
#@end
include SOAP::SOAPEnvelopeElement

== Class Methods

--- new
#@todo

== Instance Methods

--- encode(generator, ns, attrs = {})
#@todo

#@since 1.8.2
--- add(name, value)
#@todo
#@end

--- length
#@since 1.8.2
--- size
#@todo
#@end

= class SOAP::SOAPEnvelope < XSD::NSDBase
include SOAP::SOAPEnvelopeElement
include SOAP::SOAPCompoundtype

== Class Methods

--- new(header = nil, body = nil)
#@todo

== Instance Methods

--- header
--- header=(header)
#@todo

--- body
--- body=(body)
#@todo

#@since 1.8.2
--- external_content
#@todo
#@end

--- encode(generator, ns, attrs = {})
#@todo

#@since 1.8.2
--- to_ary
#@todo
#@end

#@end
