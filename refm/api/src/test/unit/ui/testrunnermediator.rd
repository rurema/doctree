= class Test::Unit::UI::TestRunnerMediator

Provides an interface to write any given UI against,
hopefully making it easy to write new UIs.

== Class Methods
--- initialize(suite)

Creates a new TestRunnerMediator initialized to run
the passed suite.

== Instance Methods

--- run_suite
Runs the suite the TestRunnerMediator was created
with.

== Private Instance Methods

--- create_result
A factory method to create the result the mediator
should run with. Can be overridden by subclasses if
one wants to use a different result.
