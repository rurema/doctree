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

--- element
--- element=(value)
#@todo
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

= class SOAP::SOAPHeader < SOAP::SOAPStruct
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

--- add(name, value)
#@todo

--- length
--- size
#@todo

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

--- external_content
#@todo

--- encode(generator, ns, attrs = {})
#@todo

--- to_ary
#@todo

