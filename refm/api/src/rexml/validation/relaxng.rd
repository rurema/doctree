#@since 1.8.2

#@#require rexml/validation/validation
#@#require rexml/parsers/baseparser

= class REXML::Validation::RelaxNG < Object
include REXML::Validation::Validator

RelaxNGに基づくXMLバリデータ。

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
  <element>
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
  # ~> /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/validation/validation.rb:22:in `validate': Validation error.  Expected: :start_element(  ) or :start_element( card ) from < Z.2 #:start_element( card ), :start_element( name ), :text(  ), :end_element(  ), :start_element( email ), :text(  ), :end_element(  ), < O.3 #:start_element( note ), :text(  ), :end_element(  ) >, :end_element(  ) >  but got :text(  (REXML::Validation::ValidationException)
  # ~>    )
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/validation/relaxng.rb:122:in `receive'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/baseparser.rb:185:in `block (2 levels) in pull'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/baseparser.rb:184:in `each'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/baseparser.rb:184:in `block in pull'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/baseparser.rb:183:in `tap'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/baseparser.rb:183:in `pull'
  # ~> 	from /home/ohai/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/rexml/parsers/treeparser.rb:22:in `parse'
  # ~> 	from -:41:in `<main>'

== Class Methods

--- new(source)
#@todo

== Instance Methods

--- current
--- current=(value)
#@todo

--- count
--- count=(value)
#@todo

--- references
#@todo

--- receive(event)
#@todo

== Constants

--- INFINITY
#@todo

--- EMPTY
#@todo

--- TEXT
#@todo

= class REXML::Validation::State < Object

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- previous=(previous)
#@todo

--- next(event)
#@todo

--- to_s
#@todo

--- inspect
#@todo

--- expected
#@todo

--- <<(event)
#@todo

== Protected Instance Methods

--- expand_ref_in(arry, ind)
#@todo

--- add_event_to_arry(arry, evt)
#@todo

--- generate_event(event)
#@todo

= class REXML::Validation::Sequence < REXML::Validation::State

== Instance Methods

--- matches?(event)
#@todo

= class REXML::Validation::Optional < REXML::Validation::State

== Instance Methods

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

= class REXML::Validation::ZeroOrMore < REXML::Validation::Optional

== Instance Methods

--- next(event)
#@todo

--- expected
#@todo

= class REXML::Validation::OneOrMore < REXML::Validation::State

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

= class REXML::Validation::Choice < REXML::Validation::State

== Class Methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- <<(event)
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

--- inspect
#@todo

== Protected Instance Methods

--- add_event_to_arry(arry, evt)
#@todo

= class REXML::Validation::Interleave < REXML::Validation::Choice

== Class methods

--- new(context)
#@todo

== Instance Methods

--- reset
#@todo

--- next_current(event)
#@todo

--- next(event)
#@todo

--- matches?(event)
#@todo

--- expected
#@todo

--- inspect
#@todo

= class REXML::Validation::Ref < Object

== Class Methods

--- new(value)
#@todo

== Instance Methods

--- to_s
#@todo

--- inspect
#@todo

#@end
