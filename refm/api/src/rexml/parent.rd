= class REXML::Parent < REXML::Child
include Enumerable

== Class Methods

--- new(parent = nil)

== Instance Methods

--- add(object)
--- push(object)
--- <<(object)

--- unshift(object)

--- delete(object)

--- each {|object| ... }
--- each_child {|object| ... }

--- delete_if {|object| ... }

--- delete_at(index)

--- each_index {|index| ... }

--- [](index)

--- []=(*args)

--- insert_before(child1, child2)

--- insert_after(child1, child2)

--- to_a
--- children

--- index(child)

--- size
#@since 1.8.5
--- length
#@end

--- replace_child(to_replace, replacement)

--- deep_clone

--- parent?
