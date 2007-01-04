#@#require rexml/parsers/baseparaser
#@#require rexml/parseexception
#@#require rexml/namespace
#@#require rexml/text

= class REXML::Parsers::SAX2Parser < Object

== Class Methods

--- new(source)

== Instance Methods

#@since 1.8.2
--- add_listener(listener)
#@end

--- listen(sym, ary) { ... }
--- listen(sym) { ... }
--- listen(ary, listener)
--- listen(ary) { ... }
--- listen(listener)

--- deafen(listener)
--- deafen { ... }

--- parse

#@since 1.8.6
--- source
#@end
