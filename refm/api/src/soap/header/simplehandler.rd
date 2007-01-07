#@since 1.8.2
require soap/header/handler
require soap/baseData

= class SOAP::Header::SimpleHandler < SOAP::Header::Handler

== Class Methods

--- new(elename)

== Instance Methods

--- on_simple_outbound

--- on_simple_inbound(header, mustunderstand)

--- on_outbound

--- on_inbound(header, mustunderstand)

#@end
