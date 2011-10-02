YAML event parser class.  This class parses a YAML document and calls
events on the handler that is passed to the constructor.  The events can
be used for things such as constructing a YAML AST or deserializing YAML
documents.  It can even be fed back to Psych::Emitter to emit the same
document that was parsed.

See Psych::Handler for documentation on the events that Psych::Parser emits.


Here is an example that prints out ever scalar found in a YAML document:

  # Handler for detecting scalar values
  class ScalarHandler < Psych::Handler
    def scalar value, anchor, tag, plain, quoted, style
      puts value
    end
  end

  parser = Psych::Parser.new(ScalarHandler.new)
  parser.parse(yaml_document)

Here is an example that feeds the parser back in to Psych::Emitter.  The
YAML document is read from STDIN and written back out to STDERR:

  parser = Psych::Parser.new(Psych::Emitter.new($stderr))
  parser.parse($stdin)

Psych uses Psych::Parser in combination with Psych::TreeBuilder to
construct an AST of the parsed YAML document.

= reopen Psych::Parser

== Class Methods

--- new(handler = Handler.new) -> Psych::Parser
#@todo

Creates a new Psych::Parser instance with +handler+.  YAML events will
be called on +handler+.  See Psych::Parser for more details.

== Instance Methods

--- handler
#@todo

The handler on which events will be called

--- handler=(val)
#@todo

The handler on which events will be called

= class Psych::Parser::Mark < Struct

== Instance Methods

--- index
#@todo

--- index=(val)
#@todo

--- line
#@todo

--- line=(val)
#@todo

--- column
#@todo

--- column=(val)
#@todo
