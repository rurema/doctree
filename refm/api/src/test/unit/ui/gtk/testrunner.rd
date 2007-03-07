require test/unit/ui/testrunnerutilities
require test/unit/ui/testrunnermediator

= class Test::Unit::UI::GTK::TestRunner < Object
extend Test::Unit::UI::TestRunnerUtilities

Runs a Test::Unit::TestSuite in a Gtk UI. 
Obviously, this one requires you to have Gtk (www.gtk.org/) and 
the Ruby Gtk extension (ruby-gnome.sourceforge.net/) installed.

== Class Methods
--- new(suite, output_level = NORMAL)   
#@todo

== Instance Methods
--- start()   
#@todo
