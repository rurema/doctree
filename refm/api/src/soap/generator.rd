#@since 1.8.1
#@#require xsd/ns
require soap/soap
require soap/baseData
require soap/encodingstyle/handler

= class SOAP::SOAPGenerator

== Class Methods

--- new(opt = {})
#@todo

--- assign_ns(attrs, ns, namespace, tag = nil)
#@todo

== Instance Methods

--- charset
--- charset=(value)
#@todo

--- default_encodingstyle
--- default_encodingstyle=(value)
#@todo

--- generate_explicit_type
--- generate_explicit_type=(value)
#@todo

#@since 1.8.3
--- use_numeric_character_reference
--- use_numeric_character_reference=(value)
#@todo
#@end

--- generate(obj, io = nil)
#@todo

--- encode_data(ns, obj, parent)
#@todo

--- add_reftarget(name, node)
#@todo

#@since 1.8.3
--- encode_child(ns, child, parent)
#@todo
#@end

--- encode_element(ns, obj, parent)
#@todo

#@since 1.8.3
--- encode_name(ns, data, attrs)
#@todo

--- encode_name_end(ns, data)
#@todo
#@end

--- encode_tag(elename, attrs = nil)
#@todo

--- encode_tag_end(elename, cr = nil)
#@todo

--- encode_rawstring(str)
#@todo

--- encode_string(str)
#@todo

#@since 1.8.3
--- element_local?(element)
#@todo

--- element_qualified?(element)
#@todo
#@end

== Constants

--- EncodeMap
#@todo

--- EncodeCharRegexp
#@todo

= class SOAP::SOAPGenerator::FormatEncodeError < SOAP::Error

#@end
