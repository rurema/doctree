#@if (version <= "1.8.0")
#@#require rexml/SHIFT_JIS
#@end

#@since 1.8.1
= reopen REXML::Encoding

== Instance Methods

#@since 1.8.3
--- decode_sjis(content)
#@todo

--- encode_sjis(str)
#@todo
#@end

#@if (version <= "1.8.1")
--- from_shift_jis(content)
#@todo

--- to_shift_jis(str)
#@todo
#@end

== Constants

#@since 1.8.4
--- SJISTOU8
#@todo

--- U8TOSJIS
#@todo
#@end

= redefine REXML::Encoding

== Instance Methods

--- decode(content)
#@todo

--- encode(str)
#@todo
#@end
