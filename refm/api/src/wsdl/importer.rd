require wsdl/xmlSchema/importer
require wsdl/parser

= class WSDL::Importer < WSDL::XMLSchema::Importer

== Class Methods

--- import(location, originalroot = nil)

== Instance Methods

#@if(version <= "1.8.2")
--- import(location, originalroot = nil)

#@end

== Private Instance Methods

--- parse(content, location, originalroot)
