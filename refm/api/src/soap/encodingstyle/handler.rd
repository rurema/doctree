require soap/soap
require soap/baseData
require soap/element

= class SOAP::EncodingStyle::Handler < Object

== Class Methods

--- new(charset)
#@todo

--- uri
#@todo

--- handler(uri)
#@todo

--- each {|value| ... }
#@todo

== Instance Methods

--- charset
#@todo

--- generate_explicit_type
--- generate_explicit_type=(value)
#@todo

--- decode_typemap=(definedtypes)
#@todo

--- encode_data(generator, ns, data, parent)
#@todo

--- encode_data_end(generator, ns, data, parent)
#@todo

--- encode_prologue
#@todo

--- encode_epilogue
#@todo

--- decode_tag(ns, name, attrs, parent)
#@todo

--- decode_tag_end(ns, name)
#@todo

--- decode_text(ns, text)
#@todo

--- decode_prologue
#@todo

--- decode_epilogue
#@todo

= class SOAP::EncodingStyle::Handler::EncodingStyleError < SOAP::Error

