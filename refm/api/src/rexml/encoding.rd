= module REXML::Encoding

== Class Methods

#@since 1.8.3
--- register(enc) {|obj| ... }

--- apply(obj, enc)

--- encoding_method(enc)
#@end

#@if (version <= "1.8.0")
--- claim(encoding_str, match = nil)
#@end

== Instance Methods

--- encoding

--- encoding=(euc)

--- check_encoding(str)

#@if (version <= "1.8.0")
--- from_utf_8(content)

--- to_utf_8(str)
#@end

== Constants

--- UTF_8

--- UTF_16

--- UNILE

#@if (version <= "1.8.0")
--- ENCODING_CLAIM

--- EUC_JP

--- ISO_8859_1

--- UNILE

--- US_ASCII
#@end

#@if (version <= "1.8.0")
= module REXML::Encodingses
#@end
