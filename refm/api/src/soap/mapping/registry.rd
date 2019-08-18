require soap/baseData
require soap/mapping/mapping
require soap/mapping/typeMap
require soap/mapping/factory
require soap/mapping/rubytypeFactory

= module SOAP::Marshallable

= module SOAP::Mapping::MappedException

= reopen SOAP::Mapping

== Constants

--- RubyTypeName
#@todo

--- RubyExtendName
#@todo

--- RubyIVarName
#@todo

#@include(registry/Mapping__SOAPException)
#@include(registry/Mapping__Object)

= class SOAP::Mapping::MappingError < SOAP::Error

#@include(registry/Mapping__Registry)
#@include(registry/Mapping__Registry__Map)

= reopen SOAP::Mapping

== Constants

--- DefaultRegistry
#@todo

--- RubyOriginalRegistry
#@todo

