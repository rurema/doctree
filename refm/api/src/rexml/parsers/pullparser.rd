require forwardable
#@#require rexml/parserexception
#@#require rexml/parsers/baseparser
#@#require rexml/xmltokens

= class REXML::Parsers::PullParser < Object
extend Forwardable
include REXML::XMLTokens

== Class Methods

--- new(stream)

== Instance Methods

#@since 1.8.3
--- has_next?

--- entity

--- empty?
#@end

#@since 1.8.5
--- source
#@end

#@since 1.8.2
--- add_listener(listener)
#@end

--- each {|event| ... }

--- peek(depth = 0)

--- pull

#@since 1.8.3
--- unshift
#@end

= class REXML::Parsers::PullEvent < Object

== Class Methods

--- new(arg)

== Instance Methods

--- [](start, endd = nil)

--- event_type

--- start_element?

--- end_element?

--- text?

--- instruction?

--- comment?

--- doctype?

--- attlistdecl?

--- elementdecl?

--- entitydecl?

--- notationdecl?

--- entity?

--- cdata?

--- xmldecl?

--- error?

--- inspect
