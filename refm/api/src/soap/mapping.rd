#@since 1.8.1

#@# soap/mapping/factory.rb
#@include(Mapping__Factory)
#@include(Mapping__StringFactory_)
#@include(Mapping__BasetypeFactory_)
#@include(Mapping__DateTimeFactory_)
#@include(Mapping__Base64Factory_)
#@since 1.8.2
#@include(Mapping__URIFactory_)
#@end
#@include(Mapping__ArrayFactory_)
#@include(Mapping__TypedArrayFactory_)
#@include(Mapping__TypedStructFactory_)
#@include(Mapping__HashFactory_)

= reopen SOAP::Mapping

== Constants

--- MapQName

#@# soap/mapping/mapping.rb
#@include(Mapping__)
#@include(Mapping__TraverseSupport)

#@# soap/mapping/registry.rb
= module SOAP::Marshallable

= module SOAP::Mapping::MappedException

= reopen SOAP::Mapping

== Constants

--- RubyTypeName

--- RubyExtendName

--- RubyIVarName

#@#@include(Mapping__SOAPException)
#@#@include(Mapping__Object)

= class SOAP::Mapping::MappingError < SOAP::Error

#@include(Mapping__Registry)
#@include(Mapping__Registry__Map)

= reopen SOAP::Mapping

== Constants

--- DefaultRegistry

--- RubyOriginalRegistry

#@# soap/mapping/rubytypeFactory.rb
#@include(Mapping__RubytypeFactory)

#@# soap/mapping/typeMap.rb
#@include(mapping/typeMap.rd)

#@end
