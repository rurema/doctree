

= class Gem::Package::TarInput
include Gem::Package::FSyncDir
include Enumerable

== Singleton Methods

--- open(io, security_policy = nil){|is| ... }
#@todo

@param io

@param security_policy

== Private Singleton Methods

--- new(io, security_policy = nil)

このクラスを初期化します。

@param io

@param security_policy


== Public Instance Methods

--- close
#@todo

--- each{ ... }
#@todo

--- extract_entry(destdir, entry, expected_md5sum = nil)
#@todo

--- load_gemspec(io) -> Gem::Specification
#@todo

--- metadata -> Gem::Specification
#@todo

--- zipped_stream(entry)
#@todo

