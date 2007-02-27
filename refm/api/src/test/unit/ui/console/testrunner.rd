require test/unit/ui/testrunnerutilities
= module Test::Unit::UI::Console
= class Test::Unit::UI::Console::TestRunner < Object
extend Test::Unit::UI::TestRunnerUtilities

Runs a Test::Unit::TestSuite on the console.

== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(suite, output_level=NORMAL, io=STDOUT)
#@todo

Creates a new TestRunner for running the passed suite. If quiet_mode
is true, the output while running is limited to progress dots,
errors and failures, and the final result. io specifies where
runner output should go to; defaults to STDOUT.

== Instance Methods
#@# bc-rdoc: detected missing name: start
--- start
#@todo

Begins the test run.
