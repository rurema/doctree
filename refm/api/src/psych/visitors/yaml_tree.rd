
= class Psych::Visitors::YAMLTree < Psych::Visitors::Visitor

YAMLTree builds a YAML ast given a ruby object.  For example:

  builder = Psych::Visitors::YAMLTree.new
  builder << { :foo => 'bar' }
  builder.tree # => #<Psych::Nodes::Stream .. }

== Class Methods

--- new(options = {}, emitter = Psych::TreeBuilder.new) -> Psych::Visitors::YAMLTree
#@todo

== Instance Methods

--- started
--- started?
#@todo

--- finished
--- finished?
#@todo

--- start(encoding = Nodes::Stream::UTF8)
#@todo

--- finish
#@todo

--- tree
#@todo

--- push(object)
#@todo

--- accept(target)
#@todo

--- visit_Psych_Omap(o)
#@todo

--- visit_Object(o)
#@todo

--- visit_Struct(o)
#@todo

--- visit_Exception(o)
#@todo

--- visit_Regexp(o)
#@todo

--- visit_DateTime(o)
#@todo

--- visit_Time(o)
#@todo

--- visit_Rational(o)
#@todo

--- visit_Complex(o)
#@todo

--- visit_Integer(o)
#@todo

--- visit_Float(o)
#@todo

--- visit_String(o)
#@todo

--- visit_Module(o)
#@todo

--- visit_Class(o)
#@todo

--- visit_Range(o)
#@todo

--- visit_Hash(o)
#@todo

--- visit_Psych_Set(o)
#@todo

--- visit_Array(o)
#@todo

--- visit_NilClass(o)
#@todo

--- visit_Symbol(o)
#@todo

#@# psych.so にある private_iv_get メソッドは private メソッドのため省
#@# 略。
