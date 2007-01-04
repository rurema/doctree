= class REXML::Parsers::BaseParser < Object

== Class Methods

--- new(source)

== Instance Methods

#@since 1.8.2
--- add_listener(listener)

--- source
#@end

--- stream=(source)

#@since 1.8.5
--- position
#@end

--- empty?

--- has_next?

--- unshift(token)

--- peek(depth = 0)

--- pull

--- entity(reference, entities)

--- normalize(input, entities = nil, entity_filter = nil)

--- unnormalize(string, entities = nil, filter = nil)

== Constants

--- NCNAME_STR

--- NAME_STR

--- NAMECHAR

--- NAME

--- NMTOKEN

--- NMTOKENS

--- REFERENCE

--- REFERENCE_RE

--- DOCTYPE_START

--- DOCTYPE_PATTERN

--- ATTRIBUTE_PATTERN

--- COMMENT_START

--- COMMENT_PATTERN

--- CDATA_START

--- CDATA_END

--- CDATA_PATTERN

--- XMLDECL_START

--- XMLDECL_PATTERN

--- INSTRUCTION_START

--- INSTRUCTION_PATTERN

--- TAG_MATCH

--- CLOSE_MATCH

--- VERSION

--- ENCODING

--- STANDALONE

--- ENTITY_START

--- IDENTITY

--- ELEMENTDECL_START

--- ELEMENTDECL_PATTERN

#@since 1.8.1
--- SYSTEMENTITY
#@end

--- ENUMERATION

--- NOTATIONTYPE

--- ENUMERATEDTYPE

--- ATTTYPE

--- ATTVALUE

--- DEFAULTDECL

--- ATTDEF

--- ATTDEF_RE

--- ATTLISTDECL_START

--- ATTLISTDECL_PATTERN

--- NOTATIONDECL_START

--- PUBLIC

--- SYSTEM

--- TEXT_PATTERN

--- PUBIDCHAR

--- SYSTEMLITERAL

--- PUBIDLITERAL

--- EXTERNALID

--- NDATADECL

--- PEREFERENCE

--- ENTITYVALUE

--- PEDEF

--- ENTITYDEF

--- PEDECL

--- GEDECL

--- ENTITYDECL

--- EREFERENCE

--- DEFAULT_ENTITIES

#@since 1.8.6
--- MISSING_ATTRIBUTE_QUOTES
#@end
