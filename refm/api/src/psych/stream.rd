
= class Psych::Stream < Psych::Visitors::YAMLTree

Psych::Stream is a streaming YAML emitter.  It will not buffer your YAML,
but send it straight to an IO.

Here is an example use:

  stream = Psych::Stream.new($stdout)
  stream.start
  stream.push({:foo => 'bar'})
  stream.finish

YAML will be immediately emitted to $stdout with no buffering.

Psych::Stream#start will take a block and ensure that Psych::Stream#finish
is called, so you can do this form:

  stream = Psych::Stream.new($stdout)
  stream.start do |em|
    em.push(:foo => 'bar')
  end

#@# 以下のメソッドについては、nodoc が指定されているため、省略。
#@# = class Psych::Stream::Emitter < Psych::Emitter
#@# include Psych::Streaming
#@# == Instance Methods
#@# --- end_document implicit_end = !streaming?
#@# --- streaming?
