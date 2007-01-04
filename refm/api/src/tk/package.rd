require tk

= class TkPackage

extend TkCore
include TkCore

== Instance Methods

--- add_path(path)

--- forget(package)

--- if_needed(pkg, ver, *arg) { .... }

--- names

--- provide(package, version=nil)

--- present(package, version=None)

--- present_exact(package, version)

--- require(package, version=None)

--- require_exact(package, version)

--- unknown_proc(*arg} { .... }

--- versions(package)

--- vcompare(version1, version2)

--- vsatisfies(version1, version2)

== Constants

--- TkCommandNames

