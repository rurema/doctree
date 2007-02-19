#@#require rexml/encoding

= class REXML::SourceFactory < Object

== Class Methods

--- create_from(arg)
#@todo

= class REXML::Source < Object
include REXML::Encoding

== Class Methods

--- new(arg)
#@todo

== Instance Methods

--- buffer
#@todo

--- line
#@todo

--- encoding
#@todo

--- encoding=(enc)
#@todo

--- scan(pattern, cons = false)
#@todo

--- read
#@todo

#@since 1.8.1
--- consume(pattern)
#@todo

--- match_to(char, pattern)
#@todo

--- match_to_consume(char, pattern)
#@todo
#@end

--- match(pattern, cons = false)
#@todo

--- empty?
#@todo

#@since 1.8.3
--- position
#@todo
#@end

--- current_line
#@todo

= class REXML::IOSource < REXML::Source

== Class Methods

--- new(arg, block_size = 500)
#@todo

== Instance Methods

--- scan(pattern, cons = false)
#@todo

--- read
#@todo

#@since 1.8.1
--- consume(pattern)
#@todo
#@end

--- match(pattern, cons = false)
#@todo

--- empty?
#@todo

#@since 1.8.3
--- position
#@todo
#@end

--- current_line
#@todo
