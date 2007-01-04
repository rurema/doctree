#@since 1.8.2

#@#require rexml/validation/validation
#@#require rexml/parsers/baseparser

= class REXML::Validation::RelaxNG < Object
include REXML::Validation::Validator

== Class Methods

--- new(source)

== Instance Methods

--- current
--- current=(value)

--- count
--- count=(value)

--- references

--- receive(event)

== Constants

--- INFINITY

--- EMPTY

--- TEXT

= class REXML::Validation::State < Object

== Class Methods

--- new(context)

== Instance Methods

--- reset

--- previous=(previous)

--- next(event)

--- to_s

--- inspect

--- expected

--- <<(event)

== Protected Instance Methods

--- expand_ref_in(arry, ind)

--- add_event_to_arry(arry, evt)

--- generate_event(event)

= class REXML::Validation::Sequence < REXML::Validation::State

== Instance Methods

--- matches?(event)

= class REXML::Validation::Optional < REXML::Validation::State

== Instance Methods

--- next(event)

--- matches?(event)

--- expected

= class REXML::Validation::ZeroOrMore < REXML::Validation::Optional

== Instance Methods

--- next(event)

--- expected

= class REXML::Validation::OneOrMore < REXML::Validation::State

== Class Methods

--- new(context)

== Instance Methods

--- reset

--- next(event)

--- matches?(event)

--- expected

= class REXML::Validation::Choice < REXML::Validation::State

== Class Methods

--- new(context)

== Instance Methods

--- reset

--- <<(event)

--- next(event)

--- matches?(event)

--- expected

--- inspect

== Protected Instance Methods

--- add_event_to_arry(arry, evt)

= class REXML::Validation::Interleave < REXML::Validation::Choice

== Class methods

--- new(context)

== Instance Methods

--- reset

--- next_current(event)

--- next(event)

--- matches?(event)

--- expected

--- inspect

= class REXML::Validation::Ref < Object

== Class Methods

--- new(value)

== Instance Methods

--- to_s

--- inspect

#@end
