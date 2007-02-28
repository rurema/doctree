
= class Test::Unit::TestSuite < Object

A collection of tests which can be run.

Note: It is easy to confuse a TestSuite instance with something that has a static suite method; I know because I have trouble keeping them straight. Think of something that has a suite method as simply providing a way to get a meaningful TestSuite instance.


== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(name="Unnamed TestSuite")
#@todo

Creates a new TestSuite with the given name.

== Instance Methods

#@# bc-rdoc: detected missing name: <<
--- <<(test)
#@todo

Adds the test to the suite.

#@# bc-rdoc: detected missing name: ==
--- ==(other)
#@todo

It's handy to be able to compare TestSuite instances.

#@# bc-rdoc: detected missing name: delete
--- delete(test)
#@todo



#@# bc-rdoc: detected missing name: empty?
--- empty?
#@todo



#@# bc-rdoc: detected missing name: run
--- run(result, &progress_block) {|STARTED, name| ...}
#@todo

Runs the tests and/or suites contained in this TestSuite.

#@# bc-rdoc: detected missing name: size
--- size
#@todo

Retuns the rolled up number of tests in this suite; i.e. if the
suite contains other suites, it counts the tests within those
suites, not the suites themselves.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Overridden to return the name given the suite at creation.

