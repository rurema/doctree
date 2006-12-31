#@since 1.8.3
require soap/httpconfigloader
require wsdl/xmlSchema/parser

= class WSDL::XMLSchema::Importer < Object

== Class Methods

--- new

--- import(location, originalroot = nil)

== Instance Methods

--- import(location, originalroot = nil)


== Private Instance Methods

--- parse(content, location, originalroot)

--- fetch(location)

--- web_client


#@end
