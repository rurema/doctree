#@#require rexml/encoding
#@#require rexml/source

= class REXML::XMLDecl < REXML::Child
include REXML::Encoding

== Class Methods

--- new(version = REXML::XMLDecl::DEFAULT_VERSION, encoding = nil, standalone = nil)

#@since 1.8.1
--- default
#@end

== Instance Methods

--- version
--- version=(value)

--- standalone
--- standalone=(value)
--- stand_alone?

#@since 1.8.1
--- writeencoding
#@end

--- clone

--- write(writer, indent = -1, transitive = false, ie_hack = false)

--- ==(other)

--- xmldecl(version, encoding, standalone)

--- node_type

#@since 1.8.1
--- old_enc=(enc)

--- encoding=(enc)

--- nowrite

--- dowrite
#@end

#@since 1.8.3
--- inspect
#@end

== Constants

--- DEFAULT_VERSION

--- DEFAULT_ENCODING

--- DEFAULT_STANDALONE

--- START

--- STOP
