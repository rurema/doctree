require wsdl/info
require wsdl/soap/mappingRegistryCreator
require wsdl/soap/methodDefCreator
require wsdl/soap/classDefCreatorSupport
require xsd/codegen

= class WSDL::SOAP::DriverCreator < Object
include WSDL::SOAP::ClassDefCreatorSupport

== Class Methods

--- new(definitions)

== Instance Methods

--- definitions

--- dump(porttype = nil)

== Private Instance Methods

--- dump_porttype(name)

