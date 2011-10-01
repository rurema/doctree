
= class Psych::Coder

If an object defines +encode_with+, then an instance of Psych::Coder will
be passed to the method when the object is being serialized.  The Coder
automatically assumes a Psych::Nodes::Mapping is being emitted.  Other
objects like Sequence and Scalar may be emitted if +seq=+ or +scalar=+ are
called, respectively.

== Class Methods

--- new(tag) -> Psych::Coder
#@todo

== Instance Methods

--- tag
#@todo

--- tag=(val)
#@todo

--- style
#@todo

--- style=(val)
#@todo

--- implicit
#@todo

--- implicit=(val)
#@todo

--- object
#@todo

--- object=(val)
#@todo

--- type
#@todo

--- seq
#@todo

--- scalar(*args)
#@todo

--- map(tag = self.tag, style = self.style)
--- map(tag = self.tag, style = self.style) { ... }
#@todo

Emit a map.  The coder will be yielded to the block.

--- epresent_scalar(tag, value)
#@todo

Emit a scalar with +value+ and +tag+

--- represent_seq(tag, list)
#@todo

Emit a sequence with +list+ and +tag+

--- represent_map(tag, map)
#@todo

Emit a sequence with +map+ and +tag+

--- represent_object(tag, obj)
#@todo

Emit an arbitrary object +obj+ and +tag+

--- scalar=(value)
#@todo

Emit a scalar with +value+

--- map=(map)
#@todo

Emit a map with +value+

--- []=(k, v)
#@todo

--- [](k)
#@todo

--- seq=(list)
#@todo

Emit a sequence of +list+
