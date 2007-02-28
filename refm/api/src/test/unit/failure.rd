
= class Test::Unit::Failure < Object
Encapsulates a test failure. Created by [[c:Test::Unit::TestCase]] when an assertion fails.

== Class Methods
--- new(test_name, location, message)
#@todo

Creates a new Failure with the given location and message.

== Instance Methods
#@# bc-rdoc: detected missing name: long_display
--- long_display
#@todo

Returns a verbose version of the error description.

#@# bc-rdoc: detected missing name: short_display
--- short_display
#@todo

Returns a brief version of the error description.

#@# bc-rdoc: detected missing name: single_character_display
--- single_character_display
#@todo

Returns a single character representation of a failure.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Overridden to return long_display.
