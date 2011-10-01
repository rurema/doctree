#@# require psych/json/yaml_events

= class Psych::JSON::TreeBuilder

#@# include Psych::JSON::YAMLEvents

Psych::JSON::TreeBuilder is an event based AST builder.  Events are sent
to an instance of Psych::JSON::TreeBuilder and a JSON AST is constructed.
