require forwardable
#@#require rexml/parserexception
#@#require rexml/parsers/baseparser
#@#require rexml/xmltokens

= class REXML::Parsers::PullParser < Object
extend Forwardable
include REXML::XMLTokens

== Class Methods

--- new(stream)
#@todo

== Instance Methods

#@since 1.8.3
--- has_next?
#@todo

--- entity
#@todo

--- empty?
#@todo
#@end

#@since 1.8.5
--- source
#@todo
#@end

#@since 1.8.2
--- add_listener(listener)
#@todo
#@end

--- each {|event| ... }
#@todo

--- peek(depth = 0)
#@todo

--- pull
#@todo

#@since 1.8.3
--- unshift
#@todo
#@end

= class REXML::Parsers::PullEvent < Object

== Class Methods

--- new(arg)
#@todo

== Instance Methods

--- [](start, endd = nil)
#@todo

--- event_type
#@todo

--- start_element?
#@todo

--- end_element?
#@todo

--- text?
#@todo

--- instruction?
#@todo

--- comment?
#@todo

--- doctype?
#@todo

--- attlistdecl?
#@todo

--- elementdecl?
#@todo

--- entitydecl?
#@todo

--- notationdecl?
#@todo

--- entity?
#@todo

--- cdata?
#@todo

--- xmldecl?
#@todo

--- error?
#@todo

--- inspect
#@todo
