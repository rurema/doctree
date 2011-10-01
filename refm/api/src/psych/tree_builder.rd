require psych/handler

= class Psych::TreeBuilder < Psych::Handler

This class works in conjunction with Psych::Parser to build an in-memory
parse tree that represents a YAML document.

Example:

  parser = Psych::Parser.new Psych::TreeBuilder.new
  parser.parse('--- foo')
  tree = parser.handler.root

See Psych::Handler for documentation on the event methods used in this
class.

== Class Methods

--- new -> Psych::TreeBuilder
#@todo

自身を初期化します。

== Instance Methods

--- root
#@todo

Returns the root node for the built tree

--- start_sequence(anchor, tag, implicit, style)
#@todo

--- end_sequence
#@todo

--- start_mapping(anchor, tag, implicit, style)
#@todo

--- end_mapping
#@todo

--- start_document(version, tag_directives, implicit)
#@todo

Handles start_document events with +version+, +tag_directives+,
and +implicit+ styling.

See Psych::Handler#start_document

--- end_document(implicit_end = !streaming?)
#@todo

Handles end_document events with +version+, +tag_directives+,
and +implicit+ styling.

See Psych::Handler#start_document

--- start_stream(encoding)
#@todo

--- end_stream
#@todo

--- scalar(value, anchor, tag, plain, quoted, style)
#@todo

--- alias(anchor)
#@todo
