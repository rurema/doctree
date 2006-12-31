require xsd/qname
require xsd/ns
require xsd/charset
require xsd/datatypes
require xsd/xmlparser
require wsdl/xmlSchema/data


= class WSDL::XMLSchema::ParseError < WSDL::Error

= class WSDL::XMLSchema::FormatDecodeError < WSDL::XMLSchema::ParseError

= class WSDL::XMLSchema::UnknownElementError < WSDL::XMLSchema::FormatDecodeError

= class WSDL::XMLSchema::UnknownAttributeError < WSDL::XMLSchema::FormatDecodeError

= class WSDL::XMLSchema::UnexpectedElementError < WSDL::XMLSchema::FormatDecodeError

= class WSDL::XMLSchema::ElementConstraintError < WSDL::XMLSchema::FormatDecodeError

= class WSDL::XMLSchema::AttributeConstraintError < WSDL::XMLSchema::FormatDecodeError


= class WSDL::XMLSchema::ParseFrame < Object

== Class Methods

--- new(ns, name, node)

== Instance Methods

--- ns

--- name

--- node
--- node=(node)

= class WSDL::XMLSchema::Parser < WSDL::Info
include XSD

== Class Methods

--- new(opt = {})


== Instance Methods

--- characters(text)

--- charset

--- end_element(name)


--- parse(string_or_readable)

--- start_element(name, attrs)

