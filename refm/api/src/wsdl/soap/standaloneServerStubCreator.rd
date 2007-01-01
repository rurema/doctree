require wsdl/info
require wsdl/soap/mappingRegistryCreator
require wsdl/soap/methodDefCreator
require wsdl/soap/classDefCreatorSupport

= class WSDL::SOAP::StandaloneServerStubCreator < Object
include WSDL::SOAP::ClassDefCreatorSupport

== Class Methods

--- new(definitions)


== Instance Methods

--- definitions

--- dump(service_name)


== Private Instance Methods

--- dump_porttype(name)

