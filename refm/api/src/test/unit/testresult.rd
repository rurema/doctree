
= class Test::Unit::TestResult < Object
include Test::Unit::Util::Observable

Collects [[c:Test::Unit::Failure]] and [[c:Test::Unit::Error]] so that they can be displayed to the user. To this end, observers can be added to it, allowing the dynamic updating of, say, a UI.

== Class Methods
#@# bc-rdoc: detected missing name: new
--- new
#@todo

Constructs a new, empty TestResult.

== Instance Methods
#@# bc-rdoc: detected missing name: add_assertion
--- add_assertion
#@todo

Records an individual assertion.

#@# bc-rdoc: detected missing name: add_error
--- add_error(error)
#@todo

Records a Test::Unit::Error.

#@# bc-rdoc: detected missing name: add_failure
--- add_failure(failure)
#@todo

Records a Test::Unit::Failure.

#@# bc-rdoc: detected missing name: add_run
--- add_run
#@todo

Records a test run.

#@# bc-rdoc: detected missing name: error_count
--- error_count
#@todo

Returns the number of errors this TestResult has recorded.
#@# bc-rdoc: detected missing name: failure_count
--- failure_count
#@todo

Returns the number of failures this TestResult has recorded.

#@# bc-rdoc: detected missing name: passed?
--- passed?
#@todo

Returns whether or not this TestResult represents successful
completion.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Returns a string contain the recorded runs, assertions, failures
and errors in this TestResult.
