#@#require rexml/encoding
#@#require rexml/source

= class REXML::XMLDecl < REXML::Child
include REXML::Encoding

== Class Methods

--- new(version = REXML::XMLDecl::DEFAULT_VERSION, encoding = nil, standalone = nil)
#@todo

#@since 1.8.1
--- default
#@todo
#@end

== Instance Methods

--- version
--- version=(value)
#@todo

--- standalone
--- standalone=(value)
--- stand_alone?
#@todo

#@since 1.8.1
--- writeencoding
#@todo
#@end

--- clone
#@todo

--- write(writer, indent = -1, transitive = false, ie_hack = false)
#@todo

--- ==(other)
#@todo

--- xmldecl(version, encoding, standalone)
#@todo

--- node_type
#@todo

#@since 1.8.1
--- old_enc=(enc)
#@todo

--- encoding=(enc)
#@todo

--- nowrite
#@todo

--- dowrite
#@todo
#@end

#@since 1.8.3
--- inspect
#@todo
#@end

== Constants

--- DEFAULT_VERSION
#@todo

--- DEFAULT_ENCODING
#@todo

--- DEFAULT_STANDALONE
#@todo

--- START
#@todo

--- STOP
#@todo
