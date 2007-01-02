#@if (version <= "1.8.0")
#@#require rexml/SHIFT_JIS
#@end

#@since 1.8.1
= reopen REXML::Encoding

== Instance Methods

#@since 1.8.3
--- decode_sjis(content)

--- encode_sjis(str)
#@end

#@if (version <= "1.8.1")
--- from_shift_jis(content)

--- to_shift_jis(str)
#@end

== Constants

#@since 1.8.4
--- SJISTOU8

--- U8TOSJIS
#@end

= redefine REXML::Encoding

== Instance Methods

--- decode(content)

--- encode(str)
#@end
