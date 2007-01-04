#@#require rexml/validation/validationexception

= module REXML::Validation::Validator

== Instance Methods

--- reset

--- dump

--- validate(event)

== Constants

--- NILEVENT

= class REXML::Validation::Event < Object

== Class Methods

--- new(event_type, event_arg = nil)


== Instance Methods

--- event_type

--- event_arg
--- event_arg=(value)

--- done?

--- single?

--- matches?(event)

--- ==(other)

--- to_s

--- inspect
