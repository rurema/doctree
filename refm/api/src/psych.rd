require psych/nodes
require psych/streaming
require psych/visitors
require psych/handler
require psych/tree_builder
require psych/parser
require psych/omap
require psych/set
require psych/coder
require psych/core_ext
require psych/deprecated
require psych/json
#@# 以下は autoload である事に注意。
require psych/stream

[[lib:yaml]] のバックエンドライブラリです。libyaml ベースで作成されてお
り、YAML バージョン 1.1 を扱う事ができます。

#@# 上記、libyaml が更新される事があれば、記述の変更をお願いします。

=== Overview

Psych is a YAML parser and emitter.  Psych leverages
libyaml[http://libyaml.org] for it's YAML parsing and emitting capabilities.
In addition to wrapping libyaml, Psych also knows how to serialize and
de-serialize most Ruby objects to and from the YAML format.

=== I NEED TO PARSE OR EMIT YAML RIGHT NOW!

  # Parse some YAML
  Psych.load("--- foo") # => "foo"

  # Emit some YAML
  Psych.dump("foo")     # => "--- foo\n...\n"
  { :a => 'b'}.to_yaml  # => "---\n:a: b\n"

Got more time on your hands?  Keep on reading!

==== YAML Parsing

Psych provides a range of interfaces for parsing a YAML document ranging from
low level to high level, depending on your parsing needs.  At the lowest
level, is an event based parser.  Mid level is access to the raw YAML AST,
and at the highest level is the ability to unmarshal YAML to ruby objects.

===== Low level parsing

The lowest level parser should be used when the YAML input is already known,
and the developer does not want to pay the price of building an AST or
automatic detection and conversion to ruby objects.  See Psych::Parser for
more information on using the event based parser.

===== Mid level parsing

Psych provides access to an AST produced from parsing a YAML document.  This
tree is built using the Psych::Parser and Psych::TreeBuilder.  The AST can
be examined and manipulated freely.  Please see Psych::parse_stream,
Psych::Nodes, and Psych::Nodes::Node for more information on dealing with
YAML syntax trees.

===== High level parsing

The high level YAML parser provided by Psych simply takes YAML as input and
returns a Ruby data structure.  For information on using the high level parser
see Psych.load

==== YAML Emitting

Psych provides a range of interfaces ranging from low to high level for
producing YAML documents.  Very similar to the YAML parsing interfaces, Psych
provides at the lowest level, an event based system, mid-level is building
a YAML AST, and the highest level is converting a Ruby object straight to
a YAML document.

===== Low level emitting

The lowest level emitter is an event based system.  Events are sent to a
Psych::Emitter object.  That object knows how to convert the events to a YAML
document.  This interface should be used when document format is known in
advance or speed is a concern.  See Psych::Emitter for more information.

===== Mid level emitting

At the mid level is building an AST.  This AST is exactly the same as the AST
used when parsing a YAML document.  Users can build an AST by hand and the
AST knows how to emit itself as a YAML document.  See Psych::Nodes,
Psych::Nodes::Node, and Psych::TreeBuilder for more information on building
a YAML AST.

===== High level emitting

The high level emitter has the easiest interface.  Psych simply takes a Ruby
data structure and converts it to a YAML document.  See Psych.dump for more
information on dumping a Ruby data structure.

= module Psych

[[lib:yaml]] のバックエンドのためのモジュールです。

== Constants

--- VERSION -> String
#@todo

The version is Psych you're using

--- LIBYAML_VERSION -> String
#@todo

The version of libyaml Psych is using

== Class Methods

--- load(yaml) -> object
#@todo

Load +yaml+ in to a Ruby data structure.  If multiple documents are
provided, the object contained in the first document will be returned.

Example:

  Psych.load("--- a")           # => 'a'
  Psych.load("---\n - a\n - b") # => ['a', 'b']

--- parse(yaml) -> object
#@todo

Parse a YAML string in +yaml+.  Returns the first object of a YAML AST.

Example:

  Psych.parse("---\n - a\n - b") # => #<Psych::Nodes::Sequence:0x00>

@see Psych::Nodes for more information about YAML AST.

--- parse_file(filename) -> object
#@todo

Parse a file at +filename+. Returns the YAML AST.

--- parser -> Psych::Parser
#@todo

Returns a default parser

--- parse_stream(yaml)
#@todo

Parse a YAML string in +yaml+.  Returns the full AST for the YAML document.
This method can handle multiple YAML documents contained in +yaml+.

Example:

  Psych.parse_stream("---\n - a\n - b") # => #<Psych::Nodes::Stream:0x00>

See Psych::Nodes for more information about YAML AST.

--- dump(o, io = nil, options = {})
#@todo

Dump Ruby object +o+ to a YAML string.  Optional +options+ may be passed in
to control the output format.  If an IO object is passed in, the YAML will
be dumped to that IO object.

Example:

  # Dump an array, get back a YAML string
  Psych.dump(['a', 'b'])  # => "---\n- a\n- b\n"

  # Dump an array to an IO object
  Psych.dump(['a', 'b'], StringIO.new)  # => #<StringIO:0x000001009d0890>

  # Dump an array with indentation set
  Psych.dump(['a', ['b']], :indentation => 3) # => "---\n- a\n-  - b\n"

  # Dump an array to an IO with indentation set
  Psych.dump(['a', ['b']], StringIO.new, :indentation => 3)

--- dump_stream(*objects)
#@todo

Dump a list of objects as separate documents to a document stream.

Example:

  Psych.dump_stream("foo\n  ", {}) # => "--- ! \"foo\\n  \"\n--- {}\n"

--- to_json(o) -> String
#@todo

Dump Ruby object +o+ to a JSON string.

--- load_stream(yaml)
#@todo

Load multiple documents given in +yaml+.  Returns the parsed documents
as a list.  For example:

  Psych.load_stream("--- foo\n...\n--- bar\n...") # => ['foo', 'bar']

--- load_file(filename)
#@todo

Load the document contained in +filename+.  Returns the yaml contained in
+filename+ as a ruby object

#@# 以下のメソッドについては、stopdoc が指定されているため、省略。
#@# --- add_domain_type(domain, type_tag, &block)
#@# --- add_builtin_type(type_tag, &block)
#@# --- remove_type(type_tag)
#@# --- add_tag(tag, klass)
#@# --- load_tags
#@# --- load_tags=(val)
#@# --- dump_tags
#@# --- dump_tags=(val)
#@# --- domain_types
#@# --- domain_types=(val)

= class Psych::Exception < RuntimeError
