#@# require psych/json/yaml_events

= class Psych::JSON::Stream < Psych::Visitors::JSONTree

#@# include Psych::JSON::RubyEvents
include Psych::Streaming

#@# Psych::JSON::Stream::Emitter
