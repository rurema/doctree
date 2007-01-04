#@#require rexml/encoding

= class REXML::SourceFactory < Object

== Class Methods

--- create_from(arg)

= class REXML::Source < Object
include REXML::Encoding

== Class Methods

--- new(arg)

== Instance Methods

--- buffer

--- line

--- encoding

--- encoding=(enc)

--- scan(pattern, cons = false)

--- read

#@since 1.8.1
--- consume(pattern)

--- match_to(char, pattern)

--- match_to_consume(char, pattern)
#@end

--- match(pattern, cons = false)

--- empty?

#@since 1.8.3
--- position
#@end

--- current_line

= class REXML::IOSource < REXML::Source

== Class Methods

--- new(arg, block_size = 500)

== Instance Methods

--- scan(pattern, cons = false)

--- read

#@since 1.8.1
--- consume(pattern)
#@end

--- match(pattern, cons = false)

--- empty?

#@since 1.8.3
--- position
#@end

--- current_line
