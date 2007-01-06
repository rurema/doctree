#@since 1.8.2

require tk
require tkextlib/blt

= class Tk::BLT::Vector < TkVariable

== Class Methods

--- create(*args)



--- destroy(*args)



--- expr(expression)



--- names(pat = None)



--- new(size = nil, keys = {})



== Instance Methods

--- *(item)



--- +(item)



--- -(item)



--- /(item)



--- [](idx)



--- []=(idx, val)



--- append(*vectors)



--- binread(channel, len = None, keys = {})



--- clear



--- delete(*indices)



--- destroy



--- dup_vector(vec)



--- expr(expression)



--- index(idx, val = None)



--- inspect



--- length



--- length=(size)



--- merge(*vectors)



--- normalize(vec = None)



--- notify(keyword)



--- offset



--- offset=(val)



--- populate(vector, density = None)



--- random



--- range(first, last = None)



--- search(val1, val2 = None)



--- seq(start, finish = None, step = None)



--- set(item)



--- sort(*vectors)



--- sort_reverse(*vectors)



--- split(*vectors)



--- to_s



--- variable(var)



= class Tk::BLT::VectorAccess < Tk::BLT::Vector

== Class Methods

--- new(vec_name)



#@end
