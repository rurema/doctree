= module REXML::StreamListener

== Instance Methods

--- tag_start(name, attrs)

--- tag_end(name)

--- text(text)

--- instruction(name, instruction)

--- comment(comment)

--- doctype(name, pub_sys, long_name, uri)

#@since 1.8.5
--- doctype_end
#@end

--- attlistdecl(element_name, attributes, raw_content)

--- elementdecl(content)

--- entitydecl(content)

--- notationdecl(content)

--- entity(content)

--- cdata(content)

--- xmldecl(version, encoding, standalone)
