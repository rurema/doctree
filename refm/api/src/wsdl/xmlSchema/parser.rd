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
#@todo

== Instance Methods

--- ns
#@todo

--- name
#@todo

--- node
--- node=(node)
#@todo

= class WSDL::XMLSchema::Parser < WSDL::Info
include XSD

== Class Methods

--- new(opt = {})
#@todo


== Instance Methods

--- characters(text)
#@todo

--- charset
#@todo

--- end_element(name)
#@todo


--- parse(string_or_readable)
#@todo

--- start_element(name, attrs)
#@todo

