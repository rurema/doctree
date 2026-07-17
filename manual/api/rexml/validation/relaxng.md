# class REXML::Validation::RelaxNG < Object
include REXML::Validation::Validator

RelaxNGに基づくXMLバリデータ。

```ruby
require 'rexml/document'
require 'rexml/validation/relaxng'

relaxng_schema = <<RELAXNG
<?xml version="1.0" encoding="UTF-8"?>
<element name="addressBook" xmlns="http://relaxng.org/ns/structure/1.0">
  <zeroOrMore>
    <element name="card">
      <element name="name">
        <text/>
      </element>
      <element name="email">
        <text/>
      </element>
      <optional>
        <element name="note">
          <text/>
        </element>
      </optional>
    </element>
  </zeroOrMore>
</element>
RELAXNG

xml = <<XML
<addressBook>
  <card>
    <name>John Smith</name>
    <email>js@example.com</email>
  </card>
  <card>
    <name>Fred Bloggs</name>
    <email>fb@example.net</email>
  </card>
</addressBook>
XML

validator = REXML::Validation::RelaxNG.new(relaxng_schema)
parser = REXML::Parsers::TreeParser.new(xml)
parser.add_listener(validator)
parser.parse
#@since 3.4
# ~> /path/to/gems/rexml-3.4.4/lib/rexml/validation/validation.rb:21:in 'REXML::Validation::Validator#validate': Validation error.  Expected: :end_element(  ) or :start_element( card ) from < Z.2 #:start_element( card ), :start_element( name ), :text(  ), :end_element(  ), :start_element( email ), :text(  ), :end_element(  ), < O.3 #:start_element( note ), :text(  ), :end_element(  ) >, :end_element(  ) >  but got :text(  (REXML::Validation::ValidationException)
#@else
# ~> /path/to/gems/rexml-3.3.9/lib/rexml/validation/validation.rb:21:in `validate': Validation error.  Expected: :end_element(  ) or :start_element( card ) from < Z.2 #:start_element( card ), :start_element( name ), :text(  ), :end_element(  ), :start_element( email ), :text(  ), :end_element(  ), < O.3 #:start_element( note ), :text(  ), :end_element(  ) >, :end_element(  ) >  but got :text(  (REXML::Validation::ValidationException)
#@end
# ~>    )
#@since 3.4
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/validation/relaxng.rb:123:in 'REXML::Validation::RelaxNG#receive'
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/parsers/baseparser.rb:251:in 'block (2 levels) in REXML::Parsers::BaseParser#pull'
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/parsers/baseparser.rb:250:in 'Array#each'
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/parsers/baseparser.rb:250:in 'block in REXML::Parsers::BaseParser#pull'
# ~> 	from <internal:kernel>:91:in 'Kernel#tap'
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/parsers/baseparser.rb:249:in 'REXML::Parsers::BaseParser#pull'
# ~> 	from /path/to/gems/rexml-3.4.4/lib/rexml/parsers/treeparser.rb:21:in 'REXML::Parsers::TreeParser#parse'
# ~> 	from -:41:in '<main>'
#@else
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/validation/relaxng.rb:123:in `receive'
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/parsers/baseparser.rb:245:in `block (2 levels) in pull'
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/parsers/baseparser.rb:244:in `each'
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/parsers/baseparser.rb:244:in `block in pull'
# ~> 	from <internal:kernel>:90:in `tap'
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/parsers/baseparser.rb:243:in `pull'
# ~> 	from /path/to/gems/rexml-3.3.9/lib/rexml/parsers/treeparser.rb:21:in `parse'
# ~> 	from -:41:in `<main>'
#@end
```

## Class Methods

### def new(source)
#@todo

## Instance Methods

### def current
### def current=(value)
#@todo

### def count
### def count=(value)
#@todo

### def references
#@todo

### def receive(event)
#@todo

## Constants

### const INFINITY
#@todo

### const EMPTY
#@todo

### const TEXT
#@todo

# class REXML::Validation::State < Object

## Class Methods

### def new(context)
#@todo

## Instance Methods

### def reset
#@todo

### def previous=(previous)
#@todo

### def next(event)
#@todo

### def to_s
#@todo

### def inspect
#@todo

### def expected
#@todo

### def <<(event)
#@todo

## Protected Instance Methods

### def expand_ref_in(arry, ind)
#@todo

### def add_event_to_arry(arry, evt)
#@todo

### def generate_event(event)
#@todo

# class REXML::Validation::Sequence < REXML::Validation::State

## Instance Methods

### def matches?(event)
#@todo

# class REXML::Validation::Optional < REXML::Validation::State

## Instance Methods

### def next(event)
#@todo

### def matches?(event)
#@todo

### def expected
#@todo

# class REXML::Validation::ZeroOrMore < REXML::Validation::Optional

## Instance Methods

### def next(event)
#@todo

### def expected
#@todo

# class REXML::Validation::OneOrMore < REXML::Validation::State

## Class Methods

### def new(context)
#@todo

## Instance Methods

### def reset
#@todo

### def next(event)
#@todo

### def matches?(event)
#@todo

### def expected
#@todo

# class REXML::Validation::Choice < REXML::Validation::State

## Class Methods

### def new(context)
#@todo

## Instance Methods

### def reset
#@todo

### def <<(event)
#@todo

### def next(event)
#@todo

### def matches?(event)
#@todo

### def expected
#@todo

### def inspect
#@todo

## Protected Instance Methods

### def add_event_to_arry(arry, evt)
#@todo

# class REXML::Validation::Interleave < REXML::Validation::Choice

## Class methods

### def new(context)
#@todo

## Instance Methods

### def reset
#@todo

### def next_current(event)
#@todo

### def next(event)
#@todo

### def matches?(event)
#@todo

### def expected
#@todo

### def inspect
#@todo

# class REXML::Validation::Ref < Object

## Class Methods

### def new(value)
#@todo

## Instance Methods

### def to_s
#@todo

### def inspect
#@todo
