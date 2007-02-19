#@since 1.8.2

#@#require rexml/validation/validation
#@#require rexml/parsers/baseparser

= class REXML::Validation::RelaxNG < Object
include REXML::Validation::Validator

== Class Methods

--- new(source)
#@todo

== Instance Methods

--- current
--- current=(value)
#@todo

--- count
--- count=(value)
#@todo

--- references
#@todo

--- receive(event)
#@todo

== Constants

--- INFINITY
#@todo

--- EMPTY
#@todo

--- TEXT
#@todo

= class REXML::Validation::State < Object

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- previous=(previous)
#@todo

--- next(event)
#@todo

--- to_s
#@todo

--- inspect
#@todo

--- expected
#@todo

--- <<(event)
#@todo

== Protected Instance Methods

--- expand_ref_in(arry, ind)
#@todo

--- add_event_to_arry(arry, evt)
#@todo

--- generate_event(event)
#@todo

= class REXML::Validation::Sequence < REXML::Validation::State

== Instance Methods

--- matches?(event)
#@todo

= class REXML::Validation::Optional < REXML::Validation::State

== Instance Methods

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

= class REXML::Validation::ZeroOrMore < REXML::Validation::Optional

== Instance Methods

--- next(event)
#@todo

--- expected
#@todo

= class REXML::Validation::OneOrMore < REXML::Validation::State

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

= class REXML::Validation::Choice < REXML::Validation::State

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- <<(event)
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

--- inspect
#@todo

== Protected Instance Methods

--- add_event_to_arry(arry, evt)
#@todo

= class REXML::Validation::Interleave < REXML::Validation::Choice

== Class methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- next_current(event)
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

--- inspect
#@todo

= class REXML::Validation::Ref < Object

== Class Methods

--- new(value)
#@todo

== Instance Methods

--- to_s
#@todo

--- inspect
#@todo

#@end
