#@since 1.8.1
require soap/soap
require soap/baseData
require soap/element

= class SOAP::EncodingStyle::Handler < Object

== Class Methods

--- new(charset)

--- uri

--- handler(uri)

--- each {|value| ... }

== Instance Methods

--- charset

--- generate_explicit_type
--- generate_explicit_type=(value)

--- decode_typemap=(definedtypes)

--- encode_data(generator, ns, data, parent)

--- encode_data_end(generator, ns, data, parent)

--- encode_prologue

--- encode_epilogue

--- decode_tag(ns, name, attrs, parent)

--- decode_tag_end(ns, name)

--- decode_text(ns, text)

--- decode_prologue

--- decode_epilogue

= class SOAP::EncodingStyle::Handler::EncodingStyleError < SOAP::Error

#@end
