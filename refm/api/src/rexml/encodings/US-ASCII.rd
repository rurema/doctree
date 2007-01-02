= reopen REXML::Encoding

== Instance Methods

#@since 1.8.3
--- encode_ascii(content)

--- decode_ascii(str)
#@end

#@if (version <= "1.8.0")
--- to_us_ascii(content)

--- from_us_ascii(str)
#@end

= redefine REXML::Encoding

== Instance Methods

#@since 1.8.1
--- decode(str)

--- encode(content)
#@end
