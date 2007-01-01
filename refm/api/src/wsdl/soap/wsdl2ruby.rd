require logger
require xsd/qname
require wsdl/importer
require wsdl/soap/classDefCreator
require wsdl/soap/servantSkeltonCreator
require wsdl/soap/driverCreator
require wsdl/soap/clientSkeltonCreator
require wsdl/soap/standaloneServerStubCreator
require wsdl/soap/cgiStubCreator

= class WSDL::SOAP::WSDL2Ruby < Object

== Instance Methods

--- basedir
--- basedir=

--- location
--- location=

--- logger
--- logger=

--- opt

--- run

== Private Instance Methods

--- new

--- create_file

--- create_classdef

--- create_client_skelton(servicename)

--- create_servant_skelton(porttypename)

--- create_cgi_stub(servicename)

--- create_standalone_server_stub(servicename)

--- create_driver(porttypename)

--- write_file(filename)

--- check_file(filename)

--- shbang

--- create_name(name)

--- import(location)



